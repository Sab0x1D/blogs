---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 2nd February 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 2nd February 2026"
excerpt: "The first week of February 2026 brings a clean picture of where the fight is headed: selective supply-chain compromises of dev tooling, hypervisor and mail-server exploits wired into ransomware playbooks, AI platforms abused as malware infrastructure, a major DeFi treasury drain, and the usual long tail of healthcare, retail and airport data breaches."
thumb: /assets/img/weekly_trends_generic_thumb.webp
date: 2026-02-08
featured: false
tags: [Weekly Trends, Weekly Threats, Ransomware, Supply Chain, AI, Identity, ICS, Data Breach]
---

The week commencing **2nd February 2026** is a tidy snapshot of what “modern” risk looks like:

- **Dev tools and update channels** being used as surgical supply-chain entry points.
- **Hypervisors, mail servers and UC platforms** sitting in the blast radius of active exploits.
- **AI platforms and extensions** doing double duty as both victim and infrastructure.
- **DeFi and crypto treasuries** being drained via compromised executive endpoints.
- A steady background hum of **data breaches and extortion** across healthcare, retail, airports and consumer apps.
- More **ICS advisories** quietly landing for systems that keep the lights and water on.

None of it is a surprise, but the pattern is getting sharper: attackers are following **developer workflows, identity planes, and AI usage** wherever they go.

---

## Top Trends at a Glance

The biggest themes this week:

- **Selective supply-chain compromises of developer tooling** – Notepad++ update infrastructure hijacked to selectively deliver backdoors to high-value users.   
- **Edge and infrastructure vulns actively wired into ransomware** – critical flaws in VMware ESXi, SmarterMail and Cisco UC added to “known exploited” lists, with live ransomware use confirmed.   
- **AI infrastructure abused as malware hosting** – Android RAT payloads delivered from legitimate AI hosting (Hugging Face), and malicious browser extensions siphoning ChatGPT sessions.   
- **Crypto/DeFi treasury compromise via exec devices** – around USD $40M drained from a Solana DeFi treasury by compromising executive endpoints, not smart contracts.   
- **Data-heavy sectors still bleeding records** – healthcare clearinghouses, electronics retailers, airports and dating platforms all showing up in breach and extortion reporting.   
- **ICS/OT and building controls under continuous scrutiny** – fresh advisories for Johnson Controls, Schneider Zigbee, and other OT-adjacent components in energy and water.   

The rest of this post walks through each of those and turns them into concrete defensive priorities.

---

## 1. Supply-Chain Attacks on Dev Tooling

The cleanest example this week is a **supply-chain compromise of Notepad++** – a ubiquitous text editor in dev and ops environments.

### What Happened

- A China-linked espionage group (tracked as **Lotus Blossom**) compromised **update infrastructure** used by Notepad++ between mid-2025 and early Q3.   
- Instead of pushing malicious updates to everyone, they **selectively served backdoored packages** to specific targets.
- Those updates delivered a custom backdoor designed for **interactive access and data theft**, not smash-and-grab monetisation.

This landed publicly now because **forensics finally caught up** — the dev and incident responders were able to reconstruct:

- How the update URL was hijacked.
- Which time windows were affected.
- The subset of users who ever spoke to the malicious infrastructure.

### Why It Matters

This is the quiet, mature version of supply-chain compromise:

- **No mass worm**, no noisy ransomware, no obvious “patch now!” moment.
- A widely trusted dev/ops tool used as **selective ingress** into high-value environments.

If you zoom out, you get a few lessons:

- “Small, safe tools” (editors, viewers, utilities) are highly attractive:
  - Massive install base.
  - Historically **minimal scrutiny on their update channels**.
- Attackers don’t always want scale; sometimes they want **precision**:
  - Only certain ASNs.
  - Only certain countries.
  - Only systems that “look” like dev boxes or jump hosts.

### What to Do About It

For defenders, this is a nudge to treat update mechanisms as **part of your threat model**, not plumbing you never question:

- For **internal tools**:
  - Sign releases.
  - Pin endpoints.
  - Log and review update behaviour periodically.
- For **third-party utilities**:
  - Inventory where they exist on **sensitive hosts** (build servers, CI/CD runners, jump boxes).
  - Monitor for:
    - Unusual update destinations.
    - Processes that normally never touch the internet suddenly doing so.
- Build one or two **“supply-chain compromise” tabletop scenarios**:
  - “What if our favourite internal CLI or editor shipped a backdoor for 3 months and we only now found out?”

---

## 2. Edge & Infrastructure Vulnerabilities in the Crosshairs

If 2024–2025 was the era of VPN and firewall bugs on repeat, early 2026 is doubling down on **hypervisors, mail servers and UC platforms**.

### ESXi / vCenter: Hypervisors as Tier-0

Broadcom and CISA have now both confirmed that **multiple VMware ESXi and vCenter vulnerabilities** were exploited as **zero-days** in the wild before patches landed:

- At least one critical bug (for example, **CVE-2025-22225**) allows an unauthenticated attacker on the management network to trigger **remote code execution** on the hypervisor.   
- Huntress and others have seen these chained with additional flaws for reliable exploitation across **a wide range of ESXi builds**.
- CISA has placed these in the **Known Exploited Vulnerabilities (KEV)** catalogue and explicitly tied them to **ransomware activity**.

If you are still treating hypervisors as mundane infrastructure, this is your reminder: **ESXi is effectively a domain controller for workloads**. If an attacker owns it, they don’t need to care which guest OSes are “hardened”.

### SmarterMail: Email & Collab as Front Doors

A critical remote-code-execution bug in **SmarterTools SmarterMail** (tracked as **CVE-2026-24423**) is now confirmed as an entry vector for at least one **ransomware campaign**:

- Internet-exposed SmarterMail servers can be compromised without valid credentials.
- Once inside, attackers get:
  - **Mail store access** (great for recon and BEC).
  - A beachhead in a DMZ or internal network.
  - An on-box platform for staging lateral movement.   

CISA’s KEV entry explicitly notes **active exploitation by ransomware operators**.

### Cisco UC: Voice and UC in Scope

On top of that, CISA also added a critical **RCE in Cisco Unified Communications (CVE-2026-20045)** to KEV:

- Attackers able to reach vulnerable UC components can execute code with high privilege.
- UC stacks are often:
  - Poorly segmented.
  - Under-patched (because “phones must keep working”).
  - Trusted by admins more than they should be.   

### The Pattern

The meta-trend here:

- Hypervisors, mail/collab servers, and UC gear are all **“edge-plus-inside”**:
  - They face untrusted networks *and* have deep reach into your environment.
- CISA quietly marked **dozens of CVEs as “known ransomware use” in 2025**, not all of which hit mainstream news.   

If you only prioritise based on CVSS and headlines, you will miss some of the **real-world initial-access workhorses**.

---

## 3. AI Platforms as Malware Infrastructure, and the Browser as the New OS

AI isn’t just a feature of attacks now; **AI platforms themselves are becoming part of the infrastructure attackers lean on**.

### Hugging Face Used as a RAT CDN

Bitdefender’s writeup this week is a perfect example:

- Android remote-access trojans are being delivered via **Hugging Face**, a widely used AI/model-hosting platform.   
- To victims and security controls, payloads look like:
  - Downloads from a trusted AI provider.
  - Part of normal ML workflows or experimentation.
- For attackers, this gives:
  - High deliverability and domain trust.
  - Flexible storage and versioning.

We’ve seen this story before with GitHub, Pastebin, Google Docs… AI infra is just the latest **“legit platform as staging point”**.

### Malicious ChatGPT Extensions & Session Theft

On the client side, **browser extensions** that claim to “help” with AI usage continue to show up in incident feeds:

- Malwarebytes and others flagged at least **16 malicious Chrome/Edge extensions** posing as ChatGPT helpers (bulk deletion, prompt management, export tools).   
- Under the hood, they:
  - Harvest **session cookies and tokens**.
  - Allow full access to:
    - Chat history.
    - Conversation content (including anything sensitive pasted in).
  - Phone home telemetry that can be used to **re-identify users across time and devices**.

This is the browser equivalent of giving an attacker a remote shell on your “AI client”.

### Why It Matters

Put together:

- AI hosting platforms are now **part of attacker infrastructure**.
- AI helper extensions are **part of the endpoint attack surface**.

Defensive implications:

- Treat traffic to AI infra (Hugging Face, etc.) as **high-context**:
  - Don’t blindly block.
  - Do log and investigate odd patterns:
    - Unexpected hosts contacting AI domains.
    - Non-dev endpoints suddenly pulling model artefacts.
- Lock down browser extensions on managed fleets:
  - Use **allow-lists**, especially on admin/dev/jump hosts.
  - Treat “AI helper” extensions as **high risk by default** until vetted.

---

## 4. DeFi / Crypto: Treasury Drains via Executive Endpoints

The largest discrete loss this week is in the crypto space.

### Step Finance Treasury Compromise

On **31st January 2026**, attackers drained roughly **USD $40 million** from **Step Finance’s** treasury on Solana:

- Root cause is **compromised executive devices**, not a smart-contract bug:
  - Attackers obtained access to keys / seed phrases associated with treasury control.
- Initial estimates called out at least **261,854 SOL** stolen, with later analysis revising both theft and partial recovery figures.   
- Token controls and partner intervention allowed **only a small portion** of funds to be clawed back.

This is exactly the kind of attack we should expect more of:

- The path of least resistance isn’t always the protocol; it’s the **human and their endpoint**.
- Executives and treasury operators often:
  - Use personal devices.
  - Blend personal and corporate wallets.
  - Work around friction in signing flows.

### Lessons Beyond Crypto

Even if you aren’t in DeFi, you can treat this as a case study for **high-value transaction workflows**:

- Anywhere an individual’s device can approve payments, transfers, or policy changes, you must assume:
  - “Attacker owns this device” is a realistic scenario.
- Controls that help:
  - Dedicated, locked-down devices for treasury / high-risk approvals.
  - Hardware wallets with clear separation between personal and corporate assets.
  - Strict rules around **seed phrase storage** and “break glass” recovery processes.

---

## 5. Data Breaches & Extortion: Healthcare, Retail, Airports, Apps

The background noise this week is a familiar mix of **healthcare, retail, transport and consumer apps**.

### Healthcare: TriZetto Impact Keeps Growing

The breach at **TriZetto Provider Solutions (Cognizant)** – a clearinghouse that processes claims for multiple health plans – continues to expand:

- The original intrusion started in **November 2024**, but was discovered in October 2025.
- Latest notifications bring the impact to **700,000+ individuals**, with exposed data including:
  - Names, addresses, dates of birth.
  - **Social Security numbers**.
  - Health insurance details (member IDs, plan info).   
- Class-action suits are already in motion.

This is a canonical example of **third-party healthcare risk**:

- Many organisations affected had never heard of TriZetto until breach notices landed.
- The real blast radius is defined by **clearinghouses and processors**, not just front-line clinics.

### Retail: Canada Computers Checkout Skimming

Canadian retailer **Canada Computers & Electronics** disclosed that attackers tampered with their **guest web checkout**:

- Window: **29th December 2025 to 22nd January 2026**.
- Affected: customers who checked out as **guests** on the website.
- Stolen data includes:
  - Cardholder name.
  - Billing address.
  - Card number, expiry date, security code.   

Members who used saved profiles, and in-store customers, were not impacted — a classic web-only skimming/Magecart-style pattern.

### Transport: Qilin vs Tulsa International Airport

Russian ransomware-as-a-service group **Qilin** claimed an attack on **Tulsa International Airport**:

- They published samples including:
  - Executive emails.
  - Employee ID and passport scans.
  - Bank correspondence, NDAs, financial records.
  - Insurance and court documents.   
- Data appears to span **2022–2025**, implying a deep historical slice rather than a narrow snapshot.
- The airport is still assessing and has not fully confirmed all details.

The tactic here is familiar:

- Target an organisation that:
  - Handles **sensitive personal and financial data**.
  - Has public safety responsibilities.
- Use the leak threat as leverage, even if operations were not significantly disrupted.

### Consumer Apps: Dating & Food

Separately, a threat group has claimed breaches spanning **Match, Hinge, OkCupid and Panera Bread**, with exfiltrated data being used for extortion and dark-web trade.   

These platforms combine:

- **Highly sensitive behavioural data** (dating history, preferences).
- **Payment and contact information**.
- Strong brand recognition.

Perfect leverage material.

---

## 6. ICS/OT: Quiet Advisories, Real-World Risk

While there was no headline-grabbing OT outage this week, **advisories for ICS and building-control gear** continue to roll out.

### Johnson Controls, Schneider Zigbee and Friends

CISA’s latest batch includes vulnerabilities in:

- **Johnson Controls Metasys** and related building automation products.
- **Schneider Electric Zigbee** components used in energy and industrial environments.
- Additional OT-adjacent products (including ibaPDA, Festo Didactic MES PC) that show up in **water, energy and manufacturing ecosystems**.   

Bulletins emphasise:

- Potential for **remote code execution, authentication bypass or privilege escalation**.
- Real-world deployment in:
  - Water utilities.
  - Energy sector control rooms.
  - Building management systems in campuses and hospitals.

Combined with the previous week’s attribution of a failed **DynoWiper** attack against Poland’s grid, the direction of travel is obvious:

- OT and building controls are not an afterthought; they are **core geopolitical and criminal targets**.

---

## 7. Meta-Trends: AI as Force Multiplier, Ransomware Still Fragmented

Overlaying all of this are a couple of meta-reports and threat-intel summaries:

- A 2026 threat report from a major vendor frames **AI as a force multiplier**:
  - Used for recon, phishing content, malware development and post-ex data triage.
  - Making it cheaper to run more **experiment-heavy campaigns** in parallel.   
- Ransomware remains a **fragmented, busy ecosystem**:
  - Crews like Akira and Qilin operating at high tempo.
  - Many smaller brands reusing the same infra and playbooks, especially once KEV-listed vulnerabilities are weaponised.

Net effects:

- You should assume **AI-assisted attackers by default**.
- The real differentiator is not whether they have a named brand, but whether they are:
  - Plugged into **fresh infra exploits**.
  - Willing to sit quietly on high-value boxes and exfil data before pulling the trigger.

---

## Actions to Take for the Week of 2–8 February

Turning this into a to-do list.

### 1. Hypervisor & Edge Hygiene

- **ESXi/vCenter**:
  - Check versions against current VMware advisories and KEV.
  - Prioritise patching or isolating any management interfaces reachable from user or DMZ segments.
- **SmarterMail / Mail Servers**:
  - If you run SmarterMail, patch **CVE-2026-24423** immediately or take it off the internet.
  - For any internet-facing mail/collab, validate:
    - TLS config.
    - Admin interfaces not exposed to the public.
- **Cisco UC**:
  - Cross-check against **CVE-2026-20045** and follow vendor guidance.
  - Ensure UC systems are segmented from general user networks.

### 2. Supply-Chain & Dev Tooling

- Inventory critical dev/ops tools used on:
  - Build servers.
  - CI/CD runners.
  - Jump hosts and admin workstations.
- For those:
  - Document where they fetch updates from.
  - Consider **pinning versions** or mirroring updates internally for critical paths.
  - Add telemetry around update processes (command-line, network connections, new binaries).

### 3. AI & Browser Surface

- Enforce **browser extension control**:
  - Start with an allow-list for corporate-managed Chrome/Edge.
  - Explicitly review and approve any “AI helper” extensions before allowing them.
- Monitor traffic to **AI hosting platforms** (Hugging Face, etc.):
  - Look for unusual origin hosts contacting them.
  - Correlate with process telemetry (which binary opened the connection?).

### 4. High-Risk Transaction Workflows (Crypto and Beyond)

- Identify any workflows where **individual endpoints can move large value** (money, data or policy):
  - Treasury systems.
  - Payment gateways.
  - Admin consoles for billing or IAM.
- For those:
  - Require **hardened, managed devices**.
  - Use **hardware tokens or wallets** where appropriate.
  - Separate personal and corporate auth contexts aggressively.

### 5. Third-Party and Sector-Specific Risk

- If you operate in or near **healthcare**:
  - Map your dependencies on clearinghouses and processors (TriZetto-style).
  - Review contracts for **notification and security obligations**.
- If you operate any **e-commerce**:
  - Validate web checkout flows for integrity (subresource integrity, CSP, tamper detection).
  - Treat guest checkout paths as high-risk and instrument them accordingly.
- If you’re in **aviation or transport**:
  - Exercise a scenario where **data** (not OT) is the main extortion lever:
    - Leaked staff IDs, travel manifests, contracts, etc.

### 6. ICS/OT Baseline

- Cross-match ICS advisories against your asset inventory:
  - Johnson Controls, Schneider Zigbee, ibaPDA, Festo Didactic, etc.
- For any matches:
  - Document whether they’re reachable from corporate networks.
  - Prioritise patches or interim mitigations (segmentation, tighter firewall rules, jump-host models).

---

## Closing Thoughts

The week starting **2nd February 2026** doesn’t have one single “big” incident. Instead, it offers a clean, composite view of how things are evolving:

- **Dev tools and update paths** are high-value, low-noise supply-chain targets.
- **Hypervisors, mail servers and UC gear** keep getting pulled into ransomware playbooks as initial-access and lateral-movement hubs.
- **AI platforms and browser extensions** have become part of the everyday attack surface — not in 5 years, right now.
- **Treasury and high-value transaction workflows** are only as strong as the endpoints and humans driving them.
- **Healthcare, retail, transport and app platforms** continue to leak data that can be turned into fraud, extortion and influence.

If you use this week to:

- Pay down a little **edge/infra patching debt**.
- Bring **dev tooling and updates** under tighter control.
- Lock down **browser extensions and AI usage** on your most sensitive endpoints.
- Sanity-check a few **third-party and sector-specific dependencies**.

…you’re doing exactly what weekly trends should drive: small, deliberate, compounding improvements.

The attackers are iterating. The only way to keep up is to iterate, too.
