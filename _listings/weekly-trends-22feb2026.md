---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 16th February 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 16th February 2026"
excerpt: "The week of 16–22 February 2026 highlights how attackers are leaning hard on remote support tools, CRM platforms, national ID systems, fintech brokers and high-profile events as data sources — while hospitals, telecoms, and OT environments carry the operational risk when things go wrong."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-02-22
featured: false
tags: [Weekly Trends, Weekly Threats, Ransomware, Data Breach, Identity, Critical Infrastructure, OT, Supply Chain]
---

The week commencing **16th February 2026** is less about “new” techniques and more about **stress-testing the same weak points from multiple angles**:

- A critical **remote support RCE in BeyondTrust** moves from patch note to active ransomware pre-positioning.
- A major US medical centre is forced to **shut clinics statewide** as it fights a ransomware attack.
- A Dutch telco, an Australian fintech, a luxury retail brand, and a Gulf finance summit all report **large-scale personal data exposures**.
- Threat intel shows **data-only extortion up 11x year-on-year**, with attackers increasingly “logging in instead of breaking in”.
- AI-enhanced campaigns show up both in **national-level attacks** and **supply-chain intrusions across APAC**.
- OT/ICS advisories and research continue to underline that **industrial and CCTV gear is squarely in scope**.

This post pulls those threads together and turns them into concrete takeaways for defenders.

---

## Top Trends at a Glance

Key signals for the week:

- **BeyondTrust CVE-2026-1731 is now clearly in the ransomware kill chain**  
  - Critical, pre-auth RCE in BeyondTrust Remote Support (RS) and Privileged Remote Access (PRA).  
  - Added to KEV, active exploitation observed, and now explicitly flagged as being used in ransomware activity.

- **Healthcare operations disrupted at scale**  
  - The University of Mississippi Medical Center (UMMC) closes ~35 clinics statewide and cancels elective procedures for days while handling a ransomware incident that knocks out electronic health records and core IT systems.

- **Identity and financial data at the core of multiple breaches**  
  - Dutch telco **Odido** reports a CRM breach impacting ~6.2M customers.  
  - Australian fintech **YouX** confirms a breach affecting hundreds of thousands of borrowers and brokers.  
  - Luxury brand **Canada Goose** and **Abu Dhabi Finance Week (ADFW)** highlight how third-party processors and event vendors can leak massive KYC-grade datasets.

- **Data-only extortion and remote access abuse are exploding**  
  - Data-only extortion growing ~11x and a majority of non-BEC intrusions starting with abuse of remote access technologies (RDP, VPN, RMM) rather than pure exploits.

- **AI-enabled campaigns and supply chain attacks evolve**  
  - National governments report foiling AI-assisted cyberattacks targeting national platforms.  
  - Crime trends emphasise AI-fuelled supply chain attacks in APAC, combining phishing, OAuth abuse, ransomware and data theft across vendor ecosystems.

- **OT/ICS and CCTV gear remain a soft target**  
  - Fresh ICS advisories hit products like Honeywell CCTV systems, GE Vernova Enervista UR Setup, Delta ASDA-Soft, and Siemens Simcenter Femap/Nastran – all sitting at the intersection of IT/OT and physical security.

---

## 1. BeyondTrust CVE-2026-1731: Remote Support as a Ransomware On-Ramp

The standout technical issue this week is **CVE-2026-1731**, a critical OS command-injection RCE in **BeyondTrust Remote Support (RS)** and **Privileged Remote Access (PRA)**.

### What the vulnerability actually does

- Affects internet-facing BeyondTrust RS/PRA appliances.
- Exploitable **pre-authentication**, over the network, with **no user interaction**.
- Attackers can send a crafted WebSocket message that tricks the appliance into executing arbitrary OS commands.
- High-severity: **low complexity, high impact, full RCE**.

BeyondTrust disclosed it on **6 February 2026**, patches are available, proof-of-concept code landed publicly soon after, and within a day or two defenders were already seeing in-the-wild exploitation.

CISA added CVE-2026-1731 to the **Known Exploited Vulnerabilities (KEV)** catalog with an aggressive remediation deadline for US federal agencies – and has since updated the entry to note that it is being used in **ransomware campaigns**.

Threat intel from multiple vendors is consistent:

- Attackers use the flaw to:
  - Drop web shells (often minimal one-liners).
  - Establish C2 channels (RATs or ad-hoc RMM tools).
  - Create local accounts and pivot laterally.
  - Stage data theft and set up for encryption.

### Why this one matters more than “just another RCE”

BeyondTrust RS/PRA is often:

- **Internet-facing by design**, to allow remote support.
- Embedded in workflows for **privileged access**, including credentials or sessions into:
  - Domain controllers
  - Core servers
  - OT management interfaces
  - High-value SaaS and infra

Compromising the appliance is not “one host”; it’s potentially:

- A **jump point into everything it touches**.
- A visibility blind spot: session replay, credentials, and logs can be tampered with or siphoned.

### Defensive moves this week

If your environment (or a key supplier) uses BeyondTrust RS or PRA:

- **Inventory**: Confirm all instances – on-prem, partner-hosted, test appliances, DMZ relics.
- **Patch prioritisation**:
  - Cloud-hosted customers are generally auto-patched.
  - **Self-hosted** deployments must be upgraded manually to the vendor’s fixed builds.
- **Exposure checks**:
  - Ensure appliances are not unnecessarily wide-open to the internet.
  - Enforce IP allow-lists / VPN-only access where feasible.
- **Hunt for post-exploitation**:
  - Unexpected outbound connections from the appliance.
  - New local accounts or services.
  - Web shells in appliance web directories.
  - Unusual remote management tools landing around the same time.

If you run a SOC, treat BeyondTrust telemetry as **tier-0**: anything abnormal is worth chasing before it turns into a full ransomware event.

---

## 2. Healthcare Ransomware: UMMC Clinics Forced Offline

Healthcare continues to demonstrate how cyber incidents translate directly into **missed treatment**.

### What happened at UMMC

The **University of Mississippi Medical Center (UMMC)** – the state’s only academic medical centre and a major employer – confirmed a **ransomware attack** that:

- Forced closure of **30+ clinics statewide** for multiple days.
- Led to **cancellation of most elective procedures**.
- Took down critical systems such as:
  - Electronic health records (EHR).
  - Appointment booking.
  - Billing and test result portals.

Emergency departments and Level 1 trauma services remained operational, but staff reverted to **paper charts and manual workflows**.

Investigators (including the FBI and federal cyber agencies) are still assessing:

- What patient data, if any, was accessed or exfiltrated.
- The scope of lateral spread across local vs cloud-based systems.

### Why this incident is important

Several recurring patterns are visible:

- **Operational disruption is the leverage**  
  The pain here isn’t only data theft; it’s the **inability to deliver care**:
  - Patients driving hours for chemotherapy or follow-up, only to find the clinic shut.
  - Clinics and departments scrambling to triage what can be safely run on paper.

- **Critical care continuity vs outpatient fragility**  
  Trauma, ED, and ICU workflows tend to have better offline playbooks; outpatient empires often do not.

- **Shared systems beyond a single hospital**  
  County health departments that rely on UMMC’s EHR systems also had to revert to paper, illustrating **ripple effects across regional healthcare**.

### Takeaways for healthcare defenders

- Assume that **EHR is a single point of failure**:
  - Develop and rehearse offline workflows for at least a subset of high-value clinics.
  - Keep **short, prioritised lists** of:
    - Patients who cannot miss chemo/dialysis.
    - Critical scheduled procedures and how to reach those patients.

- Double-check your **third-party dependencies**:
  - Imaging platforms, lab systems, telehealth portals and health information exchanges may be chokepoints.

- For incident responders:
  - Visibility into **identity systems and remote access tools** is key – healthcare is heavily reliant on those, and they’re now the primary entry point.

---

## 3. Telecom, Fintech and Retail: Identity & Financial Data in the Blast Radius

This week also brought a series of **large-scale data exposure stories** across telco, fintech, retail, and events.

### Odido: 6.2 Million Telecom Customers Exposed

Dutch mobile operator **Odido** disclosed a breach of its **customer contact / CRM system**, affecting around **6.2 million customers** – roughly a third of the country’s population.

Stolen data reportedly includes:

- Names, addresses, and places of residence.
- Mobile numbers and email addresses.
- Bank account details.
- Birth dates and passport numbers.

Core telecom services (voice/data) remained operational, but the **identity payload** is serious: enough to support high-confidence SIM swap attempts, impersonation, and tailored phishing for years.

### YouX: Australian Fintech & Broker Ecosystem Breach

In Australia, Sydney-based fintech **YouX** confirmed a significant breach with heavy downstream exposure:

- Around **629,000 loan applications** impacted.
- Personal and financial information for **~444,000 borrowers**, including:
  - Income, debt, and credit data.
  - Government ID details.
  - Driver’s licence numbers.
  - Residential addresses.
- Broker ecosystem data:
  - Hundreds of thousands of messages between brokers and clients.
  - Credentials for broker portals in some cases.

Local commentary has been blunt: the attack appears **easily preventable** and fundamentally a **cyber hygiene failure** rather than a complex zero-day scenario.

### Canada Goose & Third-Party Processors

Luxury brand **Canada Goose** also found itself in headlines after a threat group published a dataset with over **600,000 customer records**, including:

- Names and contact details.
- Order histories.
- Partial payment details (but not full card numbers).

The brand’s position is that:

- Its own core systems were **not breached**.
- The dataset appears to stem from an **older incident at a third-party payment processor**, likely dating back to 2025.

Regardless of root cause, the practical effect is the same for customers: **very phishable, very marketable personal data** is now on the market.

### Abu Dhabi Finance Week (ADFW): VIP Identity Docs

At the higher end of the value spectrum, a misconfigured cloud storage bucket tied to **Abu Dhabi Finance Week (ADFW)** exposed identity documents for over **700 high-profile attendees**, including:

- Passport scans.
- State IDs.
- Other KYC-style documentation and invoices.

The issue was traced back to a **third-party vendor** providing event registration services and had reportedly been exposed for at least two months before being reported and locked down.

### Common patterns across these breaches

Three common threads cut across Odido, YouX, Canada Goose, and ADFW:

1. **CRM / broker / event platforms as the weak link**  
   - Not core production infra, but the systems that **hold identity and financial details**.
   - Often run by **third parties** with varying degrees of maturity.

2. **KYC-grade data, not just logins**  
   - Passport numbers, government IDs, addresses, loan histories.
   - Perfect material for **account takeover, synthetic ID, and targeted phishing**.

3. **Multi-party blast radius**  
   - For YouX and Odido, the impact spans:
     - Customers.
     - Brokers/resellers.
     - Lenders and partner institutions.
   - For ADFW, it’s a mixture of ministers, executives, and investors across jurisdictions.

### What to do if you sit anywhere in similar value chains

- **Map your data flows**:
  - Who actually stores:
    - Scanned IDs and passports?
    - Income and debt documentation?
    - Broker or partner messaging history?
- **Perform a focused third-party review** on:
  - CRM, event platforms, analytics vendors, and payment processors.
  - Look at **retention, storage configuration, and access controls**, not just compliance checkboxes.

- **Prepare realistic notifications and playbooks**:
  - Assume that data at this level of sensitivity, once leaked, will fuel **years of fraud and phishing**.
  - Plan for **ongoing monitoring and education**, not just a one-off incident email.

---

## 4. AI-Enabled Campaigns and National-Level Defence

Several countries publicly disclosed that they had **foiled organised cyberattacks** against national platforms and critical sectors, noting that:

- The campaigns included:
  - Network intrusion attempts.
  - Ransomware deployment efforts.
  - Systematic phishing operations.
- Attackers explicitly leveraged **artificial intelligence** technologies to enhance:
  - Offensive tools.
  - Phishing and social engineering quality.
  - Campaign scale.

Officials also disclosed that:

- National CERTs are deflecting **hundreds of thousands of attempted breaches daily**.
- A significant subset of confirmed cyber incidents in early 2026 are assessed as **state-linked**.

This aligns with broader reporting that:

- AI is increasingly used to:
  - Generate more convincing lures.
  - Customise phishing to individual targets at scale.
  - Automate reconnaissance and exploit chaining.
- At the same time, national cyber programmes are starting to **centralise defence**, investing heavily in:
  - National SOCs.
  - Shared threat intel and takedown ops.
  - Public reporting and deterrence messaging.

For defenders outside the national space, the practical takeaway is simple:

> Assume your **phishing and social engineering problem is now AI-assisted by default**. Lure quality is no longer a strong signal.

---

## 5. Data-Only Extortion & Remote Access Abuse: The Macro View

Zooming out from single incidents, some of the most important analytical pieces this week focus on **how intrusions actually start** and how attackers monetise them.

Key takeaways from recent reporting:

- **Data-only extortion is up massively compared to the prior year.**  
  - Historically a tiny fraction of incidents; now a significant slice of case loads.  
  - Attackers increasingly skip encryption and go straight for **“steal and threaten to leak”**.

- **Ransomware, BEC, and data-related incidents** make up the overwhelming majority of incident response engagements.  
  - The same actors and access brokers often play in all three spaces.

- **Remote access abuse is the starting point in a majority of non-BEC intrusions**:
  - Misconfigured or weakly protected:
    - RDP and VPN endpoints.
    - Remote monitoring and management (RMM) tools.
    - Remote support solutions (BeyondTrust et al.).
  - Attackers “log in instead of break in”, then:
    - Pivot to servers.
    - Stage data.
    - Decide whether to encrypt, extort, or both.

Combined with the BeyondTrust story, the picture is clear:

> Whether the endgame is encryption or pure data extortion, the **first step is often a legitimate-looking remote access session**.

Monitoring and controlling that surface is more urgent than chasing every new ransomware brand.

---

## 6. OT, CCTV and Industrial Systems: Quiet but Persistent Risk

On the industrial side, this week is characterised by **advisories rather than outbreaks**, but the signal is still important.

New **ICS advisories** hit products including:

- Honeywell CCTV products.
- **GE Vernova Enervista UR Setup**, widely used in water/wastewater and energy.
- Delta Electronics **ASDA-Soft** motor drive configuration software.
- Siemens **Simcenter Femap and Nastran**.

The issues are classic OT/ICS:

- Remote code execution.
- Weak or missing authentication.
- Insecure default configurations and network exposure.

In parallel, research from OT security vendors continues to show that:

- In regions like Australia and APAC, **healthcare and manufacturing** are among the most targeted industries from an OT/IoT perspective.
- OT threats are maturing from **reconnaissance to operationally impactful activity**, sometimes piggybacking on ransomware campaigns.

If you operate OT or building security environments (CCTV, access control, BMS):

- Treat vendor software updates and ICS advisories as **change drivers**, not “nice-to-read” PDFs.
- Ensure:
  - OT networks are **segmented** and not flat with IT.
  - Remote access into OT (for integrators, vendors, maintenance) is:
    - Strongly authenticated.
    - Brokered through jump hosts with logging and recording.
  - CCTV and similar gear is **not internet-facing by default**.

---

## 7. APAC & Supply Chain: AI-Fuelled Vendor Compromise

Crime trends for APAC (including Australia) make one point very clear:

- **Supply chain attacks are becoming the default strategy**, not an edge case.

Key themes:

- Attackers compromise **trusted vendors, MSPs, browser extensions, and software components**, then:
  - Use that access to move downstream into many customers at once.
  - Blend phishing, OAuth abuse, and credential theft into one campaign.

- Phishing is increasingly built around **identity workflows**:
  - Social-engineering MFA approvals.
  - Hijacking OAuth consent screens.
  - Stealing tokens after legitimate login.

- Ransomware in APAC increasingly follows a **supply-chain pattern**:
  - Initial access brokers sell access to:
    - MSPs.
    - Cloud tenants.
    - Vulnerable SaaS integrations.
  - Ransomware crews then “rent” that access for encryption and extortion.

- AI reduces the cost of:
  - Generating convincing lures in multiple languages.
  - Building browser-based stealers and malicious extensions.
  - Scaling reconnaissance on software dependencies.

For organisations in APAC, and especially those heavily integrated with vendors:

- Assume that **vendor and SaaS compromise is part of your threat model**, not just your own perimeter.
- Security controls must include:
  - Strong governance over **which apps and vendors can integrate** with your identity providers.
  - **Regular reviews of OAuth grants**, API keys, and third-party access scopes.
  - A bias towards **least privilege for integrations** rather than broad “read everything” access.

---

## Malware of the Week — ClickFix & ModeloRAT

For this week’s malware spotlight, the standout combo is the **ClickFix** social-engineering technique being used to deliver a Python-based remote access trojan, **ModeloRAT**, via nothing more than a “helpful” copy-paste command and some abused DNS.

### What is ClickFix?

**ClickFix** isn’t a specific family so much as a **delivery pattern**:

- Attackers compromise **legitimate websites** or stand up **malicious look-alikes**.
- They present the victim with **fake error pages, fake captchas, bogus update pop-ups, or “your browser has a problem” messages**.
- The page then **walks the user through “fixing” the issue**:
  - “Press Windows + R and paste this command…”
  - Or “Open Terminal and run this line to repair your connection…”

Historically, those commands used `mshta` or `powershell` to pull second-stage payloads from attacker infrastructure.

The whole premise is simple and nasty:

> Get the victim to **infect themselves** by following what looks like copy-paste support instructions.

### The new twist: abusing `nslookup` and DNS TXT

As `mshta.exe` and obvious PowerShell one-liners have become more heavily blocked, the operators behind ClickFix have pivoted to **abusing `nslookup` and DNS TXT records** instead.

The updated chain looks like this:

1. **Lure page**  
   - Victim lands on a compromised or malicious site showing a fake error/captcha/update issue.  
   - The page instructs the user to **copy a specific command** and run it (usually in `cmd.exe` or the Run dialog).

2. **Stage 1 — `nslookup` abuse**  
   - The malicious command calls `nslookup` against a **hard-coded attacker-controlled DNS server**, not the system default resolver.  
   - Instead of returning a normal A/AAAA record, the server responds with data crafted so that part of the DNS “answer” (often the `Name:` line or a TXT record) is actually another command / payload string.
   - The command pipeline **parses the `nslookup` output and executes the extracted value** as the second-stage payload (e.g., another command, a PowerShell snippet, or a download URL).

3. **Stage 2 — ZIP + Python loader**  
   - The second-stage command **downloads a ZIP archive** from attacker infrastructure.  
   - From that archive, a **Python script** is extracted and executed.  
   - That script handles:
     - **Reconnaissance** (system info, user, domain, running processes).  
     - **Discovery** (drives, interesting folders, basic network context).  
     - Setting up the next step in the chain.

4. **Stage 3 — VBS dropper & ModeloRAT**  
   - The loader then writes a **Visual Basic Script (VBS) dropper** to disk.  
   - The VBS dropper persists and finally **drops and executes ModeloRAT**, establishing long-term remote access.

This DNS staging trick gives the attackers a couple of advantages:

- Traffic to an external DNS server can **blend into normal name-resolution noise**, especially if you only log/inspect traditional web traffic.
- Blocking known bad HTTP/S domains alone **won’t help**, because the first observable interaction is a DNS query to what looks like “just another resolver”.

### Meet ModeloRAT

**ModeloRAT** is the final payload in the currently observed ClickFix chain:

- **Language / platform:** Python-based RAT targeting **Windows** systems.  
- **Core capabilities** (based on public reporting and typical RAT behaviour):
  - System profiling (OS version, hostname, domain, user, hardware).
  - File system operations (list, read, write, delete, exfiltrate).
  - Process and service manipulation.
  - Command execution / shell access.
  - Download and execution of additional payloads.
- **Persistence:**  
  - Launched via the VBS wrapper and likely backed by:
    - Registry `Run` keys.
    - Scheduled tasks.
    - Or service entries, depending on the operator’s playbook.

ClickFix-style campaigns delivering ModeloRAT have been observed in **corporate environments**, and both criminal and state-aligned actors have used this technique over the last year. Some reporting ties an ongoing campaign to a threat actor tracked as **KongTuke**, who is specifically targeting enterprise endpoints with ModeloRAT via a variant branded **“CrashFix.”**

### Why this chain is dangerous

Three reasons this deserves “Malware of the Week” status:

1. **User-driven execution**  
   - The entire attack hinges on convincing the user to **run a command themselves**.  
   - This bypasses a lot of traditional exploit-centric thinking (no exploit kit, no macro abuse, just social engineering plus tools already on the box).

2. **Living off the land via DNS and built-ins**  
   - `nslookup`, `cmd.exe`, maybe `powershell.exe` — all **expected binaries** in most environments.  
   - DNS traffic to an external resolver is often under-logged or under-inspected compared to HTTP/S.

3. **RAT as a flexible foothold**  
   - ModeloRAT is generic but powerful: once it’s in, the operator can:
     - Run tooling of choice.
     - Stage ransomware.
     - Focus on credential theft and lateral movement.
   - It’s a perfect “do anything later” implant, which makes early detection critical.

### Detection ideas (SOC / DFIR angle)

If you’re hunting or building detections this week, ClickFix + ModeloRAT gives you several strong anchors:

1. **Command-line telemetry**  
   - Look for **`nslookup` commands executed by user shells** (`cmd.exe`, PowerShell, Run dialog) with:
     - Hard-coded external DNS server addresses.
     - Output being piped (`|`, `&`, `&&`) into another process.

2. **Clipboard / UI patterns**  
   - Pages trying to **write to the clipboard** or showing long copy-paste commands in “support” or “update” contexts.  
   - Security tools with browser extension telemetry (or browser protection agents) can help here.

3. **DNS anomalies**  
   - Endpoints making queries to **rare external resolvers** you don’t normally see in your environment.  
   - TXT responses or `Name:` fields that look like **Base64 / script fragments** rather than domains/IPs.

4. **File and process chain**  
   - Short-lived archives (ZIPs) dropped to `%TEMP%` or user profile dirs, immediately followed by Python processes or WScript/CScript spawning from the same path.  
   - New scheduled tasks or Run keys referencing:
     - `wscript.exe` / `cscript.exe`.
     - Python interpreters from unusual locations.

5. **Network C2 for ModeloRAT**  
   - Depending on variant, look for:
     - Long-lived outbound connections from Python or VBS-spawned processes.
     - Traffic to domains/IPs that don’t match any of your known SaaS/dev stacks, especially over high ports.

### Mitigation & hardening

Short, practical moves that specifically hurt ClickFix/ModeloRAT:

- **User training, but concrete**  
  - Explicitly highlight **“copy this command into Run/Terminal to fix an error”** as a red-flag pattern in awareness material.  
  - Include screenshots of fake captchas / fake “browser broken” pop-ups to anchor the mental model.

- **Application control for built-ins**  
  - Tighten what **`nslookup`, `powershell.exe`, `wscript.exe`, and Python** are allowed to do:
    - Constrain via AppLocker, WDAC, or equivalent.
    - Alert when those processes are launched by non-admin users in unusual paths or contexts.

- **DNS egress policy**  
  - Force endpoints to use **your resolvers** (or a small set of trusted ones); block direct queries to arbitrary external DNS servers at the firewall.

- **Browser controls**  
  - Where possible, **block automatic clipboard writes** from untrusted sites.  
  - Use browser security extensions that flag sites attempting to silently copy commands into the clipboard.

- **Instrument remote-support workflows**  
  - Make sure your helpdesk and remote-support staff **never ask users to run opaque one-liner commands copied from web pages**.  
  - Publish internal “this is how support *does* talk to you” guidelines so users can spot impostors and strange instructions.

Taken together, ClickFix + ModeloRAT is a good example of modern tradecraft:

- No exploit kit.
- Heavy social engineering.
- Abuse of **everyday admin tools and DNS**.
- A flexible RAT ready to bridge into whatever the operator wants to do next.

That’s exactly the kind of chain that will keep showing up in incident queues — which makes it a solid pick for **Malware of the Week**.

---

## Actions for the Week of 16–22 February

To make this actionable, here’s a focused checklist aligned to this week’s themes.

### 1. Remote Support & Privileged Access Hygiene

- Inventory all **BeyondTrust RS/PRA** and other remote support / RMM tools.
- Confirm:
  - Patching status for any instance impacted by critical 2026 advisories.
  - Whether appliances are unnecessarily exposed to the public internet.
- Stand up or tune detections for:
  - Abnormal outbound connections.
  - Web shell patterns on appliances.
  - New local accounts or scheduled tasks created from those hosts.

### 2. Prepare for Data-Only Extortion

- Assume that **exfiltration-only incidents will be part of your year**:
  - Review how you detect and investigate **large outbound or unusual data flows**:
    - To cloud storage providers.
    - To unfamiliar SaaS endpoints.
  - Establish who decides **what you pay, what you notify, and when**.

- For critical datasets (customer IDs, loan apps, KYC docs):
  - Re-check **where they live**:
    - On-prem CRM?
    - Cloud analytics?
    - Vendor platforms?
  - Validate **retention policies** and compress wherever plausible.

### 3. Harden Remote Access as “Phase 0”

- Treat RDP, VPN, RMM, and remote support as **high-value assets**:
  - Enforce MFA everywhere.
  - Prefer **phishing-resistant methods** for admin and high-risk accounts.
  - Restrict access by:
    - IP/location.
    - Device health posture.
    - Role.

- Monitor for:
  - Unusual login times or geos.
  - Sudden new device registrations.
  - Session lengths and actions that deviate from normal support patterns.

### 4. Telecom / Fintech / Broker Supply Chains

- If you rely on telcos, fintech brokers, or event vendors for customer workflows:
  - Ask direct questions about:
    - Logged and retained data fields (IDs, income, debt, etc.).
    - How long raw uploads (e.g., PDF IDs) are kept.
    - Encryption and access control on those stores.
  - Ensure your contracts:
    - Set **minimum security expectations**.
    - Define **notification timelines** and **co-ordinated disclosure**.

### 5. Healthcare & Critical Services

- For healthcare and similar critical services:
  - Validate that **offline, paper-based workflows** exist and are rehearsed at least annually for:
    - Triage.
    - Chemo/dialysis scheduling.
    - Critical surgery lists.
  - Confirm:
    - Backup and restore times for EHR and core clinical systems.
    - Segregation between hospital, clinic, and public health infrastructures.

### 6. OT & CCTV

- Cross-check the latest **ICS advisories** against your asset inventory.
- Prioritise:
  - Patching or applying vendor mitigations to affected Honeywell, GE, Delta, Siemens, and similar products.
  - Ensuring OT networks are **not flat** and do not share unconstrained access with IT.

### 7. AI & Phishing Resilience

- Update your security awareness content to **explicitly include AI-generated lures**:
  - Fewer language errors.
  - More contextually relevant hooks.
  - Voice and deepfake considerations.

- For critical roles (finance, HR, executives, administrators):
  - Introduce **additional verification steps** for:
    - Payment changes.
    - Data export requests.
    - Unusual access approvals.

---

## Closing Thoughts

The week of **16th February 2026** reinforces a few uncomfortable truths:

- The **front door is remote access**, and attackers are now more likely to steal data quietly than immediately pull the encryption trigger.
- **CRM, broker, and event platforms** hold enough contextual data to fuel identity theft and fraud for years – often outside your direct control.
- **Healthcare, telco, and OT environments** are where cyber risk shows up as real-world disruption, not just bad headlines.
- AI doesn’t fundamentally change attacker objectives, but it makes their **phishing, recon, and supply-chain operations cheaper and faster**.
- Campaigns like **ClickFix → ModeloRAT** show how far attackers can get with nothing more than social engineering and living-off-the-land tools.

If you spend this week tightening your **remote access exposure**, getting clear on where **KYC-grade data** actually lives, and making sure **high-impact services have an offline Plan B**, you’ll be materially better positioned for whatever the next few weeks throw at you.