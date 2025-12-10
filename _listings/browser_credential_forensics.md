---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Browser & Credential Artefact Forensics on Windows"
pretty_title: "Browser & Credential Artefact Forensics on Windows"
excerpt: "Infostealers and banking trojans live and die by what your browser knows. This post walks through how to pull and interpret browser and credential artefacts on Windows so you can rebuild logins, sessions, and fraud timelines with confidence."
thumb: /assets/img/browser_credential_forensics_thumb.webp
date: 2025-12-11
featured: false
tags: [DFIR, Forensics, Windows, Browsers, Credentials]
---

Modern **infostealers, banking trojans, and RATs** don’t just drop files or encrypt disks — they go straight for what your browsers and credential stores know:

- **Saved usernames and passwords**
- **Cookies and session tokens**
- **Auto-fill data** (names, addresses, card fragments)
- **Credential manager entries** and **Windows secrets**

If you’re investigating account takeover, banking fraud, business email compromise (BEC), or data theft, you can’t just look at executable artefacts. You need to understand **what the browser and OS already had in memory and on disk**.

This post focuses on Windows endpoints and covers:

- Key browser artefacts for Chromium-based browsers (Chrome, Edge, Brave) and Firefox.
- Where and how credentials, cookies, and session data are stored.
- How to collect and parse those artefacts in a forensically sound way.
- How to use them to answer core questions: *What could the attacker see? What could they steal? Which accounts are at risk?*

---

## 1. Why Browser & Credential Forensics Matter

In many investigations, especially those involving **DanaBot, Lumma, Mispadu, and similar families**, the browser is the **centre of gravity**:

- Users authenticate to **banking portals, SaaS platforms, email, VPNs, and admin consoles** in the browser.
- Browsers store **session cookies**, which are often enough to bypass passwords and MFA.
- Extensions and password managers plug directly into the browser’s storage.

When those artefacts are stolen or abused, attackers can:

- Log into victims’ accounts from other machines.
- Hijack active sessions without ever knowing the password.
- Reuse credentials for other services due to **password reuse**.

Your job in DFIR is to work out, as accurately as possible:

- **What secrets were stored in the browser and system credential stores at the time of compromise.**
- **Which secrets were likely accessed or exfiltrated by the malware/operator.**
- **Which accounts need to be reset, monitored, or considered burned.**

---

## 2. Chromium-Based Browsers — Disk Artefacts

Chromium-based browsers include **Google Chrome, Microsoft Edge, Brave, Opera, Vivaldi**, and others. They share similar on-disk structures under the user profile.

By default, data is stored under (example for Chrome):

- `C:\Users\<USER>\AppData\Local\Google\Chrome\User Data\`

Edge and others are similar but with different vendor/product folders.

### 2.1 Key databases and files

Within a profile (e.g., `Default`, `Profile 1`), you’ll see:

- `History` — SQLite DB of visited URLs, titles, and visit times.
- `Cookies` — SQLite DB of cookies and associated metadata.
- `Login Data` — SQLite DB of saved logins (URLs, usernames, encrypted passwords).
- `Web Data` — SQLite DB with autofill entries (names, emails, phone numbers, card fragments).
- `Preferences` / `Secure Preferences` — JSON with configuration, extension data, and sometimes tokens.
- `Session Storage` / `Local Storage` directories — per-site key/value data (including some app tokens).

From a forensic perspective, the most critical for credential work are:

- **`Login Data`** — what passwords the browser knows.
- **`Cookies`** — which sites have active sessions and cookie lifetimes.
- **`Web Data`** — stored autofill that reveals where the user transacts and what personal data they’ve used.
- **Extension directories** — artefacts from password managers, crypto extensions, and banking add-ons.

### 2.2 Password storage and decryption

On modern Windows systems:

- Chromium browsers encrypt saved passwords using the **Windows Data Protection API (DPAPI)**.
- The actual password data in `Login Data` is stored in a column like `password_value`, encrypted.

To decrypt them, you need:

- The user’s context (i.e., access to their DPAPI secrets).
- Either live access on the host under that user, or offline decryption using DPAPI master keys and the user’s credentials.

Tools like **Chromepass, LaZagne, DPAPIdump/DPAPIck** and various forensic suites automate this, but the key observation is:

> If malware is running in the user’s context, it can call the same APIs and decrypt the same passwords and cookies that you can during forensics.

So if you find a rich `Login Data` database, assume **an infostealer or banking trojan could have harvested it**, unless you can prove otherwise.

### 2.3 Cookies and session tokens

The `Cookies` database stores:

- `host_key`, `name`, `value` (encrypted), `path`, `expires_utc`, `last_access_utc`, `is_secure`, `is_httponly`, etc.

Again, the values are DPAPI-protected, but malware running as the user can decrypt them.

For investigations, cookies matter because they indicate:

- **Where the user is logged in** or recently authenticated.
- **Which services are at risk of session hijacking**, not just password reuse.
- Whether logins to high-value services (e.g., admin portals, banking, crypto exchanges) were likely active at the time of compromise.

If you can decrypt cookies, you can sometimes:

- Validate which tokens correspond to **recent legitimate sessions**.
- Understand the attacker’s options in terms of replay value.

### 2.4 Autofill and card data

In `Web Data`, you’ll find:

- `autofill` tables with names, addresses, emails, and other fields.
- Saved **card fragments** (e.g., last four digits) and sometimes full card data depending on settings.

These show:

- Which merchants and services the user regularly transacts with.
- What data an overlay-based trojan (like Mispadu or DanaBot with web-injects) might target or pre-fill.

Even if card numbers themselves aren’t fully stored, knowing **which cards and merchants** are used is useful for fraud teams.

---

## 3. Firefox — Disk Artefacts

Firefox stores profile data under:

- `C:\Users\<USER>\AppData\Roaming\Mozilla\Firefox\Profiles\<PROFILE>.default-release`

Key files include:

- `places.sqlite` — history and bookmarks.
- `cookies.sqlite` — cookies.
- `logins.json` — saved logins (encrypted).
- `key4.db` — key material for decrypting saved logins.
- `formhistory.sqlite` — form autofill entries.

### 3.1 Passwords and keys

Saved logins in Firefox are stored in `logins.json`, with:

- Encrypted username and password fields.
- Metadata about the site, time created, last used, etc.

Decryption requires:

- `key4.db` (cryptographic keys).  
- The master password if one is set (rarely used in consumer setups).

From an attacker’s perspective, any malware running in the user context can:

- Query Firefox’s built-in password manager.
- Use the same crypto routines to decrypt entries, assuming no master password or a weak one.

From a DFIR perspective, if you obtain `logins.json` and `key4.db`, you can:

- Enumerate all sites where saved passwords exist.
- Identify high-risk accounts and prioritise resets/monitoring.

### 3.2 Cookies and sessions

`cookies.sqlite` is a SQLite DB similar conceptually to Chromium’s Cookie DB:

- One row per cookie, with domain, name, value, expiry, last access, etc.

Again, these can be used for:

- Mapping out where the user is or was logged in.
- Assessing the **session replay risk** for cloud services, banking sites, and internal portals.

---

## 4. Windows Credential Stores and Secrets

Browsers are only one part of the credential landscape. Windows itself stores secrets in several locations.

### 4.1 Credential Manager (Windows Vault)

Windows Credential Manager holds:

- **Web credentials** — some browser-stored passwords and site credentials.
- **Windows credentials** — domain logons, mapped drives, RDP creds.
- **Generic credentials** — app-specific tokens.

They are protected by DPAPI and accessible through the user’s session or specialised tools.

For DFIR, enumerating Credential Manager entries helps you identify:

- Saved **RDP or VPN credentials** that an attacker could reuse.
- Stored passwords for internal line-of-business apps.
- Tokens used by backup or sync tools.

### 4.2 LSASS and memory-resident secrets

On compromised hosts, attackers and infostealers may:

- Dump **LSASS** to extract NTLM hashes, Kerberos tickets, and plaintext passwords (if available).
- Use tools like `mimikatz` or custom injectors.

When you see evidence that LSASS was accessed or dumped:

- Treat all credentials present in memory at that time as potentially compromised.
- Combine your understanding of **who was logged in** (event logs) with the presence of tools or memory artefacts.

### 4.3 DPAPI master keys

DPAPI master keys live under the user profile and are protected by login secrets. Malware that steals these keys together with encrypted blobs may be able to **decrypt secrets offline** later.

As an investigator, if you have:

- The relevant master keys.
- User password or NT hash (from domain controllers or LSASS).

…you can reconstruct **which secrets were effectively exposed** if a DPAPI-aware infostealer was present.

---

## 5. Collection Strategy — Doing It Safely and Usefully

When collecting browser and credential artefacts:

1. **Preserve first** — acquire images or snapshots before making changes.
2. **Collect both disk and memory** where possible:
   - Disk: browser profiles, credential manager data, registry hives.
   - Memory: LSASS, browser processes, infostealer processes.

3. **Document context**:
   - User accounts logged in at time of acquisition.
   - System time, timezone, and any known clock drift.
   - What anti-malware or EDR was installed, and what it logged.

4. **Avoid tools that modify artefacts**:
   - Prefer read-only collection tools where possible.
   - If live response is necessary, keep command footprint small and well-documented.

The goal is not just to extract secrets, but to **preserve enough state** that you can later reconstruct whether malware did the same.

---

## 6. Turning Artefacts into Answers

Browser and credential data can answer questions such as:

- **Which accounts are at immediate risk?**
  - All accounts with saved passwords in `Login Data` or `logins.json`.
  - All services with active cookies on the day of compromise.

- **Which high-value services were in use?**
  - Admin portals, VPNs, RDP gateways, cloud infrastructure consoles.

- **Was this fraud likely “manual” or scripted?**
  - Manual fraud: carefully targeted banking portals, specific merchants, time-aligned with user activity.
  - Bulk resale: large volumes of credentials for diverse sites, likely dumped and sold.

- **Did the malware have enough time and access to harvest everything?**
  - Compare time between initial infection and detection/removal.
  - Correlate with evidence of data exfiltration or infostealer C2 traffic.

In reports, turn raw artefacts into concise statements, for example:

> At the time of infection, the Chrome `Login Data` store contained saved credentials for 27 unique domains, including two online banking portals and three cloud admin consoles. Given the presence of an infostealer and the lack of DPAPI hardening, we assess it as likely (>70%) that all browser-stored credentials were exfiltrated.

---

## 7. Practical Triage Workflow

A stripped-down workflow for real incidents:

1. **Identify malware type** — banking trojan, generic infostealer, RAT with credential modules.
2. **Collect browser and credential artefacts** from affected users.
3. **Enumerate saved logins and cookies**:
   - Prioritise banking, email, VPN, admin, and financial portals.
4. **Map accounts to business impact**:
   - Which are corporate vs personal?
   - Which are shared or privileged?
5. **Trigger credential resets and monitoring** in parallel with analysis.
6. **Correlate with external signals**:
   - Fraud notifications, bank alerts, login anomalies on cloud services.
7. **Document assumptions and gaps**:
   - If you lack certain artefacts (e.g., no LSASS dump, logs rolled), clearly state where you’re estimating risk.

This keeps you moving even when you don’t have full perfect evidence.

---

## 8. Hardening Against Browser & Credential Theft

You can’t prevent users from using browsers, but you can:

- **Reduce what the browser knows**:
  - Policies to **disable storing passwords** in built-in managers where feasible.
  - Encourage or mandate **dedicated password managers** with strong master passwords and MFA.
  - Limit browser use on **high-risk roles** (finance, treasury, domain admins).

- **Harden high-value endpoints**:
  - Use dedicated, locked-down workstations for banking and privileged admin duties.
  - Enforce application allow-listing and strong EDR on those boxes.
  - Limit which users can log into them interactively.

- **Improve identity posture**:
  - MFA everywhere, preferably phishing-resistant methods (FIDO2, platform authenticators).
  - Conditional access and device trust for cloud services.
  - Frequent credential hygiene (no cached high-priv creds on everyday endpoints).

- **Monitor for infostealer patterns**:
  - Look for processes that enumerate browser profile directories and read SQLite/JSON credential stores.
  - Watch for outbound connections characteristic of known infostealer C2s.
  - Integrate threat intel on **MaaS stealer and banking trojan families** into detection content.

---

## 9. Closing Thoughts

Browsers and credential stores are the **real prize** in many modern intrusions. Disk encryption, fancy EDR, and network microsegmentation don’t help much if an infostealer can quietly siphon:

- All of a user’s saved passwords.
- Their active session tokens for banking and admin portals.
- Autofill data and card fragments useful for fraud and social engineering.

Forensic work here isn’t glamorous reverse engineering. It’s patient, methodical **artefact analysis** that tells you:

- What secrets existed.
- Which ones were probably exposed.
- Where to focus remediation.

Once you’re comfortable navigating **Chromium and Firefox artefacts, Windows Credential Manager, DPAPI, and LSASS-related traces**, you’ll be in a strong position to support investigations around:

- Banking trojans like DanaBot, Mispadu, Grandoreiro.  
- Infostealers and MaaS platforms going after browser data at scale.  
- Account takeover and BEC cases where the exploit path is “just” a malicious email plus a greedy browser.

The better you get at reading what the browser and OS already knew, the fewer surprises you’ll have when the next stealer or trojan hits your environment.
