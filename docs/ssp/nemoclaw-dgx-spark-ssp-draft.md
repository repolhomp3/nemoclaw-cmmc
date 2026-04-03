# System Security Plan (SSP) Draft
## NemoClaw AI Coding Assistant on NVIDIA DGX Spark

**Organization:** [Contractor Name]  
**System Name:** NemoClaw AI Coding Assistant  
**System Owner:** [Name / Role]  
**Authorizing Official:** [Name / Role]  
**System Location:** [Facility / Room / Enclave]  
**Version:** Draft v0.2  
**Date:** [Insert Date]  
**Security Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Assessment Context:** New in-scope asset entering an existing CMMC Level 2 enclave

---

## Related Documents

This SSP is supported by the following companion documents in this repository:
- `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
- `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
- `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
- `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`

These companion documents provide system-specific detail for derived CUI handling, logging and review, supply-chain/media intake, and AI-specific risk scenarios referenced throughout this SSP.

---

## 1. System Identification and Purpose

NemoClaw is an on-premises AI-assisted coding analysis platform deployed on an NVIDIA DGX Spark system. The system supports software developers performing code analysis, vulnerability investigation, bug research, and developer question answering against approved repositories. NemoClaw operates in a constrained analytical mode and does not autonomously modify production code or deploy changes.

The system is intended to process, store, and display Controlled Unclassified Information (CUI) contained in software source code and CUI-derived artifacts within an existing contractor-managed CMMC Level 2 environment. The system is designed to operate without operational internet access and performs all inference, storage, retrieval, and audit logging locally on the DGX Spark host.

**Applicable controls:**  
- **AC.L2-3.1.1** limit system access to authorized users, processes, and devices  
- **AC.L2-3.1.2** limit system access to authorized transactions and functions  
- **SC.L2-3.13.1** monitor, control, and protect communications  
- **SC.L2-3.13.16** protect the confidentiality of CUI at rest

---

## 2. System Description

The NemoClaw platform consists of a single NVIDIA DGX Spark host running a local web interface, local AI orchestration stack, local large language model inference service, local vector database, and local audit/logging components. Users access the system over the internal LAN using HTTPS. The system authenticates users against the organization’s existing AD/LDAP identity provider with MFA.

### 2.1 Primary functions
- Analyze approved source code repositories
- Answer developer questions using local retrieval and local inference
- Generate summaries and investigation outputs derived from source code
- Maintain auditable records of user access, agent actions, file reads, and outputs

### 2.2 Operational constraints
- No external cloud inference
- No operational internet egress
- Read-only AI access to the approved codebase
- Human review of all outputs before use
- Sandboxed tool access only

---

## 3. System Boundary and Environment

NemoClaw is a **single-node system** located inside an existing CMMC Level 2 enclave. The system is not a standalone greenfield environment; it inherits selected controls from the larger enclave, including enterprise identity, MFA, personnel screening, incident response governance, and existing compliance processes.

### 3.1 In-scope components
The following are within the system boundary because they process, store, transmit, or protect CUI:

- DGX Spark host operating system
- Local encrypted storage
- Docker and NVIDIA Container Toolkit
  - Docker remains the runtime of record for the assessed build and is treated as an explicit in-scope control surface requiring baseline, access restriction, image governance, and runtime proof.
- NemoClaw orchestration components
- OpenClaw agent loop framework
- OpenShell sandbox policy and enforcement
- Ollama inference service
- Nemotron-3-Super 120B model hosting environment
- nomic-embed-text embedding service usage
- PostgreSQL with pgvector
- Streamlit web application
- nginx reverse proxy and TLS termination
- SQLite conversation/history store
- auditd, UFW, AppArmor, fail2ban, and supporting host security services
- administrative SSH access path
- removable media used to load software, models, and updates
- local logs, exported reports, backups, and other derived artifacts containing CUI

### 3.2 External dependencies
The following are outside the local host boundary but are supporting/inherited dependencies:
- Existing AD/LDAP identity provider
- Existing MFA infrastructure
- Existing CMMC enclave policies and procedures
- Approved staging/scanning environment used prior to media transfer into the enclave

**Applicable controls:**  
- **AC.L2-3.1.20** verify and control external system connections  
- **AC.L2-3.1.22** control CUI on publicly accessible systems  
- **SC.L2-3.13.1** protect communications at external and internal boundaries  
- **SC.L2-3.13.8** implement boundary protections

---

## 4. Hardware, Software, and Architecture

### 4.1 Hardware platform
The system runs on an NVIDIA DGX Spark (Founders Edition) with:
- Grace Blackwell GB10 Superchip
- 20-core ARM CPU
- 128 GB unified LPDDR5x memory
- up to 4 TB NVMe storage with hardware self-encryption support
- ConnectX-7 10GbE networking
- Ubuntu 22.04 LTS-based DGX OS

### 4.2 Software stack
Core software components include:
- DGX OS (Ubuntu 22.04 LTS-based)
- NemoClaw
- OpenClaw
- OpenShell
- Ollama
- Nemotron-3-Super 120B
- nomic-embed-text
- PostgreSQL + pgvector
- Streamlit
- nginx
- SQLite
- UFW
- AppArmor
- auditd
- OpenSCAP / SCC
- Docker + NVIDIA Container Toolkit

### 4.3 Listening services
- nginx: `0.0.0.0:443` (internal LAN only)
- Ollama: `127.0.0.1:11434`
- PostgreSQL: `127.0.0.1:5432`
- Streamlit: `127.0.0.1:8501`

No other application services are intended to listen on externally reachable interfaces.

**Applicable controls:**  
- **CM.L2-3.4.1** establish and maintain baseline configurations  
- **CM.L2-3.4.6** employ least functionality  
- **CM.L2-3.4.8** apply deny-by-default / allow-by-exception principles  
- **SC.L2-3.13.1** protect communications  
- **SC.L2-3.13.8** boundary protections

---

## 5. Data Types and Classification

The system processes CUI software source code and generates artifacts derived from that CUI. The organization treats any output generated from CUI source content as CUI unless and until it is formally reviewed and sanitized.

### 5.1 CUI and CUI-derived data
The following are treated as CUI or CUI-derived:
- Source code under `/opt/codebase/`
- Vector embeddings derived from source code
- Module summaries and generated writeups
- Conversation history containing code excerpts or technical analysis
- User prompts and model responses containing source details
- Audit logs containing file paths, code excerpts, prompts, or outputs
- Exported reports or downloaded analysis artifacts

### 5.2 Non-CUI data
The following may be treated as non-CUI unless modified by CUI processing:
- Public base model weights
- Open-source test datasets used outside the enclave
- Generic system metadata not containing CUI

### 5.3 Data-at-rest protection
CUI and CUI-derived data stored on the DGX Spark are protected using layered storage protections including full-disk encryption and access controls. Derived stores such as pgvector, SQLite histories, and local log repositories are included in the protection scope.

**Applicable controls:**  
- **AC.L2-3.1.3** control the flow of CUI  
- **MP.L2-3.8.1** protect media containing CUI  
- **MP.L2-3.8.3** sanitize media before disposal or reuse  
- **SC.L2-3.13.16** protect confidentiality of CUI at rest

---

## 6. Users, Roles, and Privileges

### 6.1 User roles
**Developer**
- Submit code-analysis questions
- View responses and approved retrieval results
- View authorized conversation history
- No administrative privileges

**Administrator**
- Configure system settings and sandbox policies
- Manage services, logs, and user-role mappings
- Perform approved maintenance
- Access privileged audit and configuration data

**Auditor**
- Read-only access to logs, configuration evidence, and scan outputs
- No configuration authority

**Service Accounts**
- Non-interactive accounts for Ollama, PostgreSQL, NemoClaw, and nginx
- No shell access
- Least privilege assigned

### 6.2 Least privilege
Privileges are assigned based on role and limited to the minimum required to perform authorized functions. Administrative functions are separated from general developer use. Service accounts are configured without interactive login ability.

**Applicable controls:**  
- **AC.L2-3.1.1** authorized access  
- **AC.L2-3.1.2** authorized functions  
- **AC.L2-3.1.5** least privilege  
- **AC.L2-3.1.6** use of non-privileged accounts for nonsecurity functions  
- **IA.L2-3.5.1** identify users, processes, devices

---

## 7. Identification and Authentication

Users authenticate to the web application through the organization’s existing AD/LDAP identity provider using LDAPS. MFA is enforced using approved hardware-backed authenticators such as FIDO2 or PIV. Administrative access uses SSH keys and MFA, with password authentication disabled and direct root login prohibited.

Service accounts are non-interactive and are not permitted human login. All user actions are attributable to an authenticated identity.

### 7.1 Authentication requirements
- Developer access requires enterprise identity and MFA
- Admin access requires SSH key-based authentication and MFA
- Auditor access requires controlled read-only authorization
- Service accounts use local service credentials only

### 7.2 Session handling
The system shall enforce session timeout, reauthentication as required for privileged functions, and appropriate session invalidation on logout or inactivity. Final production values shall be defined in the system configuration baseline.

**Applicable controls:**  
- **IA.L2-3.5.1** identify system users and processes  
- **IA.L2-3.5.2** authenticate identities  
- **IA.L2-3.5.3** use MFA for privileged and network access  
- **IA.L2-3.5.7** enforce password complexity where passwords apply  
- **IA.L2-3.5.8** prohibit password reuse where passwords apply  
- **IA.L2-3.5.10** store/ transmit only cryptographically-protected passwords  
- **IA.L2-3.5.11** obscure feedback of authentication information

---

## 8. Access Control and CUI Flow Control

NemoClaw enforces access control through a combination of enterprise identity, role-based authorization, local service bindings, sandbox policies, file permissions, host firewall rules, and audit logging. The AI agent is constrained to read only approved directories and only through approved tools. The agent is not permitted unrestricted shell access, arbitrary process execution, or outbound network access.

### 8.1 Access enforcement
- Access is limited to authorized users on authorized devices within the enclave
- Functions are role-based and constrained by business need
- CUI repositories are read-only to the AI agent
- Sensitive stores are not exposed directly to end users
- Only approved protocols and interfaces are enabled

### 8.2 CUI flow control
CUI is permitted to flow only:
- from approved user sessions into the local application
- from the application to local retrieval/inference/storage components
- back to the authenticated user through the approved UI

CUI is not permitted to flow to public systems or external networks. Export, download, printing, and copy functions must be governed by documented policy and technical restrictions.

### 8.3 Public access prohibition
No system component is intended to be publicly accessible from the internet. The system is intended for internal enclave use only.

**Applicable controls:**  
- **AC.L2-3.1.1** authorized access  
- **AC.L2-3.1.2** authorized functions  
- **AC.L2-3.1.3** control CUI flow  
- **AC.L2-3.1.20** external connections  
- **AC.L2-3.1.22** no public exposure of CUI

---

## 9. Network and Communications Protection

The DGX Spark system is configured to prevent operational internet egress and to limit inbound access to approved internal users over HTTPS. Internal application services are bound to loopback interfaces where feasible. nginx provides TLS termination and reverse proxy functionality for the local application.

### 9.1 Network protections
- Internal LAN access only
- No internet egress during operation
- UFW host firewall restricts inbound and outbound traffic
- Local services bind to `127.0.0.1` where possible
- No host-networked container exposure unless formally approved

### 9.2 Communications security
- HTTPS with TLS 1.3 for developer access
- LDAPS for identity integration
- Loopback-only local service communications where supported
- Cryptographic protections for CUI in transit and at rest must use approved and documented implementations

### 9.3 Boundary protections
The system relies on enclave segmentation plus host-level controls to enforce communication boundaries. Any exception to the no-egress posture must be formally approved, documented, and technically enforced.

**Applicable controls:**  
- **SC.L2-3.13.1** monitor, control, protect communications  
- **SC.L2-3.13.5** separate user and system functionality as appropriate  
- **SC.L2-3.13.8** boundary protections  
- **SC.L2-3.13.11** use FIPS-validated cryptography when protecting CUI  
- **SC.L2-3.13.16** protect CUI at rest

---

## 10. Audit and Accountability

The system generates and retains audit records sufficient to establish who accessed the system, what data was requested, what files were accessed by the AI agent, what outputs were returned, and what administrative actions occurred. Audit records are protected from unauthorized modification and access.

### 10.1 Auditable events
The following events are logged:
- User authentication and session establishment
- Failed authentication events
- Administrative login and privileged actions
- Query submissions
- File read events initiated by the AI agent
- Retrieval and vector search events
- Model request and response metadata
- Output delivery events
- Export/download events
- Configuration changes
- Service failures and audit subsystem failures

### 10.2 Audit record content
Audit records shall include, at minimum:
- User or service identity
- Date and time
- Source system or session identifier
- Event type
- Object accessed
- Outcome or status
- Admin or user action context as applicable

### 10.3 Audit review and protection
Audit logs are stored locally in protected locations with restricted access. Audit review is performed on a defined cadence by authorized personnel. Failures in logging or audit service availability are reported and investigated.

**Applicable controls:**  
- **AU.L2-3.3.1** create and retain audit records  
- **AU.L2-3.3.2** ensure records contain needed content  
- **AU.L2-3.3.3** review and update audited events  
- **AU.L2-3.3.4** alert on audit logging failures  
- **AU.L2-3.3.5** correlate and analyze audit information  
- **AU.L2-3.3.6** provide reduction and reporting as needed  
- **AU.L2-3.3.7** provide authoritative time source support  
- **AU.L2-3.3.8** protect audit information  
- **AU.L2-3.3.9** limit management of audit functions

---

## 11. Configuration Management

The system maintains baseline configurations for the host OS, local services, security tooling, and AI-specific controls. Configuration changes are approved, documented, and auditable. Unauthorized functionality is disabled or prohibited.

### 11.1 Controlled configuration items
At minimum, the following are baseline-controlled:
- OS build and hardening settings
- AppArmor policies
- UFW rules
- auditd rules
- Docker daemon settings
- OpenShell sandbox policy
- nginx configuration
- Streamlit configuration
- Ollama configuration
- PostgreSQL and pgvector configuration
- service account definitions
- model manifests and image digests
- log retention and storage settings

### 11.2 Least functionality
Only required ports, protocols, services, and software are enabled. Shell access is not provided to the AI agent. Unapproved packages, services, and development tools are removed or disabled from the production configuration.

**Applicable controls:**  
- **CM.L2-3.4.1** baseline configurations  
- **CM.L2-3.4.2** security configuration enforcement  
- **CM.L2-3.4.3** change control  
- **CM.L2-3.4.4** impact analysis of changes  
- **CM.L2-3.4.5** access restrictions for change  
- **CM.L2-3.4.6** least functionality  
- **CM.L2-3.4.7** restrict nonessential programs  
- **CM.L2-3.4.8** deny-by-default / allow-by-exception  
- **CM.L2-3.4.9** manage user-installed software

---

## 12. System and Information Integrity

The organization identifies, reports, and corrects flaws affecting the host OS, containers, application stack, and supporting software. Security-relevant updates are staged, scanned, validated, and introduced through approved media handling processes. Anti-malware and integrity controls are implemented to the extent applicable to the deployed platform and media transfer process.

### 12.1 Flaw remediation
Security flaws in the following are tracked and remediated:
- DGX OS packages
- Docker engine and runtime components
- NemoClaw/OpenClaw/OpenShell components
- Python packages and Streamlit dependencies
- nginx
- Ollama
- PostgreSQL and pgvector
- imported container images and model packages

### 12.2 Malicious code and anomaly handling
The system does not permit arbitrary code execution by the AI agent. Imported artifacts are scanned prior to transfer into the enclave. Security personnel investigate anomalous behavior, unauthorized changes, and signs of compromise.

**Applicable controls:**  
- **SI.L2-3.14.1** identify, report, and correct flaws  
- **SI.L2-3.14.2** provide malicious code protection where applicable  
- **SI.L2-3.14.4** update malicious code mechanisms  
- **SI.L2-3.14.5** perform periodic scans where applicable  
- **SI.L2-3.14.6** monitor systems and take action on findings  
- **SI.L2-3.14.7** identify unauthorized use  
- **SI.L2-3.14.8** identify and correct information and system flaws in a timely manner

---

## 13. Risk Assessment

The system is subject to the organization’s enterprise risk management process and includes system-specific risk analysis for AI-assisted processing of CUI. Risk assessments are periodically reviewed and updated when architecture, software, or mission use changes.

### 13.1 AI-specific threat scenarios
The organization recognizes the following AI-relevant risk scenarios:
- Prompt injection via malicious code comments or source artifacts
- Excessive disclosure of CUI in generated outputs
- Derived CUI stored in logs or embeddings without proper safeguards
- Supply-chain compromise of imported model or container artifacts
- Abuse of legitimate user access to extract excessive code
- Misconfiguration of sandbox policy or local service exposure

### 13.2 Risk treatment
These risks are mitigated through sandboxing, access control, audit logging, output handling rules, least privilege, no-egress operation, media control, and incident response procedures.

**Applicable controls:**  
- **RA.L2-3.11.1** periodically assess risk  
- **RA.L2-3.11.2** scan for vulnerabilities  
- **RA.L2-3.11.3** remediate vulnerabilities according to risk

---

## 14. Security Assessment

The system is assessed as part of the organization’s CMMC Level 2 compliance program. Security assessment activities include host hardening validation, vulnerability scanning, configuration review, log review, and technical testing of boundary, access, and audit controls.

### 14.1 Assessment methods
- STIG/SCAP scans of the host OS
- Configuration review of local services and security controls
- Verification of local service bindings
- Verification of firewall rules and egress restrictions
- Review of audit records and time synchronization
- Validation of admin access restrictions
- Testing of session management and MFA
- Review of media transfer and update procedures

### 14.2 Continuous assessment
Significant changes to system architecture, software versions, policies, or AI model handling require review for security impact prior to implementation.

**Applicable controls:**  
- **CA.L2-3.12.1** periodically assess security controls  
- **CA.L2-3.12.2** develop and implement remediation plans  
- **CA.L2-3.12.3** monitor controls on an ongoing basis

---

## 15. Incident Response

The system operates under the organization’s enterprise incident response program, with system-specific procedures for AI-related misuse or anomalous behavior. Security incidents involving suspected CUI disclosure, unauthorized access, logging failure, sandbox escape attempts, or suspicious output generation are reported and handled under approved incident procedures.

### 15.1 System-specific incident scenarios
- Unauthorized access to developer or admin sessions
- Excessive extraction of source content via prompts
- Prompt-injection-driven misuse
- Tampering with sandbox or configuration files
- Logging subsystem failure
- Introduction of malicious software through approved media
- Unexpected external communication attempts

### 15.2 Response expectations
Incidents are documented, investigated, contained, and escalated in accordance with enterprise IR procedures, with local logs preserved as evidence.

**Applicable controls:**  
- **IR.L2-3.6.1** establish incident-handling capability  
- **IR.L2-3.6.2** track, document, and report incidents  
- **IR.L2-3.6.3** test incident response capability

---

## 16. Media Protection

CUI and CUI-derived data on removable media, exported reports, imported update media, and backup media are protected in accordance with enclave media-handling procedures. Media used to introduce models, images, updates, or patches into the enclave are subject to scanning, integrity verification, custody tracking, and controlled storage.

### 16.1 Controlled media types
- External drives used for software/model transfer
- Backup media
- Printed reports containing CUI
- Exported chat transcripts or analysis packages
- Decommissioned NVMe devices

### 16.2 Media sanitization
Media containing CUI are sanitized or destroyed before reuse or disposal in accordance with approved procedures.

**Applicable controls:**  
- **MP.L2-3.8.1** protect media containing CUI  
- **MP.L2-3.8.2** limit access to CUI on media  
- **MP.L2-3.8.3** sanitize media before disposal or reuse  
- **MP.L2-3.8.4** mark media with distribution limitations as required  
- **MP.L2-3.8.5** control transport of media  
- **MP.L2-3.8.6** protect digital media during transport

---

## 17. Maintenance

Only authorized personnel perform maintenance on the DGX Spark system. Maintenance tools and procedures are controlled. Remote maintenance is prohibited unless specifically approved and documented through enclave procedures. Maintenance activities are logged and reviewed.

### 17.1 Maintenance controls
- Authorized staff only
- Approved maintenance tools only
- Recordkeeping for maintenance actions
- Post-maintenance validation of security controls
- Control of diagnostic and removable media

**Applicable controls:**  
- **MA.L2-3.7.1** perform system maintenance  
- **MA.L2-3.7.2** control maintenance tools and techniques  
- **MA.L2-3.7.4** check media with diagnostic/test tools  
- **MA.L2-3.7.5** require supervision/approval of maintenance personnel  
- **MA.L2-3.7.6** maintain maintenance records

---

## 18. Physical Protection

The DGX Spark is a compact desktop device and is treated as a physically controlled computing asset within the enclave. Physical access is restricted to authorized personnel. Because of the device’s size and portability, enhanced custody and storage controls are required.

### 18.1 Physical safeguards
- Located in controlled office/lab space
- Stored in a locked room, cabinet, or other approved enclosure when unattended
- Tracked in asset inventory
- Physical movement requires authorization and custody tracking
- Visitor access is controlled under facility procedures

**Applicable controls:**  
- **PE.L2-3.10.1** limit physical access  
- **PE.L2-3.10.2** protect and monitor physical facility access  
- **PE.L2-3.10.3** escort visitors and monitor activity  
- **PE.L2-3.10.4** maintain physical access logs where applicable  
- **PE.L2-3.10.5** control physical access devices  
- **PE.L2-3.10.6** safeguard alternate work sites if used

---

## 19. Personnel Security and Awareness & Training

Personnel security and general security awareness training are inherited from the organization’s enterprise CMMC program. Local system access is limited to personnel who have completed required onboarding, received applicable training, and been assigned approved roles.

### 19.1 System-specific training topics
In addition to enterprise training, users of NemoClaw receive system-specific guidance on:
- handling AI-derived CUI
- recognizing prompt injection attempts
- restrictions on exports and sharing of outputs
- acceptable use of AI analysis outputs
- incident reporting expectations

**Applicable controls:**  
- **PS.L2-3.9.1** screen individuals before granting access  
- **PS.L2-3.9.2** ensure CUI is protected during personnel actions  
- **AT.L2-3.2.1** ensure users are aware of risks and responsibilities  
- **AT.L2-3.2.2** ensure managers/admins are trained for assigned duties  
- **AT.L2-3.2.3** provide role-based security training where applicable

---

## 20. Inherited Controls

The system inherits portions of the following from the existing CMMC Level 2 enclave:

- Enterprise identity lifecycle management
- MFA infrastructure
- Personnel screening and termination procedures
- Security awareness training baseline
- Incident response program
- Enterprise risk management methodology
- Enterprise physical facility controls
- Organization-wide policy framework
- Existing STIG maintenance program

Where controls are inherited, NemoClaw provides local implementation evidence showing how the inherited control is applied to this specific asset and its users.

---

## 21. AI-Specific Security Considerations

NemoClaw introduces system characteristics not present in traditional application servers. These characteristics are treated as security-relevant and are addressed through technical, procedural, and administrative controls.

### 21.1 Agent access to CUI
The AI agent reads CUI source code under constrained sandbox policy. Agent access is limited to approved directories and approved tool actions. These reads are attributable to authenticated user sessions and logged.

### 21.2 Derived CUI
Outputs, embeddings, summaries, and logs generated from CUI are treated as CUI unless explicitly sanitized. Detailed handling, storage, export, sanitization, and release rules are defined in `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`.

### 21.3 Prompt injection
The organization treats malicious code comments, source artifacts, or user prompts intended to manipulate model behavior as a threat scenario. Mitigations include sandboxing, least privilege, audit logging, user training, and incident procedures. The risk framing for this scenario is expanded in `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`.

### 21.4 Model provenance
Base model weights are public and not automatically treated as CUI. However, model hosting, prompts, outputs, and any future fine-tuned weights derived from CUI remain in scope. If fine-tuning on CUI is introduced, this SSP must be updated.

### 21.5 Cryptographic protections
The system’s draft cryptographic control position for in-transit and at-rest protection is documented in `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`. Final approval of that statement requires host-specific evidence and an approved basis for any claim under **SC.L2-3.13.11**.

---

## 22. Residual Risk Statement

Residual risk remains in the following areas despite implemented controls:
- potential over-disclosure of source content in outputs
- influence attempts through malicious repository content
- concentration of multiple services on a single host
- supply-chain risk associated with imported software, images, and models
- misuse by authorized users beyond intended operational norms

These residual risks are accepted only with documented mitigations, ongoing monitoring, and incident response capability.

---

## 23. Evidence and Supporting Artifacts

The following evidence supports this SSP and shall be maintained:
- network/data flow diagrams
- asset inventory records
- baseline configuration records
- UFW ruleset
- service bind/listen outputs
- OpenShell policy files
- AppArmor profiles
- nginx TLS configuration
- LDAP/MFA integration evidence
- auditd configuration and sample logs
- sample AI activity audit logs
- SCAP/STIG scan results
- vulnerability scan outputs
- media transfer procedure and records
- maintenance logs
- retention/destruction procedures
- incident response playbook addendum
- training records for local users/admins
- approved copies of the companion documents referenced in this SSP
- evidence mapped in `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`

The following repository documents currently serve as the primary supporting artifacts for this draft:
- `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
- `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
- `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
- `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
- `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
- `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
- `docs/standards/nemoclaw-dgx-spark-retention-and-data-disposition-matrix.md`
- `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
- `docs/procedures/nemoclaw-dgx-spark-incident-response-playbook-addendum.md`
- `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`

---

## 24. Open Items / Completion Notes

The following items should be finalized before assessment:
1. Approval of exact retention periods for logs, conversation history, embeddings, exports, backups, and intake artifacts  
2. Approved cryptographic module/boundary statement with host-specific evidence for **SC.L2-3.13.11**  
3. Session timeout and reauthentication settings  
4. Export/download/copy/print restrictions in the UI  
5. Time synchronization source for **AU.L2-3.3.7**  
6. Backup scope, storage location, and encryption method  
7. Physical custody procedure for the DGX Spark device  
8. Approval and exercise of the incident response playbook addendum specific to AI misuse, prompt injection, and extraction scenarios  
9. Formal approval/signature workflow for the companion standards and procedures  
10. Collection of runtime evidence mapped in the evidence binder index
