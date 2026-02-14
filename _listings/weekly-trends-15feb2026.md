---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 9th February 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 9th February 2026"
excerpt: "The second week of February 2026 shows ransomware pivoting back to hard encryption, government and payment pipelines under pressure, unmanaged edge VMs being used as footholds, and consumer/IoT devices feeding some of the largest DDoS and privacy incidents on record."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-02-15
featured: false
tags: [Weekly Trends, Weekly Threats, Ransomware, Supply Chain, Critical Infrastructure, IoT, Data Breach]
---

The week commencing **9th February 2026** is a good reminder that nothing happens in isolation:

- Ransomware crews are quietly **pivoting back to heavy encryption**, not just data theft.
- Government contractors and payment gateways are learning what happens when **critical back-office pipelines** go down.
- A single **unmanaged VM** can be all it takes to drag an otherwise mature vendor into a ransomware incident.
- Consumer **Android TV boxes and smart gadgets** are now feeding DDoS peaks above 30 Tbps.
- Municipal tech – from license plate readers to CCTV – is under both **technical and regulatory pressure**.
- CISA is trying to close the gap on OT by dropping fresh advisories and new guidance aimed at reducing “cost and complexity” as excuses.

Below is how those pieces fit together, and what’s worth acting on.

---

## Top Trends at a Glance

Key themes from 9–15 February:

- **Ransomware economics are shifting again** – data-only extortion is underperforming, and crews are leaning back into **encrypt-and-exfiltrate** as the default. :contentReference[oaicite:0]{index=0}  
- **Critical gov and financial pipelines exposed** – Conduent’s mega-breach (25M+ Americans, many on social programs) and BridgePay’s outage show how fragile outsourced benefits and payment back-ends can be. :contentReference[oaicite:1]{index=1}  
- **Unmanaged edge infrastructure bites back** – Warlock ransomware’s breach of SmarterTools through a single unpatched SmarterMail VM is a textbook “shadow IT” story. :contentReference[oaicite:2]{index=2}  
- **IoT and consumer devices at internet scale** – the Kimwolf botnet built largely from compromised Android TV/streaming devices drove a 31.4 Tbps DDoS, while home gadgets are now entry points for tailored phishing. :contentReference[oaicite:3]{index=3}  
- **Privacy and surveillance under scrutiny** – Mountain View, CA shut down its Flock license plate reader network after learning data was shared with hundreds of agencies without proper permission. :contentReference[oaicite:4]{index=4}  
- **Australia’s threat surface remains busy** – reports highlight a new 0APT healthcare extortion case (Epworth HealthCare), AI-linked risk (DeepSeek ban), and sustained targeting of identity systems and edge SaaS in the local context. :contentReference[oaicite:5]{index=5}  
- **OT/ICS keeps getting more guidance and more advisories** – CISA pushes new ICS advisories (Airleader Master and others) and publishes fresh OT security guidance to reduce cost/complexity barriers. :contentReference[oaicite:6]{index=6}  

---

## 1. Ransomware: Back to Encryption, Still Multi-Extortion

A useful macro signal this week is a **SecurityWeek analysis** arguing that many ransomware crews are **pivoting back to encryption** as a core pressure tactic:

- Pure data theft extortion (steal → threaten to leak) has underperformed:
  - Victims gamble on the data not being used.
  - Insurers push back on paying.
- Crews are now more likely to **encrypt *and* exfiltrate**, re-increasing operational impact as leverage. :contentReference[oaicite:7]{index=7}  

Stack that against a few other data points:

- **Check Point’s January 2026 global trends** show:
  - Global cyberattacks up, with ransomware incidents and multi-extortion tactics still strong.
  - Qilin, LockBit and Akira collectively responsible for a big slice of disclosed ransomware activity. :contentReference[oaicite:8]{index=8}  
- A **January ransomware roundup** tallies over **100 TB of stolen data** and highlights Qilin as the most prolific gang by attack count for the month. :contentReference[oaicite:9]{index=9}  
- A **Check Point threat intel bulletin** published on 9 Feb notes:
  - **451 ransomware incidents** in 2025 in the financial sector alone.
  - Increasing use of aggressive **multi-extortion** and data-leak tactics. :contentReference[oaicite:10]{index=10}  

The picture:

- The “just threaten to leak” fad is giving way to a more old-school model:
  - **Operational disruption via encryption**, plus
  - **Reputational/regulatory leverage via data leaks**.
- Campaigns are more selective:
  - Multi-stage intrusion.
  - Data staging and exfil.
  - Followed by careful, timed encryption for maximum pain.

For defenders, that means:

- Don’t get lulled into thinking “we only need to worry about exfil now”.
- You still need both:
  - **Resilient backups and recovery**.
  - **Exfiltration-aware monitoring and DLP**.

---

## 2. Government & Financial Pipelines Under Pressure

Two incidents this week show how fragile core **government and payment pipelines** can be when third parties are compromised.

### Conduent: 25M+ Americans Exposed

A big one: **Conduent**, a New Jersey-based IT contractor that runs technology for US government programs, is dealing with the fallout of a major ransomware/data breach:

- A group calling itself **SafePay** claims it compromised Conduent from **October 2024** until detection in January 2025, exfiltrating up to **8.5 TB of data**. :contentReference[oaicite:11]{index=11}  
- New reporting this week suggests at least **25 million Americans** affected, including roughly **15.4 million Texans** – about half the state. :contentReference[oaicite:12]{index=12}  
- Conduent runs systems for **Medicaid, SNAP/food assistance, unemployment insurance, child support** and more across **46 states**. :contentReference[oaicite:13]{index=13}  
- Stolen data includes:
  - Names, addresses.
  - Social Security numbers.
  - Health information and program details.

Multiple class-action suits are now in motion, alleging **slow notification and weak controls**. :contentReference[oaicite:14]{index=14}  

Key lesson:

> When you outsource social benefit systems to a third party, you are outsourcing *risk*, not responsibility.

### BridgePay: Payment Gateway Knocked Offline

On the private-sector side, **BridgePay**, a US payment gateway, was hit by a ransomware attack that forced it to **take core systems offline**:

- Incident late last week, with the company confirming a ransomware attack and pulling multiple services:
  - BridgeComm.
  - PayGuardian Cloud API.
  - MyBridgePay virtual terminal, etc. :contentReference[oaicite:15]{index=15}  
- Many downstream businesses were forced into **cash-only** or manual fallbacks.
- Early investigation suggests **no payment card data exposed**; accessed files appear only to have been encrypted. :contentReference[oaicite:16]{index=16}  

This is a clean example of **availability risk**:

- Even if no card data is stolen, taking out a payments backbone **removes oxygen** from hundreds of merchants.

### Takeaways for Defenders and Risk Owners

- Map your exposure to **benefits processors, payment gateways, and other “invisible” middlemen**:
  - If *they* go down or leak, what is your blast radius?
- For critical third parties:
  - Ask about **ransomware resilience**: segregation, backup strategy, RTO/RPO.
  - Ask how they would **notify you and your customers** if they were hit.

---

## 3. SmarterTools, Warlock, and the Cost of One Unmanaged VM

The week also gave us a neat case study in **how one stray asset can undo a lot of good security work**.

### What Happened

SmarterTools (maker of SmarterMail) confirmed that:

- The **Warlock ransomware gang (aka Storm-2603)** breached their network via a **single unpatched SmarterMail virtual machine**. :contentReference[oaicite:17]{index=17}  
- The VM was:
  - Spun up by an employee.
  - Not part of formal patch/asset management.
  - Running a vulnerable SmarterMail build affected by **CVE-2026-23760**, an **authentication bypass** that lets attackers reset admin passwords and gain control. :contentReference[oaicite:18]{index=18}  
- Once inside, Warlock:
  - Used the compromised server and **Active Directory** to pivot.
  - Targeted a set of **Windows servers** for encryption.
- Damage was limited:
  - SmarterTools says only **12 Windows servers** were impacted, mostly mitigated by antivirus.
  - Their primary services run on Linux and were isolated, so customer portals and main infra stayed up. :contentReference[oaicite:19]{index=19}  

Post-incident, SmarterTools is:

- Migrating away from **Windows and AD** for internal services.
- Urging customers to **upgrade SmarterMail** to builds that fix the auth bypass. :contentReference[oaicite:20]{index=20}  

### Why It Matters

Several patterns worth noting:

- This is **not** a mass customer compromise; it is an **internal hygiene failure**:
  - A single “lab” or “test” VM, never onboarded into the patch pipeline.
- The vulnerability in question had **already been publicly called out by CISA** as actively exploited and placed into KEV. :contentReference[oaicite:21]{index=21}  
- It shows that “we run Linux for most things” doesn’t save you if:
  - Attackers can reach one forgotten Windows server.
  - That server is wired into the same identity plane.

For defenders:

- Asset and vulnerability management needs coverage for **“unofficial” VMs and lab instances**:
  - Cloud accounts spun up by devs.
  - On-prem boxes created for short tests that never got cleaned up.
- You need at least one **hunt per quarter** that asks:
  > “What systems are talking to our AD or production networks that *we* don’t have in CMDB?”

---

## 4. Consumer & IoT: From Living Room to 31.4 Tbps DDoS

This week also brought some very concrete warnings about **home and IoT devices** being weaponised at scale.

### Kimwolf Botnet and Record-Scale DDoS

Grant Thornton Ireland and Cloudflare reporting, amplified in local media, highlights:

- A **November 2025 DDoS attack** that peaked at **31.4 Tbps** and lasted ~35 seconds.
- The attack was driven by a botnet dubbed **Kimwolf**, made up largely of:
  - **Android TV boxes**, “Android telly” units.
  - Low-cost **streaming gadgets and smart devices** with almost no hardening. :contentReference[oaicite:22]{index=22}  
- These devices are:
  - Shipped with default credentials.
  - Rarely updated by users.
  - Easy to hijack “in seconds”.

Experts are warning that:

- Once inside a home network, attackers can:
  - Observe usage patterns (when people are home, what apps they use).
  - Feed highly tailored **phishing or scam campaigns**.
- Cheap smart TVs, lightbulbs, and boxes are now an **entry point into households and small offices**, not just a nuisance. :contentReference[oaicite:23]{index=23}  

### License Plate Readers & Data Sharing: The Flock Case

On the municipal side, Malwarebytes highlighted a privacy story with security implications:

- **Mountain View, California** shut down its entire network of **Flock Safety license plate reader cameras**.
- Reason: it discovered Flock had been **sharing city plate data with hundreds of law-enforcement agencies**, including federal, without explicit permission. :contentReference[oaicite:24]{index=24}  
- This raises:
  - Governance and consent issues.
  - Questions about **data minimisation, retention, and access control**.

Combine that with the Kimwolf story and you get:

- Lots of **“smart” endpoints**, lightly governed, heavily networked.
- Data and compute power that can be repurposed for:
  - DDoS.
  - Tracking and surveillance.
  - Tightly targeted social engineering.

---

## 5. Australia: Healthcare, Identity and AI in the Crosshairs

Zooming into the Australian region, local threat briefings for the first half of February underline three threads:

### Healthcare: Epworth HealthCare Extortion

Lean Security’s daily briefing flagged a new threat actor dubbed **0APT** claiming:

- Theft of approximately **920 GB of sensitive data** from **Epworth HealthCare**, one of Victoria’s largest private hospital groups. :contentReference[oaicite:25]{index=25}  
- Data is said to include:
  - Patient information.
  - Financial data.
  - Internal operational documents.

This aligns with broader trends of **healthcare ransomware and extortion** seen through late 2025 and early 2026.

### Identity-Led Attacks and Edge SaaS

The same and related briefings note:

- A “distinct escalation” in **human-led attacks on identity systems (SSO)** and:
  - Targeted campaigns against **edge SaaS and collaboration tools**.
  - Renewed focus on **MFA bypass** and session hijacking. :contentReference[oaicite:26]{index=26}  

This ties neatly into what we saw the previous week with Evilginx2 and SSO vishing – the pattern hasn’t changed; if anything, the intensity has.

### AI Risk and Policy: DeepSeek Ban

Australia-focused commentary also picks up on policy moves like the **ban on DeepSeek AI** in some environments, framed as:

- A response to **data exposure and model-abuse risk**.
- An example of organisations beginning to **treat GenAI providers as high-risk third parties**, especially where:
  - Sensitive workloads might leak into training sets.
  - Outputs might be influenced by prompt injection. :contentReference[oaicite:27]{index=27}  

Overall, the local message:

- Healthcare in Australia continues to be **high-value, high-impact** for extortion gangs.
- Identity and AI are being recognised as **core parts of the attack surface**, not nice-to-have add-ons.

---

## 6. OT/ICS: More Advisories, New Guidance

On the OT side, this week was light on spectacular outages but heavy on **advisories and guidance**.

### New ICS Advisories

CISA’s ICS portal shows fresh advisories dated **12 February 2026**, including:

- **ICSA-26-043-10**: targeting **Airleader Master**, a compressed air management system used in industrial environments.
- Additional advisories for other ICS products, continuing a pattern of regular updates for OT vendors and integrators. :contentReference[oaicite:28]{index=28}  

These advisories typically involve:

- Remote code execution.
- Authentication bypass.
- Insecure default configurations.

### New OT Security Guidance

CISA also released new OT security guidance aimed at **overcoming cost and complexity barriers** for critical infrastructure operators:

- Focuses on:
  - Secure remote access.
  - Segmenting OT from IT networks.
  - “Secure-by-design” control device procurement.
- Explicitly acknowledges that **complexity, operational risk and budget** are the main reasons OT environments lag behind IT in security, and offers structured mitigations. :contentReference[oaicite:29]{index=29}  

The thread across all of this:

- OT risk is no longer about whether there are vulnerabilities – there are plenty.
- It’s about **whether operators can overcome perceived cost/complexity** to implement the basics:
  - Asset inventory.
  - Segmentation.
  - Patch/compensating controls.
  - Monitoring.

---

## Actions for the Week of 9–15 February

To make this practical, here’s a condensed action list aligned to the week’s themes.

### 1. Re-check Your Ransomware Assumptions

- Assume **encrypt + exfil** is the default now, not exfil alone.
- Validate that:
  - **Backups are offline or logically separated** and tested.
  - You have **detections for encryption behaviours** (mass renames, unusual use of archivers, `vssadmin`, etc.).
  - You also have some **exfil-aware controls** (large outbound transfers, new cloud storage destinations, long-duration connections).

### 2. Map Your Critical Pipelines (Benefits, Payments, Gateways)

- Identify which **third parties** sit between you and:
  - Government benefits systems.
  - Payment processing.
  - Claims and clearinghouses.
- For each critical vendor:
  - Confirm their **incident response and notification** approach.
  - Ask about their **ransomware history and hardening**.
  - Build tabletop scenarios where *they* go dark for a week.

### 3. Hunt for Orphaned Infrastructure

- Run at least one focused exercise to find:
  - VMs or servers **not in CMDB** but talking to:
    - AD / identity infrastructure.
    - Production VLANs or cloud accounts.
- Bring them into:
  - **Patch and vuln management**.
  - **Monitoring and logging**.
  - Or **retire** them if no longer needed.

### 4. Tighten IoT and Consumer-Facing Edges

Even if you don’t run consumer devices directly, you can:

- For corporate networks:
  - Put IoT into **segmented VLANs** with very limited egress.
  - Block or restrict **unnecessary outbound ports/protocols** from smart TVs, cameras, etc.
- For staff and customers:
  - Push simple guidance:
    - Change default passwords.
    - Update firmware.
    - Avoid ultra-cheap “no-name” boxes for anything sensitive.

### 5. Identity & AI Controls (Especially in AU / High-Risk Environments)

- For identity:
  - Ensure **SSO and admin accounts** have phishing-resistant MFA where possible.
  - Enable **risk-based conditional access** for unusual IPs/devices.
  - Train staff on **vishing and MFA-fatigue** stories that explicitly match current campaigns.
- For AI:
  - Treat GenAI platforms as **data processors**:
    - Define what can and can’t be pasted or uploaded.
    - Review contracts/DPAs for data retention and training use.
  - For any AI assistants/agents, ensure **strong guardrails** on what they can access and do.

### 6. OT/ICS Baseline Improvements

- Cross-reference CISA’s **latest ICS advisories** (including Airleader and similar products) against your asset inventory.
- For any matches:
  - Prioritise patching or vendor mitigations.
  - Where patching is hard, focus on:
    - **Segmentation** (no flat networks).
    - **Jump hosts** with MFA.
    - **Monitoring of management interfaces**.

---

## Closing Thoughts

The week of **9th February 2026** doesn’t introduce radical new techniques, but it does sharpen three uncomfortable realities:

1. **Ransomware is not “just data leaks”** – encryption is back in full force, on top of multi-extortion.
2. **Third-party back-office providers are as critical as your front door** – if they leak or go down, your customers feel it.
3. **The edge is everywhere** – from one unmanaged VM to a living room TV box to a city’s license plate cameras.

If you can use this week to:

- Pay down some **edge and orphaned-asset debt**.
- Clarify your exposure to **critical third-party pipelines**.
- Tighten **identity, IoT, and OT basics**.

…you’re doing the right kind of work. The attackers are iterating. The only viable response is to iterate your defences at least as consistently as they iterate their playbooks.
