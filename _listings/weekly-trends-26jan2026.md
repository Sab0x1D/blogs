---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 26 Jan 2026"
pretty_title: "Weekly Threat Trends — Week of 26 Jan 2026"
excerpt: "AI-led intrusion campaigns, identity-layer attacks, ICS advisories, and high-impact data breaches defined the week of 26 January 2026. This roundup walks defenders through what mattered and what to prioritise next."
date: 2026-02-01
categories: ["weekly-trends"]
tags: ["weekly-trends","ransomware","AI","identity","ICS","supply-chain","data-breach"]
---

## Top trends at a glance

The week starting **26 January 2026** continued the pattern we have been seeing since late 2025: attackers are leaning hard into **AI-assisted operations**, targeting the **identity and browser layer**, and intensifying pressure on **critical infrastructure** and large consumer brands.

Key themes this week:

- **AI in the kill chain, not just in marketing decks.** State-linked and financially motivated actors are using AI to generate malware, polymorphic payloads, and even exploit code, radically compressing development timelines.
- **Identity and the browser are primary battlegrounds.** MFA-bypass frameworks, SSO-focused vishing, malicious browser extensions, and prompt-injection abuses are all converging on the same target: your identity and session tokens.
- **Ransomware and double-extortion remain dominant.** New and rebranded crews are hitting energy, manufacturing, and consumer brands, with data theft and leak-site pressure now the norm rather than the exception.
- **ICS/OT organisations are under sustained scrutiny.** Fresh advisories and exploited vulnerabilities in ICS gear, firewall stacks, and VPNs reinforce that OT is no longer a “quiet corner” of the threat landscape.
- **Law-enforcement pressure is rising – and so is criminal adaptability.** Takedowns of major underground forums and infrastructure are landing, but threat actors are already shifting to new platforms and tooling.

Below is a deeper dive into the week’s most relevant developments and what they mean for defenders.

---

## 1. AI is now part of the kill chain, not just a buzzword

### Operation Poseidon and AI-generated malware loaders

Threat intel this week highlighted **Operation Poseidon**, a campaign attributed to the KONNI cluster and targeting **blockchain developers in Japan, Australia, and India**.

The hallmarks:

- Lures are framed as **financial notices** and dev-related documents.
- Victims receive **ZIP archives** that contain Windows shortcut files (LNKs) masquerading as benign content.
- When executed, the shortcut launches an **AI-generated PowerShell loader**, which in turn stages and deploys the **EndRAT** backdoor.
- The PowerShell is designed to be **polymorphic and evasive**, with dynamic string handling and obfuscation that would be extremely tedious to handcraft at scale.

The important takeaway is not that “AI was used”, but *how* it changes attacker economics:

- Generating and iterating on **multiple obfuscated loader variants** is now cheap and fast.
- Phishing lures can be **rapidly localised** (language, tone, finance context) for specific geos and verticals.
- Once a workflow is defined (e.g. “write a PowerShell loader that does X, but looks different each time”), that workflow can be reused across campaigns with minimal human effort.

From a defensive standpoint, this pushes us even further away from static indicators and deeper into **behavioural detections**:

- Look for **unusual PowerShell execution paths** (e.g. via LNKs in user profile paths, or from temp/archive extraction locations).
- Focus on **script block logging**, AMSI visibility, and detection of suspicious network beacons from `powershell.exe` or `pwsh.exe`.
- For dev environments, monitor for **suspicious access to wallet software, signing keys, build pipelines and artifact repositories**, as those are clear objectives in blockchain-adjacent campaigns.

### VoidLink and AI-authored cloud-native Linux malware

Check Point’s threat bulletin this week detailed **VoidLink**, a new **cloud-native Linux malware framework** that was reportedly authored almost entirely with the help of AI tooling. The operator used an approach they call **Spec Driven Development (SDD)** – describing functionality to an LLM, refining specifications, and then iterating on code until a working implant was produced within about a week.

Key points worth flagging:

- VoidLink focuses on **Linux and cloud workloads**, with capabilities for command execution, persistence, and data exfiltration in containerised environments.
- The developer leaned on AI not just for code, but for **design decisions**, documentation, and refactoring – essentially treating the model like a tightly integrated junior engineer.
- As with Operation Poseidon, the result is a **large volume of reasonably high-quality code** with fewer obvious “home-grown” quirks for analysts to latch onto.

For blue teams, this reinforces a trend:

- Assume **rapid iteration and experimentation** on the adversary side – more variants, more quickly.
- Expect an increase in **weird-but-valid code paths** in cloud and Linux environments that don’t match historical signatures.
- Prioritise **runtime and behavioural controls** (e.g. eBPF sensors, syscall monitoring, anomaly detection on process and network behaviour) over static signatures alone.

### AI-generated exploits and prompt-injection abuse

Beyond malware, vendors reported that advanced models have generated working exploits for **previously unknown vulnerabilities** (e.g. in QuickJS) and that **prompt-injection flaws** are being used to abuse assistants integrated with services like Google Calendar.

The pattern:

- Malicious content (meeting descriptions, web page text, comments) is crafted so that an AI agent, when reading it, follows attack instructions (e.g. exfiltrate calendar summaries to a new event or external channel).
- In exploit development, AI is assisting with **fuzzing-like code exploration**, error interpretation, and payload crafting, again reducing the time from bug to weaponisation.

For defenders, this is a nudge to treat **LLM-integrated workflows as part of the attack surface**:

- Threat model **AI agents as untrusted interpreters of untrusted input**.
- Where possible, enforce **strong guardrails**: input/output filters, allowlists for tool calls, strict scopes on what an AI agent can touch (e.g. read-only for certain APIs).
- Assume that **“malicious prompt = malicious code”** in high-risk contexts and align controls accordingly.

---

## 2. Identity, SSO, and the browser are under sustained fire

If you look across the week’s reporting, the **identity and browser layer** stands out as the most actively contested space.

### Evilginx2 formally tracked as a credential-theft threat

Australian MSSP reporting this week highlighted **Evilginx2** as a newly tracked threat in their detection stack. Evilginx2 is a **Go-based adversary-in-the-middle framework** that sits between the victim and a real login page, proxying traffic while **stealing credentials and session cookies**.

Noteworthy aspects:

- Uses **“phishlets”** – templates that closely clone real login portals (Microsoft 365, Okta, Google, etc.).
- Frequently fronted with **fake CAPTCHA or security checks** to build trust and delay scrutiny.
- Once a victim authenticates, Evilginx2 captures **session cookies and tokens**, allowing attackers to bypass traditional MFA flows and log in as the user without needing their password again.

Detections and mitigations should focus on:

- **FIDO2/WebAuthn** for phishing-resistant MFA wherever practical, especially for admins and high-value roles.
- **Source IP, device, and geo anomalies** on SSO sign-ins, particularly where session token reuse is involved.
- **TLS inspection and proxy logging** to surface strange certificate chains or mismatched hostnames in login flows (where privacy and policy allow).

### SSO-focused vishing and session hijack campaigns

Threat recaps for the week also called out **voice phishing (vishing) campaigns targeting Okta SSO users**. These playbooks typically combine:

- Pretext calls from fake “IT support” or “security operations”, often armed with real internal details to establish credibility.
- Real-time guidance through a spoofed login flow where the victim unwittingly **hands over MFA codes and SSO credentials**.
- Rapid pivoting into **high-value SaaS apps** (Salesforce, Microsoft 365, Google Workspace, internal billing portals) as soon as access is obtained.

This underscores a key point: even well-configured SSO with MFA is only as strong as the **human** on the other end of the call.

Defensive responses:

- Implement **number matching** and **push notification context** (app name, location, device) to make social engineering harder.
- Configure **MFA fatigue protections** (limited prompts, lockouts on repeated denials) and monitor for **rapid-fire pushes**.
- Train staff on **specific vishing scenarios**: what a real support call *will* and *will not* ask them to do.

### Malicious browser extensions and ChatGPT session theft

Malwarebytes researchers disclosed a campaign of **16 malicious Chrome/Edge extensions** masquerading as ChatGPT helpers (bulk delete, export, prompt managers, etc.).

Under the hood, these extensions:

- Exfiltrate **ChatGPT session tokens** and related metadata to attacker-controlled infrastructure.
- Potentially allow full access to **conversation history, prompts, and any sensitive data** users paste into chats.
- Gather extra telemetry (extension version, language, usage) that can be used to **fingerprint users across time**.

This is a good reminder that the **browser extension ecosystem is effectively part of your endpoint fleet**:

- Enforce **extension allowlists** via Chrome/Edge enterprise policies or MDM where possible.
- Use **browser management policies** to restrict who can install extensions and from where.
- Treat AI-helper extensions as **high-risk by default** and subject them to heightened review.

### Prompt-injection and collaboration app abuse

Complementing these identity-layer threats, we also saw:

- **Prompt-injection against calendar assistants**, where crafted invites cause AI agents to leak private meeting summaries into attacker-visible artifacts.
- **Microsoft Teams phishing** using guest invitations and finance-themed team names to blend into collaboration noise.

The practical takeaway is that the **“modern work” stack (SSO, chat, meetings, browser, AI assistants)** is converging into a single attack surface. Controls, monitoring, and user education need to be designed with that convergence in mind.

---

## 3. Ransomware and extortion: data, brand, and supply chain

Ransomware remains the dominant monetisation model, but the week’s activity underscores how much it has matured beyond “encrypt and pray”.

### Dire Wolf hits APAC energy and exposes supply-chain risk

Reporting this week highlighted **Dire Wolf ransomware** impacting **Perdana Petroleum Berhad** in Malaysia, with roughly **150 GB of financial and supplier data** leaked on the group’s site.

What matters:

- The victim sits in the **energy supply chain**, not necessarily at the top of the energy pyramid.
- Stolen data includes **legal, financial, and customer information**, which can be weaponised for follow-on fraud, extortion of partners, and competitive intelligence.
- The incident illustrates how **tier-2 and tier-3 providers** can act as leverage points into more heavily defended organisations.

If you are in a critical vertical (energy, healthcare, public sector) but feel “small”, this is your reminder: **you are still a valid target if you connect to someone big**.

### Nova (ex-RALord) RaaS: mature, aggressive, and cross-platform

Red-team style reporting on the **Nova ransomware family** (formerly RALord) paints a picture of a highly industrialised RaaS operation:

- Cross-platform payloads for **Windows, Linux, and VMware ESXi**.
- Heavy use of **Rust-based lockers**, complicating analysis and evasion of legacy detection.
- Aggressive **double-extortion playbook**: large-scale data theft before encryption, leak sites with detailed victim profiles, and countdown timers.
- Proficiency in **MFA bypass, backup destruction, and Safe Mode abuse** to maximise impact and reduce recovery options.

The key for defenders is not memorising every TTP but recognising the **operational maturity**:
Nova affiliates are behaving less like “script kiddies” and more like **adversaries with playbooks, SLAs, and tooling support**.

### Big-brand data and regulatory exposure

On the brand front, we saw:

- **Nike** investigating a potential data breach after the **World Leaks** group claimed to have published **1.4 TB of corporate data**. At the time of writing, the claims are unverified, but the reputational impact is already real.
- Additional reporting on **luxury manufacturers, music platforms, and large-scale consumer datasets** being traded following ransomware events, often months after the initial compromise.
- Ongoing fallout from breaches affecting **hundreds of thousands to millions of customers or investors**, raising the usual questions about notification timelines, class actions, and regulatory scrutiny.

For defenders, this reinforces three priorities:

1. **Data minimisation and segmentation** – don’t hold what you don’t need, and don’t keep all of it in one blast radius.
2. **Exfiltration-aware monitoring** – detect unusual large outbound transfers, cloud storage usage anomalies, and stealthy archive staging.
3. **Incident response muscle memory** – rehearsed playbooks for double-extortion, including decisions around paying/not paying, negotiation, and public communication.

### Doxxing of high-risk roles

We also saw coverage of **data leaks exposing law-enforcement personnel**, including ICE and Border Patrol agents. While not strictly ransomware, this is part of the same **coercion and leverage economy**:

- Information on high-risk individuals can be used for **physical intimidation, social engineering, and influence operations**.
- The line between “cybercrime”, “hacktivism”, and “state-linked information ops” continues to blur.

Organisations with staff in sensitive roles should bake **targeted personal security guidance and support** into their security programs, not treat it as an afterthought.

---

## 4. ICS/OT and critical infrastructure under pressure

The week also brought a dense cluster of **ICS advisories and infrastructure-focused activity**.

### Energy sector incidents and geopolitics

A few threads converged:

- The **Dire Wolf** ransomware intrusion into a Malaysian energy firm is a reminder that **upstream and midstream providers** are now firmly in scope.
- European reporting continued to highlight **cyber attacks against power and renewable infrastructure**, with Russia-linked actors repeatedly named in investigations.
- While not every incident is confirmed as a cyber attack, the pattern is clear: **energy, utilities, and transport** are attractive leverage points in geopolitical and criminal campaigns alike.

### CISA ICS advisories and KEV updates

CISA and partner organisations published **multiple ICS advisories** this week for products including:

- **KiloView encoder series**
- **Rockwell Automation** components such as ArmorStart LT and ControlLogix
- **Schneider Electric** Zigbee products
- **Mitsubishi Electric** GENESIS64 and CNC series
- **Johnson Controls** industrial products

In parallel, CISA added **new entries to the Known Exploited Vulnerabilities (KEV) catalogue**, including:

- High-severity issues in **VMware vCenter**, allowing remote code execution via DCE/RPC.
- Authentication bypasses and access control flaws in **Versa SD-WAN**, **Zimbra**, **Vite**, and even **eslint-config-prettier** via a supply-chain compromise.

This tells us two things:

1. **OT-specific gear is receiving more scrutiny**, and vulnerabilities there are not theoretical – they are increasingly exploited.
2. The **enterprise edge (firewalls, SD-WAN, VPN, collaboration servers)** remains a favourite entry point for both ransomware crews and state-linked actors.

If you own ICS/OT or adjacent environments, minimum actions for this week should be:

- Cross-check your asset list against the **latest ICS advisories and KEV entries**.
- Where patching is hard, **tighten network segmentation, remote access, and monitoring**.
- Ensure you have **visibility into management interfaces and out-of-band paths** often used in ICS environments.

---

## 5. Law enforcement pressure vs criminal adaptability

To close the loop, we also saw **law enforcement making visible moves** against cybercrime infrastructure.

The most notable was the **FBI seizure of the RAMP hacking forum** – formerly branded as the “only place ransomware allowed”. RAMP served as a **major marketplace for RaaS crews and initial access brokers**, with actors like Qilin, LockBit, RansomHub, and others using it to advertise, recruit affiliates, and trade stolen data.

Key implications:

- In the short term, this will **disrupt some operational flows**: fewer places to easily recruit, advertise, and coordinate.
- In the longer term, as history has shown with previous takedowns, criminals are likely to **migrate to other forums or spin up successors**.
- From a defender perspective, such takedowns are still valuable because they can yield **intel on participants, infrastructure, and money flows**, even if the ecosystem reconstitutes elsewhere.

The signal for defenders is mixed but important:

- Don’t assume “ransomware is going away” because a marquee forum got seized.
- Do assume that some actors will make **operational security mistakes** during the migration, creating **detection and disruption opportunities** you can capitalise on with good threat intel and monitoring.

---

## Actions for defenders: what to prioritise this week

To make this practical, here is a condensed **action checklist** aligned to the week’s themes. You won’t do everything in a week, but you can at least move the needle on the most exposed areas.

### 1. Identity and browser hardening

- **Audit browser extensions** on managed endpoints; remove or block unapproved ChatGPT/AI helper extensions.
- Enforce **extension allowlists** via Chrome/Edge enterprise policies or MDM where possible.
- Review **SSO access policies** (Okta, Entra ID, etc.):
  - Require **phishing-resistant MFA** for admins and high-privilege roles (FIDO2 keys, platform authenticators).
  - Tighten **conditional access** based on device compliance, network location, and risk scores.
- Implement or refine **detections for Evilginx-style activity**:
  - Multiple failed logins followed by a successful login from a new device or IP.
  - Sudden creation of persistent sessions from unusual geos shortly after successful MFA.
- Run **awareness refreshers** on vishing and MFA fatigue, explicitly referencing “SSO support” and “Teams/Zoom billing” pretexts.

### 2. Cloud, Linux, and AI-integrated workflows

- Validate that **runtime security controls** (EDR, CWPP, CNAPP, eBPF agents) are deployed on critical Linux and container workloads.
- Ensure you have **script execution visibility** for PowerShell and bash, including in CI/CD runners and dev boxes.
- For any **AI agent integrations** (calendar assistants, ticket triage bots, etc.), review:
  - What data they can read or write.
  - Which external tools and APIs they can invoke.
  - Whether they are protected against **prompt injection** from untrusted content (invites, emails, wiki pages).

### 3. Ransomware and double-extortion readiness

- Validate that **backups are offline or logically separated**, tested, and not easily reachable from standard admin accounts.
- Tune or add detections for:
  - Unusual use of tools like `vssadmin`, `wmic shadowcopy`, archivers, and mass file renames.
  - Large outbound transfers to cloud storage providers you don’t normally use.
- Review your **incident response runbook for extortion scenarios**, including:
  - Who is authorised to engage with attackers (if at all).
  - What your position is on paying ransoms.
  - How you will handle **public comms** if data leaks.

### 4. ICS/OT and edge device hygiene

- Cross-reference your **ICS inventory** against the latest CISA advisories. Highlight anything that is both:
  - Exposed to untrusted networks or remote access paths, and
  - Affected by new vulnerabilities or known exploited flaws.
- Where patching is constrained, prioritise:
  - **Network segmentation and firewall rule tightening**.
  - **Jump host** approaches for admin access, with strong MFA and logging.
  - **Monitoring of management interfaces** for brute force, weird headers, or unusual requests.

### 5. Threat intel and hunting

- Ingest and normalise threat intel relating to:
  - **Operation Poseidon / KONNI**, **VoidLink**, **Nova**, **Dire Wolf**, and **Evilginx2**.
- Build at least one **targeted hunt** this week, for example:
  - PowerShell scripts spawning from LNKs in user download directories.
  - New browser extensions installed in the last 7–14 days on high-value endpoints.
  - Unusual authentication patterns around Okta/Entra ID, especially involving new devices and geos.

---

## Closing thoughts

The week of **26 January 2026** didn’t bring a single “watershed” event, but it did reinforce several uncomfortable truths:

- **AI is fully operationalised on the attacker side** – from malware development to exploit generation and social engineering, not as a gimmick but as standard practice.
- The **identity plane and browser** are now the most consistently attacked layers in many organisations, with phishing kits, vishing, AI helpers, and prompt-injection all converging on the same target: your sessions and tokens.
- **Critical infrastructure and supply chains** remain high-value, high-impact targets, whether via ransomware, ICS vulnerabilities, or compromised service providers.
- Law enforcement is hitting key pieces of the criminal ecosystem, but **offence is still adapting faster than defence** in many places.

For defenders, the path forward is clear even if it isn’t easy:

- Double down on **identity, browser, and endpoint hygiene**.
- Treat **AI-assisted attacks** as baseline, not edge cases.
- Make sure your **ICS, OT, and edge devices** are not silently lagging behind in patching and segmentation.
- Keep one eye on the **ecosystem-level changes** (forum takedowns, KEV updates, RaaS rebrands) that shape the next quarter of activity.

As always, use these weekly signals to steer **incremental, concrete improvements** in your environment. Even small, consistent hardening steps will compound over the coming months – and that compounding is exactly what most adversaries are not planning for.

