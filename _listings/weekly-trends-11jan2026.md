---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 5th January 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 5th January 2026"
excerpt: "The first full week of 2026 is already shaping up around three themes: AI and identity converging into a single attack surface, data leaking through 'Shadow AI' and cloud abuse, and old-school ransomware and malware quietly evolving in the background. This post looks at what is emerging right now, and the security 'resolutions' that actually matter."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-01-11
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **5–11 January 2026** is the first full working week of the new year.

On paper it should be quiet: people are still easing back in, budgets are being locked, strategies are being
signed off. In practice, the threat landscape did not take a break:

- Vendors are racing to buy and build **identity-first and AI-aware security** capabilities. :contentReference[oaicite:0]{index=0}  
- Reports are showing a steep rise in **GenAI-related data policy violations** and “Shadow AI” usage by staff. :contentReference[oaicite:1]{index=1}  
- State actors and cybercrime crews are already back at work with **SEO poisoning, QR-code phishing, cloud abuse and new ransomware brands**. :contentReference[oaicite:2]{index=2}  

If 2025 was the year everyone talked about AI risk, 2026 is the year those risks start to show up in **live
incident data**. This post looks at what is emerging in this first week — and what is worth turning into
security resolutions while the year is still young.

---

## Top Trends at a Glance

- **AI + Identity Convergence** – big security players buying specialist identity and biometric vendors to deal with AI-accelerated threats and autonomous agents.
- **Shadow AI and Data Leakage** – organisations seeing hundreds of GenAI-related data policy violations per month as staff quietly use unapproved AI tools.
- **Agentic AI and “AI Insider” Risk** – forecasts and early signals of attackers targeting AI agents and orchestration layers as if they were human insiders.
- **Cloud and SaaS Abuse in Phishing** – threat actors abusing Google Cloud, QR codes, and serverless infrastructure to deliver phishing and ClickFix-style chains.
- **Ransomware Fragmentation and New Brands** – LockBit 5 dominating leak-site metrics while new families like Ripper and BQTLock join a crowded ecosystem.
- **Regulation and Reporting Tightening** – mandatory ransomware/extortion reporting and tougher breach disclosure rules driving more visibility (and pressure).

---

## AI and Identity Are Colliding into One Attack Surface

Two early-January acquisitions set the tone for the year:

- **CrowdStrike announced it will acquire SGNL**, an identity security startup focused on “continuous identity” access decisions, explicitly to tackle AI-driven threats and autonomous access. :contentReference[oaicite:3]{index=3}  
- **Ping Identity acquired Keyless**, a zero-knowledge biometric authentication firm, to strengthen passwordless and deepfake-resistant authentication. :contentReference[oaicite:4]{index=4}  

At the same time, multiple industry predictions for 2026 are converging around the same headline:

- AI and autonomous agents are expanding the attack surface.
- Identity is becoming the **easiest and most high-risk entry point** to those systems. :contentReference[oaicite:5]{index=5}  

The message is blunt: as organisations let AI agents act on behalf of users and services, **identity is no
longer just a login problem**; it is the central control layer for:

- Human users.
- Machine and service accounts.
- AI agents wired into production workflows.

Early-year implication for defenders:

- Identity and SSO teams are no longer “support functions”; they are **front-line security teams**.
- Controls like:
  - Strong MFA and phishing-resistant authentication.
  - App-consent governance.
  - Continuous access evaluation.
- …are now directly tied to AI safety as much as traditional access control.

If you are writing 2026 security resolutions, “**identity-first security with AI in scope**” needs to be near
the top of the list.

---

## Shadow AI and GenAI Data Leaks Are Already a Problem

A fresh cloud and threat report from Netskope dropped right as the year turned over, and the numbers are not
pretty:

- Enterprise use of GenAI SaaS platforms **tripled** over the past year.
- The average organisation is now making **over 18,000 prompts per month** to GenAI tools.
- The average organisation is already seeing **223 GenAI-related data policy violations per month**, a figure that has doubled year-on-year. :contentReference[oaicite:6]{index=6}  

Crucially:

- Almost half of GenAI use comes from **personal or unsanctioned AI apps** (“Shadow AI”).
- Around 60% of insider incidents in the report involved personal AI tools rather than corporate-approved
  ones. :contentReference[oaicite:7]{index=7}  

The pattern is simple:

- Staff are dropping:
  - Regulated data.
  - Source code.
  - Internal documents.
  - Even credentials.
- …into AI tools that security teams did not approve, do not log, and often cannot see.

This is one of the clearest “new year, new problem” trends:

- It’s not a hypothetical; it is happening now at measurable scale.
- It straddles **data protection, insider risk, and GenAI governance**.
- It will only accelerate as more line-of-business teams adopt AI to hit 2026 productivity targets.

Security resolutions that matter here:

- Build a **Shadow AI inventory**:
  - Which AI domains and apps are being accessed from your network and devices?
- Decide on **policy**:
  - Which AI tools are allowed, in which contexts, for which data.
- Put monitoring and guardrails in place:
  - DLP and CASB controls for uploads to GenAI.
  - Education that is specific:
    - “Don’t paste customer data or source code into AI tools that aren’t on this approved list.”

---

## Agentic AI and the “AI Insider” Problem

Several credible 2026 predictions — from IBM, Palo Alto Networks, Darktrace, Tenable and others — are
pointing at the same emerging risk:

- **Agentic AI**, i.e., AI agents that can:
  - Take actions.
  - Call tools and APIs.
  - Move money.
  - Change infrastructure.
- …will become both:
  - Extremely helpful.
  - A new class of insider-like risk. :contentReference[oaicite:8]{index=8}  

Key ideas from those analyses:

- Attackers won’t necessarily invent new primitives; they will use AI to:
  - Scale recon.
  - Accelerate social engineering.
  - Mutate payloads.
- The truly new part is **attacks on the agents themselves**:
  - Prompt injection to make an agent exfiltrate data or delete backups.
  - “Tool misuse” where agents are tricked into abusing highly privileged APIs.
  - Model manipulation and indirect prompt injection through documents, tickets, or logs.

We are not yet seeing massive “agent-caused breaches” in incident feeds, but early 2026 is exactly when:

- Many organisations will move from **pilot** to **production** on AI orchestration.
- Security teams will be asked to “sign off” on workflows that let an agent:
  - Touch production data stores.
  - Trigger financial transactions.
  - Modify access policies.

Security resolutions with real impact here:

- Get a seat at the table on **AI governance**:
  - Make sure AI inventories include agents, tools, and data access paths.
- Push for an **“AI firewall” / policy layer**:
  - Runtime controls around what agents are allowed to do.
  - Prompt and tool-usage monitoring.
- Treat high-privilege AI agents as **identities with roles**, not toys:
  - Just like a domain admin or CI/CD service account.

---

## Cloud and SaaS Abuse in Early-Year Phishing

If identity and AI are the long game, early January is also full of very concrete campaigns abusing **cloud
and SaaS platforms** in phishing and initial access.

Highlights from this week’s reporting:

- Threat actors abusing **Google Cloud Application Integration** to send fake Google notifications from a
  legitimate `noreply-application-integration@google[.]com` address, in order to steal Microsoft credentials via phishing pages. :contentReference[oaicite:9]{index=9}  
- A fresh advisory detailing **North Korean Kimsuky operators using QR codes** in spearphishing emails towards NGOs, think tanks and academia — QR codes embedded in PDFs and images that redirect to credential harvesting. :contentReference[oaicite:10]{index=10}  
- A “ColdFusion++ Christmas Campaign” that continues into January, with millions of malicious requests targeting Adobe ColdFusion servers via exposed endpoints, likely operated by an initial access broker. :contentReference[oaicite:11]{index=11}  
- A new ClickFix-style multi-stage malware campaign (PHALT#BLYX) targeting hospitality, abusing **MSBuild and social engineering** to get victims to effectively “fix” their own security by running attacker commands. :contentReference[oaicite:12]{index=12}  

Takeaways:

- Attackers are leaning harder into **abusing legitimate cloud services and infrastructure**:
  - Google Cloud features.
  - QR codes that feel user-friendly.
  - CI/CD and build tools like MSBuild.
- Defensive patterns that worked for plain-text phishing are not enough when:
  - Sender infrastructure is legitimate.
  - URLs are hidden inside QR images.
  - Users are being walked through manual execution steps.

Resolutions worth writing down:

- Ensure your email and proxy controls understand:
  - Cloud-generated emails (SendGrid, Google, Microsoft, etc.) and can apply reputation and content checks.
- Expand awareness beyond “don’t click dodgy links”:
  - “Don’t scan random QR codes.”
  - “Don’t run PowerShell/MSBuild/terminal commands sent via email or chat, even if they look like vendor docs.”
- For exposed web apps and middleware:
  - Treat ColdFusion-style endpoints and similar frameworks as **high-priority hardening targets**.

---

## Ransomware: LockBit 5 Dominance and New Names

Ransomware is not waiting for February to warm up.

A threat intel snapshot covering **late December into the first days of January** shows: :contentReference[oaicite:13]{index=13}  

- **LockBit 5** currently responsible for more than a third of observed incidents in that period — leak-site
  activity and incident reports both point to sustained, high-volume operations.
- A **mid-tier cluster** of groups (Inc Ransom, Ransomware Blog, BQTLock, DevMan2, Handala, Leaknet and
  others) contributing a steady background of double-extortion and data theft.
- Research highlighting new or rebranded ransomware like **Ripper** emerging in underground forums, plus a
  long list of smaller groups that rise and fall quickly.

The macro trend from 2025 into 2026:

- Law-enforcement and disruption operations hit big names.
- The ecosystem fragments into:
  - Many smaller, agile crews.
  - Affiliate programmes.
  - Short-lived brands that reuse tooling and playbooks.

For defenders, that means:

- The **TTPs stay consistent** (lateral movement, backup destruction, data theft), even as names and leak
  sites change.
- Detection engineering and incident response should focus on:
  - Early discovery of lateral movement and privilege escalation.
  - Changes to backup and hypervisor infrastructure.
  - Data staging and unusual exfil patterns.
- Regulatory pressure is rising:
  - In Australia and elsewhere, ransomware and extortion payments are now subject to **mandatory reporting**
    within tight timeframes, increasing both visibility and legal risk. :contentReference[oaicite:14]{index=14}  

If you want one ransomware resolution for 2026, make it this:

> “We will treat **data exfiltration and early-stage intrusion detection** as important as backup and restore.”

---

## Old-School Malware, New Delivery: SEO Poisoning and Browser Extensions

Early-year reporting also shows a continuation of **browser-centric and SEO-driven malware campaigns**:

- A long-running family dubbed **“ShadyPanda”** has quietly accumulated millions of installs via Chrome and
  Edge extensions that started as legitimate utilities and later morphed into spyware. :contentReference[oaicite:15]{index=15}  
- A group referred to as **Black Cat** (not to be confused with ALPHV ransomware) used **SEO poisoning and
  fake software downloads** to infect nearly 278,000 systems in China with data-stealing malware, focusing on
  browser data, keystrokes and crypto theft. :contentReference[oaicite:16]{index=16}  

These campaigns are important for two reasons:

- They bypass traditional “attachment-based” email flows:
  - Victims arrive at fake sites by searching for tools and utilities.
  - Browser extension ecosystems become long-term persistence points.
- They hit both:
  - Consumers and SME endpoints.
  - Corporate fleets where browser extensions are poorly governed.

Practical early-year mitigations:

- Implement or tighten **browser extension allow-lists**:
  - Limit installations to vetted extensions for managed browsers.
- Add SEO-poisoning and rogue-download hunting to:
  - Web proxy and DNS logging.
  - Threat hunting playbooks.
- Reinforce user guidance:
  - Download software from vendors or known marketplaces.
  - Be wary of “sponsored” results and unofficial mirrors.

The broader theme: the **user’s browser is the new OS desktop** — and deserves the same level of policy and
instrumentation.

---

## Regulatory and Reporting Environment Is Tightening

Finally, the policy and reporting landscape is quietly reshaping how incidents are handled:

- In Australia and several other jurisdictions, **mandatory ransomware and cyber extortion payment reporting**
  is now in force, with 72-hour windows after payment. :contentReference[oaicite:17]{index=17}  
- National and regional cyber strategies are:
  - Increasing breach reporting obligations.
  - Considering personal accountability for executives.
  - Investing in centralised government cyber units to coordinate response. :contentReference[oaicite:18]{index=18}  

For incident responders and CISOs, this means:

- “Pay or not pay?” is no longer just a business decision; it is a **regulated event**.
- Metrics and board reporting need to distinguish between:
  - Attempts vs successful extortion.
  - Payments made vs refused.
  - Data exposure vs service disruption.
- DFIR work products (timelines, containment evidence, root-cause analysis) will be increasingly used not
  only for internal learning, but also for:
  - Regulator engagement.
  - Insurance.
  - Legal proceedings.

A realistic 2026 resolution:

- Treat **incident documentation and evidence management** as part of primary response, not an afterthought.

---

## Security Resolutions That Actually Matter in 2026

To close out this first full week of the year, here are practical resolutions pulled directly from the trends
above. None of them are glamorous; all of them will move the needle.

**Identity and AI**

- Put **identity, SSO and AI governance** in the same program.
- Inventory:
  - Human identities.
  - Service accounts.
  - AI agents and their permissions.
- Enforce:
  - Strong MFA for admins and high-risk roles.
  - Admin consent for powerful app scopes.

**Shadow AI and Data Protection**

- Map which GenAI tools are being used from your estate (approved and unapproved).
- Publish a simple, opinionated policy:
  - “These tools are allowed for these data types; these are not.”
- Implement DLP / CASB controls for uploads to GenAI.

**Cloud and SaaS Abuse**

- Tune detections around:
  - Cloud-generated emails abused for phishing.
  - QR-driven logins and payment flows.
  - Unusual use of serverless and integration platforms for mail and redirects.
- Educate on ClickFix patterns:
  - Any email walking users through command-line “fixes” should be treated as hostile until proven otherwise.

**Ransomware and Extortion**

- Validate:
  - Offline / immutable backups for key systems.
  - Ability to restore in a realistic timeframe.
- Build playbooks that explicitly cover:
  - Data-only extortion.
  - Mandatory payment reporting.
  - Regulator and customer communication.

**DFIR and Observation Debt**

- Standardise:
  - Which logs you treat as canonical.
  - Where they are stored and how long.
- Make memory capture and Volatility analysis part of high-severity incidents.
- Practice at least one end-to-end “evidence-driven” incident walkthrough per quarter.

---

## Closing Thoughts

A new year always tempts big, abstract resolutions. The first week of **January 2026** sends a different
message:

- AI is here, and it’s changing both attacks and defences.
- Identity and SaaS have quietly become the real perimeter.
- Data is the thing that gets you extorted, regulated and on the front page.
- Old tactics — phishing, SEO poisoning, browser abuse, ransomware — are not going anywhere; they are just
  wearing new clothes.

The good news is that the path forward is not mystical. If you spend 2026:

- Getting **identity and AI** under unified governance.
- Bringing **Shadow AI** into the light.
- Hardening and monitoring your **cloud, SaaS and “trust infrastructure”**.
- Paying down **observation debt** so incidents can be understood, not guessed at.

…you will end the year in a much stronger place than you started it.

New year, new resolutions — but the same reality:

> Know what you have.  
> See what it is doing.  
> Be ready to act when it does something it shouldn’t.

That is still what winning looks like in 2026.
