---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 8th December 2025"
pretty_title: "Weekly Threat Trends — Week Commencing 8th December 2025"
excerpt: "This week focuses on telemetry tampering, large-scale cloud session hijacking, Telegram-driven stealer ecosystems, and how defenders can respond when logs and signals are no longer automatically trustworthy."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2025-12-14
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **8–14 December 2025** is defined by one uncomfortable theme:  
attackers are no longer content with simply *avoiding* detection — they are actively **tampering with the data and signals defenders rely on**.

We see campaigns that poison EDR telemetry, steal and resell cloud session tokens at scale, and orchestrate entire stealer operations from Telegram and serverless platforms. At the same time, blue teams are pushing deeper into **memory and process forensics** to validate what really happened when their logs disagree with reality, building on recent work around stealers, loaders, and RAM artefacts. :contentReference[oaicite:0]{index=0}  

---

## Top Trends at a Glance

- **Telemetry Tampering in the Endpoint Stack** – loaders and post-ex tools patching event providers, disabling sensors selectively, or generating benign noise to distort detection logic.
- **Cloud Session Hijacking at Scale** – stealer crews monetising browser-harvested tokens and cookies, enabling quiet, password-less account takeover in cloud suites.
- **Telegram-Centric Stealer Ecosystems** – logs, configs, builds, and operator comms all running through Telegram bots and channels.
- **QR Code and Invoice Infrastructure Abuse** – “scan-to-pay” and invoice fraud blending social engineering with payment portals and MFA fatigue.
- **Living Off SaaS and Serverless** – threat actors leaning on Notion, Google Drive, GitHub, and serverless functions as redirectors, payload hosts, and C2 relays.
- **Verification via Memory Forensics** – more teams treating RAM captures and process dumps as the final source of truth when endpoint and SIEM data can no longer be trusted.

---

## Theme Overview — When Telemetry Can’t Be Trusted

Most SOCs have built their workflows on a simple assumption: **logs tell the truth**. If the EDR says a process executed, it did. If the audit log is silent, nothing happened.

This week’s campaigns continue to attack that assumption directly.

On multiple investigations, responders recovered:

- Hosts where security tools appeared healthy in dashboards, yet memory analysis showed **sensors partially disabled, callbacks unhooked, or drivers unloaded**.
- Tenant logs that showed nothing more than “normal user activity”, while browser memory dumps revealed **cloud tokens and session cookies actively being harvested and exfiltrated**.
- Legitimate-looking QR payment portals that redirected through chains of **serverless workers and SaaS documents**, leaving only vague HTTP traces in proxies.

The pattern is not a single family or actor but a shared goal: **control the story your telemetry tells**, or at least make it noisy enough that detection engineering becomes significantly harder.

For defenders, this does not mean logs are useless; it means logs are **claims that must sometimes be verified** against independent artefacts — memory, packet captures, and out-of-band checks.

---

## Telemetry Tampering and EDR Blind Spots

The first major trend this week is focused squarely on endpoint visibility.

New loader and post-execution modules observed in the wild are no longer satisfied with `schtasks` and registry keys. Instead, they ship with logic to:

- Enumerate installed security tools (EDR agents, Sysmon, AV drivers).
- Identify their **event providers, named pipes, ETW sessions, or kernel callbacks**.
- Apply **surgical changes**:
  - Patching specific DLL exports used for event capture.
  - Disabling selected ETW providers while leaving others intact.
  - Flooding local logs with benign, repetitive events to hide anomalies in noise.

Unlike older “turn the EDR off and hope no one notices” approaches, these modules aim for **selective blindness**:

- Keep heartbeats and health checks alive so the console shows green.
- Silence only the **highest-value signals** — script block logging, PowerShell transcript events, certain image load events, or specific injection indicators.

On a few affected endpoints, SOC teams only realised something was wrong when they saw:

- Strange gaps in otherwise verbose logging streams.
- Detectors that suddenly dropped to zero hits without a content change.
- Memory captures revealing active malicious processes that simply **never appeared in sensor telemetry**.

The lesson is clear:

- Monitoring must include **meta-telemetry** — are the expected event volumes present, or did something go quiet?
- Controls like **protected process light (PPL)**, driver signing enforcement, and EDR self-protection must be regularly validated.
- Occasional **spot-check memory snapshots** on critical systems are becoming a necessity, not a luxury, especially after suspicious gaps or anomalies.

---

## Cloud Session Hijacking and Token Theft at Scale

While telemetry tampering tries to change what defenders see, **session hijacking** is all about changing what attackers can do without ever touching a password.

Commodity stealers this week continue to exfiltrate:

- Browser cookies and session tokens.
- OAuth refresh tokens and device tokens from productivity suites.
- Persistent logins for SaaS CRM, ticketing, and code repositories.

On the underground side, we see:

- Log shops advertising **“fresh cloud sessions”** instead of just “RDP combos”.
- Bots that automatically **validate stolen tokens**, checking:
  - Whether MFA is enforced.
  - What licences and roles are associated with the account.
  - Which services are accessible (mailbox, storage, admin consoles).

For defenders, the painful pattern is familiar:

1. Endpoint compromise appears “contained” — loader and stealer identified, host isolated, passwords reset.
2. Weeks later, investigation reveals that stolen tokens were quietly used from **residential proxies** to:
   - Access webmail.
   - Pull down sensitive documents from cloud storage.
   - Set up forwarding rules or OAuth application grants.
3. Authentication logs show only “successful, interactive user activity” from plausible IP ranges.

The critical takeaway this week:

- **Password resets alone are not enough** after a stealer incident.
- Incident runbooks must include:
  - **Invalidation of active sessions** and refresh tokens for affected accounts.
  - Review of OAuth grants, service principals, and “remembered devices”.
  - Correlation between **endpoint timeline** (when the stealer ran) and **cloud logs** (sessions, token use, inbox rule changes).

Token theft moves the pivot from “endpoint to domain” into “endpoint to cloud tenant”. The blast radius planning has to catch up.

---

## Telegram Log Shops and Stealer-as-a-Bot

Telegram continues to act as a de facto **malware-as-a-service control plane**, and this week’s activity reinforces that trend.

The modern stealer operator rarely hosts a classic “panel” in a single C2 any more. Instead, we see:

- Telegram bots that:
  - Receive logs directly from infected hosts (JSON, ZIPs, or encrypted blobs).
  - Tag entries by country, browser, balance, or domain found in the data.
  - Provide commands for operators to **search, filter, and purchase** individual logs or sessions.
- Channels where **build requests** are handled in-bot:
  - Affiliates send configuration (target apps, exclusions, webhooks).
  - The bot returns a customised stealer build or loader stub.
- Automated resale pipelines:
  - Logs that meet certain criteria (e.g. cloud admin accounts, crypto exchange access) are automatically forwarded to **premium buyers or separate channels**.

From a defender perspective, this has three implications:

1. **Infrastructure churn accelerates**  
   C2 domains and IPs that handle raw exfil may be short-lived, but Telegram bots and channels act as long-lived identities and coordination hubs.

2. **Attribution and clustering improve for defenders who watch Telegram**  
   Analysts who monitor relevant channels and bots can:
   - Track config changes across time.
   - See which targets are considered valuable.
   - Identify shifts between tooling families.

3. **Incident scale is larger than single hosts**  
   A single infected workstation’s logs, once uploaded, become part of **an inventory**. That inventory may be sold, re-sold, and used months later for separate campaigns.

Practical actions:

- Treat any stealer incident as **potential long-term account exposure**, not a one-off host event.
- Use threat intel feeds and manual monitoring where allowed to track **Telegram-based ecosystems** related to the families you encounter.
- Feed discovered bot names, channels, and patterns back into detection rules, even if they sit outside your direct network perimeter.

---

## QR Codes, Invoices and the New “Scan-to-Pay” Attack Surface

Payment behaviour continues to shift. This week, several campaigns illustrate how **QR codes and invoice workflows** are being abused as part of credential theft and payment fraud.

The pattern:

- Victims receive **PDF invoices or statements** that look legitimate, often cloned from real suppliers.
- Instead of a “Pay Now” button, the document heavily emphasises a **QR code**:
  - “Scan to pay securely via your banking app.”
  - “Scan to verify this invoice with our finance portal.”
- The QR code leads to:
  - A highly convincing **fake payment portal**, often cloned from common bank templates.
  - Or a landing page that instructs the user to **approve a push notification** or “update MFA method”.

Behind the scenes:

- The page may capture credentials and redirect to the real bank site, minimising suspicion.
- Or it may initiate an **MFA fatigue** flow:
  - The attacker attempts logins elsewhere.
  - The user is primed by the fake site to accept MFA prompts, thinking they are part of the QR workflow.

QR codes are attractive to attackers because:

- They are treated as **trusted UX** — scanning them feels safer than clicking links.
- They hide the full URL from quick visual inspection.
- They blend seamlessly into real-world contexts (restaurant bills, postal letters, printed invoices).

For defenders and awareness programs:

- “Don’t click unknown links” must be extended to **“don’t blindly scan unknown QR codes”**.
- Finance teams and AP processes should have **clear, non-QR fallback paths** to verify payment details.
- Technical controls like **browser isolation**, URL rewriting, and banking portal allow-lists should treat QR-originated traffic the same as any other inbound click.

---

## Living Off SaaS and Serverless Infrastructure

The final major trend this week is the continued maturation of **living-off-the-cloud** tradecraft.

Instead of hosting payloads and redirectors on bulletproof VPS, actors are increasingly using:

- **SaaS platforms** – Notion, Google Docs/Drive, Dropbox, OneDrive, GitHub gists.
- **Serverless and edge compute** – Cloudflare Workers, Vercel, AWS Lambda, Azure Functions.

Typical uses include:

- Short-lived **redirectors**:
  - Initial phishing or QR links point to a serverless function.
  - The function evaluates basic parameters (user agent, geo, time).
  - It redirects to payloads, benign sites, or simply returns an error to frustrate sandboxes.

- Payload and config hosting:
  - Encrypted blobs stored in public or semi-public SaaS locations.
  - Malware retrieves and decrypts content via legitimate APIs.
  - Rotation is trivial — swap the blob, keep the link.

- Covert C2 relays:
  - Compromised hosts periodically poll a shared document or gist for new commands.
  - Responses are encoded as innocuous text, JSON, or comments.
  - Everything rides on top of **trusted domains** and well-known CDN routes.

The effect on defenders:

- Classic blocklists are less effective when traffic goes to `*.cloudfront.net`, `*.googleusercontent.com` or `*.notion.so`.
- TLS inspection and proxy rules become politically and technically harder, especially for popular productivity platforms.
- SOCs must start thinking in terms of **“who is talking to what, how often, and why”**, not just “is the domain on a list”.

Practical mitigations include:

- Stronger **conditional access** and device posture checks for SaaS access.
- **Per-app proxying** or private access gateways for critical services.
- Analytics that flag **abnormal API usage patterns**:
  - Workstations making `raw.githubusercontent.com` calls every minute.
  - Non-developer segments hammering Notion or Drive APIs in unusual ways.

---

## What This Means for Blue Teams This Week

Across all of these trends, a few priorities emerge.

**1. Assume partial compromise of visibility is possible**

- Build monitors not just for threat events but for **gaps in expected telemetry**.
- Periodically validate that key sensors (Sysmon, EDR, audit policies) are producing the volumes and event types you expect.
- For crown-jewel systems, consider scheduled or on-demand **memory snapshots** to cross-check what is actually running.

**2. Treat stealer incidents as tenant-level events**

- Standardise a workflow for:
  - Invalidating sessions and tokens.
  - Auditing inbox rules, OAuth apps, and delegated permissions.
  - Reviewing sign-in logs and conditional access policies.
- Coordinate between endpoint, identity, and cloud security teams – **stealers are a cross-domain problem** now.

**3. Update social engineering playbooks for QR and ClickFix patterns**

- Add real examples of:
  - QR invoice fraud and fake payment portals.
  - Emails instructing users to run commands or scripts “to fix security issues”.
- Give users simple rules:
  - Verify payment details via known channels, not QR codes in unsolicited invoices.
  - Never run command-line instructions from email or chat without IT validation.

**4. Build analytics for SaaS and serverless abuse**

- Prioritise visibility into:
  - Which endpoints talk to which SaaS APIs.
  - Anomalous frequencies and patterns of requests.
- Start small:
  - Dashboards for “top 10 endpoints calling serverless platforms”.
  - Hunt queries for workstations making repeated requests to raw content endpoints.

---

## Quick Wins and Longer-Term Moves

To close out the week, here are realistic next steps.

**Quick wins (this week)**

- Add a simple alert or dashboard for **Office/Teams → script engine → network** process chains.
- Enable or tighten **session revocation** and token invalidation procedures for high-risk accounts.
- Run a one-off hunt for:
  - Script hosts calling AI APIs or unusual SaaS endpoints.
  - Endpoints that suddenly stopped sending key event types from your EDR/Sysmon configuration.

**Longer-term moves**

- Invest in **memory forensics capability** – tools, storage, and training – so you can verify incident narratives when telemetry looks off.
- Work with identity and cloud teams to define **stealer response standards** for token theft and cloud ATO.
- Develop a cross-functional program for monitoring and governing **AI and SaaS usage**, closing the grey areas attackers currently enjoy.

The shape of the threats is changing, but the fundamentals remain the same:

- Understand how your systems normally talk, log, and behave.
- Notice when that rhythm is broken — whether by silence, noise, or unexpected new paths.
- Use deeper artefacts like memory to arbitrate disputes when the logs and the host disagree.

In a world where attackers can tamper with what you see, **trust but verify** is no longer just a phrase — it is a core defensive strategy.
