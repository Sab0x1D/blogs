---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 2nd March 2026"
pretty_title: "Weekly Threat Trends — Week Commencing 2nd March 2026"
excerpt: "The first full week of autumn in Australia arrives with a very clear signal: attackers are leaning harder into enterprise edge and middleware, fake IT support is back in force, AI agents are becoming a real attack surface, and long-tail supply-chain and Oracle EBS fallout is still spilling into March."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2026-03-08
featured: false
tags: [Weekly Trends, Weekly Threats, Ransomware, Data Breach, Identity, AI Security, Supply Chain, Vulnerabilities]
---

The first full week of **March 2026** — and the first full week of **autumn here in Australia** — feels like one of those transition weeks where the pattern becomes hard to ignore.

What stands out is not one single mega-breach, but a cluster of signals all pointing the same way:

- attackers are putting more effort into **enterprise technologies and edge systems** than classic browser exploit chains,
- **fake IT support and voice-led intrusion** is still one of the fastest paths to domain-wide compromise,
- **AI agents and local gateways** are now a genuine attack surface rather than a hypothetical one,
- and the long tail of **supply-chain and Oracle EBS compromise** is still surfacing fresh victims months later. 

This week is a good one for tightening fundamentals before the year gathers speed: remote access, identity, third-party platforms, developer tooling, and anything pretending to be “internal plumbing” but quietly sitting on your perimeter.

---

## Top Trends at a Glance

A few themes define the week commencing **2 March 2026**:

- **Enterprise tech is now the favoured zero-day target**  
  Google’s latest threat analysis says it tracked **90 zero-days exploited in the wild during 2025**, with a notable structural shift toward **enterprise systems, operating systems, and networking/security appliances**, while browser exploitation dropped to historical lows. 

- **Social engineering plus remote support is still brutally effective**  
  Huntress-linked reporting this week shows a campaign using **spam plus fake IT support calls** to land **Havoc C2**, move laterally within hours, and set up for either ransomware or data theft. 

- **AI agents are now part of the attack surface**  
  A vulnerability in the self-hosted AI assistant **OpenClaw** allowed malicious websites to brute-force a localhost WebSocket gateway and potentially turn a browser tab into **full workstation compromise** for developers. 

- **Oracle EBS fallout is still surfacing new victims**  
  **Madison Square Garden** confirmed it was affected by the 2025 Oracle E-Business Suite campaign tied to **Cl0p**, joining a growing list of organisations still discovering the blast radius months later. 

- **Automotive platforms remain rich identity targets**  
  New breach reporting points to a major online automotive marketplace affecting **12.5 million people**, reinforcing how vehicle, finance and marketplace ecosystems keep concentrating personal data in attractive places. 

- **Education and healthcare remain active intrusion targets**  
  A newly documented cluster, **UAT-10027**, has been targeting US **education and healthcare** organisations since at least December 2025 using the **Dohdoor** backdoor. 

- **Australia’s IoT baseline is shifting this week**  
  From **4 March 2026**, mandatory minimum security standards apply to most consumer smart devices sold in Australia, which matters because consumer-grade connected devices keep bleeding into home offices and small business networks. 

---

## 1. Enterprise Edge and Middleware Keep Winning

One of the clearest strategic signals this week comes from Google’s latest zero-day analysis.

According to Google Threat Intelligence, **90 zero-days were exploited in real-world attacks in 2025**, and nearly **half** targeted **enterprise technologies** rather than browsers. The report describes a continuing structural shift away from heavily monitored browser chains and toward **operating systems, security appliances, networking gear, and enterprise platforms** as the more reliable initial-access path. Google also explicitly warns that AI is likely to accelerate **reconnaissance, vulnerability discovery, and exploit development** on the attacker side. 

That lines up neatly with what we’ve been seeing through late February:

- mail and collaboration platforms,
- remote support infrastructure,
- hypervisors,
- message brokers,
- third-party enterprise apps,
- and large shared middleware platforms.

The practical takeaway is simple:

> If something sits on the edge of your environment, brokers trust, or glues multiple internal systems together, it is now a first-class target.

This is why old thinking like “it’s just an internal app” or “that server only handles updates / support / workflow orchestration” keeps failing. The things we historically described as **supporting systems** are increasingly the things attackers compromise first.

For defenders heading into autumn, this means patching and attack-surface reduction should stay heavily focused on:

- remote support platforms,
- middleware and brokers,
- internet-facing enterprise applications,
- and anything with privileged reach into identity or management networks. 

---

## 2. Fake IT Support, Havoc C2, and the Return of Human-Driven Intrusions

One of the most interesting intrusion chains this week is the campaign documented by Huntress and covered more broadly as **fake IT support spam deploying customised Havoc C2**.

The pattern is worth paying attention to because it is not especially exotic — which is exactly why it works:

- The victim first gets hit with **junk email spam** to create noise and urgency.
- The attacker then calls, pretending to be **IT support**, and convinces the user to grant remote access, often through **Quick Assist** or a commercial remote-access tool like **AnyDesk**.
- Once access is granted, the actor walks the user through a fake workflow hosted on an **AWS page impersonating Microsoft**, and from there executes a script chain that ends with **Havoc Demon payloads**, persistence, and lateral movement. Huntress observed one case where the actor moved from initial access to **nine more endpoints in about eleven hours**. 

There are two reasons this matters.

First, it reinforces that **identity and trust** remain the easiest way in. No zero-day required. No elaborate exploit chain. Just a user convinced that the person on the phone is internal IT.

Second, it shows that threat actors are blending:

- **voice phishing**,
- legitimate **remote management tools**,
- fake cloud-hosted portals,
- and commodity or modified frameworks like **Havoc**,

…into a chain that is fast, flexible, and hard to distinguish from real support activity if you do not already have mature telemetry around helpdesk and RMM workflows. 

This is exactly the kind of attack that will keep showing up in 2026 because it fits modern environments so well:

- more remote support,
- more hybrid users,
- more outsourced helpdesk functions,
- and more pressure to resolve issues quickly.

For defenders, the smart response is not just “do awareness” in the abstract. It is to define and publish:

- how your **real IT support** operates,
- which tools are officially used,
- whether staff should ever accept unsolicited Quick Assist / AnyDesk sessions,
- and what a legitimate remediation process actually looks like.

If users cannot tell what “normal support” looks like, attackers will happily define it for them. 

---

## 3. AI Agents Move From Novelty to Attack Surface

If last year was about “AI in phishing”, this week is more about **AI infrastructure itself becoming a weak point**.

SecurityWeek reported a flaw in **OpenClaw**, a self-hosted AI assistant, where a malicious website could open a WebSocket connection to the local gateway port, brute-force a password, auto-register as a trusted device, and effectively seize administrative control of the agent. The design problem was subtle but serious:

- the gateway was bound to **localhost**,
- localhost traffic was implicitly trusted,
- rate limiting did **not** apply to loopback connections,
- and pairing from localhost could occur **without a user prompt**. 

The end result is the sort of quote that should make every engineering team pause:

> for a developer with normal OpenClaw integrations, exploitation was effectively equivalent to **full workstation compromise initiated from a browser tab**. 

Why this matters beyond one tool:

- It shows how **agentic tooling** introduces new trust assumptions that browser security models do not automatically save you from.
- It shows that “localhost” is not magically safe when a browser can talk to it.
- It shows how AI assistants linked into:
  - Slack,
  - shell execution,
  - file systems,
  - local apps,
  - and developer environments,

…can quietly become a privileged control plane.

This does not mean AI assistants are unusable. It means they need to be threat-modelled like any other high-privilege local service.

For defenders and engineers, the practical lesson is:

- treat **local AI gateways** as privileged services,
- enforce proper authentication and rate limiting even on loopback,
- minimise what the assistant is allowed to access,
- and assume malicious web content will eventually try to abuse any weak local trust boundary. 

---

## 4. Oracle EBS Fallout Still Has New Victims

One of the best reminders this week that incidents do not end when the headlines fade is the fresh confirmation that **Madison Square Garden** was impacted by the 2025 **Oracle E-Business Suite** campaign associated with **Cl0p**.

SecurityWeek reports that MSG has now confirmed the breach and started notifying affected individuals after being named by the attackers months earlier. According to the report:

- the compromised Oracle EBS instance was **hosted and managed by a third-party vendor**,
- the stolen data reportedly dated back to **August 2025**,
- and compromised personal information included **names and Social Security numbers**. 

That is exactly the pattern we have seen repeatedly in large-scale enterprise software exploitation:

1. zero-day or edge compromise hits a widely used business platform,
2. data is taken quietly,
3. extortion pressure follows,
4. and only months later do individual victims, regulators, and customers begin to understand the real blast radius.

This matters because the Oracle EBS story is not really about one arena operator. It is about:

- **enterprise management software**,
- **shared vendor-hosted environments**,
- and the way a single compromise at a common platform layer can ripple across many organisations.

The lesson for 2026 remains:

- “Hosted by a third party” does not reduce your exposure.
- It only changes where you need visibility, contracts, and assurance.

If your environment depends on outsourced ERP, CRM, finance, HR or event-management stacks, ask yourself one simple question:

> If that vendor was popped six months ago, how quickly would we know our data was in scope?

If the answer is “we’d find out when they tell us”, your dependency risk is still too passive. 

---

## 5. Automotive, Education and Healthcare Stay Rich Targets

This week also reinforces how attractive **high-volume identity ecosystems** remain.

A breach reported this week hit a major online automotive marketplace and is said to affect **12.5 million individuals**. Even without going deep into vendor-specific mechanics, that number matters because automotive marketplaces increasingly sit at the intersection of:

- consumer identity,
- vehicle ownership data,
- finance and lead-generation workflows,
- and downstream dealer / insurer / lender ecosystems. 

In parallel, ongoing reporting on **UAT-10027** shows a previously undocumented cluster targeting **education and healthcare** in the United States since at least **December 2025**, deploying the **Dohdoor** backdoor. Those two sectors stay perennially attractive because they combine:

- broad user populations,
- patchy infrastructure,
- sensitive data,
- and relatively low tolerance for downtime. 

Taken together, these stories show that attackers are not just chasing prestige targets. They are chasing **dense data environments** where one compromise creates:

- good phishing fuel,
- useful access for follow-on intrusion,
- and enough leverage to monetise through extortion, fraud, or access resale.

This is why education, healthcare, automotive, and finance keep showing up. They are not random sectors; they are **identity-rich sectors**.

---

## 6. Australia’s First Week of Autumn Starts With Smart Device Rules

There is also a useful local policy signal this week.

From **4 March 2026**, mandatory minimum security requirements begin applying to most consumer smart devices sold in Australia. The goal is to cut out some of the worst practices that have kept IoT and smart home devices weak for years. As iTnews notes, connected devices are everywhere now and often collect sensitive data including camera, microphone, location and behavioural information. 

This matters more than it sounds like it should.

Consumer smart devices are no longer confined to homes. They bleed into:

- home offices,
- BYOD-heavy small businesses,
- hybrid work environments,
- retail and branch sites,
- and occasionally even ad hoc enterprise networks.

When those devices are weak, they become:

- footholds,
- botnet nodes,
- surveillance points,
- or simply noisy, unmanaged risk.

So while this is framed as a consumer-device reform, it fits the broader seasonal trend nicely:

> the first week of autumn in Australia is starting with a quiet but important baseline lift in connected-device security.

That does not solve IoT risk overnight. But it is a useful prompt for organisations to review their own connected-device posture too:

- what is on the network,
- who owns it,
- and whether it is being treated as infrastructure or clutter. 

---

## Malware of the Week — Fake IT Support → Havoc C2

For this week’s **Malware of the Week**, the best fit is not a flashy new ransomware family but the **Havoc C2 intrusion chain** delivered through fake IT support.

This earns the slot because it captures several 2026 realities in one neat package:

- social engineering,
- legitimate remote access tools,
- cloud-hosted fake portals,
- modular C2,
- and very fast hands-on-keyboard lateral movement.

### What is Havoc?

**Havoc** is an open-source, teamserver-style command-and-control framework designed for post-exploitation. In the hands of defenders or red teams it is a simulation tool; in the hands of attackers it becomes a lightweight alternative to more mature C2 ecosystems.

The core “Demon” implant can support:

- command execution,
- process injection,
- payload staging,
- credential and discovery activity,
- and lateral movement support.

That flexibility is exactly why it keeps getting adopted and modified by threat actors. It is not necessarily the final monetisation tool. It is the thing that gives them **control and options** after initial access.

### How this week’s chain worked

In the campaign documented by Huntress and reported this week:

1. **Spam flood / email bombing**  
   - Victims are overwhelmed with junk email to create a believable support problem. 

2. **Phone call from “IT support”**  
   - The attacker calls and offers help.  
   - The victim is convinced to grant remote access through **Quick Assist** or install a tool like **AnyDesk**. 

3. **Fake Microsoft-hosted anti-spam workflow**  
   - The operator opens a fake cloud-hosted page, pretending to be part of a Microsoft anti-spam update flow.  
   - The user is instructed to enter information and interact with prompts that end up kicking off a malicious script path. 

4. **Havoc Demon deployment**  
   - The payload is dropped and the beachhead host begins beaconing as part of a customised Havoc setup.  
   - From there, the actor starts enumerating the environment and pushing further into the network. 

5. **Persistence via legitimate tools**  
   - Legitimate RMM software is retained as backup persistence even if the primary C2 is disrupted. 

In at least one observed case, the actor moved from the initial host to **nine additional endpoints within about eleven hours**, which tells you this was not opportunistic clicking around. The end goal was very likely **data theft, ransomware, or both**. 

### Why this chain is dangerous

Three reasons.

**First, it attacks the human trust boundary directly.**  
There is no need to exploit a memory corruption bug when a user will invite you in because you sound like internal support.

**Second, it blends beautifully into legitimate tooling.**  
Quick Assist, AnyDesk, remote help pages, Outlook-themed workflows — these are not obviously “malware” to most users.

**Third, Havoc is flexible enough to bridge into almost anything.**  
Once the actor has a Havoc foothold, they can pivot toward:

- credential theft,
- file staging,
- data exfiltration,
- ransomware prep,
- or longer-term persistence.

That makes it an ideal **mid-chain implant** in modern intrusion operations.

### Detection ideas

If you want practical anchors for this week, hunt on combinations of:

- **spam flood** or unusual surges of junk mail followed by:
  - inbound helpdesk-looking calls,
  - remote assistance activity,
  - or Quick Assist sessions,
- endpoint launches of **Quick Assist**, **AnyDesk**, or similar tools outside normal support patterns,
- browsers opening pages that impersonate Microsoft or support portals and are immediately followed by:
  - script execution,
  - credential prompts,
  - or suspicious network beacons,
- new persistence through legitimate RMM tools on hosts where they do not normally exist,
- lateral movement from a user workstation unusually quickly after a support session starts. 

### Hardening moves

A few short, high-value steps:

- Publish a **“how IT support contacts you”** guide internally.
- Require that remote assistance only occurs through **approved workflows and approved tools**.
- Alert on:
  - first-time Quick Assist usage,
  - AnyDesk installs,
  - or support tooling launched by non-support users.
- Train users specifically on:
  - fake support calls,
  - email bombing,
  - and “we need to fix your spam issue” pretexts.

This is one of those chains that looks almost boring on paper — and that is exactly why it works so well.

---

## Actions for the Week: Autumn Tune-Up

To open autumn on the right foot, here is a focused checklist aligned to this week’s themes.

### 1. Review enterprise edge and support systems

- Re-check exposure and patching for:
  - remote support platforms,
  - ERP / Oracle EBS-like systems,
  - middleware and brokers,
  - any internet-facing enterprise apps that quietly hold customer or employee data.
- For anything vendor-hosted:
  - confirm notification paths,
  - logging expectations,
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
  - and installs on non-support endpoints.

### 3. Treat AI agents and local gateways as real infrastructure

- If teams are using self-hosted or local AI assistants:
  - review localhost services,
  - authentication,
  - rate limiting,
  - pairing logic,
  - and the data sources those agents can access.
- Do not assume “browser can’t hurt localhost” without testing it.

### 4. Re-map third-party identity-heavy data stores

- Specifically review who stores:
  - ID documents,
  - financial applications,
  - healthcare support data,
  - event registration data,
  - broker / reseller communication history.
- Make those vendors part of your **actual threat model**, not just your procurement file.

### 5. Use the smart device law change as a local prompt

- Review connected-device exposure in:
  - offices,
  - branch sites,
  - meeting rooms,
  - and home-office-heavy environments.
- Segment or remove:
  - unmanaged cameras,
  - smart TVs,
  - speakers,
  - and other low-trust devices from business-critical networks.

---

The first week of **autumn in Australia** is arriving with a pretty clear message:

- the enterprise edge still matters more than most teams want to admit,
- social engineering plus remote assistance is still one of the fastest roads to compromise,
- AI tooling is now part of the environment you need to defend,
- and the biggest breaches often come from **systems your users never knew existed but trusted with their data anyway**.

That is what makes this a good week for seasonal housekeeping: find the quiet systems, find the quiet vendors, and find the quiet trust assumptions before an attacker does.