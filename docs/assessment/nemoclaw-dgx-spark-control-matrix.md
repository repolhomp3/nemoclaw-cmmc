# NemoClaw on DGX Spark - CMMC L2 Control Matrix

**Document Type:** Control Implementation Matrix  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [System Owner / Compliance Owner]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This matrix maps the NemoClaw DGX Spark deployment to the **110 NIST SP 800-171 Rev. 2 security requirements** used for **CMMC Level 2**. It is intended to support SSP development, remediation planning, internal review, and eventual assessor preparation.

This matrix is system-specific. It assumes:
- the DGX Spark is entering an existing CMMC Level 2 enclave
- enterprise identity, training, HR, and incident response functions are partly inherited
- NemoClaw processes CUI source code and CUI-derived artifacts
- internal services other than nginx are intended to bind to localhost only
- operational internet egress is blocked in production

---

## 2. Reading Guide

### Ownership labels
- **Local** — must be implemented directly on the DGX Spark / NemoClaw stack
- **Shared** — depends on both enclave-wide controls and local implementation
- **Inherited** — primarily provided by existing enclave processes, but local evidence is still needed
- **Conditional** — applies if the feature or technology is enabled; preferred approach is often to disable or prohibit it

### Matrix columns
- **Applicability / Ownership** — whether and how the control applies to this system
- **Implementation Summary** — intended control approach for NemoClaw on DGX Spark
- **Evidence / Validation** — what an assessor or internal reviewer would expect to see
- **Current Gap / Action** — what still needs to be formalized, implemented, or evidenced

---

## 3. Access Control (AC)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **AC.L2-3.1.1** | Shared | Restrict NemoClaw access to authorized AD/LDAP users, approved admin/auditor accounts, approved service accounts, and approved enclave-connected devices. | AD group mappings, app RBAC config, SSH access rules, service account list, bind/listen output. | Document repository/project authorization model and approved endpoint assumptions. |
| **AC.L2-3.1.2** | Local | Limit each role to permitted functions: developers query/view, admins configure/maintain, auditors review evidence, service accounts run only required services. | Role matrix, UI authorization rules, service account permissions, admin procedure. | Finalize role/function mapping in policy and application config evidence. |
| **AC.L2-3.1.3** | Shared | Permit CUI flow only between authenticated user sessions, local retrieval/inference/storage components, and approved internal evidence/export paths. | Data flow diagram, export restrictions, derived CUI standard, firewall rules, UI restrictions. | Finalize copy/download/print/export controls and sanitization workflow. |
| **AC.L2-3.1.4** | Shared | Separate user, admin, auditor, and security-review duties to reduce unilateral misuse of CUI, logging, or policy changes. | Role definitions, approval workflow, admin vs reviewer assignments. | Define who approves policy changes, reviews logs, and authorizes exports. |
| **AC.L2-3.1.5** | Shared | Enforce least privilege for AD groups, service accounts, local file permissions, database access, and sandbox tool permissions. | Filesystem perms, service account config, OpenShell policy, sudo/SSH restrictions. | Produce a least-privilege review for app, database, and admin operations. |
| **AC.L2-3.1.6** | Local | Require non-privileged accounts for routine use; reserve privileged access for admin tasks only. | Separate admin accounts, SSH config, admin SOP, screenshots/config of user/admin separation. | Confirm admins do not use privileged identities for ordinary developer tasks. |
| **AC.L2-3.1.7** | Local | Prevent non-privileged users from executing privileged functions; log any privileged operations that do occur. | sudo policy, app authorization checks, audit logs for admin actions. | Verify app/admin interfaces do not expose privilege escalation paths. |
| **AC.L2-3.1.8** | Shared | Limit unsuccessful logon attempts for UI and SSH access using IdP controls, app handling, and host configuration. | AD/IdP policy, SSH settings, app auth settings, failed-login logs. | Document threshold, lockout duration, and where enforcement occurs. |
| **AC.L2-3.1.9** | Local | Present approved login/privacy/security notice banners for the UI and administrative access paths. | Login banner text, SSH banner config, UI screenshot. | Add approved CUI/security notice language to all entry points. |
| **AC.L2-3.1.10** | Local | Use session lock / idle lock and pattern-hiding displays for UI sessions and admin consoles after inactivity. | Session timeout config, workstation lock policy references, UI behavior test. | Finalize idle timeout values and implementation for Streamlit/nginx session layer. |
| **AC.L2-3.1.11** | Local | Automatically terminate user sessions after defined inactivity or session-age conditions. | Session management config, logout logs, test results. | Define exact timeout/re-auth values and capture evidence. |
| **AC.L2-3.1.12** | Conditional / Shared | Monitor and control remote access sessions used for admin access or any approved remote user access. | SSH config, bastion/VPN/tailnet documentation if used, remote access logs. | Confirm remote access architecture and monitoring path for admin sessions. |
| **AC.L2-3.1.13** | Shared | Protect confidentiality of remote sessions with approved cryptography for SSH, HTTPS, and any authorized remote admin path. | SSH/TLS config, cipher policy, certificate settings, crypto statement. | Finalize FIPS-aligned crypto implementation statement and remote access boundary. |
| **AC.L2-3.1.14** | Conditional / Shared | Route remote access through managed access control points such as approved VPN, bastion, enclave ingress, or managed reverse proxy path. | Network diagram, gateway/bastion design, firewall rules. | Document actual managed ingress path for developer and admin access. |
| **AC.L2-3.1.15** | Local | Explicitly authorize any remote execution of privileged commands and access to security-relevant information. | Admin SOP, approval records, SSH sudo policy, audit logs. | Define approval workflow for remote privileged maintenance. |
| **AC.L2-3.1.16** | Conditional / Local | Authorize wireless access only if Wi-Fi/Bluetooth are enabled for production use; preferred baseline is disable unless required. | Hardware/service status, BIOS/OS settings, wireless policy, scans. | Decide whether Wi-Fi/Bluetooth are disabled or approved with restrictions. |
| **AC.L2-3.1.17** | Conditional / Local | If wireless is enabled, require approved authentication and encryption for all wireless access. | Wireless config, enterprise Wi-Fi settings, evidence of encryption/auth. | Prefer disablement; if enabled, document WLAN controls and enclave approval. |
| **AC.L2-3.1.18** | Conditional / Shared | Control mobile device access to the UI/admin paths; preferred baseline is prohibit or heavily restrict mobile access. | Access policy, MDM policy if applicable, nginx/auth restrictions, test results. | Decide whether phones/tablets are prohibited or approved under controls. |
| **AC.L2-3.1.19** | Conditional / Shared | If mobile devices are allowed to access/store CUI outputs, require encryption and mobile platform protections. | MDM policy, device encryption evidence, access policy. | Easiest compliant approach is prohibit mobile CUI handling for this system. |
| **AC.L2-3.1.20** | Shared | Verify and control connections to external systems, including IdP, admin paths, staging/media workflow, and any non-local integrations. | External connection inventory, firewall rules, architecture diagram. | Build and approve explicit external connection list for SSP and assessment. |
| **AC.L2-3.1.21** | Conditional / Shared | Limit use of portable storage devices and external systems for NemoClaw exports, backups, and evidence bundles. | USB policy, export SOP, media SOP, host restrictions. | Finalize removable-media restrictions and exported-evidence handling. |
| **AC.L2-3.1.22** | Local | Prevent CUI from being posted, processed, or stored on publicly accessible systems; NemoClaw is internal-only. | Network exposure review, DNS/public scan results, UI access policy. | Maintain explicit prohibition on public internet exposure in baseline. |

---

## 4. Awareness and Training (AT)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **AT.L2-3.2.1** | Inherited / Shared | Provide users, managers, and admins awareness of risks, policies, and procedures relevant to CUI and NemoClaw use. | Enterprise training records, local user guidance, acceptable use materials. | Add NemoClaw-specific user guidance on AI-derived CUI and misuse risk. |
| **AT.L2-3.2.2** | Inherited / Shared | Train personnel with security responsibilities such as admins, compliance staff, and reviewers on assigned duties for this platform. | Role-based training records, admin SOP acknowledgments, workshop materials. | Create role-specific training for DGX Spark admins and reviewers. |
| **AT.L2-3.2.3** | Inherited / Shared | Include insider-threat awareness tailored to AI-assisted code access, excessive extraction, and suspicious prompt behavior. | Insider threat training records, local addendum, awareness slides. | Add NemoClaw-specific insider misuse examples to training materials. |

---

## 5. Audit and Accountability (AU)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **AU.L2-3.3.1** | Shared | Generate and retain audit records for auth, queries, file reads, admin actions, exports, and system events. | Logging standard, sample logs, retention config, log source inventory. | Finalize retention schedule and confirm all critical sources are enabled. |
| **AU.L2-3.3.2** | Local | Ensure records contain timestamp, user/service ID, event type, object/resource, source context, and outcome. | Sample logs from nginx, app, auditd, SSH, DB, agent logs. | Validate each log source against a minimum required field set. |
| **AU.L2-3.3.3** | Shared | Periodically review and update which events are logged based on system risk and architecture changes. | Review tickets, change records, logging standard revisions. | Establish formal review cadence and owner for event-set updates. |
| **AU.L2-3.3.4** | Local | Alert or otherwise surface failures in logging, audit collection, or log pipeline availability. | Service monitoring, log failure alerts, test screenshots/logs. | Define actual alert mechanism for auditd/app logging failures. |
| **AU.L2-3.3.5** | Shared | Correlate logs across user sessions, agent actions, host events, and exports for investigations. | Correlation IDs, review procedures, sample incident reconstruction. | Ensure session IDs or equivalent identifiers exist across major components. |
| **AU.L2-3.3.6** | Local | Provide reporting/reduction capability to support analyst review, incident response, and assessor evidence requests. | Queries/scripts, review dashboards/reports, exported review artifacts. | Define standard review reports and evidence extraction process. |
| **AU.L2-3.3.7** | Shared | Synchronize host and component clocks with an approved authoritative time source. | NTP/chrony config, enclave time source docs, comparison output. | Document exact authoritative source and method used by DGX Spark. |
| **AU.L2-3.3.8** | Local | Protect logs and logging tools from unauthorized access, modification, or deletion using permissions and tamper-resistant handling. | File perms, audit config, admin role restrictions, append-only controls if used. | Decide whether to implement append-only/immutable protections for critical logs. |
| **AU.L2-3.3.9** | Local | Limit management of logging configuration and log deletion/rotation functions to approved privileged roles. | Sudo policy, role matrix, logging config ownership. | Define and document who can alter logging and under what approvals. |

---

## 6. Configuration Management (CM)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **CM.L2-3.4.1** | Local | Maintain baselines and inventories for host OS, packages, container images, model artifacts, configs, and documentation. | Asset inventory, baseline docs, image digests, package lists, SSP references. | Build a formal baseline package for production DGX Spark. |
| **CM.L2-3.4.2** | Local | Define and enforce security configuration settings for OS, Docker, AppArmor, UFW, nginx, DB, and app components. | Hardening guides, config files, STIG/SCAP results, enforcement procedures. | Convert current architecture assumptions into an approved configuration baseline. |
| **CM.L2-3.4.3** | Shared | Track, review, approve, and log changes to the DGX Spark system and supporting application stack. | Change tickets, git history, approval records, deployment logs. | Define formal change approval workflow for this repo and production system. |
| **CM.L2-3.4.4** | Shared | Assess security impact before implementing changes to models, policies, images, packages, or exposed services. | Change assessment templates, review notes, test signoffs. | Add a security impact checklist for model/image/policy changes. |
| **CM.L2-3.4.5** | Local | Restrict physical and logical access to make changes to system configs, images, models, and security tooling. | Admin access controls, code repo permissions, host perms, maintenance SOP. | Document who can change OpenShell, firewall, nginx, and app auth settings. |
| **CM.L2-3.4.6** | Local | Configure only essential capabilities: local-only services, no agent shell, no public exposure, minimal packages and ports. | Service list, `ss`/listen output, package inventory, OpenShell policy, UFW rules. | Verify production image/package set and remove nonessential utilities. |
| **CM.L2-3.4.7** | Local | Restrict or disable nonessential programs, ports, protocols, and services including unnecessary wireless/BT/admin tools. | Service status, firewall config, package blacklist/baseline. | Formalize disablement list for production build. |
| **CM.L2-3.4.8** | Local | Apply allow-by-exception principles to executable content, services, network paths, and approved images/models. | OpenShell policy, firewall rules, approved artifact lists, allowlists. | Determine whether host allowlisting/application control will be implemented beyond policy. |
| **CM.L2-3.4.9** | Local | Prevent and monitor unauthorized user-installed software on the host and within the app stack. | Package management controls, sudo restrictions, audit logs, repo policy. | Define how unauthorized installs are prevented and periodically reviewed. |

---

## 7. Identification and Authentication (IA)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **IA.L2-3.5.1** | Shared | Identify all users, devices, and service processes interacting with NemoClaw via enterprise identity and local service accounts. | AD integration docs, service account list, host identity config. | Document device identity assumptions for developer workstations and admin hosts. |
| **IA.L2-3.5.2** | Shared | Authenticate identities before granting access using LDAPS/MFA for users and local credentials for services. | Auth flow diagram, config screenshots, sample login events. | Capture concrete app-side evidence of successful federation/auth checks. |
| **IA.L2-3.5.3** | Shared | Enforce MFA for privileged local/network access and network access by nonprivileged users. | IdP policy, SSH+MFA proof, UI login evidence. | Confirm MFA coverage for all user classes including auditors/admins. |
| **IA.L2-3.5.4** | Shared | Use replay-resistant mechanisms for network authentication such as modern TLS-backed federated auth and SSH key exchange. | Auth design, protocol config, SSH/TLS settings. | State explicitly which replay-resistant mechanisms satisfy this control. |
| **IA.L2-3.5.5** | Shared | Prevent reuse of identifiers for a defined period using enterprise identity lifecycle controls. | IAM policy, HR/IT deprovisioning procedure. | Reference enterprise identifier reuse rule in local control response. |
| **IA.L2-3.5.6** | Shared | Disable user identifiers after defined inactivity period through enterprise account lifecycle management. | IAM policy, sample disabled-account evidence, review procedure. | Confirm inactivity thresholds and local dependency on enterprise enforcement. |
| **IA.L2-3.5.7** | Shared | Enforce password complexity where passwords remain in use, especially for admin or fallback paths. | Password policy, PAM/AD config, screenshots/policy docs. | Identify all password-bearing accounts and ensure policy coverage. |
| **IA.L2-3.5.8** | Shared | Prohibit password reuse for required generations through enterprise or PAM policy. | Password history policy evidence. | Confirm local service/admin accounts are within enforced policy where applicable. |
| **IA.L2-3.5.9** | Shared | Require immediate change of temporary passwords for any accounts that ever use them. | IAM/PAM policy, onboarding procedure. | Document whether temporary passwords are used at all for this system. |
| **IA.L2-3.5.10** | Local | Store/transmit passwords only using approved cryptographic protections; prefer key-based/non-password service auth where possible. | SSH config, password storage review, app/DB secret handling docs. | Document credential storage locations and protection methods. |
| **IA.L2-3.5.11** | Local | Obscure authentication feedback in the UI and admin interfaces to avoid credential disclosure. | Login screens, auth error behavior test, SSH behavior. | Verify UI/error messages do not disclose sensitive auth details. |

---

## 8. Incident Response (IR)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **IR.L2-3.6.1** | Inherited / Shared | Use the enterprise incident handling capability and extend it for NemoClaw scenarios such as prompt injection, CUI over-disclosure, logging failure, and model/image tampering. | Enterprise IR plan, local addendum, escalation contacts, playbook drafts. | Create system-specific AI misuse / prompt-injection playbook addendum. |
| **IR.L2-3.6.2** | Inherited / Shared | Track, document, and report incidents affecting the DGX Spark system through enterprise channels with local evidence preservation. | Incident tickets, reporting SOP, evidence handling procedure. | Document local evidence collection sources and preservation steps. |
| **IR.L2-3.6.3** | Shared | Test the incident response capability with scenarios relevant to this system, including suspicious extraction and supply-chain intake issues. | Tabletop results, test records, after-action items. | Schedule and record a NemoClaw-specific tabletop exercise. |

---

## 9. Maintenance (MA)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **MA.L2-3.7.1** | Local | Perform maintenance using approved personnel and documented procedures for the DGX Spark host and software stack. | Maintenance SOP, tickets, maintenance logs. | Define regular maintenance scope for OS, firmware, and app stack. |
| **MA.L2-3.7.2** | Local | Control the tools, techniques, mechanisms, and personnel used for maintenance, including approved media and admin paths. | Tool list, admin procedure, access controls, approved media records. | Document authorized maintenance tools and prohibit ad hoc tooling. |
| **MA.L2-3.7.3** | Conditional / Local | Sanitize equipment removed for off-site maintenance before removal if it contains CUI or CUI-derived data. | Decommission/transport SOP, sanitization records. | Add explicit off-site repair/removal procedure for this portable device. |
| **MA.L2-3.7.4** | Local | Check diagnostic/test media for malicious code before use on the system. | Media intake SOP, scan reports, maintenance records. | Ensure maintenance media is explicitly covered in the intake process. |
| **MA.L2-3.7.5** | Conditional / Shared | If nonlocal maintenance is ever permitted via external network connections, require MFA and terminate sessions after completion. | Remote maintenance policy, MFA evidence, session logs. | Preferred baseline is prohibit nonlocal maintenance unless exception approved. |
| **MA.L2-3.7.6** | Local | Supervise maintenance personnel without the required access authorization when they work on the system. | Visitor/maintenance logs, escort procedure, approval records. | Document vendor or non-cleared technician supervision expectations. |

---

## 10. Media Protection (MP)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **MP.L2-3.8.1** | Shared | Protect digital and printed media containing CUI or derived CUI, including exports, logs, backups, and transferred artifacts. | Derived CUI standard, media SOP, storage protections, physical controls. | Finalize approved storage locations and evidence handling rules. |
| **MP.L2-3.8.2** | Shared | Limit access to CUI on system media to authorized users and service roles only. | Filesystem perms, backup access rules, export controls, admin role matrix. | Confirm backups and exported evidence inherit proper access controls. |
| **MP.L2-3.8.3** | Shared | Sanitize or destroy media containing CUI before disposal or reuse, including removable media and retired NVMe devices. | Sanitization SOP, destruction records, decommission checklist. | Create DGX Spark-specific media sanitization/decommission procedure. |
| **MP.L2-3.8.4** | Shared | Apply required CUI markings and distribution limitations to exported reports, media, and printed artifacts where applicable. | Templates, report headers, labeling procedure, sample outputs. | Define how generated reports/evidence bundles will be marked. |
| **MP.L2-3.8.5** | Shared | Control and maintain accountability for CUI media during transport outside controlled areas. | Media transport logs, custody forms, SOP. | Implement custody tracking for approved transfer media and paper artifacts. |
| **MP.L2-3.8.6** | Shared | Protect digital media during transport with cryptography or equivalent physical safeguards. | Media SOP, encryption records, chain-of-custody forms. | Decide when physical safeguards suffice versus encrypted transport media. |

---

## 11. Personnel Security (PS)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **PS.L2-3.9.1** | Inherited / Shared | Screen individuals before granting access to the system through existing HR/personnel security processes. | Screening policy, onboarding workflow, access approval records. | Reference inherited personnel screening control in local package. |
| **PS.L2-3.9.2** | Inherited / Shared | Protect CUI and the system during and after personnel actions such as transfers and terminations by timely deprovisioning and key recovery. | Offboarding procedure, account disable evidence, access review records. | Confirm local admin/service access removal is tied into enterprise offboarding. |

---

## 12. Physical Protection (PE)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **PE.L2-3.10.1** | Shared | Restrict physical access to the DGX Spark, peripherals, and operating area to authorized personnel only. | Facility controls, room/cabinet lock evidence, asset list. | Define exact storage/custody approach for this small-form-factor device. |
| **PE.L2-3.10.2** | Inherited / Shared | Protect and monitor the physical facility and supporting infrastructure where the system operates. | Facility security procedures, camera/access records, room assignment. | Reference inherited facility protections and local placement details. |
| **PE.L2-3.10.3** | Inherited / Shared | Escort visitors and monitor visitor activity in areas where the system is located. | Visitor policy, logs, escort procedure. | Ensure local admins know how visitor handling applies to the DGX area. |
| **PE.L2-3.10.4** | Inherited / Shared | Maintain physical access logs for the facility or room and, where relevant, device movement logs. | Badge logs, visitor logs, custody logs. | Add device movement/custody logging if the unit may be relocated. |
| **PE.L2-3.10.5** | Shared | Control and manage physical access devices such as keys, badges, cabinet locks, and authorized custody holders. | Key/badge management records, cabinet lock records, role assignments. | Document who can physically move or open the device enclosure/storage area. |
| **PE.L2-3.10.6** | Conditional / Shared | If used at alternate work sites, enforce safeguarding measures for CUI and the device. | Remote/alternate site policy, approval records. | Preferred baseline is no alternate-site use; if allowed, create explicit procedure. |

---

## 13. Risk Assessment (RA)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **RA.L2-3.11.1** | Shared | Periodically assess system risk, including prompt injection, derived CUI sprawl, insider misuse, and supply-chain intake scenarios. | Risk register, AI risk addendum, periodic review records. | Add the AI risk addendum to the formal risk register/workflow. |
| **RA.L2-3.11.2** | Shared | Scan for vulnerabilities in the host, images, packages, and applications periodically and when new relevant flaws arise. | SCAP results, container scan reports, dependency scans, patch advisories. | Build a recurring vulnerability review process for app stack and images. |
| **RA.L2-3.11.3** | Shared | Remediate vulnerabilities according to risk, with POA&M entries and documented exceptions where needed. | POA&M items, remediation tickets, risk acceptance records. | Define SLAs and ownership for host, image, and application-level flaws. |

---

## 14. Security Assessment (CA)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **CA.L2-3.12.1** | Shared | Periodically assess the security controls for NemoClaw using scans, config reviews, and assessor-style testing. | Assessment schedule, test plans, completed review records. | Define a recurring control assessment cadence for this system. |
| **CA.L2-3.12.2** | Shared | Develop and implement POA&Ms or remediation plans for identified deficiencies. | POA&M tracker, remediation status, approvals. | Stand up a formal POA&M for NemoClaw-specific gaps already identified. |
| **CA.L2-3.12.3** | Shared | Monitor controls on an ongoing basis through logging, change review, scans, and periodic reassessment. | Continuous monitoring plan, review records, dashboards/tickets. | Document what “ongoing monitoring” means for this single-node AI system. |

---

## 15. System and Communications Protection (SC)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **SC.L2-3.13.1** | Local | Monitor, control, and protect communications at external and key internal boundaries using UFW, localhost bindings, TLS, and network architecture. | Firewall rules, network diagram, listen output, TLS config. | Define key internal boundaries and expected traffic paths in the SSP. |
| **SC.L2-3.13.2** | Local | Use secure architecture and engineering principles: single-node local processing, sandboxing, no public APIs, least functionality, and isolated internal services. | Architecture docs, OpenShell policy, design review records. | Capture architecture/security design rationale as formal evidence. |
| **SC.L2-3.13.3** | Local | Separate user functionality from system management functionality through distinct roles, admin paths, and service permissions. | RBAC config, admin SOP, UI/admin separation evidence. | Verify no user-accessible path exposes management functions. |
| **SC.L2-3.13.4** | Local | Prevent unauthorized or unintended information transfer via shared resources using session isolation, restricted temp/cache handling, and controlled exports. | App design notes, temp storage policy, export controls, test cases. | Evaluate shared storage/session leakage risks in app and DB layers. |
| **SC.L2-3.13.5** | Conditional / Local | If any component becomes publicly accessible, place it on a separated subnetwork; current design avoids public exposure entirely. | Network design, public exposure review, firewall policy. | Maintain explicit prohibition on public exposure; document no-DMZ-needed rationale. |
| **SC.L2-3.13.6** | Local | Deny network traffic by default and allow by exception using host firewall and enclave boundary policy. | UFW rules, network test results, denied connection logs. | Capture actual deny-by-default rule set and egress validation evidence. |
| **SC.L2-3.13.7** | Conditional / Shared | Prevent split tunneling or simultaneous external and enclave connections for remote devices used to access the system. | Remote access policy, VPN/tailnet settings, admin host rules. | Confirm whether enterprise remote access controls satisfy this or if local restrictions are needed. |
| **SC.L2-3.13.8** | Shared | Protect confidentiality of CUI in transit with approved cryptography for HTTPS, LDAPS, SSH, and transport media where used. | TLS/SSH configs, certificates, crypto statement, test results. | Finalize which transports carry CUI and how each is protected. |
| **SC.L2-3.13.9** | Local | Terminate network connections at session end or after defined inactivity for UI and admin sessions. | Session config, timeout tests, SSH keepalive/termination settings. | Align with AC session timeout values and capture evidence. |
| **SC.L2-3.13.10** | Shared | Establish and manage cryptographic keys for certificates, SSH keys, disk/media encryption, and service credentials. | Key management procedure, cert inventory, SSH key records. | Document key lifecycle, rotation, storage, and recovery practices. |
| **SC.L2-3.13.11** | Shared | Employ FIPS-validated cryptography when used to protect confidentiality of CUI. | Crypto implementation statement, module versions, FIPS mode evidence. | This remains a major open item: define actual module/boundary and evidence. |
| **SC.L2-3.13.12** | Conditional / Local | Prohibit remote activation of collaborative computing devices; if none exist, document absence/disablement of microphones/cameras as applicable. | Hardware inventory, service settings, OS/peripheral config. | Confirm whether any collaborative devices exist on the deployed unit. |
| **SC.L2-3.13.13** | Conditional / Local | Control and monitor mobile code such as browser-delivered scripts and any dynamic code content in the UI. | CSP settings, dependency controls, browser/app security config. | Define how mobile code risk is addressed for the Streamlit/nginx interface. |
| **SC.L2-3.13.14** | Conditional / Local | Control and monitor VoIP technologies; preferred baseline is no VoIP capability for this system. | Service inventory, disabled services, network review. | Document VoIP as not used/disabled unless a real use case emerges. |
| **SC.L2-3.13.15** | Local | Protect authenticity of communications sessions using TLS, secure cookies, anti-CSRF/session protections, and SSH integrity features. | App/session config, TLS config, session tests. | Validate Streamlit/nginx session handling against authenticity requirements. |
| **SC.L2-3.13.16** | Local | Protect confidentiality of CUI at rest using full-disk encryption, protected local stores, permissions, and derived CUI handling. | Disk encryption evidence, file/database permissions, derived CUI standard. | Tie all derived stores and backups into one formal at-rest protection statement. |

---

## 16. System and Information Integrity (SI)

| Practice | Applicability / Ownership | Implementation Summary | Evidence / Validation | Current Gap / Action |
|---|---|---|---|---|
| **SI.L2-3.14.1** | Shared | Identify, report, and correct flaws in OS, app stack, containers, models, and supporting services through patching and controlled updates. | Patch records, update SOP, vulnerability tickets, change logs. | Define timely remediation workflow across all stack layers. |
| **SI.L2-3.14.2** | Shared | Provide protection from malicious code at appropriate locations, especially staging/import media, downloaded artifacts, and supporting hosts. | Scan reports, anti-malware tool config, media SOP. | Clarify host anti-malware approach versus staging-only scanning. |
| **SI.L2-3.14.3** | Shared | Monitor security alerts/advisories for OS, Docker, app dependencies, Ollama, PostgreSQL, and related components. | Advisory tracking records, subscription list, review tickets. | Build a regular advisory review process for the AI/application stack. |
| **SI.L2-3.14.4** | Shared | Update malicious code protection mechanisms when new releases are available. | AV/signature update records, scanner update logs. | Document what mechanisms exist and how updates are handled in the enclave. |
| **SI.L2-3.14.5** | Shared | Perform periodic scans and scan files from external sources during intake/open/use as applicable. | Scan schedules, scan reports, imported file scan evidence. | Ensure imported packages/models/media are always scanned before use. |
| **SI.L2-3.14.6** | Shared | Monitor the system, including inbound/outbound communications and policy violations, to detect attacks and indicators of attack. | Logging standard, firewall/audit logs, review records. | Define monitoring thresholds and alerting for unusual extraction or denied-action spikes. |
| **SI.L2-3.14.7** | Shared | Identify unauthorized use through log review, anomaly detection, admin oversight, and incident procedures. | Review records, incident tickets, anomaly reports. | Establish concrete criteria for suspicious NemoClaw usage patterns. |

---

## 17. Summary of Highest-Priority Open Actions

The following items remain the most important before the matrix can be considered assessment-ready:

1. **Finalize the cryptographic implementation statement** for **SC.L2-3.13.11** and related transport/at-rest controls.  
2. **Define exact session timeout, lock, and reauthentication settings** for the UI and admin paths.  
3. **Build the formal retention schedule** for logs, prompts/responses, embeddings, summaries, and exports.  
4. **Stand up the incident response playbook addendum** for AI misuse, prompt injection, and extraction scenarios.  
5. **Document the remote access architecture** and whether wireless/mobile access are prohibited or controlled exceptions.  
6. **Create the production baseline package** covering services, packages, configs, images, models, and security settings.  
7. **Define the monitoring and review workflow** for log failures, suspicious query behavior, export events, and denied sandbox actions.  
8. **Create decommission/sanitization procedures** for removable media and the DGX Spark storage devices.  
9. **Produce concrete evidence artifacts** for app RBAC, logging fields, service bindings, firewall rules, and import approvals.  
10. **Translate inherited controls into explicit local dependency statements** so assessors can see where enclave controls end and NemoClaw-specific controls begin.

---

## 18. Recommended Next Companion Artifact

The next document that should be created from this matrix is:

- `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`

That checklist should convert each control response above into:
- what to inspect
- what to ask
- what to test
- what evidence to request
- what common failures to look for
