---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 9th March 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 9th March 2026"
excerpt: "The second week of March — and the second week of autumn in Australia — is shaping up around enterprise zero-days, fake IT support intrusions, AI-agent attack surface, long-tail Oracle EBS fallout, and a steady drumbeat of identity-rich breaches across automotive, education, and healthcare."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-03-15
featured: false
tags: [Weekly Trends, Weekly Threats, Ransomware, Data Breach, Identity, AI Security, Supply Chain, Vulnerabilities]
---

The week commencing **9th March 2026** has a very clear feel to it: autumn has started here in Australia, but the threat landscape is not cooling off. If anything, this week reinforces that 2026 is being defined less by flashy browser exploits and more by **enterprise platforms, identity abuse, remote support workflows, and AI-linked attack surface**. Google’s latest analysis of 2025 zero-days says the centre of gravity has shifted toward **enterprise systems, operating systems, and security/network appliances**, while browser zero-days have dropped to their lowest share in years.

This week’s notable trends are not random headlines. They fit together:

- attackers are still finding leverage in **internet-facing enterprise software**,
- social engineering plus **legitimate remote access tooling** remains one of the fastest ways into a network,
- **AI assistants and local agent frameworks** are now real infrastructure that can be abused,
- and major 2025 campaigns — especially **Oracle EBS compromise** — are still surfacing fresh victims months later.

---

## Top Trends at a Glance

The key themes from **9–15 March 2026**:

- **Enterprise zero-days and edge technologies remain the main prize**  
  Google tracked **90 zero-days exploited in the wild during 2025**, with attackers focusing increasingly on **enterprise platforms and appliances** instead of browsers.

- **Fake IT support and remote-assistance abuse are still working**  
  Huntress-linked reporting this week described a campaign where **email bombing plus phone-based fake IT support** led to remote assistance sessions, customised **Havoc C2**, and lateral movement in under half a day.

- **AI agents are now part of the attack surface**  
  A flaw in the self-hosted AI assistant **OpenClaw** allowed malicious sites to abuse a localhost gateway and potentially escalate from a browser tab to **full workstation compromise**.

- **Oracle EBS fallout is still producing new victims**  
  **Madison Square Garden** confirmed it was affected by the 2025 **Oracle E-Business Suite** campaign tied to **Cl0p**, months after the initial intrusion wave.

- **Automotive, education, and healthcare remain rich identity targets**  
  Reporting this week includes a major online automotive marketplace breach impacting **12.5 million people**, plus continued targeting of **education and healthcare** by a cluster tracked as **UAT-10027** using **Dohdoor**.

- **Australia’s IoT baseline is quietly rising**  
  New mandatory minimum security standards for most consumer smart devices sold in Australia take effect from **4 March 2026**, a relevant local development given the continued blending of smart devices into homes, home offices and small business networks.

---

## 1. Enterprise Platforms and Edge Systems Keep Winning

One of the most important strategic signals this week comes from Google’s latest threat analysis. The company says it observed **90 zero-days exploited in real-world attacks in 2025**, and almost **half** of them targeted **enterprise software, operating systems, and network/security appliances**, while browser zero-days represented a noticeably smaller slice than in previous years. Google also warns that AI is likely to accelerate **reconnaissance, vulnerability discovery, and exploit development** for attackers.

This matches what we have been seeing for months:

- remote support systems,
- middleware and brokers,
- hypervisors,
- mail and collaboration stacks,
- and enterprise management platforms

…are now more attractive than user-driven exploit chains in many environments.

Why? Because compromising one enterprise service often means:

- privileged reach,
- broad visibility,
- easier persistence,
- and a cleaner path into identity or management networks.

The lesson is straightforward:

> “Internal plumbing” and “support systems” are no longer support systems from an attacker’s point of view. They are **primary access points**.

This matters for defenders in a very practical way. Patch priorities should stay heavily weighted toward:

- anything internet-facing,
- anything that brokers trust,
- anything that stores credentials or sessions,
- and anything that quietly connects many systems together.

---

## 2. Fake IT Support Is Still One of the Fastest Roads In

One of the more useful intrusion stories this week involves a campaign using **spam plus fake IT support calls** to deliver **Havoc C2**.

The pattern is painfully effective:

1. The victim is overwhelmed with junk email.  
2. An attacker calls pretending to be **IT support**.  
3. The user is convinced to launch **Quick Assist** or install a remote support tool.  
4. The attacker walks them through a fake remediation workflow hosted on a cloud page impersonating Microsoft.  
5. A **customised Havoc payload** lands, persistence is established, and lateral movement begins. Huntress observed one case where the actor pivoted to **nine additional endpoints within roughly eleven hours**.

This campaign matters because it illustrates three 2026 realities:

- **human trust still beats technical complexity** in many organisations,
- **legitimate support tooling** is incredibly useful to attackers,
- and once the attacker has even a small foothold, the time to move laterally can be very short.

There is a tendency to frame this as “just awareness”, but that misses the bigger issue. Users are much more vulnerable when organisations have not clearly defined:

- how real support contacts them,
- which tools are approved,
- whether unsolicited support calls are ever normal,
- and what a legitimate “fix” actually looks like.

If a user cannot distinguish between real and fake IT support, the attacker has already won half the battle.

---

## 3. AI Assistants Are Becoming Real Infrastructure

A particularly important development this week is the growing reality that **AI assistants and local gateways** are now part of enterprise attack surface.

Security reporting on **OpenClaw**, a self-hosted AI assistant, showed that a malicious website could connect to a locally running WebSocket gateway, brute-force credentials, self-register as a trusted device, and potentially achieve control equivalent to **full workstation compromise** depending on the assistant’s integrations. The issue stemmed from weak assumptions around:

- localhost trust,
- lack of rate limiting on loopback traffic,
- and pairing flows that did not require meaningful user confirmation.

This is important well beyond one product.

The bigger lesson is that AI assistants increasingly have access to:

- local files,
- shell execution,
- browser sessions,
- collaboration platforms,
- tickets,
- code repositories,
- and sometimes production systems.

That means they are no longer just “productivity tools”. They are **privileged control planes** in miniature.

The defensive takeaway is simple:

- treat local AI gateways like privileged services,
- enforce strong auth and rate limiting even on localhost,
- minimise what they can touch,
- and assume malicious web content will eventually try to talk to anything listening on loopback.

---

## 4. Oracle EBS Is Still a Live Story

One of the best reminders this week that incidents do not end when the headlines fade is the fresh confirmation that **Madison Square Garden** was affected by the 2025 **Oracle E-Business Suite** campaign tied to **Cl0p**.

Recent reporting says MSG has now confirmed the breach and begun notifying affected individuals after being named by attackers months ago. The compromised Oracle EBS instance was reportedly **hosted and managed by a third-party vendor**, and the stolen data is said to include **names and Social Security numbers**.

The bigger point is not just that one organisation got hit. It is that this campaign continues to prove how dangerous shared enterprise business platforms can be:

- ERP and finance platforms are packed with sensitive data,
- they are often outsourced or vendor-managed,
- and compromise at that layer can quietly affect many organisations before anyone realises the scope.

This continues to be one of the clearest supply-chain lessons of 2026:

> “Hosted by a third party” is not a mitigation. It is just a different place where trust can fail.

If you rely on vendor-hosted ERP, HR, CRM or event-management platforms, this is a good week to ask:

- what data sits there,
- what logs you get,
- what notification timelines you are contractually guaranteed,
- and how you would independently validate exposure if the vendor was compromised.

---

## 5. Automotive, Education and Healthcare Are Still Identity-Rich Targets

A major breach reported this week hit an online automotive marketplace and is said to affect **12.5 million people**. That matters because these platforms increasingly sit at the intersection of:

- personal identity,
- vehicle ownership,
- credit or finance journeys,
- insurance workflows,
- and downstream dealer ecosystems.

At the same time, reporting continues on **UAT-10027**, a threat cluster targeting **education and healthcare** organisations since late 2025 using the **Dohdoor** backdoor. Those sectors remain persistent favourites because they combine:

- large populations,
- older infrastructure,
- high-value personal data,
- and relatively low tolerance for downtime.

The common thread across all of these environments is not just “sensitive data”. It is **identity density**:

- the more names, records, addresses, identifiers, health details or finance details in one place,
- the more attractive that platform becomes for phishing, fraud, extortion or access resale.

That is why attackers keep returning to:

- healthcare,
- education,
- automotive ecosystems,
- and enterprise data platforms.

They are not random sectors. They are **data concentration sectors**.

---

## 6. Australia’s Smart Device Baseline Quietly Improves

A local development worth noting this week is that from **4 March 2026**, new minimum security standards apply to most consumer smart devices sold in Australia. Reporting notes this is intended to address the long-standing problem of insecure connected devices collecting:

- audio,
- video,
- location,
- and behavioural data

…while often shipping with poor defaults and weak update practices.

This matters more than it might appear to at first glance.

Consumer smart devices bleed into:

- home offices,
- branch offices,
- BYOD-heavy small businesses,
- retail sites,
- and ad hoc corporate environments.

Insecure smart devices can become:

- surveillance points,
- stepping stones,
- botnet nodes,
- or simply unmanaged risk that nobody owns.

For defenders in Australia, this is a good seasonal prompt to review:

- what connected devices are actually on the network,
- who owns them,
- and whether they are being treated as infrastructure or ignored as clutter.

---

## Malware of the Week — Havoc C2 via Fake IT Support

For this week’s **Malware of the Week**, the standout is the **Havoc C2 intrusion chain** delivered through fake IT support.

This is a strong pick because it captures several 2026 realities in one package:

- voice-led social engineering,
- legitimate remote access tooling,
- cloud-hosted fake portals,
- fast lateral movement,
- and a flexible post-exploitation framework.

### What is Havoc?

**Havoc** is an open-source command-and-control framework used for post-exploitation. In legitimate hands it is a red-team tool. In attacker hands it becomes:

- a flexible remote implant,
- a lateral movement platform,
- and a staging point for whatever comes next.

Its “Demon” payload supports capabilities such as:

- command execution,
- process injection,
- discovery,
- payload delivery,
- and persistence.

That flexibility is why it keeps turning up in real campaigns.

### How this week’s chain worked

The sequence documented this week is fairly clean:

1. **Spam flood / email bombing**  
   - The victim is buried in junk mail to create urgency and confusion.

2. **Phone call from “IT support”**  
   - The attacker contacts the victim pretending to be internal support.  
   - The user is convinced to accept **Quick Assist** or install a remote access tool such as **AnyDesk**.

3. **Fake remediation portal**  
   - The victim is taken through a fake cloud-hosted page impersonating Microsoft support or anti-spam remediation.  
   - Under this pretext, script execution or staged actions occur.

4. **Havoc payload deployment**  
   - A Havoc payload lands and begins beaconing.  
   - The actor then starts environment discovery and lateral movement. In one observed case, they reached **nine additional endpoints in about eleven hours**.

5. **Persistence through legitimate tools**  
   - Legitimate RMM or remote support software is kept around as backup access in case the main implant is disrupted.

### Why this chain is dangerous

Three reasons stand out:

**First, it attacks trust directly.**  
No exploit kit. No browser zero-day. The user opens the door.

**Second, it blends into normal operations.**  
Quick Assist, AnyDesk, cloud support pages, email issues — none of this looks obviously malicious unless your organisation has defined what “real support” looks like.

**Third, Havoc is a bridge tool.**  
It does not need to be ransomware itself. It only needs to give the attacker enough control to choose whether the next move is:

- credential theft,
- data exfiltration,
- ransomware staging,
- or long-term persistence.

### Detection ideas

Good hunting anchors for this week include:

- **email bombing** followed by:
  - remote support sessions,
  - Quick Assist usage,
  - or unusual helpdesk-like activity,
- first-time or unusual launches of:
  - **Quick Assist**,
  - **AnyDesk**,
  - or other remote tools on non-support endpoints,
- browser sessions to support-looking domains immediately followed by:
  - script execution,
  - new remote access tools,
  - or outbound beacons,
- lateral movement from a workstation unusually soon after a support session begins.

### Hardening moves

A few short, practical steps:

- Publish a clear internal guide for **how real IT support contacts staff**.
- Restrict remote support tooling to:
  - approved products,
  - approved teams,
  - approved workflows.
- Alert on:
  - first-time Quick Assist usage,
  - AnyDesk or similar installs,
  - support tools on servers or executive endpoints.
- Train staff specifically on:
  - fake support calls,
  - email-bomb pretexts,
  - and “we need to fix your mailbox / spam issue” scenarios.

This is exactly the sort of intrusion pattern likely to stay relevant as Easter approaches and support teams, contractors and users all get busier.

---

## Actions for the Week: Early-Autumn Tune-Up

To keep this practical, here is a focused checklist for the week.

### 1. Review enterprise edge and support systems

- Re-check exposure and patching for:
  - remote support platforms,
  - ERP / Oracle EBS-like systems,
  - middleware and brokers,
  - internet-facing enterprise applications.
- For vendor-hosted systems:
  - confirm logging expectations,
  - incident notification timelines,
  - and who actually owns security operations.

### 2. Tighten remote access and support workflows

- Inventory:
  - Quick Assist,
  - AnyDesk,
  - TeamViewer,
  - ScreenConnect,
  - and any internal or outsourced support tooling.
- Decide:
  - which are approved,
  - who may use them,
  - and what “normal” looks like.
- Detect:
  - first-time use,
  - off-hours use,
  - installs on unusual endpoints.

### 3. Treat AI agents and local gateways as infrastructure

- If teams are using local or self-hosted AI assistants:
  - review localhost services,
  - authentication,
  - rate limiting,
  - and the permissions those agents hold.
- Do not assume a browser cannot meaningfully abuse localhost without testing it.

### 4. Re-map third-party identity-heavy data stores

- Specifically review which platforms store:
  - ID documents,
  - finance applications,
  - healthcare support data,
  - event registration data,
  - reseller or broker communication history.
- Make those vendors part of your **actual threat model**, not just procurement paperwork.

### 5. Use the smart device rule change as a local prompt

- Review connected-device exposure in:
  - offices,
  - branch sites,
  - meeting rooms,
  - home-office-heavy environments.
- Segment or remove:
  - unmanaged cameras,
  - smart TVs,
  - speakers,
  - and other low-trust devices from business-critical networks.

---

The second week of **autumn in Australia** is arriving with a pretty clear message:

- the enterprise edge still matters more than many teams want to admit,
- fake support plus remote assistance remains one of the fastest roads to compromise,
- AI tooling is now part of the environment you need to defend,
- and some of the biggest exposures still come from systems your users never knew existed but trusted with their data anyway.

That makes this a good week for seasonal housekeeping: find the quiet systems, find the quiet vendors, and find the quiet trust assumptions before an attacker does.