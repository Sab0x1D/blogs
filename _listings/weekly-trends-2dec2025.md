---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 22nd December 2025"
pretty_title: "Weekly Threat Trends — Week Commencing 22nd December 2025"
excerpt: "With staff on leave, change freezes in place, and everyone distracted by end-of-year deadlines, threat actors use December to push BEC, gift-card fraud, shipping scams, and high-impact ransomware. This week’s post focuses on holiday operating risk and how to keep control when the lights are dimmed."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2025-12-22
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **22–28 December 2025** falls squarely across the Christmas period for many organisations.  
It is exactly when people want to switch off — and exactly when attackers know **defenders are distracted,
change windows are tight, and coverage in the SOC is thin.**

This week’s trends revolve around **holiday operating risk**:

- Business email compromise (BEC) and payment fraud targeting finance teams working from home.
- Shipping, travel and gift-card scams that blur the line between “personal” and “corporate” risk.
- Ransomware and destructive wipers timed for **change freezes** and skeleton-crew on-call rotations.
- Fraud and account takeover in consumer-facing portals, riding on peak retail and refund activity.

In between all of that: **Merry Christmas** — this post is about keeping the network calm enough that you
can actually enjoy a day off without waking up to a ruined change freeze.

---

## Top Trends at a Glance

- **Holiday BEC and Invoice Fraud** – convincing “urgent payment” and “bonus adjustments” sent to thinly staffed finance and payroll teams.
- **Gift-Card and Voucher Abuse** – attackers pushing employees to buy codes, or draining corporate and customer reward balances.
- **Shipping, Delivery and Travel Scams** – phishing around parcels, boarding passes, and hotel portals that double as initial access.
- **Change-Freeze Ransomware and Wipers** – high-impact operations scheduled for low staffing and minimal appetite for risky response actions.
- **Retail and Customer-Portal Account Takeover** – credential stuffing and token reuse during peak login periods.
- **Operational Readiness Gaps** – escalation paths, approvals, and incident ownership becoming unclear once key people go on leave.

---

## End-of-Year BEC and Invoice Fraud

The biggest, most consistent theme this week is **payment fraud**. December is prime time:

- Finance teams rush to close books.
- Suppliers push invoices and last-minute renewals.
- Leadership is on the move, working sporadically from phones and airport lounges.

Threat actors exploit this by sending **well-timed, well-researched BEC lures**:

- Fake “updated banking details” emails from supposedly known suppliers, timed just before scheduled payments.
- “Urgent wire for acquisition / bonus / charity donation” messages claiming to be from executives.
- “We need to release year-end bonuses early, please approve attached payroll file” attachments that either:
  - Directly request a fraudulent batch upload.
  - Contain malware as a second play.

Common traits in this week’s examples:

- Attackers use **long-running recon periods**:
  - Monitoring compromised mailboxes for weeks to learn payment cycles.
  - Replying in existing threads with in-line responses, not brand new emails.
- The fraud requests are **small enough to slip under normal controls**:
  - 20–80k per transaction.
  - Within existing supplier relationships.
  - Leveraging “we need this done before everyone goes on leave” pressure.

Defensive measures to emphasise right now:

- Reinforce **out-of-band verification**:
  - Any banking detail change must be confirmed via a known phone number or portal, not email.
- Clearly communicate **“holiday fraud rules”** to finance:
  - It is acceptable — encouraged — to delay payment if verification is incomplete, even under “executive pressure”.
- Ensure your secure email gateway and mail rules:
  - Flag external senders clearly, even in reply chains.
  - Highlight lookalike domains and newly registered senders, particularly in supplier-themed mail.

From an incident perspective, remember that BEC is as much **fraud and governance** as it is “technical security”.  
Get finance, legal, and cyber aligned before things heat up.

---

## Gift-Card, Voucher and “Secret Santa” Abuse

The second big holiday theme is **gift-card and voucher fraud**, which continues to leak from the “consumer” side into corporate environments.

Patterns this week include:

- Classic “CEO/manager asks you to buy gift cards” scams re-skinned around:
  - “Secret Santa for the team.”
  - “We want to surprise staff/clients before the shutdown.”
- Attacks targeting **corporate reward portals**:
  - Points and vouchers accrued via travel, fuel, or partner programs.
  - Redemption accounts protected by weak or reused credentials.
- Criminals combining **BEC and gift-card fraud**:
  - Gain access to a manager’s mailbox.
  - Send realistic internal messages instructing staff to:
    - Purchase vouchers.
    - Share codes or photos.
    - “Keep this quiet, it’s a surprise.”

Where it touches corporate risk:

- Money is lost directly if staff use corporate cards to buy gift codes and send them to attackers.
- Compromised reward accounts may reveal:
  - Travel patterns.
  - Hotel preferences.
  - Relationship data with key suppliers or clients.

To manage this risk:

- Communicate a clear policy: **no executive or manager will ever ask staff to buy gift-cards via email or chat**.
- Encourage scepticism around:
  - “Surprise” initiatives requested out-of-hours.
  - Messages asking for secrecy from accounts that rarely interact with staff.
- Ensure reward portals and travel accounts:
  - Use strong, unique passwords and MFA.
  - Are reviewed for unusual redemption activity, particularly during the holiday period.

A short, well-timed awareness note to staff this week can neutralise a large chunk of this threat surface.

---

## Shipping, Delivery and Travel-Themed Phishing

With parcels and travel bookings peaking, **delivery and itinerary scams** are everywhere, targeting both personal and corporate identities.

Observed lures include:

- Fake SMS and emails from couriers:
  - “We attempted delivery; pay customs/duty to release your parcel.”
  - “Your package is delayed, click here to reschedule.”
- Airline and travel portal impersonation:
  - “Check in now to confirm your seat.”
  - “Your booking is at risk; update card details.”

Why this matters for organisations:

- Staff often use **corporate email and devices** for travel confirmations and delivery notifications.
- Clicking on a personal-looking link from a corporate device can:
  - Drive them to credential harvesting pages.
  - Drop malware or steer them into a ClickFix-style script chain.
- Some campaigns specifically target:
  - Staff responsible for **shipping, logistics, or reception**.
  - Employees in companies that heavily rely on physical deliveries.

Best practices to reinforce:

- On managed devices:
  - Prefer going to courier/airline sites directly instead of tapping links in messages.
  - Treat any page asking for card details or login as suspicious if it comes from an unsolicited message.
- For corporate shipping workflows:
  - Ensure **official notification addresses and portals** are documented and shared.
  - Anything outside those channels should be verified before staff pay fees or update details.

A small twist on this theme is **QR-based delivery confirmation** in physical notes:

- Cards left on desks or in mail rooms with QR codes leading to fake “reschedule delivery” portals.
- QR codes circumventing some URL-filtering controls.

Treat QR codes as links you cannot see — with the same scepticism.

---

## Ransomware and Wipers in Change-Freezes

Operationally, late December often includes:

- Change freezes on production systems.
- Reduced maintenance windows.
- Skeleton incident response and IT staff.

Attackers know this. Ransomware crews and destructive actors are increasingly timing:

- **Initial ingress and staging** in the early weeks of December.
- **Detonation** during:
  - Night of 24th/25th.
  - New Year’s Eve.
  - Weekends overlapping public holidays.

This week’s cases show:

- Ransomware deployed via existing access (*RDP, RMM, domain admin*) rather than zero-day exploitation.
- Heavy use of:
  - Backup enumeration and suppression.
  - Hypervisor and storage-targeted encryption.
- Some operations skipping classic file-encryption and instead deploying **wipers**:
  - Destroying boot records.
  - Corrupting hypervisor storage.
  - Aiming to maximise downtime during a period where **escalation and approval paths are slow**.

Key defensive moves **before** the holidays fully hit:

- Validate **offline and immutable backups**:
  - Confirm restore procedures for critical systems.
  - Test at least one recent restore end-to-end, including authentication and access workflows.
- Clarify **authority during a change freeze**:
  - Who can authorise:
    - Emergency firewall changes.
    - Network segmentation or shutdowns.
    - Rapid backup restores and DR failover.
- Ensure on-call playbooks explicitly handle:
  - Overnight ransomware events.
  - Complete site or hypervisor outages.
  - Situations where key leaders are unreachable for hours.

The aim is simple: make sure your on-call team knows **they are allowed to act**, even when the environment is technically in change freeze.

---

## Retail, Customer-Portals and Account Takeover

For any organisation with customer portals, retail sites, or loyalty programs, this week is a **pressure test**.

Threat actors are running:

- Large-scale **credential stuffing** campaigns:
  - Using breach combos targeting email+password pairs.
  - Exploiting customers’ tendency to reuse credentials.
- Token replay and refresh attacks:
  - Reusing stolen session tokens from stealers and infostealers.
  - Hitting login endpoints with valid sessions to:
    - View and edit personal data.
    - Place orders.
    - Drain balances and vouchers.

These attacks are often mixed with legitimate peak traffic, making detection harder:

- Spikes in login events look normal.
- Password-reset and helpdesk volumes increase for both real and fraud-driven reasons.

For defenders, priority controls include:

- Strong, enforced **MFA for high-risk actions**:
  - Changing addresses.
  - Altering saved payment methods.
  - Transferring loyalty points.
- **Risk-based access** mechanisms that:
  - Step up authentication for suspicious IPs, devices or geos.
  - Flag impossible travel or unusual device combinations.
- Monitoring for:
  - Multiple accounts accessed from the same IP or device fingerprint within short windows.
  - Sudden changes in shipping address, particularly to high-risk regions.
  - Unusual patterns in returns, refunds and voucher redemptions.

Fraud and cyber teams need to work closely together — many of these events show up first as **chargebacks and customer complaints**, not SIEM alerts.

---

## Operational Readiness in a Half-Empty Office

Across all these technical trends sits a simple reality: **people are on leave**.

Miscommunications and gaps this week typically look like:

- Incidents languishing because:
  - Ownership is unclear.
  - Ticket queues are watched by junior staff without decision authority.
- On-call staff unsure:
  - Which executives or business owners to wake up.
  - How far they are allowed to go in making impactful changes.
- Delays in fraud responses because:
  - Banking and finance contacts have limited availability.
  - Internal sign-off chains are longer at the exact time attackers want to move fast.

Practical steps to plug these gaps:

- Publish a **holiday escalation chart**:
  - Primary and secondary contacts for:
    - Security incidents.
    - Payment and BEC concerns.
    - Communications and legal decisions.
- Make sure **role-based backups** exist:
  - At least one alternate per critical function (SOC lead, IAM admin, backup admin, finance approvals).
- Give on-call teams **pre-authorised actions**:
  - Up to a clearly defined threshold, they can:
    - Block or disable accounts.
    - Isolate hosts or subnets.
    - Put holds on payments flagged as fraudulent.
  - Beyond that threshold, they know which person to contact next.

The goal is to avoid incidents sliding for 8–12 hours simply because nobody is comfortable making a call.

---

## Actions for the Week of 22–28 December

To make this week survivable, consider the following concrete actions.

**For Finance and Payroll**

- Push a short, clear reminder:
  - Verify all changes to banking details out-of-band via known contacts.
  - Treat any “urgent, confidential payment” request as suspicious, especially if it bypasses normal workflow.
- Implement temporary rules:
  - Two-person approval for new beneficiary or banking changes.
  - Holds on large, unusual transfers until callbacks are completed.

**For Staff in General**

- Send a simple, non-technical awareness note:
  - We are seeing gift-card, parcel, and travel-themed scams.
  - No manager will ever ask you to buy gift cards via email or chat.
  - Do not run command-line instructions sent to you over email or Teams, even if they claim to “fix” security issues.
- Remind staff that **corporate devices are still corporate** even when used for personal orders and travel.

**For Security and IT**

- Validate holiday on-call and escalation:
  - Names, numbers, backups, and authority are all current.
- Run a **quick ransomware readiness check**:
  - Confirm locations and health of backups for key systems.
  - Ensure at least one person on call knows how to initiate restores and DR.
- Tighten detection for:
  - RDP, VPN, and RMM activity outside normal hours.
  - Large outbound data transfers from unexpected systems.
  - New inbox rules and forwarding configured just before close of business.

---

## Closing Thoughts (and a Merry Christmas)

This week is always a strange mix of **quiet corridors and frantic inboxes**. Attackers know that:

- People are tired.
- Processes are relaxed.
- Teams are partially staffed.

That is why holiday periods are no longer quiet times in threat intel — they are some of the **most opportunistic windows of the year**.

The counter is not paranoia; it is **deliberate, pre-planned operating discipline**:

- Clear fraud and BEC rules for finance.
- Simple awareness for staff on gift-card, parcel, and travel scams.
- Strong on-call and escalation arrangements for security and IT.
- Tested backups and runbooks ready for ransomware or wiper events.

If you can get those basics in place, you dramatically reduce the chance of spending Christmas Eve rebuilding a hypervisor or arguing with a bank about fraudulent transfers.

So, genuinely: **Merry Christmas and happy holidays**.  
The aim of all this is to keep your December as uneventful as possible — so the only fire you deal with is the one under the BBQ, not in your production network.
