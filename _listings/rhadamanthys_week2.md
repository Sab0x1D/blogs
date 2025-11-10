---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Rhadamanthys — Modular Malware Done Right (For the Wrong Reasons)"
pretty_title: "Rhadamanthys — Modular Malware Done Right (For the Wrong Reasons)"
excerpt: "A deep dive into Rhadamanthys, the stealer-loader hybrid redefining modular malware design. We explore its internal architecture, infection vectors, and what defenders can learn from its engineering."
thumb: /assets/img/rhadamanthys_thumb.jpg
date: 2025-11-11
featured: false
tags: [Malware, Threats, Forensics, Awareness]
---

### 1. Introduction

Rhadamanthys is not just another info-stealer.  
It’s a **modular framework** that blurs the line between credential theft, loader, and full-fledged command-and-control platform.  
Discovered in early 2023, it quickly became a favourite on Russian-language forums due to its reliability and extensibility.

Where Lumma or RedLine focus on stealing data, Rhadamanthys behaves more like a *malware platform-as-a-service*: developers provide plug-ins for persistence, lateral movement, and secondary payload deployment.

---

### 2. Evolution and Distribution

**Early 2023 → Stealer:** small C++ binary with encrypted C2 strings.  
**Late 2023 → Loader:** modular design with plug-in DLLs.  
**2024 → Hybrid MaaS:** full dashboard, build options, and crypto-payment portal.

Distribution methods seen in 2025:
- SEO poisoning and *cracked software* lure sites.  
- Email attachments disguised as invoices (`.zip → .js → .dll`).  
- Fake MSI installers embedded with Rhadamanthys stub.  
- Abuse of **Discord CDN** and **Bitbucket** for payload hosting.  

The loader often drops with `md5.dll` or `auth.dll` filenames to mimic legitimate dependencies.

---

### 3. Modular Architecture

Rhadamanthys binaries contain a **main loader stub** and optional **plug-in modules** packed with UPX or custom PE crypter.

#### 3.1 Core Modules

| Module | Function |
|---------|-----------|
| `core.dll` | Main orchestrator, plugin loader |
| `browser.dll` | Chromium & Gecko credential extractor |
| `crypto.dll` | Wallet stealer for Exodus, MetaMask, Atomic |
| `miner.dll` | Optional XMR miner |
| `loader.dll` | Secondary payload downloader |
| `persist.dll` | Scheduled Task + RunKey persistence |
| `injection.dll` | Reflective DLL injection engine |

Each module is AES-encrypted with per-build keys stored in the configuration blob.  

#### 3.2 Loader Mechanics
The loader decrypts its modules in memory and dynamically resolves APIs using CRC32 hashing.  
It communicates with the core process via a shared memory section named `Global\\RHADAPI`.

---

### 4. Execution Flow

1. **Dropper Launch** → creates mutex `Rhad-{GUID}`.  
2. **Decryption** → RC4 decode config block appended after PE overlay.  
3. **Injection** → spawns `explorer.exe` child, maps payload via `NtMapViewOfSection`.  
4. **Enumeration** → browser profiles, wallet paths, system info.  
5. **Exfiltration** → uploads archive via HTTPS to C2.  
6. **Command Loop** → awaits JSON commands: `load`, `update`, `plugin_exec`.  

---

### 5. Technical Highlights

- Written in C++17 with Boost and custom JSON parser.  
- Uses Thread Local Storage callbacks for anti-debug.  
- PE metadata contains fake timestamps and compile path obfuscation.  
- In-memory plugins are signed with developer’s ECC key; unverified modules are ignored → harder to hijack.

---

### 6. Network Protocol

Rhadamanthys uses a bespoke binary protocol over HTTPS port 443.

**Handshake:**
```
POST /gate.php HTTP/1.1
User-Agent: RhadClient/2.0
X-Key: <RSA_Enc_Key>
Content-Length: ...
```

Payload is zlib-compressed JSON:

```json
{
  "id":"<hostid>",
  "build":"2.1-pro",
  "plugins":["browser","crypto","loader"],
  "data":"<base64>"
}
```

Server replies with AES-encrypted command block.  
Domain rotation via hardcoded seed + daily RC4 mask similar to QakBot.

---

### 7. Forensic Indicators

| Artefact | Path | Notes |
|-----------|------|-------|
| `%AppData%\\Rhadamanthys\\` | Module storage dir |
| `%ProgramData%\\rhadsvc.dll` | Persistence DLL |
| Registry: `HKCU\\Software\\Rhad` | Config blob |
| Mutex `Rhad-*` | Execution instance |
| Task Scheduler `UpdaterSvc` | Maintains reboot persistence |

**Network IOCs:**  
`rhad-gate[.]top`, `cdn-rhad[.]xyz`, `89.185.*.*`.

---

### 8. Defensive Playbook

#### Host Level
- Detect unusual DLL injection into `explorer.exe`.  
- Flag DLLs signed with self-signed ECC keys.  
- Monitor creation of folders named “Rhadamanthys”.  

#### Network Level
- JA3 fingerprint `c53ca0aee6d8d2a90f8a4100e13f94c4`.  
- Alert on POSTs to `/gate.php` with `User-Agent: RhadClient`.  
- TLS SNI often uses random 5-char subdomains.  

#### Memory Forensics
Volatility `malfind` and `ldrmodules` show manual mapping sections with no PE header on disk.  
Look for ECC public key strings (`BEGIN PUBLIC KEY`).

---

### 9. DFIR Tips

1. Capture RAM before shutdown → plugin modules reside only in memory.  
2. Extract config via `strings | grep "gate"` or YARA regex `rhad.*panel`.  
3. Check Prefetch for DLL load anomalies.  
4. Examine Task Scheduler XML for hidden triggers.  

---

### 10. Defensive Takeaways

Rhadamanthys shows that modularity equals resilience.  
Its plugin system lets actors pivot faster than traditional stealers — a trend blue teams must anticipate.  
Defenders should build modular detection rules mirroring attacker designs: separate signatures for loader, plugins, and config.

---

### 11. Outlook

2025 variants add Go-based stagers and Rust modules to evade static YARA rules.  
Expect Rhadamanthys to inspire next-generation MaaS builders through its reliability and code quality.

---
