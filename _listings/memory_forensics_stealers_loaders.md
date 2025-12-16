---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Memory Forensics for Stealers & Loaders"
pretty_title: "Memory Forensics for Stealers & Loaders"
excerpt: "Stealers and loaders increasingly hide their most important behaviour in RAM. This post walks through how to follow the process tree, capture targeted memory dumps, and extract configs, C2s, and credentials so you can turn volatile artefacts into detections. It ties memory findings back to disk artefacts and logs so you can explain scope, impact, and timelines with confidence."
thumb: /assets/img/memory_forensics_stealers_loaders_thumb.webp
date: 2025-12-17
featured: false
tags: [DFIR, Forensics, Windows, Memory, Stealers, Loaders]
---


> **Memory Forensics for Stealers & Loaders**  
> Building on browser credential forensics and DanaBot analysis, this week we move up the stack and focus on what is happening in **memory** and **running processes** when modern stealers and loaders are doing their work.

Most commodity threats you see in the wild today follow a similar pattern:

1. A user is tricked into opening something (phish, fake invoice, fake “job offer” files, cracked software, etc.).  
2. A **loader** quietly executes, pulls down one or more payloads, and sets up persistence.  
3. A **stealer** or RAT harvests credentials, cookies, and system information, then exfiltrates everything to a remote panel.

Disk artefacts still matter, but more and more of the interesting behaviour – configuration, injected code, decrypted strings, live network beacons – exists **only in memory** or is easiest to understand by following processes in real time.

This post walks through how to approach **memory and process forensics** in the context of stealers and loaders, using the tools most analysts already have available, and framing everything so it naturally feeds into **detection engineering** and **threat hunting**.

---

## Why Memory & Process Forensics Matter for Stealers & Loaders

Stealers and loaders are designed to minimise their footprint and maximise flexibility. Some common patterns:

- **Fileless or “almost fileless” execution** – payloads reflectively loaded into memory, never written as a PE on disk.  
- **Heavy use of process injection** – the malicious code lives inside legitimate processes (browsers, Office, system utilities).  
- **Encryption and packing** – configs, strings, and URLs only appear in cleartext once decrypted in memory.  
- **Multi-stage chains** – what you see on disk may only be a small stager; the “real” stealer comes later, often in memory only.

Traditional “grab the EXE from disk and upload to a sandbox” still has value, but you often miss:

- The **real C2 infrastructure** (vs. a one-time staging URL).  
- The **full configuration** (targeted apps, exfil paths, exclusion lists).  
- The **runtime behaviour** (what process is injected, what credentials are touched, what security tooling is tampered with).

Memory and process forensics let you answer questions such as:

- Which processes were spawned in this chain, and in what order?  
- Where is the actual stealer payload executing?  
- What strings, configs, and network indicators exist only in memory?  
- How did the malware tamper with browser credential stores or security tools?

Once you can answer these, your YARA rules, EDR detections, and incident reports become far more grounded in how the threat really behaves.

---

## Typical Loader → Stealer Infection Chain

Let us quickly outline a simplified but realistic chain you might see:

1. **Initial access**
   - User opens a malicious ISO or ZIP, double-clicks a fake PDF that is actually an executable.  
   - Alternatively, an Office macro or shortcut file launches a script (PowerShell, WScript, etc.).

2. **Loader stage**
   - The loader:  
     - Performs basic **environment checks** (VM, sandbox, locale).  
     - Contacts a **staging server** (often via HTTPS, sometimes via a paste site, GitHub, Discord, Telegram, etc.).  
     - Downloads an encrypted blob and injects it into memory (often into a new or existing process).  
     - Sets up **persistence** (registry Run keys, scheduled tasks, service install, startup folder, etc.).

3. **Stealer stage**
   - The stealer payload:  
     - Enumerates browsers and apps (Chrome, Edge, Firefox, Discord, Telegram, password managers, wallets).  
     - Harvests credentials, cookies, session tokens, autofill data.  
     - Collects host fingerprinting data (OS, hardware, AV solution, locale, installed software).  
     - Compresses and exfiltrates everything to a **panel or log shop** backend.

From a **DFIR** perspective, you care about every transition in that chain:

- The parent/child relationships between processes.  
- The exact executable (path, hash, signer) hosting the malicious code.  
- The memory regions containing decrypted configurations and C2s.  
- The artefacts left behind (tasks, services, registry, browser files).

Memory and process forensics are how you stitch all that together.

---

## Core Tooling: Following the Process Tree in Real Time

You do not need exotic tools to start. A solid minimum stack on a Windows endpoint includes:

- **Process Hacker / Process Explorer** – to inspect:  
  - Process tree and parent/child relationships.  
  - Command-line arguments and working directory.  
  - Loaded modules (DLLs).  
  - Digital signatures and verified publishers.  
  - Open handles (files, registry keys, network sockets).

- **Process Monitor (ProcMon)** – to capture:  
  - File system activity (reads/writes, dropped payloads, log files).  
  - Registry modifications (persistence keys, configuration storage).  
  - Network connections (hostnames, IPs, ports).  
  - Process and thread operations (CreateProcess, CreateFile, RegSetValue, etc.).

- **Built-in OS tools** – for quick triage:  
  - `tasklist`, `wmic process`, or `Get-Process` for scripting and automation.  
  - `netstat -ano` / `Get-NetTCPConnection` for quick socket inspection.  
  - Event Viewer (Sysmon, Windows Security, Application logs) for corroborating evidence.

In a real incident, your workflow often looks like this:

1. Identify a suspicious process (e.g. an unexpected child of Outlook, Teams, or the browser).  
2. Use Process Hacker/Explorer to expand the tree and trace back to the **initial launcher**.  
3. Look at command-line arguments – scripts, unusual flags, LOLBins (e.g. `regsvr32`, `rundll32`, `powershell.exe`).  
4. Use ProcMon with tight filters (by PID or process name) to see what that process is actually doing.  
5. When you are confident you have the relevant process, capture memory artefacts before killing anything.

The process tree is your backbone. Memory artefacts are then anchored to specific PIDs and times in that tree.

---

## Capturing Memory: Full Dumps vs Targeted Process Dumps

In an ideal world you would capture a **full memory image** of the system before making any changes:

- Tools like dedicated memory acquisition utilities (or EDR live response features) give you a bit-for-bit snapshot of RAM.  
- You can then use frameworks like Volatility or Rekall to analyse processes, network connections, and injected code offline.

However, in many environments you may be:

- Working under time pressure.  
- Limited by disk space or tooling.  
- Operating from a live EDR console with no easy way to grab full images.

In those cases, **targeted process dumps** are still extremely valuable.

Typical options include:

- **Process Hacker / Process Explorer**  
  - Right-click the suspicious process → “Create full memory dump”.  
  - Saves a `.dmp` file you can analyse later (locally or in a sandbox).

- **Task Manager (Windows 10/11)**  
  - Right-click the process → “Create dump file”.  
  - Quick and dirty, but often enough for string extraction and basic config hunting.

- **Sysinternals Procdump**  
  - `procdump -ma <PID> suspicious_process.dmp`  
  - Scriptable, good for automating dumps from multiple PIDs (e.g. every process spawned by the loader).

Key considerations:

- **Timing matters** – you want the dump **after** the malware has decrypted its configuration and started beaconing, but **before** you kill the process or reboot.  
- **Disk hygiene** – dumps can be large and may contain sensitive data (passwords, tokens, documents); handle them like any other high-sensitivity artefact.  
- **Legal/privileged data** – depending on your environment, memory may contain material with legal or privacy implications. Follow your organisation’s SOPs and retention rules.

Once you have a dump, the fun part begins: cutting it open to see what the stealer or loader looks like from the inside.

---

## What to Hunt for Inside Memory

With a process dump in hand, you can start with fairly simple techniques before moving into deeper reverse engineering.

### 1. Strings and configuration artefacts

Running `strings` (or more advanced tooling) over the dump can reveal:

- **C2 domains and URLs** (including backup/secondary infrastructure).  
- **Panel paths** (e.g. `/gate.php`, `/upload.php`, `/api/logs`).  
- **Encryption keys or hard-coded salts** used for obfuscation.  
- **Target lists** – browser names, wallet apps, specific file extensions.  
- **Anti-analysis flags** – checks for VM artefacts, usernames, processes, AV products.  
- **Custom markers** – mutex names, pipe names, window classes, etc.

You will often see configs stored as JSON blobs, base64 strings, or simple key/value pairs. Once you recognise a pattern, you can:

- Write a **YARA rule** that hunts for that config structure in memory or on disk.  
- Build **Sigma/EDR rules** that look for processes making outbound connections to those domains or URL paths.  
- Add those indicators to your **threat intel** and hunting playbooks.

### 2. Injection patterns and non-backed memory regions

In modern stealers and loaders, the most critical code may live in:

- **Private, non-image memory regions** – allocated at runtime (e.g. via `VirtualAlloc`) and marked executable.  
- **Sections of legitimate processes** that were overwritten with shellcode or unpacked payloads.  
- **Suspicious DLLs** loaded from user-writable paths or temp locations.

Using memory analysis frameworks or process inspection tools, you look for:

- Memory regions that are **RWX** (read-write-execute) or otherwise abnormal for that process.  
- Modules with **no signature**, odd names, or unusual load paths.  
- Embedded PE headers inside raw memory regions (indicative of unpacked payloads).

If you can reliably characterise these patterns, you have strong input for:

- **Detection engineering** – flagging suspicious memory protections or module load patterns.  
- **YARA rules** – matching on the unpacked payload rather than just the loader stub on disk.

### 3. Live credentials and tokens

Because stealers and loaders are often all about **credentials**, your dumps may contain:

- **Plaintext passwords** pulled from credential stores.  
- **Session cookies and tokens** for web apps and cloud services.  
- **Decrypted browser database contents** that would be encrypted at rest on disk.

You generally do not want to extract and examine every password from memory dumps (for privacy and legal reasons), but knowing that such data exists:

- Explains the **impact** of the incident (why a single endpoint compromise can lead to full account takeover).  
- Helps you justify **aggressive response** (forcing password resets, invalidating tokens, revoking refresh tokens, etc.).  
- Ties nicely back to your **Week 6 browser credential forensics** work – disk and memory artefacts together give a full picture.

---

## A Walkthrough: Following a Loader → Stealer Chain in Memory

To make this more concrete, consider a simplified case study based on real-world patterns.

1. **Initial detection**
   - EDR flags `WINWORD.EXE` spawning `wscript.exe` with a suspicious command line.  
   - You confirm the user opened a “proforma invoice” DOCX from an email.

2. **Process tree expansion**
   - `WINWORD.EXE` → `wscript.exe` → `loader.exe` in `%ProgramData%\` with a random name.  
   - Shortly after, `loader.exe` spawns a new `chrome.exe` instance, even though the user does not recall opening Chrome.

3. **Behavioural triage**
   - In ProcMon, you filter on `loader.exe` and the suspicious `chrome.exe`.  
   - You see `loader.exe` writing a DLL into `C:\Users\<user>\AppData\Local\Temp\` and then injecting into `chrome.exe` via `CreateRemoteThread`.  
   - The injected `chrome.exe` instance begins making outbound HTTPS connections to previously unseen domains, with odd `User-Agent` strings.

4. **Memory capture**
   - You create full dumps of `loader.exe` and the suspicious `chrome.exe` instance.  
   - You quarantine the files written to disk but **do not** immediately kill the processes until dumps are confirmed.

5. **Dump analysis**
   - Running `strings` and some light parsing on the `chrome.exe` dump reveals:  
     - A JSON-like config block listing targeted browsers, wallet paths, and exclusion lists.  
     - Primary and backup C2 domains (`panelX.xyz`, `logstoreY.top`) with specific URL paths (`/gate.php`, `/up.php`).  
     - A hard-coded encryption key used to protect exfiltrated log archives.

   - In the `loader.exe` dump, you spot:  
     - Basic sandbox checks (looking for VM processes, low RAM, GPU names).  
     - A list of LOLBins and utilities it can abuse for persistence (e.g. `schtasks`, `reg`, `powershell`).

6. **From forensics to detection**
   - You build YARA rules that:  
     - Match on the config structure and specific key names inside memory or unpacked binaries.  
     - Look for the unique mutex name and pipe name used by this stealer family.

   - You propose SIEM/EDR detections that:  
     - Alert on Office spawning scripting hosts that spawn random-named binaries in `%ProgramData%`.  
     - Flag non-user-driven browsers making connections to the identified domains or URL paths.  
     - Monitor for scheduled tasks or registry keys created by those binaries.

The key point: without **memory and process forensics**, you might only have the initial loader EXE and a generic “stealer suspected” verdict from VT. With memory analysis, you now understand the **full behaviour**, **targeting**, and **infrastructure** of the threat.

---

## Tying Memory Forensics Back to Disk & DFIR Artefacts

Memory analysis does not exist in isolation. The most useful investigations tie together:

- **Memory artefacts**  
  - Configs, C2s, injected modules, decrypted strings, credentials in RAM.

- **Disk artefacts**  
  - Dropped loaders, unpacked payloads, log files.  
  - Browser databases and session files (as covered in Week 6).  
  - Persistence mechanisms (Run keys, scheduled tasks, services, startup items).

- **System and security logs**  
  - Sysmon events for process creation, image loads, and network connections.  
  - Windows Security logs for logons, privilege use, and account changes.  
  - EDR telemetry and alerts.

By correlating memory findings to on-disk and log artefacts, you can answer:

- **Scope** – which hosts ran this stealer/loader chain?  
- **Impact** – which accounts and applications are at risk?  
- **Timeline** – when did initial access occur; how long did the malware run; when did exfil happen?  
- **Controls** – which detections worked, which failed, and what needs tuning?

This correlation step is also where your **forensic report** becomes truly useful to incident managers, SOC leads, and stakeholders. You are not just saying “we found a stealer”; you are explaining **how it got in, what it did, and what must happen next**.

---

## Turning Memory Forensics into Repeatable Playbooks

To make this sustainable, you want a repeatable process – not one-off heroics. A simple playbook for stealer/loader investigations might look like this:

1. **Initial triage**
   - Identify suspicious parent/child chains (Office → script → binary; browser → LOLBin; etc.).  
   - Capture basic telemetry: hashes, paths, command lines, network connections.

2. **Memory capture**
   - Dump target processes (loader, injected process, any odd children).  
   - If feasible, capture full memory images for high-value or high-risk cases.

3. **Memory analysis**
   - Run strings and simple heuristics to pull: configs, C2s, mutexes, keys.  
   - Identify injected regions and unpacked payloads; re-dump those as standalone samples if possible.

4. **Correlate with disk & logs**
   - Locate dropped files, persistence artefacts, browser data touched.  
   - Pull relevant sysmon, security, and EDR logs across the same timeframe.

5. **Detection & hardening output**
   - Develop or update YARA rules for loaders and stealers (disk and memory variants).  
   - Create SIEM queries / detection rules for process chains and network IOCs.  
   - Document any weak points in controls (e.g. lack of Office macro restrictions, weak application control).

6. **Reporting & lessons learned**
   - Produce a concise report / wiki page with:  
     - Infection chain diagram.  
     - Key indicators (hashes, domains, paths, mutexes).  
     - Recommended detections and mitigations.  
   - Feed this back into your **weekly trend** content so your wider audience benefits.

Over time, you will accumulate a library of playbooks for different families and TTPs, and memory forensics will feel like a natural step instead of a special project.
