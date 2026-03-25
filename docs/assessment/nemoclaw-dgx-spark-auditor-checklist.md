# NemoClaw on DGX Spark - Auditor Checklist

**Document Type:** Auditor / Assessor Checklist  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Compliance Owner / Assessment Lead]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This checklist converts the NemoClaw DGX Spark SSP, gap assessment, supporting standards, and control matrix into an assessor-friendly verification artifact.

It is intended for use by:
- internal security reviewers
- compliance teams
- readiness assessors
- C3PAO-style audit preparation efforts

It focuses on what to inspect, what to ask, what to test, what evidence to request, and what failure patterns to watch for on this specific AI-assisted CUI processing system.

---

## 2. Core Documents to Review Before Testing

Review these documents before performing system testing:
- `README.md`
- `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
- `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
- `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
- `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
- `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
- `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`

---

## 3. Assessor Notes for This System

### 3.1 High-risk areas for this platform
Assessors should pay special attention to:
- agent access to CUI source code
- handling of derived CUI in embeddings, logs, and outputs
- export/download/copy behavior
- prompt injection and hostile-content response
- logging completeness and user attribution
- media/model/image intake workflow
- local-only service bindings and no-egress enforcement
- distinction between inherited enclave controls and local DGX Spark controls

### 3.2 Common failure mode on AI systems
The most common audit failure on systems like this is not the absence of a security feature. It is **poor scoping**:
- the team protects source code but not embeddings
- logs contain derived CUI but are treated like generic ops logs
- models are tracked but image/media intake is not controlled
- app sessions are authenticated but outputs are insufficiently restricted or audited

---

## 4. Checklist Format

Each entry below includes:
- **Inspect** — what artifacts/configurations to review
- **Ask** — questions for admins, owners, or users
- **Test** — specific validation activity
- **Expected Evidence** — what should exist if the control is working
- **Red Flags** — common issues that suggest the control is weak or missing

---

## 5. Access Control (AC)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **AC.L2-3.1.1** | AD/LDAP group mappings, app RBAC, admin account list, service accounts | Who is authorized to use NemoClaw? Who approves access? | Attempt access with unauthorized role or disabled account | Role mapping, approved user list, denied access logs | Shared accounts, unclear role mapping, dormant accounts still active |
| **AC.L2-3.1.2** | Role matrix, UI function restrictions, admin functions | What can developers do vs admins vs auditors? | Log in as each role and verify allowed functions only | Screenshots/config showing role-specific functions | Developers can access admin views or global logs |
| **AC.L2-3.1.3** | Data flow diagrams, export controls, derived CUI standard | How are outputs, logs, and exports classified and controlled? | Try exporting/downloading/copying CUI-derived content; verify control/logging | Export logs, policy, restricted UI behavior | Unlogged exports, unrestricted downloads, no derived-CUI treatment |
| **AC.L2-3.1.4** | Approval workflows, admin/reviewer assignments | Who reviews logs? Who approves policy changes and exports? | Trace a sample change or export approval | Separation-of-duties evidence, workflow records | Same person can change policy, review logs, and approve exceptions alone |
| **AC.L2-3.1.5** | Service permissions, OpenShell policy, filesystem perms, sudo config | How was least privilege validated? | Review service accounts and agent permissions against needed functions | Permission listings, policy files, least-privilege review | Agent/service accounts broader than required |
| **AC.L2-3.1.6** | Admin account usage patterns, privileged account list | Do admins use separate accounts for admin work? | Inspect admin login history and account assignments | Separate admin identities, policy | Privileged accounts used for routine user activity |
| **AC.L2-3.1.7** | Sudo policy, app privilege checks | Can standard users trigger privileged operations? | Attempt privileged action from nonprivileged account | Denied logs, UI restrictions, sudo restrictions | Hidden admin actions exposed to standard users |
| **AC.L2-3.1.8** | Lockout settings in IdP/app/SSH | What is the failed-login threshold and reset interval? | Repeated failed login attempts; confirm lockout or throttling | Policy docs, failed-auth logs | Unlimited retries, no lockout evidence |
| **AC.L2-3.1.9** | Login banner text for UI/SSH | Is a warning banner shown before access? | Access UI and SSH entrypoint | Screenshots, SSH banner config | No warning banner or generic consumer text only |
| **AC.L2-3.1.10** | Session lock/idle settings | What happens to an unattended session? | Leave session idle and observe lock/timeout behavior | Session timeout config, test results | Sessions stay open indefinitely |
| **AC.L2-3.1.11** | Session termination settings | What is max session age/inactivity timeout? | Verify auto-logout after threshold | Logout events, session config | No session termination or only manual logout |
| **AC.L2-3.1.12** | Remote access architecture, SSH/VPN/bastion configs | How is remote admin access monitored and controlled? | Review remote session logs and control point | Remote access logs, bastion/VPN policy | Direct unmanaged remote access |
| **AC.L2-3.1.13** | SSH/TLS crypto settings | How is confidentiality protected for remote sessions? | Validate negotiated protocols/ciphers and configuration | TLS/SSH config, crypto statement | Weak ciphers, unclear crypto posture |
| **AC.L2-3.1.14** | Managed access points, enclave ingress path | Does all remote access go through approved control points? | Trace path from admin/user device to system | Network diagram, gateway controls | Ad hoc remote access routes |
| **AC.L2-3.1.15** | Admin approval process, privileged remote command logging | How are remote privileged operations approved? | Review a sample privileged maintenance event | Tickets, logs, admin SOP | Privileged remote work with no approval trail |
| **AC.L2-3.1.16** | Wireless settings, service status, BIOS/OS config | Are Wi-Fi/Bluetooth disabled or approved? | Check interface state and production baseline | Disabled service evidence or approved WLAN policy | Wireless enabled with no policy or business need |
| **AC.L2-3.1.17** | WLAN security config if applicable | If wireless is enabled, what auth/encryption is used? | Validate configuration against policy | Wireless config, enterprise auth proof | Weak or consumer-grade wireless security |
| **AC.L2-3.1.18** | Mobile-device access policy | Are phones/tablets allowed to access NemoClaw? | Attempt access from mobile path if allowed | Policy, MDM requirements, test results | Uncontrolled mobile access to CUI outputs |
| **AC.L2-3.1.19** | Mobile CUI handling controls | Can mobile devices store/view CUI-derived outputs? | Review device protections if mobile permitted | Encryption/MDM evidence | Mobile use allowed with no endpoint controls |
| **AC.L2-3.1.20** | External connection inventory, firewall rules | What external systems connect to the DGX Spark? | Validate only approved connections exist | Connection inventory, ruleset, diagram | Undocumented connections, stray egress paths |
| **AC.L2-3.1.21** | USB/removable media restrictions | How are portable storage devices controlled? | Attempt or review controlled export/media workflow | Media SOP, host restrictions, logs | Uncontrolled USB use or untracked exports |
| **AC.L2-3.1.22** | Public exposure review, DNS, reverse proxy exposure | Is any part of NemoClaw publicly reachable? | Verify no public internet exposure exists | Exposure scan, network policy | Public DNS or externally routable access to CUI system |

---

## 6. Awareness and Training (AT)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **AT.L2-3.2.1** | Security awareness materials, user onboarding docs | What training do users get before using NemoClaw? | Sample review of current training content | Training records, AI/CUI user guidance | No NemoClaw-specific guidance |
| **AT.L2-3.2.2** | Admin/reviewer training records | What special training do admins and reviewers receive? | Interview an admin on responsibilities and procedures | Role-based training records | Admins rely on informal knowledge only |
| **AT.L2-3.2.3** | Insider threat awareness content | Are AI misuse and over-extraction covered in insider-risk awareness? | Ask users/admins how suspicious behavior is recognized/reported | Training module references, awareness notes | No insider-risk framing for AI-assisted code access |

---

## 7. Audit and Accountability (AU)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **AU.L2-3.3.1** | Log source inventory, retention config | What events are logged and how long are they kept? | Generate representative user/admin events and confirm they are logged | Logging standard, sample logs, retention settings | Critical events missing or no defined retention |
| **AU.L2-3.3.2** | Sample logs from nginx, app, auditd, SSH, DB | Do records include identity, time, event, object, outcome? | Check record completeness across sources | Representative records with required fields | Logs lack user identity or resource context |
| **AU.L2-3.3.3** | Logging review procedure and updates | Who reviews whether the event set is still sufficient? | Review evidence of periodic logging review | Review records, updated standards | Logging set never revisited after initial setup |
| **AU.L2-3.3.4** | Alerting for audit failures | What happens if auditd or app logging fails? | Simulate or review failure event handling | Alerts, tickets, incident records | Silent log failures |
| **AU.L2-3.3.5** | Correlation methods and identifiers | Can you reconstruct one user session across layers? | Trace a single query across web, app, agent, and host logs | Session IDs/correlation IDs, analyst procedure | No way to connect query to file reads and output |
| **AU.L2-3.3.6** | Reporting capability, dashboards/scripts | How are logs reduced for review or incident response? | Produce a review report or evidence pack | Queries/reports, analyst workflow | Logs exist but cannot be practically reviewed |
| **AU.L2-3.3.7** | NTP/chrony config, enclave time source docs | What is the authoritative time source? | Compare timestamps across components | Time sync config, consistent logs | Time drift or undefined source |
| **AU.L2-3.3.8** | Log permissions, tamper protections | Who can modify or delete logs? | Attempt or review access controls around log stores | Restricted perms, append-only controls if used | Broad read/write access to logs |
| **AU.L2-3.3.9** | Logging admin rights, role assignments | Who can change log settings or rotate/delete logs? | Review privileged role list and changes | Role matrix, config ownership | Logging managed by ordinary users or undocumented admins |

---

## 8. Configuration Management (CM)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **CM.L2-3.4.1** | Asset inventory, package baseline, image/model inventory | What is the approved baseline for this DGX Spark? | Compare running system to documented baseline | Baseline package, inventory, digests | No authoritative baseline |
| **CM.L2-3.4.2** | Hardening configs, STIG/SCAP outputs | How are security settings enforced and tracked? | Review current config against baseline | Config files, scans, remediation records | Baseline exists on paper only |
| **CM.L2-3.4.3** | Change tickets, repo history, approvals | How are changes approved before implementation? | Trace one recent production-relevant change | Ticket + approval + commit/deploy evidence | Direct changes with no approval trail |
| **CM.L2-3.4.4** | Security impact review templates | How is security impact assessed for model/image/config changes? | Review one completed impact analysis | Review checklist, signoff records | Changes made with no security impact analysis |
| **CM.L2-3.4.5** | Access to config files/repos/admin tools | Who can change OpenShell, firewall, auth, or nginx config? | Inspect file/repo perms and admin roles | Restricted access, role assignment evidence | Too many people can change critical security settings |
| **CM.L2-3.4.6** | Service list, ports, packages | Are only essential capabilities enabled? | Run service/listen review; verify no shell for agent | `ss` output, package list, OpenShell policy | Extra services, exposed local listeners, unnecessary tools |
| **CM.L2-3.4.7** | Disabled-service list, package restrictions | What nonessential services are disabled? | Verify disabled services remain disabled | Baseline docs, service status output | Wireless/BT/debug tools left enabled by default |
| **CM.L2-3.4.8** | Allowlists, firewall rules, approved artifacts | What is deny-by-default vs allow-by-exception here? | Check allowed images/models/services against documented list | Allowlist docs, rules, policy files | Broad default-allow posture |
| **CM.L2-3.4.9** | Package install restrictions, sudo policy | How is user-installed software prevented or detected? | Review logs and package controls | Sudo restrictions, audit evidence | Users can install software locally without review |

---

## 9. Identification and Authentication (IA)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **IA.L2-3.5.1** | Identity architecture, service account list | How are users, services, and hosts identified? | Review mappings and sample auth records | AD integration, service account inventory | Unknown local accounts or undocumented identities |
| **IA.L2-3.5.2** | Auth flow, MFA config, LDAPS settings | How is authentication enforced before access is granted? | Perform login flow review and inspect logs | Successful/failed auth events, config evidence | App trusts identity without proper validation |
| **IA.L2-3.5.3** | MFA evidence for UI/admin access | Which access paths require MFA? | Validate MFA on user/admin login paths | IdP policy, screenshots, logs | MFA missing for admins or users |
| **IA.L2-3.5.4** | Protocol configs, auth design | What replay-resistant mechanisms are used? | Review SSH/TLS/federated auth design | Protocol configuration, design statement | Reliance on weak or replay-prone auth mechanisms |
| **IA.L2-3.5.5** | Identifier lifecycle policy | Can a departed user’s identifier be immediately reused? | Review enterprise control and sample process | IAM policy evidence | No identifier reuse control |
| **IA.L2-3.5.6** | Inactive account disablement process | When are dormant accounts disabled? | Review sample inactive-account handling | IAM policy, disabled-account evidence | Old accounts remain enabled indefinitely |
| **IA.L2-3.5.7** | Password policy where applicable | What password complexity applies to this system? | Review AD/PAM settings for relevant accounts | Policy screenshots/docs | Weak password settings on any local/admin path |
| **IA.L2-3.5.8** | Password history policy | Is password reuse prohibited? | Review policy and a sample config | Password history evidence | No password reuse prevention |
| **IA.L2-3.5.9** | Temporary password procedure | Are temporary passwords ever used? | Review onboarding/reset workflow | Reset procedure, policy | Temporary credentials persist without forced change |
| **IA.L2-3.5.10** | Secret storage, SSH/key handling | How are passwords and secrets protected in storage/transit? | Review config, key material handling, secret files | Protected secret storage, encrypted transport evidence | Plaintext secrets or insecure sharing of admin credentials |
| **IA.L2-3.5.11** | Auth error handling | Do auth failures leak sensitive details? | Try bad username/password flows | Generic error messages, UI screenshots | Error messages reveal valid usernames or auth internals |

---

## 10. Incident Response (IR)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **IR.L2-3.6.1** | Enterprise IR plan and local addendum | How is NemoClaw covered in the IR program? | Walk through a prompt-injection or data-leak scenario | IR plan, local playbook, escalation contacts | No AI-specific incident handling |
| **IR.L2-3.6.2** | Incident tracking and reporting process | How would an admin report suspicious extraction or logging failure? | Review a sample ticket/workflow | Incident records, SOP, evidence preservation steps | Staff unsure how to report or preserve evidence |
| **IR.L2-3.6.3** | Tabletop/test records | Has the team tested AI misuse or supply-chain scenarios? | Review test outputs or conduct tabletop discussion | Exercise records, after-action items | No testing of system-specific incident scenarios |

---

## 11. Maintenance (MA)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **MA.L2-3.7.1** | Maintenance SOP, maintenance logs | Who performs maintenance and under what process? | Review recent maintenance record | Ticket/log records, approved personnel list | Ad hoc maintenance with no records |
| **MA.L2-3.7.2** | Tool list, approved admin methods | What tools are approved for maintenance? | Compare actual admin practice to SOP | Tool inventory, admin procedure | Unapproved tools/scripts used in production |
| **MA.L2-3.7.3** | Off-site maintenance/removal procedure | What happens if the device leaves the site for service? | Review decommission/sanitization workflow | Sanitization/removal SOP | Portable device could leave site with CUI intact |
| **MA.L2-3.7.4** | Maintenance-media scan records | How are diagnostic/test media checked? | Review scan evidence for one maintenance artifact | Scan logs, media intake records | Maintenance media bypasses intake controls |
| **MA.L2-3.7.5** | Remote maintenance policy | Is remote maintenance allowed, and if so under what controls? | Review remote maintenance evidence or exception path | Policy, MFA/session logs | Uncontrolled remote maintenance |
| **MA.L2-3.7.6** | Supervision records for non-cleared personnel | How are vendor technicians supervised? | Review escort/supervision procedure | Escort records, approval notes | No supervision requirements for outside maintenance personnel |

---

## 12. Media Protection (MP)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **MP.L2-3.8.1** | Media handling docs, export locations, backups | What media may contain CUI or derived CUI? | Inspect approved storage/export paths | Media policy, derived CUI standard | Only source repo treated as CUI; logs/exports ignored |
| **MP.L2-3.8.2** | Access controls on backups/exports/media | Who can access CUI-bearing media? | Verify permissions on sample export/backup location | ACLs/perms, role mapping | Backup/export areas broadly accessible |
| **MP.L2-3.8.3** | Sanitization/decommission SOP | How are removable media and NVMe devices sanitized? | Review a sample sanitization record or procedure | Sanitization checklist, destruction records | No clear media sanitization path |
| **MP.L2-3.8.4** | Marking templates for reports/media | How are CUI reports/exports marked? | Review sample exported report or evidence package | Templates, marked artifacts | Reports with sensitive content lack markings |
| **MP.L2-3.8.5** | Transport/custody logs | How is media controlled during transport? | Follow one approved media transfer record | Chain-of-custody forms, media IDs | USB/media moves with no accountability |
| **MP.L2-3.8.6** | Media encryption/physical protection during transport | How is digital media protected in transit? | Review control choice for one transfer event | Encrypted media evidence or physical safeguard record | Transfer media unencrypted and loosely handled |

---

## 13. Personnel Security (PS)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **PS.L2-3.9.1** | Screening/onboarding policy | Are users screened before NemoClaw access is granted? | Review sample onboarding/access approval | Screening and access approval records | Access provisioned before screening/approval |
| **PS.L2-3.9.2** | Offboarding/deprovisioning workflow | How is access removed when personnel leave or change roles? | Trace one terminated/transferred-user workflow | Deprovisioning records, account disable evidence | Departed users still have access |

---

## 14. Physical Protection (PE)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **PE.L2-3.10.1** | Room/cabinet controls, asset location | Where is the DGX Spark physically kept? | Inspect placement and access restriction | Lock evidence, asset inventory, custody assignment | Device sitting unsecured in common area |
| **PE.L2-3.10.2** | Facility security controls | How is the surrounding facility monitored/protected? | Review facility-level support evidence | Badge/access logs, room controls | Facility protections assumed but undocumented |
| **PE.L2-3.10.3** | Visitor policy and escort procedures | How are visitors handled near the system? | Review visitor log and escort process | Visitor records, escort policy | Visitors can access system area unsupervised |
| **PE.L2-3.10.4** | Physical access/device movement logs | Are access and movement logs maintained? | Review one room-access or relocation event | Badge logs, movement records | Portable device can move without traceability |
| **PE.L2-3.10.5** | Key/badge/cabinet-lock management | Who can unlock the room/cabinet or take custody of the device? | Review key holder/custodian list | Access-device management records | No defined custodian for the device |
| **PE.L2-3.10.6** | Alternate-site use policy if any | Can the DGX Spark be used at alternate locations? | Review approvals or prohibition statement | Policy, approval records | Informal off-site use allowed |

---

## 15. Risk Assessment (RA)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **RA.L2-3.11.1** | Risk register, AI risk addendum | What AI-specific risks are tracked for this system? | Review risk entries and review cadence | Risk register, addendum, review records | Prompt injection and derived CUI not treated as risks |
| **RA.L2-3.11.2** | Vulnerability scan outputs, app/image review process | What is scanned and how often? | Review host, image, and dependency scan evidence | SCAP results, image scans, dependency scans | Only host OS scanned; containers/app stack ignored |
| **RA.L2-3.11.3** | POA&M or remediation tracker | How are vulnerabilities prioritized and closed? | Trace one finding to remediation or risk acceptance | Tickets, POA&M entries, approvals | Findings accumulate with no ownership or due dates |

---

## 16. Security Assessment (CA)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **CA.L2-3.12.1** | Assessment schedule, test plans | How often are controls reassessed? | Review recent self-assessment or readiness test | Schedules, reports, completed assessments | No periodic assessment cycle |
| **CA.L2-3.12.2** | POA&M/remediation plan | How are deficiencies tracked and corrected? | Review current NemoClaw-specific corrective actions | POA&M tracker, remediation status | Gap list exists but no formal remediation program |
| **CA.L2-3.12.3** | Continuous monitoring plan | What ongoing monitoring applies to this host and app stack? | Review logs/scans/reviews used as monitoring inputs | Monitoring plan, recurring review evidence | “Continuous monitoring” claimed but undefined |

---

## 17. System and Communications Protection (SC)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **SC.L2-3.13.1** | Firewall rules, bind/listen output, network diagram | What communications are allowed and why? | Verify only intended listeners exist and egress is restricted | `ss` output, UFW rules, design docs | Unexpected listeners or open egress |
| **SC.L2-3.13.2** | Architecture/security design docs | What engineering principles drove the design? | Review design decisions around local-only inference and sandboxing | Architecture narrative, design review | Security principles implied but never documented |
| **SC.L2-3.13.3** | Admin vs user function separation | How are management and user functions separated? | Verify admin-only functions are not in standard user path | RBAC evidence, UI screenshots | User-facing app exposes management controls |
| **SC.L2-3.13.4** | Shared resource handling, temp/cache behavior | How is unintended data transfer prevented between users/sessions? | Review session isolation and temp-storage handling | App design notes, storage rules | One user can access another user’s sessions/outputs |
| **SC.L2-3.13.5** | Network segmentation/public exposure stance | Is any component public-facing or in a DMZ-like segment? | Confirm design matches stated non-public posture | Exposure review, network docs | Publicly reachable web endpoint without formal design basis |
| **SC.L2-3.13.6** | Deny-by-default rules, network tests | Is network traffic denied by default? | Attempt unauthorized inbound/outbound connection | UFW rules, test evidence, denied logs | Firewall mostly allow-all with a few denies |
| **SC.L2-3.13.7** | Remote device/network access policy | How is split tunneling prevented for remote access clients? | Review remote-access architecture and policy | VPN/bastion settings, policy docs | Remote admins can bridge enclave and external networks simultaneously |
| **SC.L2-3.13.8** | TLS/SSH/LDAPS protections, media crypto | Which in-transit paths carry CUI and how are they protected? | Validate protocol usage/configuration | TLS configs, certificates, SSH settings, crypto statement | CUI path exists with weak or unclear protection |
| **SC.L2-3.13.9** | Session termination settings | How are network connections terminated at end of session? | Verify session close/timeout behavior | Timeout config, termination logs | Connections/sessions persist beyond policy |
| **SC.L2-3.13.10** | Key/cert lifecycle docs | How are SSH keys, TLS certs, and encryption keys managed? | Review one certificate/key lifecycle example | Key inventory, rotation/revocation procedure | No key inventory or lifecycle control |
| **SC.L2-3.13.11** | FIPS crypto statement, module evidence | What exact FIPS-validated cryptographic modules protect CUI? | Review system mode, module versions, and scope claim | Crypto statement, module evidence, screenshots/output | Vague “TLS 1.3/LUKS” answer with no module evidence |
| **SC.L2-3.13.12** | Hardware/peripheral inventory | Are collaborative computing devices present or disabled? | Inspect device/peripheral config | Inventory, disabled-service evidence | Unexpected camera/mic collaboration features left active |
| **SC.L2-3.13.13** | Browser/mobile code controls, CSP | How is mobile code controlled in the web UI? | Review front-end and proxy security controls | CSP, dependency controls, secure headers | Streamlit UI exposed without browser-hardening considerations |
| **SC.L2-3.13.14** | VoIP/service inventory | Is VoIP present or disabled? | Inspect service list/network exposure | Service inventory, disabled-state evidence | Unused communications services enabled |
| **SC.L2-3.13.15** | Session integrity/authenticity controls | How is session authenticity protected? | Review secure cookie/session config and behavior | App/proxy config, session tests | Weak session handling, insecure cookies, no integrity protections |
| **SC.L2-3.13.16** | Disk encryption, DB/file perms, backup handling | How is CUI protected at rest across all stores? | Inspect encryption and access controls for code, logs, DBs, backups | Encryption evidence, perms, derived CUI standard | Only main code directory protected; logs/DBs/backups overlooked |

---

## 18. System and Information Integrity (SI)

| Practice | Inspect | Ask | Test | Expected Evidence | Red Flags |
|---|---|---|---|---|---|
| **SI.L2-3.14.1** | Patch/update records, vulnerability workflow | How are flaws identified and corrected across the stack? | Trace one flaw from detection to closure | Tickets, updates, approvals | No unified flaw-management process |
| **SI.L2-3.14.2** | Malware protections for staging/import paths | Where is malicious code scanning performed? | Review scan evidence for imported artifacts | Scanner configs/reports, SOP | Team assumes air gap alone replaces malware scanning |
| **SI.L2-3.14.3** | Advisory tracking process | How are security advisories monitored for OS, app, images, models? | Review recent advisory review record | Subscription lists, review tickets | No one tracks non-OS advisories |
| **SI.L2-3.14.4** | Malware protection update process | How are scan/signature mechanisms kept current? | Review update records for detection tools | Tool update logs, maintenance records | Outdated scanners or undefined update path |
| **SI.L2-3.14.5** | Periodic scan schedule and imported-file scanning | Are periodic and intake-time scans occurring? | Review schedule and a sample import event | Scan schedules, import scan evidence | Imported artifacts not consistently scanned |
| **SI.L2-3.14.6** | Monitoring/alerting for anomalies | How are attacks or suspicious behavior detected? | Review alert criteria and a sample anomaly workflow | Monitoring rules, review logs | Monitoring exists only as manual hope |
| **SI.L2-3.14.7** | Unauthorized-use identification process | How would you detect misuse by an authorized user? | Review suspicious extraction/use-case thresholds | Review procedures, analyst criteria, tickets | No criteria for abnormal query/export behavior |

---

## 19. AI-Specific Supplemental Checks

These are not separate CMMC practices, but they are the practical checks most likely to matter on this system.

### 19.1 Derived CUI handling
- Verify embeddings, summaries, prompts, outputs, logs, and exports are treated as CUI by default.
- Verify derived CUI handling is reflected in access controls, retention rules, and media handling.
- Verify reviewers understand that public base model weights are not the same thing as CUI-derived outputs.

**Red flags:**
- “Only `/opt/codebase` is CUI.”
- Logs and reports stored outside protected paths.
- Embeddings treated as harmless metadata.

### 19.2 Prompt injection / hostile content
- Ask how the team would identify a malicious code comment trying to manipulate the agent.
- Review whether threat scenarios appear in risk, training, logging, and incident procedures.
- Verify that the agent cannot spawn shells or make network calls even if prompted to do so.

**Red flags:**
- Team treats prompt injection as “just a model quality issue.”
- No logs or alerting around denied policy actions.
- No tabletop or scenario-based discussion has ever occurred.

### 19.3 Local-only inference and no-egress posture
- Verify Ollama, PostgreSQL, and Streamlit bind only to localhost.
- Verify host firewall blocks operational internet egress.
- Verify the system can perform intended operations without internet connectivity.

**Suggested tests:**
- inspect `ss -ltnp` / equivalent
- inspect UFW rules
- attempt disallowed outbound connection from production mode path

**Red flags:**
- local services bound to `0.0.0.0`
- “temporary” outbound allowances left in place
- undocumented update paths from production network

### 19.4 Supply-chain intake
- Trace one model or image from request through staging, scan, hash, approval, media transfer, and import.
- Verify immutable image digest or equivalent artifact identity is recorded.
- Verify intake records are preserved.

**Red flags:**
- artifacts loaded from memory with no paperwork
- mutable tags used as identity
- no hash verification inside/import-side of enclave

### 19.5 Logging completeness
- For one user query, verify you can answer:
  - who asked it
  - what files were read
  - what tools were invoked
  - what output was produced
  - whether it was exported
- If you cannot answer those five, the logging design is not ready.

---

## 20. Suggested Assessor Test Sequence

A practical test order for this system:

1. Review SSP, control matrix, and companion standards.  
2. Verify network/listening services and no-egress posture.  
3. Verify identity, MFA, and role separation.  
4. Run through one user query end-to-end and reconstruct it from logs.  
5. Verify export/download/copy controls and derived CUI treatment.  
6. Trace one model/image/media intake event.  
7. Review vulnerability management and baseline configuration evidence.  
8. Review incident response, training, and risk treatment for AI-specific scenarios.  
9. Review physical custody and media sanitization procedures.  
10. Resolve inherited-control boundaries with enclave owners.

---

## 21. High-Value Evidence Bundle to Request

If time is limited, ask for these first:
- latest SSP draft
- control matrix
- derived CUI handling standard
- logging and review standard
- media/model/image intake SOP
- AI risk addendum
- one sample user-session log reconstruction
- one sample approved media/model intake record
- firewall rules and service bind output
- MFA/auth configuration evidence
- latest host scan and app/image vulnerability results
- role mapping / access approval evidence
- decommission/sanitization procedure if available

---

## 22. Most Likely Findings if the System Were Assessed Too Early

1. Derived CUI not fully scoped across logs, embeddings, summaries, and exports.  
2. Session timeout / reauthentication values not formally defined.  
3. FIPS cryptography statement too vague for **SC.L2-3.13.11**.  
4. Logging exists but review and alerting workflow is weak.  
5. Media/model/image intake process documented but not yet evidenced with real records.  
6. Inherited vs local control boundaries insufficiently explicit.  
7. Prompt-injection risk acknowledged conceptually but not operationalized in testing and IR.

---

## 23. Recommended Next Documents After This Checklist

After this checklist, the most useful next artifacts are:
- incident response playbook addendum for AI misuse and prompt injection
- retention schedule / data disposition matrix
- cryptographic implementation statement
- evidence binder index mapped to the control matrix and this checklist
