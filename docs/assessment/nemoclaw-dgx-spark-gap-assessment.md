# NemoClaw on DGX Spark - CMMC L2 Gap Assessment

## 1. Executive judgment

**Assessment:** This system is **viable for CMMC L2 inclusion** if treated as a **new in-scope asset joining an existing assessed enclave**, not as a special “AI exception.”

The control story is strongest where the environment already has:
- inherited enclave governance
- centralized identity
- MFA
- STIG/SCAP process
- no operational internet egress
- local-only inference and storage

The control story is weakest where the system is AI-specific:
- agent reads of CUI source code
- derived CUI in outputs/logs/embeddings
- prompt injection / hostile content handling
- image/model media transfer
- logging completeness and reviewability
- formal configuration control of sandbox policies and AI components

## 2. Scoping position

For CMMC L2, the current basis is **NIST SP 800-171 Rev. 2**. This system should be scoped as an **OSC-operated system that processes, stores, and transmits CUI internally**.

### 2.1 In-scope assets
Treat these as in scope:
- DGX OS host
- Docker + NVIDIA Container Toolkit
- NemoClaw/OpenClaw orchestration
- OpenShell sandbox/policies
- nginx reverse proxy
- Streamlit web UI
- Ollama
- PostgreSQL + pgvector
- SQLite conversation store
- auditd / UFW / AppArmor / fail2ban
- local audit/log storage
- admin SSH path
- LDAPS auth path to existing IdP
- removable media process for loading models/images
- any backup/export location containing derived CUI

### 2.2 Derived CUI position
These should be presumed **CUI or CUI-derived** unless formally sanitized:
- embeddings
- module summaries
- response logs
- conversation transcripts
- cached prompts/responses
- file-read logs containing code excerpts or sensitive paths

That impacts across:
- **AC.L2-3.1.1**, **AC.L2-3.1.2**, **AC.L2-3.1.3**
- **AU.L2-3.3.1** through **AU.L2-3.3.9**
- **MP.L2-3.8.1**, **MP.L2-3.8.3**, **MP.L2-3.8.6**
- **SC.L2-3.13.8**, **SC.L2-3.13.11**, **SC.L2-3.13.16**

## 3. Likely findings by priority

## 3.1 Critical gaps to close before serious assessment activity

### C1. No formal control narrative for AI-specific data handling
The architecture description is strong, but not yet an assessor-grade control narrative for:
- how prompts are classified
- when outputs become CUI-derived
- where outputs/logs are stored
- who can see them
- how long they are retained
- how they are sanitized/exported

**Control impact:**
- **AC.L2-3.1.1** limit access to authorized users
- **AC.L2-3.1.2** limit system access to authorized transactions/functions
- **AC.L2-3.1.3** control CUI flows
- **MP.L2-3.8.1** protect media containing CUI
- **SC.L2-3.13.16** protect confidentiality of CUI at rest

**Fix:** Add a documented “derived CUI handling standard” specific to AI outputs, embeddings, logs, and summaries.

### C2. Audit trail expectations are strong, but evidence standards are not yet defined
Assessors will ask:
- exactly what is logged?
- is user identity attached?
- do logs capture file reads and outputs?
- are timestamps synchronized?
- who reviews logs, how often, and against what criteria?
- how are logs protected from modification?

**Control impact:**
- **AU.L2-3.3.1** create and retain audit records
- **AU.L2-3.3.2** ensure records include needed details
- **AU.L2-3.3.3** review/update logged events
- **AU.L2-3.3.4** alert on audit failures
- **AU.L2-3.3.5** correlate review/analysis
- **AU.L2-3.3.6** reduce/report audit processing failures
- **AU.L2-3.3.8** protect audit information
- **AU.L2-3.3.9** limit management of audit functionality

**Fix:** Define mandatory fields, review cadence, retention, alerting, and tamper protections.

### C3. Prompt injection / malicious code-comment threat model not yet operationalized
This needs to appear in:
- risk assessment
- secure configuration baseline
- incident response scenarios
- admin/user procedures
- test cases

**Control impact:**
- **RA.L2-3.11.1** periodically assess risk
- **RA.L2-3.11.2** scan for vulnerabilities where applicable
- **SI.L2-3.14.1** identify/manage flaws
- **SC.L2-3.13.1** monitor/control/protect communications
- **SC.L2-3.13.8** boundary protections
- **CA.L2-3.12.1** periodic assessments

**Fix:** Add “AI prompt injection via source content” as a named risk scenario with mitigations and verification tests.

### C4. Media-transfer and supply-chain procedures need formalization
The external pull → scan → approved media → hash verify → load air-gapped process should become a controlled procedure with records.

**Control impact:**
- **CM.L2-3.4.1** establish baselines
- **CM.L2-3.4.2** security configuration enforcement
- **CM.L2-3.4.6** least functionality
- **CM.L2-3.4.8** apply deny-by-default/allow-by-exception principles
- **MP.L2-3.8.6** sanitize/protect media
- **SI.L2-3.14.1** remediate flaws

**Fix:** Create a signed intake procedure for container images, model weights, packages, and update bundles.

## 3.2 High-priority gaps

### H1. Session management details are missing
Need explicit settings for:
- timeout / idle logout
- re-authentication for privileged functions
- failed auth handling
- per-user session isolation
- admin vs auditor role separation in UI

**Control impact:**
- **AC.L2-3.1.1**, **AC.L2-3.1.2**, **AC.L2-3.1.5**
- **IA.L2-3.5.1**, **IA.L2-3.5.2**, **IA.L2-3.5.3**, **IA.L2-3.5.7**, **IA.L2-3.5.8**, **IA.L2-3.5.10**, **IA.L2-3.5.11**

### H2. Boundary flow controls for exports are unclear
If users can:
- copy output
- download reports
- export chat history
- print
- upload files
- paste large code blocks back out

then explicit control rules are needed.

**Control impact:**
- **AC.L2-3.1.3** control CUI flows
- **AC.L2-3.1.20** external connections
- **SC.L2-3.13.1**, **SC.L2-3.13.8**

### H3. Retention/destruction rules are not stated
Need defined retention for:
- audit logs
- conversation logs
- embeddings
- summaries
- temporary files
- imported media
- decommissioned NVMe drives

**Control impact:**
- **MP.L2-3.8.3** sanitize media before disposal/reuse
- **AU.L2-3.3.1** retention
- **CM.L2-3.4.1** documented baseline data locations

### H4. Cryptographic compliance evidence is underspecified
“TLS 1.3” and “LUKS + SED” are not enough by themselves. A clear position is needed on what crypto protects CUI and whether it is **FIPS-validated** in the deployed stack.

**Control impact:**
- **SC.L2-3.13.8** data in transit
- **SC.L2-3.13.11** employ FIPS-validated cryptography when used to protect CUI
- **SC.L2-3.13.16** at-rest protection

### H5. Vulnerability management for AI app stack is incomplete
STIG/SCAP helps the host but does not fully cover:
- Streamlit/Python packages
- Docker images
- Ollama packages/runtime
- pgvector/PostgreSQL app-layer vulnerabilities
- nginx configuration drift
- OpenClaw/OpenShell versioning

**Control impact:**
- **SI.L2-3.14.1** identify/report/correct flaws
- **RA.L2-3.11.2** scan for vulnerabilities
- **CM.L2-3.4.1**, **CM.L2-3.4.6**

## 3.3 Moderate gaps

### M1. Portable-device physical protection needs explicit procedure
This is a 1.2 kg cube, not a rack server. Physical security should address:
- cable lock / locked office / locked cabinet
- transport restrictions
- storage when unattended
- admin custody
- labeling / asset inventory

**Control impact:**
- **PE.L2-3.10.1** limit physical access
- **PE.L2-3.10.3** escort/monitor visitors
- **PE.L2-3.10.4** maintain logs where applicable
- **PE.L2-3.10.5** control/manage physical access devices
- **PE.L2-3.10.6** safeguard alternate work sites if relevant

### M2. Maintenance model needs specificity
Define:
- who performs maintenance
- whether remote maintenance is prohibited
- how patches/firmware enter the enclave
- supervision of vendor work
- post-maintenance validation

**Control impact:**
- **MA.L2-3.7.1** perform maintenance
- **MA.L2-3.7.2** provide controls on tools/techniques
- **MA.L2-3.7.4** check media with diagnostic tools
- **MA.L2-3.7.5** require supervision/approval for maintenance personnel
- **MA.L2-3.7.6** timely maintenance records

### M3. Insider misuse via legitimate prompts needs procedure
Even with no shell/network, a user could try to extract excessive code or sensitive summaries.

**Control impact:**
- **AC.L2-3.1.1**, **AC.L2-3.1.2**, **AC.L2-3.1.5**
- **AU.L2-3.3.1**
- **AT.L2-3.2.1**, **AT.L2-3.2.2**

## 4. Inherited vs system-specific control split

### 4.1 Likely inherited from existing CMMC boundary
These are often mostly inherited, but still need DGX-specific evidence:
- **AT** training program
- most of **IR** policy/procedures
- much of **PS** screening/termination
- parts of **PE**
- enterprise **RA** methodology
- enterprise **CA** assessment program
- AD/LDAP identity governance under parts of **IA/AC**
- enclave media-handling policy under **MP**

### 4.2 Must be system-specific for NemoClaw
These cannot be inherited by implication:
- OpenShell policy
- agent tool restrictions
- file-read logging
- prompt/response logging
- output classification handling
- nginx/Streamlit session security
- pgvector protection
- local retention/destruction
- image/model import procedure
- AI-specific risk scenarios
- admin maintenance on the DGX Spark
- UFW/egress enforcement
- localhost-only service bindings

## 5. Recommended remediation sequence

## 5.1 30-day priority plan

### Wave 1: Scope and policy
1. Freeze formal boundary definition for DGX Spark.
2. Publish derived-CUI handling rules.
3. Define retention/destruction matrix.
4. Document media/image/model intake procedure.
5. Add AI-specific threat scenarios to risk register and IR playbooks.

### Wave 2: Technical control hardening
6. Verify all non-nginx services bind only to localhost.
7. Implement/verify deny-by-default host egress and inbound firewall exceptions.
8. Lock OpenShell policies under configuration management.
9. Enable immutable or append-protected audit log handling where feasible.
10. Configure session timeout/re-auth controls in UI/proxy layers.

### Wave 3: Evidence and validation
11. Build evidence list by control family.
12. Run host + container + app vulnerability checks.
13. Execute tabletop for prompt injection / data leakage scenario.
14. Run assessor-style tests against access, logging, and egress.
15. Update SSP with inherited/system-specific split.

## 6. Evidence package to plan now

Collect and maintain:
- system diagram
- data flow diagram
- asset inventory entry
- host hardening baseline
- STIG/SCAP results
- UFW rules
- service bind/listen outputs
- OpenShell policy files
- AppArmor profiles
- nginx TLS config
- LDAP/MFA integration screenshots/config
- auditd rules and sample logs
- sample agent activity logs
- sample per-user query trace
- retention settings/procedures
- media transfer SOP
- vulnerability scan outputs for host and containers
- risk register entries for AI-specific threats
- IR playbook addendum
- admin access procedure
- decommission/sanitization procedure for SED/LUKS/NVMe

## 7. Recommended next documents

Before building the full 110-control matrix, prioritize these five documents:
1. Boundary and scoping statement
2. Derived CUI handling standard
3. Media/model/image intake SOP
4. AI threat/risk addendum
5. Logging and review standard
