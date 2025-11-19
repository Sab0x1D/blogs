---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Email Forensics — Tracing a Phish End-to-End"
pretty_title: "Email Forensics — Tracing a Phish End-to-End"
excerpt: "Phishing is the initial access vector in most intrusions. This deep guide walks through header analysis, payload extraction, and chain reconstruction so you can follow a phish from delivery to C2."
thumb: /assets/img/email_forensics_thumb.webp
date: 2025-11-20
featured: false
tags: [DFIR, Forensics, Email, Investigation]
---

Email remains the dominant initial access vector. Forensics must reconstruct the delivery chain (sender → MTA → client), analyze headers for spoofing indicators (SPF/DKIM/DMARC), extract payloads and follow redirect/tracking chains, and tie the resulting indicators back to endpoint and network artefacts.

---

## 1. Evidence Sources & Preservation

- **Raw RFC‑822 message** (`.eml`): includes headers, body, and attachments.  
- **Gateway logs**: connection IPs, HELO/EHLO, auth results, filtering decisions.  
- **Client artefacts**: downloads folder, Outlook OST/PST, webmail browser history.  
- **Endpoint telemetry**: process creation after open/click, registry changes.  
- **Network data**: DNS queries, proxy logs, PCAP if available.

Always preserve originals read‑only; compute SHA‑256 and document timestamps in UTC.

---

## 2. Header Analysis — The Fast Path

Key fields to validate:

- `Return-Path` vs `From` (bounce address often reveals sending service).  
- `Received` chain (read bottom‑up; earliest hop exposes origination path).  
- `Message-ID` (domain, timestamp anomalies).  
- `Authentication-Results` (SPF/DKIM/DMARC).  
- `ARC-Seal` (forwarding context).

**Triage cues:** SPF=fail + DKIM=fail on a brand domain; mismatched HELO vs connecting IP; impossibly fresh domain for a “vendor” sender.

---

## 3. SPF / DKIM / DMARC — How To Read Them

- **SPF**: does the sender IP appear in the domain’s `v=spf1` TXT? Forwarding can break SPF; correlate with DKIM.  
- **DKIM**: cryptographic signature of headers/body; if pass → the signed domain actually sent/authorized it.  
- **DMARC**: domain’s alignment policy. If fail + policy=reject, why did your gateway allow it? Check exceptions and mail flow.

---

## 4. Attachments & Links — Safe Extraction

### 4.1 Extract Attachments
- Decode from base64 directly from the raw `.eml` (do not rely on the mail client).  
- Hash (`sha256`) and store separately.  
- For Office docs: `oledump.py`, `olevba`, and macro stream review.  
- For PDFs: `pdfid.py`, `peepdf`, embedded JS/launch actions.

### 4.2 Enumerate Links
- Extract URLs from HTML and plain‑text parts.  
- Expand shorteners in a sandbox (`curl -I -L --max-redirs 5`).  
- Record each hop (time, status code, domain age) to build the redirect chain.

---

## 5. Reconstruction — From Inbox to C2

1. **Delivery** — `Received` shows origination; note geolocation and ASN.  
2. **Render** — body/HTML show visual lure and hidden links.  
3. **User Action** — click or open; correlate with browser history and OS `RecentDocs`.  
4. **Payload** — attachment detonation or landing page JS triggers download.  
5. **Execution** — child process chain (`winword.exe` → `wscript.exe` → `powershell.exe` / `mshta.exe`).  
6. **C2** — outbound TLS POST with small responses and regular timing.

Build a **timeline** with absolute times (UTC) mapping each step.

---

## 6. Case Study (Simulated, Realistic)

- **09:12:00Z** — Mail accepted from `203.0.113.55`; SPF=fail, DKIM=none.  
- **09:12:35Z** — User opens; clicks `hxxps://short[.]ly/a1b2`.  
- **09:12:36Z** — Redirect → `hxxps://track[.]redir‑svc[.]com/?t=...` → `hxxps://cdn‑docs[.]site/invoice_update.exe`.  
- **09:12:44Z** — Download saved to `%UserProfile%\Downloads\invoice_update.exe`.  
- **09:12:50Z** — `invoice_update.exe` spawns `powershell.exe` with base64; registry Run key added.  
- **09:12:55Z** — TLS POST 620 KB to `hxxps://cdn‑docs[.]site/api/submit` every 600 s.

From headers, body, client, and PCAP we now have a complete chain linking delivery to C2.

---

## 7. Tooling Quick Recipes

**Parse headers (Python):**
```python
import email
m = email.message_from_file(open('raw.eml','r',encoding='utf-8',errors='ignore'))
print(m['From'], m['Return-Path'])
for r in m.get_all('Received', []): print('Received:', r)
```

**Extract URLs (shell):**
```bash
grep -Eo '(https?://[^")\s]+)' raw.eml | sort -u > urls.txt
```

**Expand redirects (safe env):**
```bash
while read u; do curl -s -I -L --max-redirs 5 "$u" | awk 'BEGIN{ORS=" "} /^HTTP|^Location:/'; echo; done < urls.txt
```

---

## 8. Correlation With Endpoint & Network

- Match **process start times** (EDR logs) to email open/click times.  
- Match **DNS queries** and **proxy SNI** with redirect hops.  
- If memory dump exists, search for **URL fragments** and **UA strings** present in the email’s landing page scripts.  
- Pivot from hashes and URLs into TI platforms to see **wider campaign context**.

---

## 9. Detection & Hunting

**Mail Gateway**
- Rule: flag `spf=fail AND dkim=fail` for domains in your address book.  
- Rule: quarantine messages with first‑seen sender domain age < 30 days + `Brand-Keywords` in subject.

**Endpoint**
- Alert on `winword.exe` spawning `wscript`/`mshta`/`powershell`.  
- Watch for Run/RunOnce keys created within 2 minutes of a new download in `Downloads/`.

**Network**
- Detect periodic HTTPS POSTs with high upload/low download.  
- Track JA3/JA4 fingerprints known for malware loaders.

---

## 10. Reporting & Chain of Custody

- Save `.eml`, attachment, hashes, and every hop in the redirect chain.  
- Keep time‑normalized (UTC) evidence tables.  
- Redact personal data when sharing externally.  
- Write a short **executive summary** explaining business impact and required user actions.

---

## 11. User Guidance Snippets (Drop‑in)

- “If you clicked a link, change passwords from a **separate** trusted device; enable MFA.”  
- “If you opened an attachment, **do not reboot** unless IR instructs — we may need a memory capture.”  
- “Verify invoices or urgent requests via a second channel before acting.”

---

## 12. Final Thoughts

Email forensics is about **stitching evidence**: headers show the road in, body shows the lure, attachments/links show the payload, endpoint shows execution, and the network reveals the C2. When you can narrate each hop with timestamps and artefacts, containment is faster and defensible.

---
