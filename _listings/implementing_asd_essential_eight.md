---
author: Sab0x1D
author_avatar: /assets/img/sab01xd-profile.jpeg
layout: listing
title: "Implementing the ASD Essential Eight: Practical Hardening for Windows & Linux"
pretty_title: "Implementing the ASD Essential Eight: Practical Hardening for Windows & Linux"
excerpt: "The ASD Essential Eight is more than a checklist – it is a practical hardening baseline that can materially reduce the impact of real-world attacks. This guide walks through step-by-step implementation examples for each of the eight strategies across Windows and Linux. From application control and macro settings to MFA and automated backups, the focus is on controls you can actually deploy with minimal guesswork."
thumb: /assets/img/essential-eight.webp
date: 2026-01-14
featured: false
tags: ["Essential Eight", "Hardening", "Security Baselines", "ASD", "GRC"]
---

# Implementing the ASD Essential Eight: Practical Hardening for Windows & Linux

The Australian Signals Directorate (ASD) Essential Eight has become the baseline security uplift for many Australian organisations. It is deliberately opinionated: it tells you not just *what* to do, but roughly *how far* to go.

The problem is that in most write-ups, the Essential Eight is described at a policy level:

> "Do application whitelisting."  
> "Patch your systems."  
> "Enable MFA."

Useful, but not enough to log into a host and actually implement the controls.

This post is a practical, step-by-step guide. It assumes a mixed environment with:

- Windows 10/11 endpoints
- Linux endpoints (e.g. Ubuntu)
- Microsoft 365 / Azure AD for identity and email (common in AU environments)

For each Essential Eight strategy, we walk through:

- What the control is trying to achieve
- Concrete implementation examples on Windows and/or Linux
- Screenshot placeholders you can use when documenting your own environment

---

## Before you start: know what you are hardening

Before touching any keyboard:

- **Inventory what you actually run**
  - Operating systems (Windows desktop/server, Linux flavours, macOS).
  - Business-critical applications (browsers, Office suite, bespoke apps).
  - Identity and access platforms (AD, Azure AD, Okta, local accounts).
- **Understand who needs to do what**
  - Who genuinely needs admin rights.
  - Who uses macros for legitimate reasons.
  - Which systems are mission-critical if taken offline.
- **Decide your target maturity**
  - Essential Eight maturity levels (0–3) define how far you go with each control.
  - You may aim for higher maturity on internet-facing or critical systems first.

Once you have this context, you can start turning the Essential Eight into concrete configurations.

---

## Application control: Whitelisting on Windows

**Goal:** Only allow trusted, approved applications to execute. Block unknown binaries and script-based payloads by default.

On modern Windows fleets, application control is often delivered through:

- Windows Defender Application Control (WDAC)
- AppLocker
- Third-party allowlisting tools

For smaller environments or standalone hosts, **Software Restriction Policies (SRP)** via Local Security Policy can still be a simple starting point.

### Step 1 – Open Local Security Policy

1. Press `Win + R`.
2. Type `secpol.msc` and press Enter.
3. In the left-hand pane, expand:
   - `Security Settings → Software Restriction Policies`.

> [Screenshot placeholder – Local Security Policy console with “Software Restriction Policies” selected.]

If no policy exists, right-click **Software Restriction Policies** and select **New Software Restriction Policies**.

### Step 2 – Flip the default model to “deny-by-default”

1. In **Software Restriction Policies**, click **Security Levels**.
2. Right-click **Disallowed** → **Set as Default**.
3. Confirm that the default security level is now **Disallowed**, not **Unrestricted**.

This is the core shift: everything is blocked unless explicitly permitted.

> [Screenshot placeholder – Security Levels view showing “Disallowed” as Default Security Level.]

### Step 3 – Allow known-good locations

You now need to create explicit “allow” rules for trusted paths.

1. Right-click **Additional Rules**.
2. Choose **New Path Rule…**.
3. Add rules for locations such as:
   - `C:\Windows\*`
   - `C:\Program Files\*`
   - `C:\Program Files (x86)\*`
4. Set the **Security level** to **Unrestricted** for these paths.

You can also add hash or certificate rules for specific binaries where path-based rules are too coarse.

> [Screenshot placeholder – Path rule dialog allowing C:\Program Files\* as Unrestricted.]

### Step 4 – Harden script execution

Script file types are a common initial access vector. You should ensure they are treated as “executable” so SRP controls them.

1. In **Software Restriction Policies**, right-click **Additional Rules** and select **Designated File Types**.
2. Confirm that high-risk extensions are listed (or add them if missing), including:
   - `.ps1`, `.psm1` (PowerShell scripts and modules)
   - `.vbs`, `.vbe` (VBScript)
   - `.js`, `.jse` (JScript)
   - `.wsf` (Windows Script File)
   - `.bat`, `.cmd` (batch files), where appropriate
3. Remove filetypes that are safe to ignore if they cause noise (e.g. some shortcut types), but do so deliberately.

> [Screenshot placeholder – Designated File Types window listing script extensions such as .ps1, .vbs, .js, .wsf.]

Test with a non-critical machine first: drop a `.ps1` script into a non-whitelisted folder and confirm that it is blocked.

---

## Patch applications: keeping software current on Linux

**Goal:** Ensure third-party and line-of-business applications are updated quickly when security patches are released.

On Linux, especially where you build or customise software from source, applying patches can mean:

- Using a package manager (**apt**, **dnf**, etc.) for standard packages.
- Applying source-level patches for custom code via `diff` and `patch`.

### Step 1 – Use the package manager for standard software

On Debian/Ubuntu-based systems:

```bash
sudo apt-get update
sudo apt-get upgrade
# or, when appropriate:
sudo apt-get dist-upgrade
```

This should be automated via:

- Configuration management (Ansible, Puppet, etc.).
- Scheduled tasks (cron, systemd timers).
- Managed tooling (e.g. Landscape, Canonical Livepatch, or equivalents).

> [Screenshot placeholder – Terminal output showing `sudo apt-get update` and `sudo apt-get upgrade` completing successfully.]

### Step 2 – Apply source-level patches safely

For custom applications managed in-house, a common workflow uses `diff` and `patch`:

1. Place the original file (e.g. `app.c`) and the updated version (e.g. `app_new.c`) side by side.
2. Generate a unified diff:

   ```bash
   diff -u app.c app_new.c > app.patch
   ```

3. Perform a dry-run to validate:

   ```bash
   patch --dry-run < app.patch
   ```

4. Back up the original file:

   ```bash
   cp app.c app.c.bak
   ```

5. Apply the patch:

   ```bash
   patch < app.patch
   ```

6. If needed, roll back:

   ```bash
   patch -R < app.patch
   ```

> [Screenshot placeholder – Terminal showing creation of app.patch, a successful `patch --dry-run`, and then applying the patch.]

This pattern generalises: always test, always back up, always confirm the outcome.

---

## Macro security: hardening Microsoft Office

**Goal:** Stop malicious macros from executing while still allowing controlled, signed automation where needed.

Malicious macros remain a popular malware delivery mechanism. Your macro strategy should be:

- Block macros from the internet by default.
- Allow macros only from trusted locations or signed by trusted publishers.

### Step 1 – Configure macro settings in Trust Center

From any Office application (e.g. Word):

1. Go to `File → Options`.
2. Select **Trust Center**.
3. Click **Trust Center Settings…**.
4. Select **Macro Settings** on the left.

Recommended baseline:

- Choose **Disable all macros except digitally signed macros**.
- Optionally, also tick **Trust access to the VBA project object model** *off* unless required.

> [Screenshot placeholder – Office Trust Center “Macro Settings” tab showing “Disable all macros except digitally signed macros” selected.]

### Step 2 – Use trusted locations and signed macros

To support legitimate automation:

1. Create **Trusted Locations** in the Trust Center for authorised macro repositories (e.g. a signed network share).
2. Sign internal macros with a trusted code-signing certificate.
3. Educate users that:
   - Macros outside trusted locations and unsigned macros will not run.
   - Random macro-enabled files from email or the internet should never be enabled.

> [Screenshot placeholder – Trust Center “Trusted Locations” view with a controlled network share added.]

---

## User application hardening: browsers and plugins

**Goal:** Reduce browser attack surface by disabling legacy plugins, controlling risky features, and adding protective extensions.

Browsers are often the first place users meet attacker-controlled content. You want to:

- Remove deprecated plugins (Flash, old Java plugins).
- Block unnecessary active content.
- Add protection against malvertising and tracking.

### Step 1 – Confirm legacy plugins are disabled or removed

Modern browsers (Edge, Chrome, current Firefox versions):

- No longer support traditional NPAPI plugins such as Java.
- Have removed Adobe Flash entirely.

In managed environments:

- Use Group Policy (for Edge/Chrome) to prevent re-enabling any legacy plugin behaviour.
- Block access to sites that require legacy plugins and isolate those use-cases if absolutely unavoidable.

> [Screenshot placeholder – Microsoft Edge settings showing no Flash/Java plugin options and a note that Flash is deprecated.]

### Step 2 – Harden browser configuration

For each browser standard:

- Disable “Allow sites to run insecure content” (mixed active content).
- Force HTTPS where possible.
- Block pop-ups and unwanted notifications.
- Restrict or block high-risk protocols/extensions not required by business.

In Edge/Chrome:

1. Go to **Settings → Privacy, search, and services**.
2. Enable protections such as:
   - Tracking prevention.
   - Secure DNS (DoH) with an approved resolver.
3. Lock these settings via Group Policy where possible.

> [Screenshot placeholder – Edge/Chrome privacy settings with tracking prevention and secure DNS enabled.]

### Step 3 – Use security-focused extensions

Deploy approved extensions such as:

- An ad blocker (e.g. uBlock Origin, Adblock Plus).
- A script control extension if appropriate.
- Enterprise password management tools.

These should be:

- Centrally managed and pushed (e.g. via Edge/Chrome extension policies).
- Reviewed periodically to ensure they remain trustworthy.

> [Screenshot placeholder – Browser extensions page showing approved ad blocker and enterprise password manager installed and enabled.]

---

## Restricting administrative privileges

**Goal:** Ensure users only have the rights they genuinely need, and that administrative access is separate, auditable, and limited.

Unnecessary admin rights turn small compromises into full-domain incidents.

### Step 1 – Separate admin and user identities

On Windows:

1. In **Computer Management → Local Users and Groups → Users**, create:
   - A standard user account for daily use (if one does not already exist).
   - A separate admin account for administrative tasks.
2. Ensure the daily account is a member of **Users**, not **Administrators**.
3. Place the admin account into an appropriate group (e.g. **Administrators**, or a delegated admin group in AD).

> [Screenshot placeholder – Local Users and Groups view showing separate standard and admin accounts.]

On Linux:

- Use **named user accounts** for normal work.
- Use `sudo` for privileged actions, not direct `root` logins.
- Configure `/etc/sudoers` (via `visudo`) to limit what each admin can do, and log all `sudo` actions.

> [Screenshot placeholder – Terminal showing `id` output of a standard user and `sudo -l` listing allowed commands.]

### Step 2 – Apply least privilege to files and services

On Windows:

- Use NTFS permissions to limit access to sensitive folders.
- Apply Group Policy to:
  - Deny logon locally/over RDP for non-admin accounts where appropriate.
  - Restrict installation of device drivers and new software to admins.

On Linux:

- Use `chown` and `chmod` to control file ownership and permissions.
- Use systemd service unit permissions (e.g. `User=`, `Group=`, `ProtectSystem=`) to sandbox services.

> [Screenshot placeholder – Windows folder properties “Security” tab showing restricted ACLs; or Linux terminal showing `ls -l` with least-privilege permissions.]

---

## OS patching: Windows and Linux

**Goal:** Keep the operating system itself up to date with security patches to close known vulnerabilities.

### Step 1 – Configure Windows Update

On standalone Windows hosts:

1. Open **Settings → Update & Security → Windows Update**.
2. Click **Check for updates** and apply available updates.
3. Configure **Active hours** to minimise impact on users.
4. Enable automatic updates unless a staged patching process requires more control.

In managed environments:

- Use WSUS, SCCM, or Intune to:
  - Approve updates.
  - Ring deployments (test → pilot → broad).
  - Report on compliance.

> [Screenshot placeholder – Windows Update settings screen showing updates being downloaded and installed.]

### Step 2 – Configure Linux OS updates

On Ubuntu:

- Via GUI: open **Software Updater** and apply updates.
- Via CLI:

  ```bash
  sudo apt-get update
  sudo apt-get upgrade
  ```

For servers, consider:

- Unattended-upgrades for security updates.
- Centralised management and reporting tooling.

> [Screenshot placeholder – Ubuntu Software Updater window showing available updates.]

Tie both OS and application patching into a regular cadence:

- Security updates ASAP (hours to days).
- Feature updates on a scheduled cycle.
- Clear maintenance windows and communication to users.

---

## Multi-factor authentication (MFA)

**Goal:** Ensure that a stolen password alone is not enough to compromise an account.

MFA is critical for:

- Remote access (VPN, RDP, SSH gateways).
- Email and collaboration (Microsoft 365, Google Workspace).
- Administrator accounts in particular.

### Step 1 – Enable MFA for Microsoft 365 / Azure AD users

1. Sign in to the **Microsoft 365 admin center** or **Azure portal** with appropriate admin rights.
2. Navigate to **Azure Active Directory → Users → Per-user MFA** (or equivalent under Conditional Access).
3. Enable MFA for:
   - All users, or
   - High-risk groups first (admins, remote workers), then expand.

> [Screenshot placeholder – Azure AD portal showing MFA enabled for user accounts.]

### Step 2 – Register authenticator app

From the user’s perspective:

1. Install **Microsoft Authenticator** (or another approved app) on their mobile device.
2. On a workstation, browse to `https://aka.ms/mfasetup`.
3. Sign in with the corporate account.
4. Scan the QR code presented in the browser using the Authenticator app.
5. Confirm a test notification or code.

> [Screenshot placeholder – Microsoft Authenticator app showing a newly added work account, alongside browser page with QR code.]

For VPNs and SSH access:

- Integrate MFA via:
  - SAML/OIDC with your IdP, or
  - Local MFA modules (e.g. PAM-based OTP) if IdP is not available.

---

## Regular backups: Linux commands and scheduling

**Goal:** Ensure you can recover quickly from ransomware, accidental deletion, or major system failure.

Backups should be:

- Regular (aligned with business RPO/RTO).
- Tested (restores verified).
- Stored in a way that attackers cannot easily modify or delete them.

### Step 1 – Create a basic backup with `tar`

For file-level backups on Linux:

```bash
tar -czf /backups/data-$(date +%F).tar.gz /srv/data
```

- `-c` creates an archive.
- `-z` compresses with gzip.
- `-f` specifies the output file.

> [Screenshot placeholder – Terminal showing execution of a `tar -czf` command and resulting archive in /backups.]

### Step 2 – Use `cpio` or `dd` when appropriate

- `cpio` is useful when combined with `find` for more complex selections:

  ```bash
  find /srv/data -type f -print | cpio -ov > /backups/data.cpio
  ```

- `dd` is suitable for disk or partition imaging:

  ```bash
  sudo dd if=/dev/sda of=/backups/disk-$(date +%F).img bs=4M status=progress
  ```

> [Screenshot placeholder – Terminal showing a `dd` backup with the `status=progress` output as the image is created.]

These tools underpin many higher-level backup solutions.

### Step 3 – Automate backups with cron

To run a backup script regularly:

1. Create a script, for example `/usr/local/bin/backup.sh`:

   ```bash
   #!/bin/bash
   tar -czf /backups/data-$(date +%F-%H%M).tar.gz /srv/data
   ```

2. Make it executable:

   ```bash
   sudo chmod +x /usr/local/bin/backup.sh
   ```

3. Add a cron entry:

   ```bash
   crontab -e
   ```

   Example: run every night at 1am:

   ```cron
   0 1 * * * /usr/local/bin/backup.sh
   ```

4. Verify that cron is firing:

   ```bash
   grep CRON /var/log/syslog
   ```

> [Screenshot placeholder – `crontab -e` editor showing a nightly backup job, plus terminal snippet of `grep CRON /var/log/syslog` confirming execution.]

Remember: a backup strategy is incomplete without regular **restore testing** and secure offsite/immutable storage.

---

## Bringing it all together

Implementing the ASD Essential Eight is not about perfection on day one. It is about:

- Knowing your environment.
- Picking realistic hardening steps.
- Implementing them consistently.
- Measuring and iterating.

In this guide, we walked through practical examples for each strategy:

- Application control using deny-by-default execution policies on Windows.
- Application and OS patching on both Windows and Linux.
- Macro lockdown and trusted locations in Microsoft Office.
- Browser and plugin hardening with modern configurations.
- Clear separation and restriction of administrative privileges.
- MFA rollout via Azure AD and authenticator apps.
- Regular, automated backups on Linux using `tar`, `cpio`, `dd` and cron.

From here, the next steps are:

- Decide your target Essential Eight maturity per system class.
- Turn these examples into hardened baselines (GPOs, Ansible playbooks, Intune profiles, etc.).
- Embed monitoring and reporting so you know when controls drift.

The Essential Eight is most powerful when it stops being a PDF on someone’s desktop and becomes the *default state* of your fleet. This post gives you a starting point you can actually implement today.
