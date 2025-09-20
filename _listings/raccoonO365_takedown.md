---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg

layout: listing
title: "RaccoonO365: Inside the Global Phishing-as-a-Service Takedown"
pretty_title: "RaccoonO365: <br>Inside the Global Phishing-as-a-Service Takedown"
excerpt: "Microsoft and Cloudflare dismantled RaccoonO365, a $355/month phishing-as-a-service empire that stole 5,000+ Microsoft 365 credentials across 94 countries. This deep dive explains how the service operated, the scale of its impact, and what the takedown means for defenders."
thumb: /assets/img/raccoon_thumb.webp
date: 2025-09-20
featured: false
tags: [Phish, Malware]
---

The September 2025 takedown of **RaccoonO365** represents a clear inflection point in how phishing is organized and sold. Where once phishing meant a single opportunistic email, today it can mean a full commercial product: polished templates, infrastructure, rotation tools, and customer support — all rented out to criminals on a monthly subscription.

Phishing has always been about exploiting trust, but the difference now is scale. With platforms like RaccoonO365, attackers don’t need technical skill. They need only a stolen credit card and a willingness to pay the monthly fee. Everything else — from domain registration to credential management dashboards — is taken care of.

---

## Why This Takedown Matters

RaccoonO365 shows what happens when **criminal services borrow the playbook of Silicon Valley startups**. Instead of investing time in coding or hosting, attackers could pay a fee and launch professional phishing campaigns in minutes.

Key reasons this case matters:  

- Subscribers paid **$355/month** for access, making phishing a predictable recurring revenue stream for its operators.  
- The kit impersonated **Microsoft 365 login portals** with near pixel-perfect accuracy.  
- Backend dashboards helped attackers **filter and resell credentials**, treating stolen data as inventory.  
- Support channels were available — turning cybercrime into a service industry with "customer success."  

This model wasn’t built by amateurs. It was structured, reliable, and resilient. That makes it more dangerous than one-off scams.

---

## What Was RaccoonO365?

RaccoonO365 was sold openly in underground forums and through Telegram channels. The marketing copy promised high success rates, constant updates, and responsive support. Screenshots shared by affiliates showed professional dashboards, while testimonials advertised “ROI” — language lifted directly from SaaS culture.

For subscribers it provided:

- **Replica login pages** that mimicked Microsoft’s sign-in flow exactly.  
- **Credential capture hooks** to steal usernames, passwords, and in some cases session tokens.  
- **Filtering and export tools** in the administrator panel to prioritize high-value accounts.  
- **Domain rotation & hosting services** so fresh URLs were always ready to use.  

Think of it as a phishing “franchise in a box.” No technical experience required.

---

## Scale and Impact

The scale of RaccoonO365 was not just theoretical. When investigators pulled apart its infrastructure, they found:  

- **338 fake domains** tied to its phishing pages.  
- Victims in **94 countries** across nearly every region.  
- Over **5,000 Microsoft 365 credentials** stolen and catalogued.  

For context: a single compromised Microsoft 365 account can give attackers:  
- Access to sensitive **emails** that contain invoices, contracts, or financial details.  
- Entry into **OneDrive files** and **SharePoint sites**, exposing intellectual property.  
- The ability to impersonate executives in **Teams chats**, fueling BEC scams.  

RaccoonO365 wasn’t just about credentials. It was about opening doors into entire organizations.

---

## How the Kit Worked (Technical Overview)

The kit’s workflow followed a clear, repeatable pattern:  

1. **Delivery** — phishing links arrived via email blasts, SMS smishing, or malicious ads.  
2. **Landing** — victims were redirected to **Microsoft lookalike portals**.  
3. **Capture** — usernames, passwords, and tokens were instantly POSTed to attacker servers.  
4. **Processing** — stolen data appeared in the attacker’s dashboard, ready to be filtered and sold.  

Some operators attempted MFA bypasses:  
- **Session token theft** via reverse proxying.  
- **Push-bombing victims** until they accepted login requests.  

With these techniques, attackers could sidestep one of the few protections organizations still relied on.

---

## The Takedown

In September 2025, Microsoft, Cloudflare, and global law enforcement coordinated to dismantle RaccoonO365. The takedown involved:  

- **Seizing hundreds of domains** and redirecting them to takedown notices.  
- **Cutting off hosting providers** supporting the kit.  
- **Publishing IOCs** (domains, IPs, hashes) to alert defenders worldwide.  

The result: a significant disruption of active phishing campaigns and a direct hit to the operators’ revenue streams.

But experts agree — takedowns are temporary. Criminals can rebuild, rebrand, and return. What makes this important is the message: the defenders are adapting too, and collaboration across vendors and infrastructure providers works.

---

## The Bigger Picture: Cybercrime Mimics SaaS

RaccoonO365 is not unique. It’s part of a broader wave where underground operators mirror legitimate SaaS companies:  

- **Ransomware-as-a-Service (RaaS)**: turnkey ransomware for affiliates.  
- **Initial Access Brokers (IABs)**: subscription-based access to corporate networks.  
- **Phishing-as-a-Service (PhaaS)**: mass credential theft for a flat monthly rate.  

These services come with documentation, updates, uptime guarantees, and even **support tickets**. For criminals, the model is low risk and high reward. For defenders, it means we’re fighting not individuals but **entire business ecosystems**.

---

## Defensive Guidance (Operational Checklist)

Security teams can take concrete steps to defend against platforms like RaccoonO365:  

- **Zero Trust Access:** Never assume credentials alone equal trust. Require continuous verification.  
- **MFA Everywhere:** Push for hardware tokens or FIDO2 keys to defeat proxy-based MFA bypasses.  
- **Domain Monitoring:** Watch for typosquats and lookalike domains that mimic your brand.  
- **Threat Intel Feeds:** Integrate known phishing kit indicators into SIEM/SOAR pipelines.  
- **Awareness Campaigns:** Train employees with real-world phishing simulations modeled on current kits.  
- **Incident Playbooks:** Build workflows for rapid credential resets, IOC ingestion, and cross-team response.  

---

## Historical Context: The Evolution of Phishing Kits

RaccoonO365 continues a story that stretches back more than a decade. Each generation has grown more professional:  

- **BulletProofLink (2021):** Offered thousands of phishing templates on subscription.  
- **EvilProxy (2023):** Used reverse proxies to capture tokens and bypass MFA.  
- **RaccoonO365 (2025):** Scaled globally with domain rotation and dashboards.  

The trajectory is clear: every takedown leads to reinvention. What changes is the level of polish and professionalism.

---

## Key Takeaways

- **Phishing has gone pro:** Subscription-based services scale faster than ad hoc scams.  
- **Scale magnifies harm:** Hundreds of domains and thousands of victims multiply organizational risk.  
- **Takedowns matter but aren’t final:** Disruption buys time but doesn’t end the business model.  
- **Defense requires adaptation:** Blend Zero Trust architectures, MFA, and proactive monitoring with rapid incident response.  

---

## Final Word

RaccoonO365’s takedown is a tactical win, but it’s also a reminder of the new reality. Criminal groups aren’t hacking for fun. They’re building businesses — ones with pricing models, roadmaps, and customers. And just like real SaaS, as long as there’s demand, supply will keep coming back.

<blockquote class="featured-quote">
Phishing-as-a-Service isn’t a passing fad. It’s a permanent feature of the cybercrime economy. Takedowns like RaccoonO365 prove that collaboration works — but lasting defense requires treating criminal services as industries, not incidents.
</blockquote>
