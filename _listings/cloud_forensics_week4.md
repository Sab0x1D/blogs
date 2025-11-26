---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Cloud Forensics — Investigating Incidents in AWS, Azure & GCP"
pretty_title: "Cloud Forensics — Investigating Incidents in AWS, Azure & GCP"
excerpt: "Cloud breaches look chaotic at first: APIs everywhere, short‑lived resources, and logs scattered across regions and services. This post walks through how to think about cloud forensics, what to collect, and how to reconstruct an incident across AWS, Azure, and GCP."
thumb: /assets/img/cloud_forensics_thumb.avif
date: 2025-11-27
featured: false
tags: [DFIR, Forensics, Cloud, AWS, Azure, GCP]
---

Cloud forensics is still forensics — you are answering the same questions:

- **What happened?**
- **How did they get in?**
- **What did they touch?**
- **What else is at risk?**

The difference is the **terrain**. Instead of one Windows host or one on‑prem network, you are dealing with:

- Short‑lived instances and containers that may no longer exist.
- Separate **control planes** (management APIs) and **data planes** (VMs, storage, serverless).
- Identity and access being enforced via complex **IAM policies, roles, conditional access, and tokens**.
- Logs that live in different services, regions, and retention buckets.

This post gives you a practical, vendor‑agnostic way to approach **cloud forensics in AWS, Azure, and GCP**. We’ll cover mindset, logging foundations, common attack paths, detailed walkthroughs of two realistic incidents, and a checklist you can adapt into your own playbooks.

---

## 1. Why Cloud Forensics Feels “Different”

If you already do endpoint or network forensics, cloud will feel:

- **Familiar** – you still care about IPs, users, timestamps, and artefacts.
- **Frustrating** – you often can’t “image the box”, and critical evidence lives in somebody else’s control plane.
- **Fast‑moving** – resources are created and destroyed in minutes, and logs rotate quickly if you haven’t planned ahead.

Three realities shape every cloud investigation:

1. **Shared responsibility**  
   The provider runs the underlying infrastructure; you are responsible for **identity, configuration, workloads, and data**. If CloudTrail, Azure Activity Logs, or GCP Audit Logs are not configured and retained, no one will magically produce them for you later.

2. **Everything is an API call**  
   Spinning up a VM, deleting a disk, reading an S3 bucket, disabling MFA — it all happens via authenticated API calls. Those calls are your primary evidence trail.

3. **Identity is the new perimeter**  
   In cloud incidents, the most valuable artefact is often not a disk image but a **compromised identity**: an access key, OAuth token, service principal, or workload identity that now does things it shouldn’t.

Once you accept that **“forensics = log + identity + configuration”** in the cloud, the investigation process becomes much more repeatable.

---

## 2. Think in “Planes”: Control, Data, and Identity

A useful mental model is to split cloud into three overlapping planes.

### 2.1 Control plane

The control plane is the management API surface:

- AWS: IAM, CloudTrail, the AWS Management Console, the APIs that create/modify resources.
- Azure: Azure Resource Manager (ARM), Azure AD / Entra ID, Subscription and Resource Group operations.
- GCP: Cloud Resource Manager, IAM, project‑level APIs.

**Forensics goal:** reconstruct **who did what, where, and when** at the management layer:

- Who created a new VM?
- Who attached a public IP?
- Who changed a security group or firewall rule?
- Who generated a new access key or consented an OAuth app?

This usually means **audit logs + identity logs + configuration snapshots**.

### 2.2 Data / workload plane

This is where the workloads and data live:

- VMs, containers, serverless functions.
- Storage buckets (S3, Blob Storage, GCS).
- Databases, queues, and app services.

Here, you fall back on more traditional artefacts:

- OS logs from cloud VMs (Windows Event Logs, syslog, application logs).
- Web server logs, DB logs, API gateway logs.
- Storage access logs that show reads, writes, and permission changes.

### 2.3 Identity plane

Cutting across everything is **identity**:

- Human users logging into portals or consoles.
- Service principals, managed identities, workload identities.
- Short‑lived tokens (STS, OAuth, OpenID Connect) exchanged between services.

Compromise of identity is usually the start of your story. Your job in the identity plane is to:

- Track **authentication events** (logins, MFA prompts, failures, unusual locations).
- Trace how a **token or access key** was used across the environment.
- Separate **legitimate automation** (CI/CD, backup jobs) from attacker abuse.

Cloud forensics is really **correlating these three planes over time**.

---

## 3. Logging Foundations by Provider

If you’re doing cloud forensics without logging in place, you’re already on the back foot. Below is a quick mapping of what you should have before an incident happens.

### 3.1 AWS

**Must‑have sources:**

- **CloudTrail** – records almost all API calls at the account level.  
  - Turn on **organization‑wide trails**.  
  - Send to a dedicated logging account and S3 bucket.  
  - Enable data events for S3 and Lambda on high‑value workloads.

- **CloudTrail Lake or Athena** – something that lets you query CloudTrail at speed.

- **VPC Flow Logs** – network‑level source/destination IP, port, and accept/deny decisions.

- **CloudWatch Logs** – for OS logs (via the CloudWatch agent), app logs, and security appliances.

- **S3 access logs / CloudTrail data events** – to see who read or modified objects in sensitive buckets.

### 3.2 Azure

**Must‑have sources:**

- **Azure Activity Logs** – control plane operations at subscription level (creating resources, changing configs).

- **Azure AD / Entra ID sign‑in and audit logs** – logons, token grants, conditional access decisions, and directory changes.

- **Resource logs** for key services:  
  - Key Vault access logs.  
  - Storage Analytics / diagnostic logs.  
  - App Service HTTP logs.  
  - Network Security Group (NSG) flow logs.

- **Microsoft Sentinel / Log Analytics** – centralised workspace to ingest and query logs.

### 3.3 GCP

**Must‑have sources:**

- **Cloud Audit Logs** – Admin Activity (always on), Data Access (must be enabled), System Events.

- **VPC Flow Logs** – network traffic visibility for subnets.

- **Cloud Logging** – VM logs (via Ops Agent), Kubernetes logs, App Engine / Cloud Run logs.

- **Storage access logs** – bucket read/write events for sensitive data.

Across all three, you should:

- **Standardise retention** (e.g., 180–365 days for core audit logs).  
- **Centralise** logs into dedicated “log projects / accounts / subscriptions”.  
- Ensure least‑privilege on logging buckets so attackers **can’t easily wipe evidence**.

---

## 4. Common Cloud Attack Paths (and Where Evidence Lives)

Most cloud incidents you’ll handle fall into a handful of patterns.

### 4.1 Stolen console credentials

**Storyline:** Attacker phishes a user’s cloud console password and bypasses or defeats MFA. They log in as that user and start doing “admin things”.

**Evidence hot‑spots:**

- Sign‑in logs (new device, IP, location, impossible travel).  
- Authentication method details (MFA success/failure, bypass via legacy protocol).  
- Control plane logs showing resource changes, role assignments, policy updates.  
- Recovery email/phone changes or new MFA methods being registered.

Questions to answer:

- Did they add or change any **admin accounts or roles**?  
- Did they generate any **access keys** or create long‑lived tokens?  
- Did they touch high‑value resources (sensitive storage, production VMs, Secrets/Key Vault)?

### 4.2 Stolen access keys / service credentials

**Storyline:** A developer accidentally commits an AWS access key / Azure connection string / GCP service account key to GitHub. Attacker scans for it, then abuses it to talk directly to APIs.

**Evidence hot‑spots:**

- IAM / service account key creation and use.  
- API calls using that identity: listing buckets, copying objects, spinning up instances, disabling security controls.  
- Storage read events showing large object downloads.  
- VPC / NSG flow logs for unusual egress from newly created instances.

Questions to answer:

- Where did the key come from? Which repo / CI system / shared script?  
- What permissions did that identity actually have?  
- How long has it been abused?  
- Is there evidence of **persistence** (new backdoor accounts, scheduled tasks in cloud, new OAuth apps)?

### 4.3 Misconfigured storage and databases

**Storyline:** A bucket, blob container, or database is exposed to the internet, either anonymously or via weak auth. Someone finds it and starts browsing or downloading sensitive data.

**Evidence hot‑spots:**

- Storage configuration (public access flags, ACLs, shared access signatures).  
- Storage access logs for anonymous or foreign IPs.  
- CloudFront / CDN logs if the data was fronted.  
- Any configuration changes before/after the exposure (e.g., someone “fixing” it).

Questions to answer:

- Was the exposure **read‑only**, or could an attacker also **modify** and plant malicious files?  
- What data was actually accessed (object names, timestamps, transfer sizes)?  
- Is there evidence of automated scraping vs a targeted browse?

### 4.4 Compromised workload (VM / container)

**Storyline:** A public‑facing VM, container, or PaaS app has a vulnerability. Attacker gains remote code execution, pivots with the instance’s identity, and moves deeper into the environment.

**Evidence hot‑spots:**

- Endpoint logs from the instance (shell history, web server logs, process tree).  
- Metadata service access logs (where available) indicating token theft.  
- Cloud audit logs showing the instance’s identity performing new actions (listing secrets, creating new resources).  
- Network logs showing lateral movement, C2 traffic, or data exfiltration.

Questions to answer:

- How did they get code execution on the workload?  
- Did they **steal the instance’s role/identity**?  
- Did they use that identity to touch storage, secrets, or control plane?

---

## 5. Walkthrough 1 — Stolen AWS Access Key

Let’s walk a realistic, simplified AWS scenario from first alert to containment.

### 5.1 First signal

Your SOC receives an alert from a threat intelligence integration: **access keys associated with one of your AWS accounts have appeared on a public GitHub repo**.

Almost simultaneously, GuardDuty fires findings for:

- `Recon:IAMUser/NetworkPermissions` – an IAM user enumerating security groups.  
- `Recon:IAMUser/MaliciousIPCaller` – API calls from an IP flagged as abusive.

### 5.2 Immediate steps

1. **Confirm the key** – use AWS CLI or console to identify which IAM user / role the key belongs to.  
2. **Disable or revoke the key** – create a new key if that identity is needed operationally, but suspend the compromised one.  
3. **Snapshot the logs** – ensure CloudTrail and relevant CloudWatch logs are retained and, ideally, duplicated to a separate investigation bucket.

### 5.3 Reconstructing the timeline

Using CloudTrail (queried via Athena or CloudTrail Lake), you build a view like:

- `2025-11-10T08:03:12Z` – `CreateAccessKey` for IAM user `ci-deploy-bot` from your corporate IP.  
- `2025-11-15T02:14:22Z` – first `ListBuckets` and `ListRoles` calls from an IP in a different country, using the same key.  
- Following minutes:  
  - `GetBucketLocation` and `ListObjects` on multiple S3 buckets.  
  - `DescribeSecurityGroups`, `DescribeInstances`, `DescribeNetworkAcls`.  
  - A failed attempt to `CreateUser` and `AttachUserPolicy` (blocked by SCP).

You correlate this with:

- VPC Flow Logs showing egress from EC2 instances created by that user.  
- S3 access logs showing object reads for `s3://prod-customer-data/` over a 2‑hour window.

### 5.4 Assessing impact

Key questions:

- What permissions did `ci-deploy-bot` really have? Was it over‑privileged?  
- Which buckets were actually accessed, and how many objects were read?  
- Did the attacker manage to create any new **backdoor identities or roles** that persisted beyond key revocation?

You pull the IAM policy and discover the classic anti‑pattern: `AdministratorAccess` attached “temporarily” and never removed.

Impact assessment concludes:

- Attackers **listed** many buckets but only **read** from two.  
- No evidence of resource deletion or crypto‑mining.  
- No successful creation of new IAM users or roles due to higher‑level organization SCPs.

### 5.5 Containment and lessons

Actions taken:

- Permanently delete the compromised key; generate a new least‑privilege role for CI.  
- Rotate any credentials stored in the affected S3 buckets (if they contained configs/secrets).  
- Add detective controls: GuardDuty findings piped to SIEM with alerting, access‑key leak monitoring in CI.

Forensically, the important bit is you **correlated CloudTrail, S3 logs, and IAM configuration** to reconstruct what that single key did from first misuse to revocation.

---

## 6. Walkthrough 2 — Suspicious Azure Admin Sign‑In

Now a Microsoft Azure example focusing on the identity plane.

### 6.1 First signal

A Sentinel analytic rule fires: **“Impossible travel”** for an Azure AD user `cloud-admin@tenant.onmicrosoft.com` — logons from Australia and Eastern Europe within 15 minutes.

At almost the same time, another rule flags:

- Creation of a new **service principal** with `Directory.ReadWrite.All`.  
- Assignment of the `Owner` role on a production subscription to that principal.

### 6.2 Pivoting through sign‑in and audit logs

In the Entra ID (Azure AD) sign‑in logs you see:

- 09:01 – Successful sign‑in for `cloud-admin` from an Australian IP, device marked compliant, MFA satisfied.  
- 09:17 – Successful sign‑in for `cloud-admin` from an Eastern European IP, using **legacy protocol** without modern MFA, via a browser user agent you don’t normally see.

Drilling into the second event, you find:

- Conditional Access policy was not applied due to a gap in scoping.  
- MFA was not enforced for that protocol, so the password alone was enough.

In the Azure AD audit logs and Activity Logs, within minutes of the second sign‑in:

- A new app registration and service principal named `SyncApp-Prod` was created.  
- That principal was granted `Directory.ReadWrite.All` via Graph API permissions.  
- The principal was assigned `Owner` on the production subscription.

### 6.3 Reconstructing attacker goals

From the combination of logs you infer:

- Goal 1: **Persistence** – by creating a service principal with high directory privileges, the attacker can operate even if the `cloud-admin` password is later reset.  
- Goal 2: **Cloud control** – by giving that principal `Owner` on the subscription, they can deploy or modify any resource, including networking, storage, and compute.

You check Resource Group Activity Logs and see that no new VMs or storage accounts were created yet. The attacker appears to have been interrupted early by detection.

### 6.4 Forensic and response steps

- Immediately block sign‑in for `cloud-admin`, force password reset, and invalidate sessions.  
- Delete or disable the malicious service principal, remove role assignments and app registrations.  
- Review **other sign‑ins** for `cloud-admin` over the past 30 days to ensure this wasn’t ongoing.  
- Tighten Conditional Access so that **all protocols** and privileged roles require strong MFA and device compliance.

From a forensics perspective, you’ve used:

- **Sign‑in logs** to spot anomalous logon patterns.  
- **Audit logs** to tie those logons to risky directory and subscription changes.  
- **Role assignment history** to confirm the scope of attacker access.

---

## 7. Practical Cloud Forensics Artefact Checklist

When a cloud incident drops on your desk, here’s a concrete artefact checklist you can adapt.

### 7.1 AWS

- CloudTrail logs (org‑level, including data events for key workloads).  
- IAM configuration snapshots (users, roles, policies, access keys, last‑used data).  
- S3 access logs / CloudTrail data events for sensitive buckets.  
- VPC Flow Logs for affected VPCs and subnets.  
- OS logs from EC2 instances involved (system, security, application).  
- GuardDuty findings and Security Hub alerts around the relevant timeframe.

### 7.2 Azure

- Entra ID (Azure AD) sign‑in and audit logs for relevant users, apps, and service principals.  
- Azure Activity Logs for affected subscriptions and resource groups.  
- Role assignments and Privileged Identity Management (PIM) logs.  
- Resource logs: Key Vault, Storage, App Service, Kubernetes, NSG flow logs.  
- Defender for Cloud / Sentinel incidents and alerts.

### 7.3 GCP

- Cloud Audit Logs (Admin Activity, Data Access, System Events) for affected projects.  
- IAM policy history for projects, folders, and organisations.  
- VPC Flow Logs and firewall rule configuration.  
- Cloud Logging for workloads (Compute Engine, GKE, serverless).  
- Any security centre findings (if using Security Command Center).

### 7.4 Cross‑cutting

- Ticketing / case management entries (who did what during the response).  
- Snapshots of critical resources before and after remediation.  
- Copies of indicators (IPs, user agents, domains, hashes) for later hunting.

---

## 8. Building a Repeatable Cloud Forensics Playbook

Rather than improvising every time, build a **cloud forensics runbook** that answers five questions for each environment: **where to look, how to collect, how to correlate, how to contain, and how to learn**.

### 8.1 Where to look

Pre‑define:

- Which log sources are authoritative for **identity, control plane, and workload activity**.  
- How to quickly pivot between them (SIEM queries, saved searches, dashboards).

### 8.2 How to collect

Have ready‑made procedures for:

- Exporting audit logs for a specific timeframe and set of identities.  
- Capturing VM snapshots or disk images when necessary and allowed.  
- Preserving evidence in separate, access‑controlled “forensics” projects / accounts.

### 8.3 How to correlate

Standardise on:

- Time zone and clock source (ideally UTC everywhere).  
- Common identifiers (user principal names, role names, IPs, request IDs).  
- A simple **timeline template** where you can paste events from different log sources and see the story unfold.

### 8.4 How to contain

Document options and trade‑offs:

- Disabling accounts vs forcing password reset vs revoking sessions.  
- Rotating access keys and secrets.  
- Detaching or quarantining compromised resources (moving VMs to an isolated subnet, locking storage buckets).

Containment in cloud can be very fast when you know which **levers** you can safely pull.

### 8.5 How to learn

After action, capture:

- Which logs you wished you’d had but didn’t.  
- Which identities were over‑privileged and why.  
- Which detections fired, which missed, and which were noisy.

Turn those into **logging improvements, policy changes, and new detections**.

---

## 9. How To Practice Cloud Forensics (Without Burning Production)

Cloud forensics is a skill you can safely practice in a lab. A simple approach:

1. **Pick one provider** to start with (AWS, Azure, or GCP).  
2. Create a small, isolated environment with:  
   - One or two test users.  
   - A couple of VMs and a storage bucket with dummy data.  
   - Logging fully enabled (audit logs, flow logs, OS logs).

3. Script a few “attacks” against yourself:  
   - Simulate a stolen key by using it from a different IP and performing suspicious actions.  
   - Misconfigure a bucket, access it anonymously, then fix it.  
   - Exploit a deliberately vulnerable web app on a test VM and pivot using its role.

4. Afterwards, **turn off the automation** and pretend you only have the logs. Reconstruct:  
   - The initial access.  
   - The timeline of actions.  
   - The impact on data and identity.

5. Capture these as **worked examples** for your future runbooks.

This practice loop builds the muscle memory you will rely on when a real alert comes in at 3am.

---

## 10. Final Thoughts

Cloud forensics isn’t a completely new discipline — it’s digital forensics with different constraints and different opportunities.

- You often have **richer audit logs** than on‑prem, if you enabled and retained them.  
- You can frequently reconstruct entire incidents **without touching a single disk image**, purely from APIs and identity events.  
- But you are also one misconfigured bucket, one over‑privileged role, or one leaked key away from a serious breach.

If you treat your cloud environments as **forensically hostile by default** — logs can be tampered with, resources can disappear, identities can be abused — you’ll design better visibility and playbooks.

The bottom line:

- Invest early in **logging, identity hygiene, and least privilege**.  
- Build and rehearse **cloud‑specific incident workflows**.  
- And remember that every API call is a clue. Your job in cloud forensics is to string those clues together fast enough to contain the damage and learn from it.

Cloud will only grow. If you can confidently investigate incidents in AWS, Azure, and GCP, you’re not just “keeping up” — you’re building a skillset that will be central to DFIR for years to come.
