---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 13 Oct 2025"
pretty_title: "Weekly Threat Trends<br>Week Commencing 13 Oct 2025"
excerpt: "A detailed look at the cyber threat landscape observed across 13–19 October 2025 — including fake coding interview scams, Salesforce abuse, QR-based phishing, and emerging stealer campaigns."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2025-10-20
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

> A weekly summary of the most notable cyber incidents, scam campaigns, and malware developments observed across the global landscape.  
> The intent is to translate technical events into actionable awareness — for defenders, analysts, and everyday users alike.

---

### Top Trends at a Glance
- Sophisticated **LinkedIn-based recruitment scams** continue to deploy malware under the guise of “coding tests”.
- Repeated **abuse of Salesforce-hosted domains** for phishing against Meta business users.
- **QR-based phishing** becomes more localized and frequent in physical environments.
- **Stealer-as-a-Service (SaaS)** platforms show renewed activity, with RedLine, Lumma, and a new Go-based loader gaining traction.
- Continued rise in **AI-augmented scams** — deepfake voices, cloned profiles, and synthetic job offers.

---

### 1. Fake Interview Projects Targeting Developers
The most discussed campaign this week involved fake recruiters posing as representatives of legitimate blockchain or fintech firms on LinkedIn.  
Attackers contacted experienced developers with convincing pre-interview chats, complete with corporate logos and cloned HR profiles. The “next step” was a short coding test hosted on Bitbucket or GitHub — usually a small React/Node or Python project.  

Inside the archive: a clean project tree, with readme files, a proper package.json, and comments that appeared legitimate. Hidden deeper were **malicious dependency chains** — either through a tampered `npm` package or an obfuscated binary loader disguised as an image or test data file.  
Once executed, the payload established outbound connections to C2 servers and fetched stealer components.  

This campaign illustrates a growing trend: **threat actors leveraging professional networks** rather than generic spam. The attackers relied on credibility (real company names, professional communication tone) instead of social media randomness.

**Why it matters:**  
Developers are trusted users with broad access to systems and repositories. By compromising their devices, attackers gain entry points into CI/CD pipelines, production servers, and API keys.  

**Recommendations:**  
- Treat any test code or recruiter-provided files as potentially unsafe.  
- Perform all assessments in **isolated virtual machines** or sandboxed environments.  
- Verify the sender’s email domains and company affiliation independently before engaging.

---

### 2. Salesforce Phish Abuse Resurgence
Phishing actors continued exploiting Salesforce-hosted domains to deliver highly convincing credential traps targeting **Meta Business Suite** and **Instagram for Business** users.  

Because Salesforce is a legitimate enterprise SaaS provider with strong reputational trust, these URLs bypassed many secure email gateways and link scanners. The phishing pages closely mirrored Meta’s real support dashboards, even featuring working navigation links that redirected to legitimate Meta domains after credential submission.  

The technique relies on hosting the phishing content on an abused Salesforce community subdomain, giving it a genuine SSL certificate and brand association.  

**Trend note:**  
This tactic has been circulating since early 2023 but shows no sign of slowing down. Over the last two months, analysts have observed **a sharp uptick in domain registrations** mimicking internal Salesforce pages, often with language-specific branding (e.g., `/es/` or `/fr/`).

**Why it’s effective:**  
Victims recognize the Salesforce domain and assume legitimacy, especially when the page is linked from a believable “Meta Ads” email or message.  

**Defensive considerations:**  
- Train users to identify **legitimate Meta Support URLs**.  
- Deploy **browser isolation** or content security filters for Salesforce domains used externally.  
- Engage in threat intelligence monitoring for **Salesforce community subdomains** containing Meta-related keywords.

---

### 3. QR Code Phishing Expands to Public Infrastructure
A growing number of cities in Australia, the UK, and parts of North America reported **QR code tampering** in public locations — parking meters, restaurant menus, and bus stops.  

The scheme involves attackers placing stickers with malicious QR codes over legitimate ones. Scanning these redirects victims to phishing portals mimicking payment processors or mobile banking login pages.  
Because the pages are optimized for mobile browsers and use legitimate branding (including copied favicons and HTTPS certificates from cheap CAs), the visual deception is strong.  

**What’s new this week:**  
In several confirmed cases, the QR code pages dynamically changed based on the victim’s region or phone type, serving localized lures (e.g., “Service NSW Toll Payment” for Australian users or “TfL Parking Portal” for London). This suggests organized, automated infrastructure rather than isolated prank campaigns.  

**Impact:**  
QR-based phishing bridges the physical and digital worlds, bypassing traditional email or web controls. Once credentials are entered, victims are redirected to real payment pages — creating the illusion of a successful transaction until unauthorized charges appear later.  

**Mitigation:**  
- Treat unsolicited QR codes as untrusted, even in familiar environments.  
- For organizations, incorporate QR phishing scenarios into **awareness training** modules.  
- Encourage physical inspections of public assets and report tampered codes to local authorities.

---

### 4. Malware Activity Overview
Telemetry from community sensors and public sandboxes (including Abuse.ch, ANY.RUN, and Malpedia tracking) revealed several notable developments:  

#### RedLine Stealer
Remains the most active commodity infostealer, distributed via spam attachments and malicious download sites disguised as browser updates.  
Operators continue to rotate their command-and-control domains daily, often leveraging short-lived TLDs (`.cam`, `.click`, `.xyz`). Payloads showed increased obfuscation and a shift toward PowerShell droppers.  

#### LummaC2
Updated modules were seen with improved crypto wallet extraction and anti-VM logic. Lumma is being sold under subscription models, with new “premium” tiers offering automatic data exfiltration dashboards.  

#### New Go-based RAT (unclassified)
A new remote access tool compiled in GoLang surfaced in cracked installer archives and Telegram channels. The binary embeds encrypted configuration blocks and communicates via WebSockets, suggesting a modular architecture.  

#### Agent Tesla
Still a persistent threat across email-based delivery, now using LNK and HTML smuggling methods to bypass detection. Distribution mimics legitimate Windows Defender update alerts or plugin installers.  

**Overall trend:**  
Commodity malware families are converging toward **modular loader ecosystems**, where multiple stealers, RATs, and credential collectors share infrastructure or loaders for efficiency.  

**Recommendations for defenders:**  
- Expand **YARA coverage** for Go-based payloads and obfuscated PE sections.  
- Ensure endpoint logging captures **PowerShell execution** and **network anomalies**.  
- Where possible, integrate sandbox detonation into email gateways to pre-detonate suspicious attachments.

---

### 5. Social Engineering & Scam Evolution
Social engineering remained the top initial access vector this week, with several ongoing campaigns adapting their tactics:

#### Crypto and Investment Fraud
Telegram and X (formerly Twitter) saw a wave of “investment bot” scams, using cloned profiles of known influencers or blockchain founders.  
Victims were encouraged to “test” the bot with small deposits, which were promptly drained. These operations mimic legitimate interfaces, often using previously breached API tokens to simulate transaction activity.

#### AI-Voice Vishing
Corporate finance departments reported increased incidents of deepfake voice calls purporting to be executives authorizing urgent transfers. In some cases, the cloned voices were reconstructed from **public podcast appearances** or YouTube videos.  
A single call can now be generated from less than two minutes of source audio using AI voice models, making verification extremely difficult.

#### Parcel and Toll Smishing
Classic SMS lures impersonating postal services or road toll agencies continued in large volume. Many now include short-lived links using Cloudflare R2 storage or CDN mirrors, making takedown efforts harder.  
While not novel, the **consistency and frequency** of these campaigns remain a major threat for less tech-savvy users.

---

### 6. Defender’s Corner
Key mitigations and focus points derived from the week’s activity:

- **Secure developer pipelines:** Conduct code reviews for any third-party or test submissions; sandbox execution environments used during interviews or freelance contracts.
- **Email and link filtering:** Expand inspection coverage for legitimate SaaS domains (e.g., Salesforce, Google Forms, HubSpot) as these are frequently abused for phishing.
- **Public QR verification:** Introduce public awareness campaigns warning against scanning unverified QR codes, especially those related to payments or parking.
- **Enhanced endpoint logging:** Track script interpreters (PowerShell, WScript, mshta) and correlate with outbound traffic.
- **MFA and credential hygiene:** Reinforce multi-factor authentication and encourage password managers to mitigate the impact of stolen credentials.
- **Security awareness refresh:** Focus October training content on *AI-enabled deception* — fake voices, cloned profiles, and deepfake visuals.

---

### Week in Summary
The week of **13–19 October 2025** reinforced the continued fusion of social engineering and technical compromise. Threat actors no longer rely solely on exploit kits or zero-days — they manipulate workflows, recruitment processes, and SaaS trust models instead.  

From fake HR interviews to Salesforce-hosted phish and localized QR scams, the emphasis is shifting toward **blending into legitimate environments** rather than breaking into them.  
Malware payloads remain secondary — the true weapon is still *credibility*.

For defenders and organizations, the coming quarter demands:
- Tighter scrutiny over **trusted platforms**.  
- Continuous awareness training focused on **social vectors**.  
- Ongoing monitoring for **brand abuse** and **domain impersonation**.  

Trust is the new attack surface — and 2025’s threat landscape is proving just how easily it can be exploited.

---
