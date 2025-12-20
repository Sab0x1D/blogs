---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Weekly Threat Trends — Week Commencing 15th December 2025"
pretty_title: "Weekly Threat Trends — Week Commencing 15th December 2025"
excerpt: "This week is all about trust abuse: poisoned package ecosystems, SSO and IdP missteps, remote management tooling turned into backdoors, and data extortion operations that never bother with encryption."
thumb: /assets/img/weekly_trends_thumb.jpg
date: 2025-12-21
featured: false
tags: [Weekly Trends, Weekly Threats, Awareness]
---

The week of **15–21 December 2025** is dominated by one idea:  
attackers would rather **ride your trusted systems** than fight them.

From poisoned packages in public registries and misused SSO flows, to remote management tools behaving
like pre-installed RATs, the most effective intrusion paths this week are all about **abusing what’s
already allowed**. On the response side, blue teams are pushing further into **provenance and attestation**
— trying to answer not just *what ran*, but *where it came from and who actually authorised it*.

---

## Top Trends at a Glance

- **Poisoned Package Ecosystems** – npm, PyPI and container registries abused for initial access and lateral movement via “helpful” libraries and internal tooling.
- **SSO and IdP Abuse** – attackers leaning on OAuth/OIDC misconfigurations, weak conditional access, and MFA fatigue to walk straight through the front door.
- **Remote Management Tools as Resident Backdoors** – RMM and helpdesk agents repurposed as long-term C2 with almost no new binaries deployed.
- **Data Extortion Without Encryption** – crews skipping the noisy ransomware step and going straight to slow, quiet exfiltration plus leverage.
- **macOS and Linux in the Crosshairs** – mixed-fleet organisations discovering their non-Windows estate is no longer “below the noise floor.”
- **Provenance and Attestation in DFIR** – growing focus on code origin, signing, SBOMs, and signed telemetry as a way to re-establish trust after an intrusion.

---

## Theme Overview — Trust as the Real Attack Surface

Most of the interesting cases this week start with the same pattern:

- No exploit kit.
- No obvious phishing attachment.
- No obviously malicious EXE on disk.

Instead, attackers are:

- Publishing **apparently useful libraries** to public registries.
- Abusing **SSO trust relationships** between tenants and apps.
- Living inside **remote management and helpdesk tooling** that defenders already rely on.
- Quietly siphoning data, then using that access for **extortion instead of encryption**.

It is less about “breaking in” and more about **persuading the environment to invite them in**.

For defenders, this pushes the conversation from:

> “Is this file malicious?”

to:

> “Should this thing ever have been allowed to run or connect in the first place, and who vouched for it?”

---

## Poisoned Packages and the Developer Supply Chain

Public package ecosystems have been noisy for years, but this week’s activity shows a worrying level
of **operator discipline** around supply-chain driven intrusions.

The pattern looks like this:

- Threat actors identify:
  - Popular internal package names leaked via GitHub, CI logs, or error messages.
  - Common typos of legitimate libraries.
  - Generic, attractive names like `logging-helper`, `sso-utils`, `cloud-backup-agent`.
- They publish packages that:
  - Provide **real functionality** (wrappers, helpers, integrations) so they aren’t immediately suspicious.
  - Include a small **“post-install” or “first-run” hook** that:
    - Collects environment info.
    - Exfiltrates credentials (cloud keys, tokens, metadata).
    - Drops or pulls a second-stage payload if certain conditions are met.

In some of this week’s cases:

- Initial access into production environments came from **CI/CD pipelines** installing poisoned dependencies.
- The malicious logic only activated when:
  - Running inside cloud build agents or Kubernetes nodes.
  - Certain environment variables were present (e.g., `AWS_ACCESS_KEY_ID`, `AZURE_TENANT_ID`, or internal domain strings).
- For developer workstations, the payload was limited to **stealing Git credentials and SSH keys**, presumably for later lateral movement.

Why this works:

- Dependency sprawl means **hundreds of packages** per project; one more entry rarely stands out.
- Many organisations still allow **direct access to public registries** from build systems.
- SBOMs, where they exist, are often generated but not **actively reviewed or enforced**.

Practical considerations for defenders:

- Treat build environments and CI/CD like **crown-jewel assets**, not glorified VMs.
- Introduce **allow-listed or proxied package registries**:
  - Internal mirrors that sync only vetted packages.
  - Policy that production workloads can only pull from those mirrors.
- Use SBOMs as more than compliance paperwork:
  - Compare SBOMs between builds to spot **sudden new dependencies**.
  - Alert on packages that appear out of nowhere in critical services.
- For incident response, extend triage to include:
  - Which packages were added or updated in the weeks before compromise.
  - Whether any of them had suspicious install hooks or network calls.

---

## SSO and Identity Provider Abuse

The second big trend this week is **identity as the easiest way in**.

Attackers are investing less effort in bypassing EDR on endpoints and more in exploiting:

- Weak or misconfigured **OAuth/OIDC flows**.
- Overly broad **app consent and delegated permissions**.
- **MFA fatigue** and inconsistent conditional access.

In several organisations, intrusions followed a familiar script:

1. Initial foothold via stealer, phishing, or exposed credential.
2. Use of that account to:
   - Approve a malicious app in the corporate tenant.
   - Grant long-lived delegated permissions to read mail, files, or manage settings.
3. Pivoting entirely into cloud:
   - Pulling mailboxes and document libraries.
   - Managing forwarding rules and shared mailboxes.
   - Accessing ticketing or HR systems via SSO without ever touching a VPN.

In more advanced cases, actors abused:

- Relationships between **multiple tenants** (e.g., suppliers and customers) connected via B2B or app registrations.
- Legacy or misconfigured **redirect URIs** and **implicit grant flows** left behind by old integrations.

For blue teams, this trend stresses:

- You cannot treat SSO as “safer login” by default; it introduces **new trust relationships** that must be understood and monitored.
- Detection content needs to cover:
  - New app registrations and service principals, especially those requesting high-privilege scopes.
  - Rare consent operations by end users and administrators.
  - Sign-ins from newly created or rarely used apps that suddenly access a lot of data.

Mitigations to prioritise:

- Enforce **admin consent workflows** for risky permissions; avoid end-users approving powerful apps.
- Review and harden **conditional access policies**:
  - Block or challenge logins from high-risk devices and locations, even if credentials and MFA succeed.
- Regularly audit:
  - App registrations, service principals, and their permissions.
  - Cross-tenant trust relationships and B2B links.

SSO is one of the best usability and security upgrades available — but only when **identity, app, and cloud security are on the same page**.

---

## Remote Management Tools as Long-Lived Backdoors

The third notable theme is the ongoing abuse of **remote management and helpdesk tools**.

This week’s incidents reinforced how dangerous it is to:

- Roll out RMM agents broadly.
- Grant them high privileges.
- Assume “because they’re ours, they’re safe.”

In several cases:

- Attackers:
  - Gained access to a helpdesk account or deployment console.
  - Used it to push scripts and remote sessions to dozens or hundreds of endpoints.
- No new malware binaries were deployed in the initial stage — only:
  - Legitimate RMM features for command execution, file transfer, and screen control.
  - Simple scripts to disable endpoint protections or stage later payloads.

From a SOC perspective, this is incredibly noisy to triage:

- It looks like standard helpdesk activity.
- The originating IPs and tools are “trusted”.
- The same tools are used by multiple teams (IT, OT, third-party vendors).

To manage this risk:

- Treat RMM consoles like **tier-0 assets**:
  - Strong MFA.
  - Privileged access management.
  - Tight audit logging and alerting on unusual usage (out-of-hours, unusual operators, new device groups).
- Consider **segmented RMM**:
  - Different tools or tenants for internal IT vs third-party support vs OT environments.
- Build detection content specifically for:
  - RMM-driven script execution outside normal windows or playbooks.
  - Mass deployment actions initiated by non-standard operators.
  - New agents being installed on servers or segments where they were never intended to exist.

If attackers can own your RMM, they’ve effectively been promoted to your **remote IT team**. Controls need to match that level of risk.

---

## Data Extortion Without Encryption

The fourth trend this week is a continuing move away from **loud ransomware** towards **quiet, pure extortion**.

In multiple cases:

- There was **no disk encryption**.
- No classic ransomware note on endpoints.
- Instead, victims received:
  - Emails or chat messages referencing specific datasets, internal projects, or legal matters.
  - Proof-of-exfil snippets (screenshots, partial dumps).
  - Demands for payment under threat of public release, competitor leaks, or regulatory reporting.

Technically, the operations looked like:

- Initial access via familiar means (phishing, VPN abuse, SSO missteps).
- Hours to days of **discovery and data staging**:
  - Indexing shared drives and document libraries.
  - Dumping targeted databases.
  - Compressing and encrypting staging archives.
- **Slow, low-and-slow exfiltration**:
  - Via cloud storage to cloud storage transfers.
  - Over HTTP(S) to servers masquerading as backup endpoints.
  - Using existing third-party integrations and connectors.

This approach has several advantages for attackers:

- Far less noisy than encrypting an entire environment.
- Harder for defenders to label as “traditional ransomware” in metrics and reports.
- Leverages the fact that **data exposure** can be just as damaging as downtime, especially in regulated industries.

For defenders:

- Incident classification must catch up — not all extortion is “ransomware”.
- Exfil detection becomes a core capability:
  - Volume-based rules (sudden spikes of egress from unusual systems).
  - Content-aware policies where possible (DLP, regex, data classification tags).
  - Analysis of **new data paths** (e.g., suddenly using a new SaaS connector to move data between tenants).

Runbooks also need an explicit branch for **“extortion with no encryption”**:

- Legal and comms workflows for potential data exposure.
- Agreements on when and how to notify regulators and affected customers.
- Forensic processes for demonstrating exactly *what* was accessed, not just what could have been.

---

## macOS and Linux in the Crosshairs

While Windows still dominates enterprise incidents, this week showed a notable bump in **macOS and Linux desktop targeting**, particularly in:

- Dev-heavy organisations.
- Creative and media teams.
- Engineering groups with local tooling stacks.

Observed trends:

- Stealers and RATs with **cross-platform payloads**:
  - Python- or Go-based cores.
  - Platform-specific install scripts and persistence methods.
- macOS-specific chains that:
  - Abuse notarised but malicious apps.
  - Lean on “productivity utilities” distributed outside the App Store.
  - Target browser data and keychains for later reuse on cloud services.
- Linux malware focusing less on servers and more on:
  - Developer workstations.
  - Admin jump boxes used to manage containers and Kubernetes.

For many organisations, visibility on these platforms is still **years behind** what they have for Windows:

- No equivalent of Sysmon on macOS.
- Patchy EDR coverage for Linux desktops.
- Inconsistent logging and centralisation.

Defensive moves to prioritise:

- Close the tooling gap:
  - Ensure EDR/AV coverage for macOS and Linux endpoints, not just servers.
  - Standardise logs (process, auth, sudo, package managers) into your SIEM.
- Update incident runbooks so **non-Windows hosts are part of first-wave triage**, not an afterthought.
- Apply the same identity, SSO, and stealer response disciplines across platforms — the cloud doesn’t care which OS the browser ran on.

---

## Provenance, Attestation and “Who Signed Off on This?”

With trust being abused everywhere, DFIR teams are increasingly leaning on **provenance** to regain footing:

- Where did this binary, script, or package come from?
- Who built it, and on which pipeline?
- Was it signed, and if so, by what key?
- Do our logs and telemetry carry any cryptographic guarantees, or can they be forged or tampered with?

This week, several responders started integrating:

- **Build attestation**:
  - Evidence that a given container or binary was produced by a known CI pipeline.
  - Comparison between declared SBOM and actual runtime behaviour.
- **Signed logs and telemetry**:
  - Ensuring that endpoint logs are tamper-evident once they reach central storage.
  - Verifying gaps and anomalies against independent sources (network captures, memory images).
- **Provenance-aware triage**:
  - Giving priority to incidents involving unsigned or unknown-origin code.
  - Whitelisting only artifacts with traceable build histories for production.

It’s still early days, and many of these mechanisms are complex to roll out. But the direction is clear: as attackers exploit every “trusted” path they can find, defenders need **cryptographic proof of origin and integrity**, not just hopeful configuration.

---

## What This Means for Blue Teams This Week

Across all these trends, a few themes repeat:

- **Trust is not a binary yes/no** — it’s a chain that can be weakened at many points:
  - Package registries.
  - Build systems.
  - Identity providers and app consents.
  - Remote management infrastructure.
- **Visibility must be cross-domain**:
  - Endpoint, identity, cloud, CI/CD, and SaaS logs need to be correlated, not siloed.
- **Incident scope is broader than a single host**:
  - In a stealer or supply-chain scenario, you’re often dealing with **entire tenant or pipeline exposure**, not a single machine.

Practically, blue teams can focus on:

- Hardening and monitoring **developer and build environments** as first-class critical assets.
- Tightening **SSO and app consent governance** so that attackers can’t simply create their own backdoor apps.
- Treating **RMM tools and consoles** with the same sensitivity as domain controllers.
- Building at least basic capability around:
  - Exfil detection.
  - SBOM comparison and anomaly detection.
  - Provenance checks for critical artifacts.

---

## Quick Wins and Next Steps

Some realistic, near-term actions based on this week’s activity:

- **Inventory your package usage**  
  - For one or two critical applications, generate SBOMs and actually review the dependency list.
  - Flag packages with:
    - Very recent creation dates.
    - Low download counts combined with high privilege in your environment.

- **Audit SSO app consents and service principals**  
  - Identify apps with:
    - Broad read/write scopes over mail, files, or directory data.
    - Owners that have left the organisation or generic “service” accounts.
  - Introduce an approval workflow for any new app requesting high-privilege scopes.

- **Review RMM and helpdesk access**  
  - Confirm:
    - Who has access to console logins.
    - Whether those logins are behind strong MFA and privileged access management.
  - Create alerts for:
    - Mass actions outside maintenance windows.
    - New device groups being created or onboarded unexpectedly.

- **Plan one provenance experiment**  
  - Pick a small service and:
    - Ensure its builds are attested and signed.
    - Set a policy that only images with valid attestation can be deployed.
  - Use the lessons learned to plan wider rollout.

Longer term, the direction of travel is clear:

- Strong identity and SSO hygiene.
- Mature software supply-chain controls.
- Cross-platform endpoint visibility.
- And, increasingly, **attested evidence** for both code and telemetry.

Attackers will keep trying to stand on the shoulders of whatever your environment already trusts.  
Your job is to make that trust **earned, monitored, and revocable** — not assumed.
