---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 29th December 2025"
pretty_title: "Weekly Threat Trends — Week Commencing 29th December 2025"
excerpt: "This half-week at the end of 2025 and the first days of 2026 are a good moment to take stock: AI-driven intrusion chains, identity-led attacks, data extortion, and the growing role of DFIR all reshaped how defenders work. This post closes out the year with a snapshot of what’s hitting the wire right now and concrete priorities for the year ahead."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-01-04
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **29 December 2025 – 4 January 2026** is a strange one:  
half of it sits in the closing hours of 2025, the other half in the first days of 2026.

Operationally, it’s a **quiet-but-not-quiet** week:

- A lot of staff are still on leave.
- Many environments are in change freeze.
- Attackers are watching password resets, token churn, and year-end reporting windows for opportunities.

Rather than a single explosive campaign, this week is defined by **multiple slow burns** that all share the
same message:

> 2025 has re-wired the threat landscape around **identity, SaaS, AI-assisted tradecraft, and data**.  
> 2026 will reward teams that treat those as first-class security domains, not side quests.

Before we get into the details: **Happy New Year**.  
The goal of this post is to close out 2025 honestly, and kick off 2026 with a clear, realistic set of moves
that will actually make a difference.

---

## Top Trends at a Glance

- **AI-Accelerated Intrusion Chains** – from PROMPTFLUX-style droppers to LLM-optimised lures, attackers are using AI to iterate faster, not to replace tradecraft.
- **Identity and SaaS as the Primary Battleground** – SSO abuse, token theft, and app-consent misuse dominate successful intrusions.
- **Extortion Without Encryption** – data theft and doxxing outpacing classic “encrypt-everything” ransomware playbooks.
- **Observation Debt in Telemetry and DFIR** – gaps in logging, memory forensics, and provenance making it hard to reconstruct what really happened.
- **Software Supply Chain and “Trust Infrastructure” Risk** – poisoned packages, misconfigured CI/CD, and abused RMM tools as repeat entry points.
- **Human Load, Fatigue and Process Drift** – over-stretched security teams and unclear ownership turning minor incidents into major ones.

---

## Year-End Snapshot — What This Week Actually Looks Like

Most year-end threat writeups focus on big, named campaigns. On the wire this particular week, the pattern
is subtler:

- A steady background hum of **credential-stuffing and token replay** against:
  - Customer portals.
  - Cloud admin panels.
  - VPN and legacy remote-access gateways.
- Long-running **BEC threads** from November and early December:
  - Still attempting to nudge finance and AP teams into “final adjustments” before year-end.
- **Stealer logs and session inventories** accumulated over the last quarter:
  - Now being monetised as operators cycle old inventory into new campaigns.
- Opportunistic **ransomware and wiper operations** probing:
  - Whether backups are really tested.
  - Whether holiday on-call teams are allowed to pull the big red levers.

It’s less about a single actor and more about **many actors testing the boundaries at the same time**.

Against that backdrop, this week is the right time to zoom out. The rest of this post is less about IOCs and
more about **what 2025 changed — and how to enter 2026 with a plan**.

---

## AI-Accelerated Intrusion Chains

We end 2025 with “AI-powered malware” no longer a buzzword but a **messy, real phenomenon**:

- AI-assisted droppers and loaders (PROMPTFLUX-style) that:
  - Call LLM APIs to mutate scripts on demand.
  - Generate slightly different payload wrappers per victim.
  - Ask models to adjust behaviour based on environment signals.
- Phishing and ClickFix chains where:
  - Lures are written and localised by models.
  - Fake dialogues and error prompts mirror real OS and application UX.
- Post-ex tooling that:
  - Feeds stolen data to LLMs to prioritise which accounts, files, or projects to target first.
  - Uses AI to summarise victim environments for less technical affiliates.

Key reality check as we step into 2026:

- **The kill chain hasn’t changed**:
  - Users still need to click, run, or consent to something.
  - Malware still needs to execute, persist, talk to C2, move laterally, and steal or destroy things.
- **The tempo has changed**:
  - Variants turn over faster.
  - Lures adapt to language, role, and region without a human copywriter.
  - Low-skilled actors can run higher-quality operations.

Defensive response going into 2026:

- Invest in **behavioural and contextual detection**:
  - Parent-child process chains.
  - Script hosts calling unusual APIs (including AI endpoints).
  - Dynamic code execution and self-modifying binaries.
- Treat **AI API usage from endpoints** as a monitored surface:
  - Not something you default-allow and forget.
- Experiment with **defensive AI** in a controlled way:
  - Incident clustering and summarisation.
  - Alert triage and prioritisation.
  - Automated enrichment of IOCs and cases.

AI is now part of the threat landscape and the defense toolkit. The teams that win are those who **use it on
purpose**, not those who pretend it is either magical or irrelevant.

---

## Identity, SaaS and the New Perimeter

If 2020 was the year of “VPN everywhere” and 2021–2022 were about hybrid work, 2025 has been the year where:

> “The perimeter is wherever your identities and sessions go.”

This week reinforces that:

- Successful intrusions increasingly revolve around:
  - SSO misconfigurations.
  - Weak app-consent governance in OAuth/OIDC.
  - Stealer-driven token and cookie theft.
- Attackers spend more time:
  - Turning one compromised mailbox into tenant-wide visibility.
  - Converting stolen browser sessions into cloud-admin access.
  - Living entirely inside SaaS platforms once they’re in.

For 2026, a realistic identity/SaaS security agenda looks like:

- **Strong app-consent and SSO hygiene**
  - Admin consent for risky scopes.
  - Regular review of:
    - App registrations.
    - Service principals.
    - Cross-tenant trust and B2B links.
- **Session-aware incident response**
  - Password resets are the *start*, not the end, of stealer response.
  - Built-in playbooks for:
    - Revoking tokens.
    - Killing active sessions.
    - Reviewing inbox rules, OAuth grants, and “remembered devices.”
- **Risk-based access and step-up auth**
  - Conditional policies that treat new devices, strange geos, and impossible travel with suspicion.
  - Extra checks for:
    - Admin actions.
    - Data exports.
    - Changes to security controls.

If you manage to get **identity, SSO, and SaaS** into the same conversation as traditional network and
endpoint security in 2026, you’ll already be ahead of many peers.

---

## Data Extortion, Privacy, and Quiet Catastrophes

By late 2025, the more mature extortion crews have largely settled on a model:

- Notebook: Data is often more valuable than uptime.
- Ransomware (encryption) is noisy, risky, and increasingly well-defended against.
- Quiet data theft, followed by targeted extortion, is often **cheaper, lower-risk, and more profitable**.

This week, as with much of Q4, we see:

- Threat groups exfiltrating:
  - Legal and HR archives.
  - M&A and deal documents.
  - Sensitive customer datasets.
- Extortion notes framed as:
  - “We have X GB of your [specific internal project] and Y years of customer data.”
  - “Pay to prevent public release, regulator notification, or competitive leakage.”

For defenders and leadership, this forces an uncomfortable shift:

- “Did we stay online?” is no longer the main metric.
- The real questions become:
  - “What left the environment?”
  - “Who was affected?”
  - “What will regulators and customers reasonably expect us to do now?”

Heading into 2026:

- Build or refine **data mapping**:
  - Know where the sensitive things live: file shares, SaaS platforms, data lakes.
  - Know which identities and systems can access them.
- Invest in **exfil detection**:
  - Volume-based (sudden spikes in outbound or cross-tenant traffic).
  - Path-based (data moving via unusual apps or connectors).
- Plan **extortion-without-encryption** runbooks:
  - Legal, privacy, and comms teams ready to collaborate.
  - Pre-agreed thresholds for customer and regulator notifications.

“Ransomware” is increasingly just one of several ways to pressure victims.  
In 2026, assume that **any serious intrusion is a potential data-breach event**, even if no files are
encrypted.

---

## Observation Debt: Logs, Memory and Provenance

One of the sharpest lessons of 2025 — and this week continues to underline it — is that many teams are
sitting on **observation debt**:

- Gaps in logging and retention that only become obvious during a major incident.
- Limited use of **memory forensics** in environments dominated by fileless and in-memory tradecraft.
- Lack of **provenance and attestation** for binaries, containers, and even logs themselves.

We saw attackers:

- Tamper with EDR and event providers to selectively blind specific detectors.
- Abuse trusted tools (RMM, backup agents, CI/CD) in ways that regular logging didn’t clearly capture.
- Leave defenders arguing with themselves:
  - “Did this actually execute, or is the log lying?”
  - “Did the attacker backdoor this pipeline, or is this just a misconfiguration?”

As we step into 2026, closing this gap doesn’t mean turning on **every possible log**; it means:

- Deciding what your **canonical sources of truth** are for:
  - Process execution.
  - Network connections.
  - Identity activity.
  - Code provenance.
- Ensuring those sources are:
  - Collected.
  - Protected (tamper-evident, properly access-controlled).
  - Actually usable under pressure.

On the DFIR front:

- Make **memory capture and analysis** a standard part of serious incidents.
- Build repeatable Volatility workflows:
  - Identify processes.
  - Map network connections.
  - Hunt for injected regions and in-memory configs.
- Use memory as a way to **referee disagreements** between logs, endpoints, and instincts.

In 2026, the teams that do well won’t necessarily be those with the most data; they’ll be the ones who know
**which data they trust, why, and how to get to it fast**.

---

## Supply Chain, RMM, and “Trust Infrastructure”

2025 has also made it clear that many compromises don’t start with a phishing email — they start with:

- A compromised or poisoned dependency in **package registries**.
- A misconfigured or hijacked **CI/CD pipeline**.
- A legitimate **remote management tool** operated by the wrong person.

This week follows that arc:

- We continue to see:
  - Malicious packages in npm, PyPI and container registries with targeted install hooks.
  - Attackers using RMM consoles and helpdesk agents to push scripts instead of dropping obvious malware.
- Incidents where:
  - “The malware” is barely present.
  - The real story is “our build or management system did exactly what it was told — by an attacker.”

For 2026, a pragmatic approach to “trust infrastructure” includes:

- Treating **CI/CD, RMM, and IdPs** as **tier-0 assets**:
  - Strongest MFA.
  - Least privilege.
  - Tight audit and logging.
- Moving towards **curated package usage**:
  - Internal mirrors for dependencies.
  - Allow-lists for critical workloads.
  - SBOMs that are actually reviewed, not just generated.
- Introducing **provenance checks** in deployment:
  - Only ship artifacts that can prove:
    - Which pipeline built them.
    - Which source repos they came from.
    - Which signatures they carry.

If an attacker can stand on the shoulders of your trust infrastructure, every other control becomes cosmetic.

---

## Lessons from 2025 in One Page

As we close out the year, a brutally honest summary looks like this:

- **Attackers moved closer to identity and data**:
  - Credential theft, session hijacking, and SaaS abuse became the default path to high-value access.
- **Malware became more dynamic but not more magical**:
  - AI-assisted droppers and loaders increased turnover speed but still had to obey OS and network rules.
- **Extortion matured**:
  - Data-centric pressure, corporate doxxing, and brand damage overtook simple encryption as the main weapon.
- **Defenders who invested in fundamentals won more often**:
  - Strong identity and SSO hygiene.
  - Memory forensics and proper DFIR workflows.
  - Good backups, tested.
  - Clear incident ownership and on-call plans.
- **Observation debt hurt**:
  - Incidents took longer and cost more when teams had to guess what happened instead of reading it from evidence.

---

## Starting 2026: Practical Security “Resolutions”

No grand visions here — just **concrete, achievable moves** that will compound over the year if you start
early.

**1. Identity and SSO First**

- Map your IdP and SSO landscape.
- Clean up:
  - Old app registrations and service principals.
  - Over-privileged admin accounts.
  - Weak or inconsistent MFA policies.
- Establish a stealer/identity incident runbook that always includes:
  - Session/token revocation.
  - OAuth and inbox-rule review.

**2. Make Memory Forensics Routine, Not Exotic**

- Pick one or two critical incident types (e.g., suspected malware on high-value endpoints).
- Standardise:
  - Which tool you use for memory capture.
  - Where images are stored.
  - A basic Volatility plugin set for first-pass triage.
- Run at least one **tabletop + lab** combining:
  - Logs.
  - Disk artefacts.
  - Memory images.
  To tell a complete story.

**3. Reduce Trust in the Wrong Places, Increase It in the Right Ones**

- Lock down:
  - RMM consoles.
  - CI/CD pipelines.
  - Backup and hypervisor management planes.
- Start small with provenance:
  - One key service where only attested builds are allowed to deploy.
- Document which systems you would absolutely not want an attacker to operate — and harden them as if they
  were domain controllers.

**4. Prepare for Data Extortion, Not Just Ransomware**

- Identify your **top 5 data sets** by business impact.
- For each:
  - Where is it?
  - Who can access it?
  - How would you know if it was exfiltrated?
- Draft a **data-breach playbook**:
  - Decision-makers.
  - Regulator timelines.
  - Customer communication approaches.

**5. Take Care of the Humans**

- Review on-call rotations and escalation policies:
  - Avoid permanent overwork for a handful of key people.
- Run honest post-incident reviews that:
  - Focus on system and process fixes, not blame.
- Invest a small but consistent amount in training:
  - New joiners.
  - Cross-skilling between IR, detection engineering, and cloud/identity teams.

You don’t have to fix everything in January. But you do need to start **moving in the right direction** and
keep moving.

---

## Closing Thoughts (Happy New Year)

2025 made one thing clear:  

- Attackers will keep finding new ways to stand on the shoulders of our **trusted systems, identities, and
  tools**.
- The technology will keep changing, but the core job of defenders will not:
  - Understand how your environment really works.
  - Notice when it behaves differently.
  - Respond quickly, clearly, and with enough context to make good calls.

As we cross the line into 2026:

- **Happy New Year** to everyone doing this work — SOC analysts, DFIR responders, detection engineers, admins,
  and all the hidden glue roles in between.
- The fact that many incidents this year **didn’t become headlines** is because people quietly did the right
  thing at the right time.

The aim for 2026 is simple:

- Fewer surprises.
- Faster, better-informed response.
- A little less observation debt, and a little more confidence in the story your evidence tells you.

If this weekly trends series has one message to carry into the new year, it’s this:

> You don’t need perfect security. You need **clear priorities, trustworthy telemetry, and enough discipline
>  to act on them when it counts.**

Here’s to making that a reality in 2026.
