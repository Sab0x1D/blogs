---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 1st December 2025"
pretty_title: "Weekly Threat Trends — Week Commencing 1st December 2025"
excerpt: "This week is all about early AI-powered malware experiments like PROMPTFLUX, and why solid memory forensics with Volatility is becoming a must-have skill for dealing with shape-shifting loaders and fileless tradecraft."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2025-12-07
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

> The week of **1–7 December 2025** marks an interesting pivot: attackers are leaning harder into
**AI-assisted malware and tooling**, while defenders quietly bring **memory forensics** back into the
spotlight to keep up with increasingly in-memory, script-heavy tradecraft.

---

## Top Trends at a Glance

- **AI-Assisted Droppers & Loaders** – PROMPTFLUX-style scripts outsourcing obfuscation and payload shaping to LLMs.
- **LLM-Optimised Phishing & ClickFix** – AI-written lures and fake system prompts tuned for language, brand and context.
- **Script Engines as AI Gateways** – PowerShell, wscript, python and friends talking directly to AI APIs from compromised hosts.
- **Memory Forensics Back in Fashion** – Volatility used more routinely to deal with fileless and just-in-time generated payloads.
- **Detection Engineering for Dynamic Payloads** – Shift from string-based signatures to behaviour, egress, and API-usage analytics.
- **Policy Gaps Around AI SaaS** – Organisations allowing blind, unrestricted access to public LLMs from managed endpoints.

---

## AI-Assisted Malware in the Wild — PROMPTFLUX-Style Experiments

The loudest story this week is the continued experimentation with **AI-assisted malware**.

We’re now seeing multiple families where the most interesting line in the analysis isn’t a string in the
binary, but the fact that the malware **talks to an LLM at runtime**.

Instead of shipping with one obfuscation routine and a fixed script, the dropper behaves more like a client
for a remote code-mutation service:

- It executes on the host via a familiar chain (maldoc → script engine → loader).
- It collects some basic **environmental context** (OS version, language locale, maybe AV hints).
- It sends a carefully crafted **prompt** to an LLM endpoint controlled or proxied by the attacker.
- It receives **new script or shellcode** in response.
- It immediately writes and executes that returned code as the next stage.

The family commonly referred to as *PROMPTFLUX* has become the poster child for this pattern:

- The first stage is usually a VBScript or similar, nothing especially exotic on its own.
- The interesting behaviour happens when it:
  - Calls out to a remote model with its own source code embedded in the prompt.
  - Asks the model to “obfuscate this”, “rewrite to avoid detection”, or “update these C2 values”.
  - Treats the response as executable logic and chains into it without ever touching a heavy packer.

From a static-analysis point of view, this is annoying. Every victim can end up with **a slightly different
script** and a slightly different obfuscation style, depending on how the operator has been tweaking prompts
this week.

From a behavioural point of view, it’s very familiar:

- Office → script engine → outbound HTTPS to shady API → write new script → execute.
- Repeated cycles of “download script, run script, discard” within a single session.
- Execution from user-writable paths with sketchy parent/child relationships.

The AI part doesn’t invalidate your fundamentals; it just gives operators **faster, cheaper polymorphism**
and experimentation.

---

## LLM-Optimised Phishing & ClickFix Campaigns

The other visible impact of AI this week is on the **social engineering side**.

Multiple campaigns are now clearly using LLMs to:

- Rewrite phishing emails in multiple languages with consistent, natural tone.
- Generate **fake dialogues and system prompts** that look close to native OS messages.
- Customise messages for job roles, industries, or technologies (e.g., fake “security updates” themed around whatever EDR product the target is likely to have).

The **ClickFix** pattern is spreading: instead of attaching a generic executable, attackers send victims
step-by-step instructions that *look* like legitimate security remediation:

1. “Open PowerShell as Administrator.”
2. “Paste this command to repair corrupted security components.”
3. “If prompted, click ‘Yes’ to continue.”

Behind the scenes, that command is:

- Pulling a script or loader from attacker infrastructure.
- Disabling protections or adding exclusions.
- Bootstrapping a PROMPTFLUX-style chain that then talks to an LLM to get the “real” payload.

AI helps here by:

- Making the instructions sound exactly like internal IT language.
- Adapting terminology to region and stack (Teams vs Slack, Intune vs generic MDM, etc.).
- Generating endless variations so that a single mail-flow rule or keyword doesn’t kill an entire campaign.

For defenders, this reinforces two themes:

- **User awareness** has to move beyond “don’t click dodgy links” to “don’t run copy-paste commands from email.”
- **Mail content filters** need to start looking for patterns like:
  - Code blocks with PowerShell, cmd, bash, or python.
  - Stepwise instructions to open terminals or developer tools.
  - “Repair security”, “reset protection”, or “fix quarantine” narratives that aren’t coming from your actual IT channels.

---

## Script Engines as Gateways to AI APIs

One of the more subtle but important shifts this week is the way **script engines themselves** have become
the gateway to AI services.

In a lot of environments, outbound access to AI SaaS is only loosely controlled. Developers are using
ChatGPT-style APIs, security teams are testing AI enrichment, and occasionally random endpoints are allowed
to “try things out”.

Attackers are taking advantage of this ambiguity:

- The initial loader runs via **PowerShell, wscript, cscript, python or node**.
- That process directly calls an AI API endpoint to:
  - Fetch obfuscated follow-up scripts.
  - Generate decoder functions or unpacking stubs on demand.
  - Transform existing code snippets based on new detection feedback.

Because these APIs look like ordinary HTTPS traffic and are often hosted on big, well-known clouds, they
get **whitelisted almost by default**.

Threat hunting this week has highlighted a few patterns worth turning into detections or dashboards:

- Script host processes making POST requests to endpoints with obviously LLM-like paths:
  - `/v1/chat/completions`
  - `/api/generate`
  - `/inference` or `/predict`
- Endpoints in non-developer segments (finance, HR, standard user laptops) suddenly generating a **high volume of small JSON POSTs** to AI providers.
- Freshly dropped scripts that:
  - Reference AI endpoints directly.
  - Include hard-coded API keys or bearer tokens.
  - Immediately write and execute yet another layer of code based on responses.

It’s not enough to log “we talk to AI somewhere”. We now need to know **which processes, on which hosts,
under which identities** are doing the talking.

---

## Memory Forensics Back in Focus

On the blue-team side, the most encouraging trend this week is a renewed interest in **memory forensics**.

As more tradecraft shifts into:

- In-memory decryption.
- Script-only payloads.
- Dynamic code generation via LLMs.

…traditional disk-only analysis is leaving too many gaps. Teams that have kept their **Volatility skills**
sharp are finding they can still get solid answers even when every disk artefact looks different.

Memory images from live incidents this week have been used to:

- Reconstruct **full process trees** around suspicious script hosts and loaders, including:
  - Exact command lines.
  - Parent/child relationships that weren’t fully logged elsewhere.
- Identify **injected regions** inside seemingly legitimate processes:
  - Browsers carrying stealer modules.
  - `svchost.exe` or `explorer.exe` with extra executable segments.
- Map network connections at the time of capture:
  - Which PID was actually talking to that LLM endpoint?
  - Which process maintained the long-lived beacon to C2?
- Pull out **decrypted configs and IOCs**:
  - C2 URLs and backup domains.
  - Campaign IDs and mutexes.
  - Hard-coded API keys or encoded routing tables.

A recurring pattern: on disk, analysts saw **only a bland script and maybe a DLL**. In memory, they found:

- A fully unpacked payload injected into a long-lived process.
- The plaintext C2 config complete with domains and URIs.
- Evidence that certain account credentials were resident in LSASS at the time.

That difference is the gap between “this host looked weird” and a solid narrative of *what actually happened*.

---

## Practical Volatility Workflows That Keep Showing Up

The good news is you don’t need advanced RE skills to start getting value from memory images. The same
handful of Volatility plugins and workflows keep proving their worth in cases like this week’s AI-assisted
campaigns.

The pattern most teams are settling on looks something like:

**Establish context**

- `windows.info` to confirm OS build and symbol tables.
- `windows.pslist` and `windows.psscan` to list active, hidden, and recently terminated processes.

**Prioritise suspects**

- Look for:
  - Script hosts (`powershell.exe`, `wscript.exe`, `cscript.exe`, `python.exe`) with odd parents.
  - Legitimate binaries running from odd locations.
  - Processes that started shortly before suspicious network activity.

**Inspect suspicious processes**

- `windows.cmdline` to see launch arguments.
- `windows.dlllist` to enumerate modules and check paths.
- `windows.malfind` to surface injected or RWX memory regions.

**Map network activity**

- `windows.netscan` / `netstat` plugins to tie outbound connections back to specific PIDs.

**Hunt strings and configs**

- Dump interesting regions and run `strings`/`floss` to extract:
  - Domains, URIs, IPs.
  - Mutexes, campaign names, operator handles.
  - Embedded prompts or API keys for LLM endpoints.

**Assess credential exposure**

- Identify LSASS in the snapshot.
- Depending on policy, dump and analyse:
  - Which accounts had tokens or credentials resident.
  - Whether that lines up with observed lateral movement.

For this week’s AI-assisted cases, that workflow was often the only way to definitively answer:

- Which process actually talked to the LLM?
- Where did the “real” payload live?
- Which accounts and systems were put at risk?

---

## Detection Engineering Priorities for Dynamic Payloads

Given how quickly AI-assisted malware can mutate its **appearance**, this week’s detection conversations
are moving firmly towards **behaviour and context**.

A few priorities that keep bubbling up:

### Focus on execution chains, not just binaries

Instead of asking “does this file match a known bad hash?”, focus on patterns like:

- Document or mail client → script engine → outbound web calls → new script/EXE creation → execution.
- Script engines writing and launching other scripts within a short time window.
- Processes that repeatedly overwrite or replace their own executable file.

These patterns remain relatively constant even as the actual code and strings change.

### Treat AI API usage as security-relevant telemetry

This week made it clear that:

- “We don’t use AI on this host” is itself a useful rule.
- Any scriptable access to LLM APIs from user endpoints is worth logging, even if not outright blocking.

Small, practical steps:

- Add **process-level logging** for outbound connections to AI providers and model-hosting services.
- Build **baseline views**:
  - Which teams legitimately use AI APIs?
  - From which subnets and via which tools?
- Turn deviations from that baseline into at least low-noise alerts or hunting leads.

### Tighten egress around scripting and developer tooling

Many environments still allow:

- Developer tools with full internet access on production desktops.
- Script engines reaching anywhere outbound as long as it’s HTTPS.

This is exactly the gap AI-assisted malware wants to live in. Controls worth considering:

- Outbound restrictions for:
  - `powershell.exe`, `python.exe`, `wscript.exe`, `cscript.exe`, `mshta.exe`.
- Stronger **proxy identification of client processes**, not just destination domain.
- Dedicated, better-monitored **dev sandboxes** for AI experimentation, separate from everyday endpoints.

---

## Policy Gaps Around AI SaaS

A big meta-theme this week is that many organisations still don’t have coherent answers to questions like:

- Who is allowed to use public LLMs from corporate devices?
- Are API keys allowed to be stored in scripts on endpoints?
- Do we distinguish between **browser-only AI usage** and **programmatic access from code and tools**?
- What gets logged, and for how long, about AI API calls made with corporate identities?

Attackers are, unsurprisingly, exploring these grey areas first.

If you don’t have clear policy and technical enforcement around:

- Which tenants and keys can call AI services.
- Which network paths are used.
- How those calls are monitored.

…then a compromised endpoint using an LLM to mutate its own malware isn’t going to look much different from
a developer testing Copilot or a SOC experiment with an enrichment script.

---

## Actions for the Week Ahead

To turn this week’s noise into something practical, here are some concrete actions:

- **Hunt for script engines calling AI APIs**  
  - Query your logs for `powershell.exe`, `wscript.exe`, `python.exe`, etc., talking to AI-related domains or API paths.
  - Investigate any occurrences from non-dev segments.

- **Baseline legitimate AI usage**  
  - Work with dev and data teams to understand who *should* be using LLM APIs today.
  - Tag those scenarios as “known good” and treat everything else as suspicious until proven otherwise.

- **Pilot a memory forensics workflow**  
  - Pick one recent or ongoing incident and:
    - Capture a memory image (if you didn’t already).
    - Run the basic Volatility workflow outlined above.
  - Document what you learn that you couldn’t have seen from disk and logs alone.

- **Tighten egress for scripting tools**  
  - Even a simple control like “script hosts can only talk to a handful of approved internal services” will make AI-backed droppers far noisier.

- **Update awareness training**  
  - Add ClickFix-style scenarios:
    - Users being asked to open terminals.
    - Copy-paste commands from email or chat to “fix” security issues.
  - Emphasise that **support and IT never instruct through random commands sent over email**.

---

## Closing Thoughts

AI isn’t rewriting the playbook, but it is turning the **speed knob** on attacker adaptation up a notch.

This week’s experiments show what happens when:

- Droppers can **ask a model to handle their obfuscation**.
- Phishers can **generate endless, tailored lures** with minimal effort.
- Operators can tweak prompts instead of re-compiling malware.

The counter-move isn’t more desperate signature chasing. It’s doubling down on:

- Behaviour, not bytes.
- Memory, not just disk.
- Egress and identity, not just perimeter.

If you can see **which process talked to which service, when, and why**, and you can pull **what was actually
running in RAM** when it did, AI-assisted malware becomes just another flavour of a problem you already know
how to fight.

Same fundamentals. New toys. Time to tune the playbook.
