---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 19th January 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 19th January 2026"
excerpt: "The third week of January shows how long ransomware and data breaches echo: late-2025 intrusions are turning into 2026 mega-leaks, OT advisories are landing off the back of a failed wiper attack on Poland’s grid, and local government audits are still catching basic access control failures. This post walks through what is actually happening on the wire, from Everest and Black Basta to Prosura, Under Armour, Polish energy, and Victorian schools."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-01-25
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **19–25 January 2026** is a good reminder that cyber incidents never really “end”:

- Ransomware events from **late 2025** are now surfacing as mega-breaches and class actions in 2026.
- OT and energy-sector attacks from **December** are being formally attributed and analysed.
- Regulators and auditors are opening investigations into incidents that hit **schools, councils and insurers** earlier in the month.

It is less about brand-new techniques and more about the **long tail of impact**:

> The real damage of 2025’s campaigns is landing now — in leak dumps, regulatory probes, ICS advisories, and audits that show how much basic hygiene is still missing.

This week’s trends are organised around that idea.

---

## Top Trends at a Glance

- **Everest and the Long Tail of Ransomware Leaks** – Under Armour’s November 2025 breach surfaces as a 72M-account leak in January; Everest also claims major manufacturers and automakers. :contentReference[oaicite:0]{index=0}  
- **Retail, Manufacturing and Distribution in the Firing Line** – Ingram Micro, Kyowon Group, Eros Elevators, Luxshare and others show ransomware pressure on global supply chains and service providers. :contentReference[oaicite:1]{index=1}  
- **Black Basta Leadership on “Most Wanted” Lists** – European and Ukrainian authorities expose key Black Basta members and put the alleged leader on EU and INTERPOL lists, signalling growing focus on individual cybercrime leadership. :contentReference[oaicite:2]{index=2}  
- **Nation-State Wipers vs Europe’s Energy Sector** – ESET and others attribute December’s failed attack on Poland’s power grid to Sandworm, using DynoWiper against energy infrastructure. :contentReference[oaicite:3]{index=3}  
- **OT / ICS Under the Microscope** – CISA drops a wave of ICS advisories across Schneider, Rockwell, Hubitat and others, reinforcing that process control and home-automation are both in play. :contentReference[oaicite:4]{index=4}  
- **Local Governance and Education: Back to Basics** – Logan City Council’s audit exposes lingering access control failures, while OVIC launches a formal investigation into the Victorian schools breach affecting hundreds of thousands of students. :contentReference[oaicite:5]{index=5}  
- **New Malware and RATs in the Noise Floor** – GhostPenguin, EtherRAT and a multi-stage Amnesia RAT campaign remind us that loaders and remote access trojans are still the workhorses behind many of these breaches. :contentReference[oaicite:6]{index=6}  

---

## Everest, Under Armour and the Long Echo of Ransomware

The headline breach this week is **Under Armour** finally surfacing as a confirmed mass compromise:

- The **Everest ransomware group** claimed it hit Under Armour in **November 2025**, exfiltrating around **343 GB** of data and attempting to extort the company. :contentReference[oaicite:7]{index=7}  
- After Under Armour allegedly declined to pay, Everest dumped the data; on **18 January 2026** the leak was widely mirrored on cybercrime forums and added to Have I Been Pwned. :contentReference[oaicite:8]{index=8}  
- Current estimates suggest around **72–72.7 million accounts** are affected, with data including:
  - Email addresses.
  - Names, dates of birth, gender and geographic information.
  - Purchase history and loyalty data.
  - Potentially phone numbers and physical addresses. :contentReference[oaicite:9]{index=9}  

The pattern is classic 2025–26 ransomware:

- **Initial intrusion** months ago.
- **Negotiations fail** or stall.
- **Data lands in the wild** in bulk, fuelling:
  - Targeted phishing.
  - Account takeover.
  - Class-action lawsuits (already filed in the US on behalf of affected customers). :contentReference[oaicite:10]{index=10}  

Everest is simultaneously linked to:

- Alleged compromises of **Nissan** and **Chrysler**, with almost a terabyte of corporate data claimed from Nissan and threats to leak if payment is not made. :contentReference[oaicite:11]{index=11}  

For defenders, the lesson is not just “patch more”:

- Ransomware incidents have **multi-stage impact**:
  - Immediate operational disruption.
  - Months-later leak events.
  - Regulatory, legal and fraud fallout that can last years.
- Once data is published:
  - Everest claims it has been duplicated “across various hacker forums and leak database sites,” making containment impossible. :contentReference[oaicite:12]{index=12}  

If you are tracking your own risk exposure, this week is a reminder to:

- Monitor leak sites and breach aggregation services for your organisation’s domains.
- Treat **historic ransomware incidents** as ongoing data-breach risk, not closed cases.
- Prepare comms, legal and customer-support playbooks for **“data finally leaked”** scenarios long after the original compromise.

---

## Supply Chain, Tech Services and Ransomware Spillover

Under Armour is not alone. The same period is seeing fallout for other large organisations that sit **inside supply chains** rather than at the consumer edge.

### Ingram Micro

Global IT distributor **Ingram Micro** disclosed that a July 2025 ransomware attack has now been confirmed to have exposed personal data for around **42,500 individuals**:

- Compromised data includes names, dates of birth, Social Security numbers and employment-related information. :contentReference[oaicite:13]{index=13}  

While not massive by consumer-breach standards, this matters because:

- Ingram sits at the **heart of IT supply chains**, with visibility into:
  - Corporate customers.
  - Resellers.
  - Distribution channels.
- Personal information about staff and partners can be used for:
  - Targeted spear-phishing.
  - Social engineering against downstream organisations.

### Kyowon Group (South Korea)

South Korean conglomerate **Kyowon Group** reported a major ransomware incident this week:

- Abnormal activity detected around **10 January 2025** (disclosed now).
- Roughly **600 of 800 servers** compromised.
- Authorities estimate **up to 9.6 million customer accounts** could be affected, with signs of potential data leakage. :contentReference[oaicite:14]{index=14}  

Kyowon operates across education, publishing, media and technology, making its data particularly useful for:

- Wide-scale phishing.
- Identity theft.
- Targeting of families and small businesses.

### Eros Elevators and Luxshare

Elsewhere:

- Indian manufacturer **Eros Elevators** was hit by **LockBit 5**, causing serious disruption to operations and data. :contentReference[oaicite:15]{index=15}  
- Chinese electronics manufacturer **Luxshare Precision**, a key assembler for iPhones and iPads, was claimed by **RansomHouse** in December; the group publicly took credit on **8 January 2026**, describing a double-extortion attack involving both encryption and data theft. :contentReference[oaicite:16]{index=16}  

The common thread:

- Ransomware is **deep in the supply chain**:
  - Distributors, manufacturers, claims processors, education conglomerates.
- Downstream risk is non-trivial:
  - Even if your own perimeter holds, suppliers’ breaches can affect:
    - Customer data.
    - Availability of services.
    - Trust in your own brand.

Security takeaways for this week:

- Keep revisiting **third-party risk**:
  - What would it mean if your distributor, manufacturer or claims administrator went offline or leaked?
- Don’t just ask vendors “do you have ISO/controls?”:
  - Ask about their **incident history** and how they handle extortion and breach notification.

---

## Black Basta: Leadership on EU & INTERPOL Lists

Law-enforcement pressure against major ransomware gangs continued to build.

This week, European and Ukrainian authorities:

- Announced the exposure of two alleged key **Black Basta** members (Ukrainian nationals acting as technical specialists).
- Identified the group’s alleged leader, a Russian national, now placed on the **EU’s “Most Wanted” list** and subject to an **INTERPOL Red Notice**. :contentReference[oaicite:17]{index=17}  
- Coverage notes Black Basta’s history:
  - Around **600 victims worldwide** since early 2022.
  - Major incidents including the **Zirco Data** hack and countless double-extortion cases. :contentReference[oaicite:18]{index=18}  

This follows similar “unmasking” actions against other crews and supports a trend:

- Governments are increasingly willing to:
  - Name individuals.
  - Share photos and personal details.
  - Coordinate Red Notices and EU-wide most-wanted listings.

Impact for defenders:

- It won’t shut Black Basta down overnight, but:
  - It raises the cost of participation for operators.
  - It makes it riskier to move money and travel.
- It is a reminder that **attribution is improving**:
  - For major crews, anonymity is no longer guaranteed.

In threat-intel terms, this is a useful opportunity to:

- Revisit your own **ransomware playbooks**:
  - Under what conditions would you cooperate with law enforcement?
  - How do you preserve evidence to support future prosecutions?

---

## Sandworm, DynoWiper and Europe’s Energy Sector

On the nation-state side, one of the bigger developments this week is formal attribution of the **December 2025 attack on Poland’s power grid**.

Key details from ESET and Reuters:

- Slovakia-based ESET researchers and other analysts now assess with high confidence that the attack was conducted by **Sandworm**, the GRU-linked group behind multiple past disruptions in Ukraine. :contentReference[oaicite:19]{index=19}  
- The operation used a new wiper dubbed **DynoWiper**, designed to:
  - Delete files.
  - Disable systems in energy infrastructure. :contentReference[oaicite:20]{index=20}  
- Polish authorities describe it as **one of the most serious attempts in recent years**, though:
  - The attack ultimately failed to cause power outages.
  - Defensive and operational measures prevented physical disruption. :contentReference[oaicite:21]{index=21}  

Important context:

- The attack occurred on **29–30 December**, almost exactly ten years after Sandworm’s 2015 cyberattack on Ukraine’s grid, which produced the first malware-induced blackout on record, and nine years after a similar 2016 operation. :contentReference[oaicite:22]{index=22}  

The message for OT defenders is straightforward:

- Wipers and disruptive tooling remain key parts of the **Russian playbook** against European infrastructure.
- Even “failed” attacks are valuable:
  - They test detection and response.
  - They probe how operators and governments react.
  - They help refine future campaigns.

This ties directly into what CISA and partners are doing on the ICS side this week.

---

## ICS / OT Under Pressure: CISA Advisories and Hubitat

Aligned with the above, **CISA released a wave of Industrial Control Systems (ICS) advisories** over 20–22 January:

- On **20 January**, advisories covered products including **Schneider Electric EcoStruxure Foxboro DCS**, among others, used widely in process control. :contentReference[oaicite:23]{index=23}  
- On **22 January**, CISA released **10 additional ICS advisories**, covering:
  - Schneider EcoStruxure Process Expert.
  - AutomationDirect CLICK PLC.
  - Rockwell CompactLogix 5370.
  - Johnson Controls iSTAR ICU.
  - Weintek cMT X Series HMI EasyWeb Service.
  - **Hubitat Elevation Hubs**, among others. :contentReference[oaicite:24]{index=24}  
- For **Hubitat Elevation Hubs**, a newly highlighted vulnerability allowed:
  - Authenticated attackers to bypass authorisation using a user-controlled key and escalate privileges to control devices outside their authorised scope.
  - Hubitat has issued firmware updates to address this. :contentReference[oaicite:25]{index=25}  

Taken together:

- The advisory burst reflects **ongoing discovery of serious vulnerabilities** in both:
  - Classic industrial systems (DCS, PLC, HMI).
  - Prosumer / home-automation devices that increasingly sit in small offices and critical “edge” environments.
- Water sector and ICS-focused bulletins emphasise that organisations should:
  - Cross-check these advisories against their asset inventories.
  - Apply patches or mitigations promptly. :contentReference[oaicite:26]{index=26}  

For this week, the practical move is:

- If you have any footprint in **energy, manufacturing, water, building management or home-automation bridging into business networks**, treat:
  - Newly released **ICS advisories**.
  - The **Sandworm / DynoWiper analysis**.
  - Recent **OT risk guidance** from CISA and FBI.
- …as a single combined call to **get serious about OT asset visibility and patching**. :contentReference[oaicite:27]{index=27}  

---

## Prosura, Victorian Schools and Local Government: Basics Still Hurt

Closer to home (for Australia), this week is dominated by a cluster of stories that all point to **basic governance and access control gaps**.

### Prosura: Insurer Breach and Direct Threat Actor Contact

Australian car-excess insurer **Prosura** has spent January managing a significant cyber incident:

- Prosura detected unauthorised access around **3 January 2026** and took key online services offline. :contentReference[oaicite:28]{index=28}  
- A self-described “threat actor” obtained customer data and contacted customers directly, threatening to leak information unless a deal was struck. :contentReference[oaicite:29]{index=29}  
- An update on **14 January** confirmed that stolen data is now being **advertised for sale on a leak forum**, with attackers claiming to hold **98 million lines of records** including contact, travel and policy details. :contentReference[oaicite:30]{index=30}  

This is a textbook **data-extortion-without-encryption** scenario:

- Threat actor goes straight to customers, bypassing the company.
- Data sale claims place pressure on both:
  - Individual victims (fraud, scams).
  - The organisation (regulators, media, brand damage).

### Victorian Government Schools: Student Data and OVIC Investigation

At the same time, **Victorian government schools** are still dealing with fallout from a major breach disclosed on **14 January**:

- An external third party accessed a Department of Education database containing:
  - Student names.
  - School-issued email addresses and encrypted passwords.
  - School names and year levels.
- The breach impacts current and past students across **all Victorian government schools**, with estimates of over **665,000 students** at risk. :contentReference[oaicite:31]{index=31}  
- The Department reset student passwords, claims no evidence of public data release so far, and is working with external cyber experts. :contentReference[oaicite:32]{index=32}  

This week, the **Office of the Victorian Information Commissioner (OVIC)** formally announced it has:

- Commenced an investigation into:
  - How the incident occurred.
  - Whether the Department complied with the **Privacy and Data Protection Act 2014**.
- Confirmed that an unauthorised external party accessed names, email addresses, school names, year levels and encrypted passwords. :contentReference[oaicite:33]{index=33}  

The key point:

- We are moving from **“incident”** to **“regulatory case study”**.
- The findings will likely shape:
  - Expectations placed on other education providers.
  - How student data must be protected and managed across the sector.

### Logan City Council: Audit Exposes Core Control Failures

In Queensland, a Queensland Audit Office (QAO) report on **Logan City Council** paints a familiar picture of under-secured core systems:

- The audit found **173 former employees still had active system accounts**, with two logging in weeks after leaving; one ex-staff member logged in after their employment ended. :contentReference[oaicite:34]{index=34}  
- **44 current staff** were using high-level access for routine tasks, and the number of **domain administrator accounts** had increased since the previous audit.
- Password policies were inconsistent, and seven external accounts had **no expiry dates**, increasing the risk of unauthorised access.
- Long-standing issues with financial approvals and oversight remained unresolved. :contentReference[oaicite:35]{index=35}  

The commentary from the Auditor-General is blunt:

- Significant deficiencies remaining unresolved for long periods **increase exposure to cyber risks**, including loss of personal information and service disruption. :contentReference[oaicite:36]{index=36}  

Across Prosura, Victorian schools and Logan, the theme is not “sophisticated zero-days” — it is:

- **Account lifecycle failures**.
- **Weak governance on sensitive data**.
- **Slow remediation of known issues**.

If you work in or with public-sector entities, this is your nudge to:

- Tighten joiner-mover-leaver processes (especially for privileged roles).
- Validate that **student, ratepayer and customer data** is:
  - Minimised.
  - Access-controlled.
  - Logged appropriately.
- Expect regulators to treat “we knew about this but didn’t fix it” as a serious aggravating factor.

---

## New Malware and RAT Activity: GhostPenguin, EtherRAT and Amnesia

Below the big ransomware and governance headlines, the **malware noise floor** continues to evolve.

A threat intel report covering **13–19 January** highlights: :contentReference[oaicite:37]{index=37}  

- Two new threats:
  - **GhostPenguin**, details not yet fully public but flagged as a fresh Linux-focused threat in some reporting.
  - **EtherRAT**, a new remote-access trojan with capabilities for:
    - Command execution.
    - Data theft.
    - Persistence.
- Ransomware focus on **Akira**, which continues to be active enough that CISA has a dedicated **#StopRansomware** advisory for it (including cases of payloads targeting Nutanix AHV). :contentReference[oaicite:38]{index=38}  

In parallel, The Hacker News describes a **multi-stage phishing campaign targeting Russia** that drops both **Amnesia RAT** and ransomware:

- Victims are lured with documents.
- The chain involves multiple stages before:
  - Remote access is established via Amnesia RAT.
  - Ransomware is deployed as the final payload. :contentReference[oaicite:39]{index=39}  

The consistent pattern:

- RATs and loaders (GhostPenguin, EtherRAT, Amnesia, GootLoader etc.) remain the **plumbing** that makes ransomware and data theft possible.
- Most high-impact breaches still start from:
  - A phish.
  - A malicious download.
  - A misconfigured server exploited by known malware.

From a defensive point of view:

- Detection engineering that focuses on **post-ex behaviour** (RAT C2, lateral movement, archive abuse, script host anomalies) is still one of the best investments you can make.
- Threat-hunting around:
  - New outbound destinations.
  - Suspicious script executions.
  - Living-off-the-land binaries calling out to the internet.
- …will often catch these tools **before** they become a full ransomware or extortion case.

---

## Actions for the Week of 19–25 January

Translating all of this into concrete moves:

**1. Treat Old Ransomware as Current Data-Breach Risk**

- Review any ransomware or extortion incidents from **2024–2025**:
  - Confirm whether exfiltrated data could still be released.
  - Pre-draft comms and legal responses for “data dumped months later” scenarios.
- Monitor leak sites and breach notification services for:
  - Your domains.
  - Key partner brands (especially in logistics, manufacturing, insurance).

**2. Re-Assess Supply-Chain Dependencies**

- Map critical suppliers in:
  - Distribution (e.g. Ingram-type).
  - Manufacturing (Eros, Luxshare-type).
  - Claims and back-office processing (Kyowon-type).
- For each, ask:
  - “If they went offline for a week, what would break?”
  - “If their data was dumped, what does that expose about us?”

**3. Close Obvious Access-Control Gaps**

- Audit:
  - Ex-employee accounts.
  - Privileged groups (domain admins, finance superusers).
  - External accounts and their expiry dates.
- Aim to avoid being the next Logan-style case study where **basic hygiene failures** are documented in a public audit.

**4. For Education / Child-Related Data**

- If you hold any data on minors:
  - Review how it is stored and accessed.
  - Ensure logging and monitoring is active for:
    - Database access.
    - Admin operations.
  - Validate password policies and reset mechanisms.
- Use the Victorian schools case as a **tabletop scenario**:
  - “What if our student/child data was breached in the same way?”

**5. Tighten OT / ICS Exposure**

- Cross-check CISA’s latest advisories against your asset inventory:
  - Schneider EcoStruxure.
  - Rockwell CompactLogix.
  - Hubitat and similar gateways.
- For any match:
  - Apply patches or vendor-recommended mitigations.
  - Validate network segmentation and remote-access controls.

**6. Keep Hunting the Plumbing, Not Just the Payloads**

- Update detection content and hunts for:
  - New RATs (EtherRAT, Amnesia).
  - Loader behaviours and malformed archives.
- Focus on:
  - Script host usage (`wscript`, `powershell`, `msbuild`).
  - Unusual archive unpacking chains.
  - New or rare outbound destinations per host.

---

## Closing Thoughts

The week commencing **19th January 2026** doesn’t introduce many brand-new attack techniques — instead, it shows the **second and third waves of existing incidents**:

- November’s ransomware becomes January’s mega-breach.
- December’s failed wiper becomes late-January’s OT advisory set.
- Long-standing access weaknesses in councils and departments become this week’s audit reports and regulator investigations.

The underlying message is simple:

> Detection and response are just the opening moves.  
> The real game is what happens in the **months after**: leaks, lawsuits, advisories, investigations and audits.

If you use this week to:

- Pay down a bit of **access-control debt**.
- Tighten your **supply-chain view**.
- Cross-check your **OT footprint** against fresh advisories.
- And remember that **data exfil today is a headline six months from now**.

…you’re doing exactly what weekly threat intel is meant to support: turning noise into concrete, incremental hardening.
