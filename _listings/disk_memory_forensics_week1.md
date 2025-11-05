---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Disk & Memory Forensics 101 — Finding Persistence in the Noise"
pretty_title: "Disk & Memory Forensics 101 — Finding Persistence in the Noise"
excerpt: "Digital forensics starts where traditional IT troubleshooting ends. This primer walks through real-world techniques to uncover persistence mechanisms and reconstruct volatile evidence using free and open-source tools."
thumb: /assets/img/disk_memory_forensics_thumb.jpg
date: 2025-11-05
featured: false
tags: [DFIR, Forensics, Investigation, Awareness]
---

### 1. Why Disk & Memory Forensics Matter

When malware detonates, the *what* is obvious — files appear, processes spawn, data leaks.  
But to understand the *how* and *why*, analysts must capture both **disk** (static) and **memory** (volatile) evidence.

Disk forensics preserves the long-term footprints — registry hives, prefetch files, event logs.  
Memory forensics reveals live processes, injected code, network connections, and encryption keys that disappear on reboot.

---

### 2. Setting Up Your Forensic Workstation

Recommended free stack:

| Category | Tool | Purpose |
|-----------|------|----------|
| Imaging | `dd`, `FTK Imager Lite` | Bit-level acquisition |
| Analysis | `Autopsy`, `Magnet AXIOM Free`, `X-Ways` | File system & timeline review |
| Memory | `Volatility 3`, `Rekall` | Process & injection analysis |
| Hex & Strings | `HxD`, `strings`, `binwalk` | Low-level data inspection |

Always verify hash integrity (MD5/SHA256) after acquisition and preserve originals in *read-only* mounts.

---

### 3. Disk Forensics Workflow

#### 3.1 Identify Artefacts
1. **Master File Table (MFT)** — shows file creation/deletion.  
2. **USN Journal** — captures changes between imaging sessions.  
3. **Prefetch Files** (`C:\Windows\Prefetch\*.pf`) — track executed binaries.  
4. **Registry Keys** (`Run`, `RunOnce`, `Services`) — reveal persistence.  
5. **Event Logs** — correlate process creation (Event ID 4688) with file writes.  

#### 3.2 Example Case: Lumma Persistence Trail
During analysis of an infected VM:

- MFT entry reveals new directory `%AppData%\Microsoft\Update\`.  
- Prefetch shows `updater.exe – 1 runs`.  
- Registry `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` references the same path.  
- Event ID 7045 logs creation of a scheduled task.  
- SHA256 hash matches known Lumma sample.

Result: Persistence confirmed within 3 minutes of timeline review.

#### 3.3 Timeline Reconstruction
Use `Autopsy` or `log2timeline (plaso)`:

```bash
log2timeline.py lumma.plaso /mnt/image
psort.py -z UTC --timeline_format=csv lumma.plaso > timeline.csv
```

Filter for first execution indicators around infection time.

---

### 4. Memory Forensics Workflow

#### 4.1 Capturing Memory
Use `winpmem` on live Windows host:

```bash
winpmem.exe --format raw -o memory.raw
```

Always document exact acquisition time and system uptime.

#### 4.2 Analyzing with Volatility 3

```bash
vol -f memory.raw windows.pstree
vol -f memory.raw windows.cmdline
vol -f memory.raw windows.netscan
```

#### 4.3 Detecting Injection & Persistence
Indicators:
- Unknown process parented by `explorer.exe`.  
- Mapped DLLs not present on disk (`memmap` plugin).  
- Suspicious scheduled task in registry hive loaded in memory snapshot.

Example:
```bash
vol -f memory.raw windows.malfind --dump-dir extracted/
```
Output reveals injected section at `0x20000000` inside explorer.exe containing Lumma payload.

#### 4.4 Extracting Config Data
Dump memory section to file and run `strings –n 6 | grep "lumma"` — often leaks C2 URLs or build IDs.

---

### 5. Correlating Disk & Memory Findings

The magic happens when you **merge timelines**:

1. Disk artefact: Prefetch shows execution time = 09:22:17.  
2. Memory artefact: Process list shows PID 2412 created 09:22:17.  
3. Event log: Task creation 09:22:18.  
4. Network trace: HTTPS POST 09:22:20 to unknown domain.  

Together, these form an evidential chain strong enough for legal reporting.

---

### 6. Anti-Forensic Challenges

Attackers use:
- **RAM clearing** scripts (`cmd /c wevtutil cl System`).  
- **Self-deleting binaries**.  
- **Process Doppelgänging** / **Process Hollowing** (code injection without disk trace).  
- **Encrypted payloads** using runtime decryption.

Counter with:
- Continuous EDR snapshots.  
- Frequent memory captures on suspected hosts.  
- Automatic timeline creation for post-incident review.

---

### 7. Reporting and Documentation

Every forensic action must be **repeatable and verifiable**.  
Best practices:
- Maintain chain-of-custody log.  
- Record all command-line executions.  
- Store results and hashes with UTC timestamps.  
- Generate a concise executive summary for non-technical stakeholders.

---

### 8. Automation Ideas

Python-based collection script example:

```python
import os, subprocess, datetime, hashlib

def hash_file(path):
    h = hashlib.sha256()
    with open(path,'rb') as f:
        while chunk:=f.read(8192): h.update(chunk)
    return h.hexdigest()

ts = datetime.datetime.utcnow().strftime("%Y%m%d_%H%M%S")
subprocess.run(["winpmem.exe","--format","raw","-o",f"mem_{ts}.raw"])
print("Memory hash:", hash_file(f"mem_{ts}.raw"))
```

Extend this to collect registry hives and event logs for unified evidence bundles.

---

### 9. Key Takeaways

- **Volatility** + **Autopsy** form a complete open-source toolkit.  
- Persistence artefacts hide in plain sight — registry keys, scheduled tasks, or injected threads.  
- Always correlate volatile and static data.  
- Document every step for defensibility.

---

### 10. Next Steps

In **Week 2**, we’ll move from host artefacts to **Network Forensics**, analyzing PCAPs to uncover beaconing patterns and data exfil.  
Stay tuned for practical detection rules and Wireshark/Zeek examples.

---
