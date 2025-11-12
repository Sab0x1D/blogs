---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Network Forensics — Tracking a C2 Through PCAPs"
pretty_title: "Network Forensics — Tracking a C2 Through PCAPs"
excerpt: "Follow the traffic, find the truth. A hands-on guide to identifying command-and-control activity using Wireshark, Zeek, and open-source techniques."
thumb: /assets/img/network_forensics_thumb.jpg
date: 2025-11-13
featured: false
tags: [DFIR, Forensics, Network, Investigation]
---

### 1. Introduction

Every breach leaves a network trail — even the stealthiest implants must *phone home*.  
Network forensics captures those whispers: C2 beacons, DNS tunnels, encrypted uploads, and odd timing patterns.

This guide walks through real PCAP analysis to uncover a malware C2 session, demonstrating techniques usable in any enterprise DFIR workflow.

---

### 2. Tooling Stack

| Tool | Purpose |
|------|----------|
| **Wireshark** | Packet inspection & visualization |
| **Zeek (Bro)** | Session-level analysis & log generation |
| **NetworkMiner** | File reconstruction & metadata |
| **TShark** | CLI automation |
| **JA3/JA4** | TLS fingerprinting |

Setup:  
`sudo apt install zeek tshark wireshark networkminer`  
Ensure capture interface is in promiscuous mode.

---

### 3. Capturing the Traffic

On a suspect host:  
```bash
tcpdump -i eth0 -w capture.pcap
```
During incident response, limit to 10 minutes or < 1 GB to avoid overhead.  

Hash and store the PCAP as read-only.  

---

### 4. Quick Triage in Wireshark

1. Apply display filter: `tcp.port == 443 || tcp.port == 80`.  
2. Sort by conversation bytes → spot anomalies.  
3. Use **Statistics → Endpoints** → unknown remote IPs.  
4. Follow TLS handshake → note SNI and JA3.  

Example:  

| IP | SNI | JA3 | Bytes Out | Notes |
|----|-----|-----|------------|-------|
| 185.198.57.44 | cdn-rhad[.]xyz | c53ca0aee6d8d2a90f8a4100e13f94c4 | 600 KB | Suspicious C2 upload |

---

### 5. Zeek Deep Dive

Run Zeek on the PCAP:

```bash
zeek -r capture.pcap
```

Generates logs: `conn.log`, `ssl.log`, `http.log`, `files.log`.

#### 5.1 Connection Analysis
```
cat conn.log | zeek-cut id.orig_h id.resp_h service duration orig_bytes resp_bytes
```
Look for long-lived HTTPS sessions (> 600 s) with low response bytes.

#### 5.2 SSL/TLS Inspection
```
cat ssl.log | zeek-cut ja3 ja3s subject
```
Cross-check JA3 hashes with known malware fingerprints on https://ja3er.com.

---

### 6. Behavioural Indicators

- **Beacon timing:** equal interval sessions (e.g., every 600 s).  
- **Data ratio:** high upload / low download.  
- **Domain age:** WHOIS < 30 days.  
- **DNS entropy:** subdomain strings > 20 chars.  
- **TLS versions:** rare cipher suites or missing SNI.  

Use Wireshark IO Graph (`Statistics → IO Graph`) to visualize beacon patterns.

---

### 7. Case Study — Rhadamanthys C2 Session

Captured traffic shows:
- Outbound HTTPS to `cdn-rhad[.]xyz` every 610 s.  
- JA3 `c53ca0aee6d8d2a90f8a4100e13f94c4`.  
- POST requests to `/gate.php`.  
- Upload sizes ~ 700 KB.  

Using Zeek `files.log`, analyst reconstructs ZIP archives matching Lumma/Rhad style credential bundles.

---

### 8. Correlating Host and Network Data

1. Memory analysis shows PID 2412 → `explorer.exe` injected with Rhad payload.  
2. Prefetch + MFT confirm DLL drop time = 09:22:17.  
3. PCAP shows C2 POST 09:22:20 → full chain established.

Timeline correlation connects network trace to on-disk artefacts beyond reasonable doubt.

---

### 9. Automated Detection Using Zeek Scripts

```zeek
event zeek_init() {
  print "Loaded Rhadamanthys beacon detector";
}

event http_request(c: connection, method: string, host: string, uri: string) {
  if ( /gate\.php/ in uri && /RhadClient/ in c$user_agent )
    print fmt("Possible Rhad C2 from %s to %s", c$id$orig_h, host);
}
```

Output:  
```
Possible Rhad C2 from 10.37.129.60 to cdn-rhad.xyz
```

---

### 10. Mitigation Checklist

**For Blue Teams**
- Block C2 domains/IPs.  
- Use JA3 and URI signatures in proxy logs.  
- Implement rate-based alerting on regular HTTPS POSTs.  
- Mirror traffic to Zeek for continuous inspection.

**For Analysts**
- Always capture before containment — live traffic is volatile.  
- Store hashes of PCAPs with UTC timestamps.  
- Build a personal library of JA3 fingerprints.

---

### 11. Closing Notes

Network forensics bridges the gap between endpoint and intel.  
By combining PCAP review, Zeek analysis, and TLS fingerprints, you can recreate entire attack flows even after disk evidence is wiped.  

In Week 3, we’ll turn to **Email Forensics — Tracing a Phish End-to-End**, connecting headers, SPF/DKIM failures, and payload chains.

---
