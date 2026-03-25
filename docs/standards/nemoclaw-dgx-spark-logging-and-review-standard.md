# NemoClaw on DGX Spark - Logging and Review Standard

**Document Type:** Standard  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Security Operations / System Owner]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This standard defines the minimum logging, audit protection, review, retention, and response requirements for NemoClaw on the DGX Spark platform.

The goal is to ensure that security-relevant events, user actions, administrative actions, agent actions, and CUI-related handling events are attributable, reviewable, protected from unauthorized modification, and available for assessment and incident response.

---

## 2. Scope

This standard applies to all components of the NemoClaw system that generate or store security-relevant records, including:
- operating system logs
- auditd records
- authentication records
- nginx access/error logs
- Streamlit application logs
- NemoClaw/OpenClaw orchestration logs
- OpenShell policy enforcement logs
- Ollama service logs
- PostgreSQL logs
- SQLite/application event records
- configuration change records
- export/download records

---

## 3. Logging Principles

1. All security-relevant actions shall be attributable to a user, service account, process, or host.
2. Logs shall contain sufficient context for reconstruction of significant events.
3. Logs containing CUI or CUI-derived content shall be protected as CUI.
4. Access to log data shall follow least privilege.
5. Log review is a required control activity, not passive storage.
6. Failures in logging or audit collection shall be treated as security-relevant events.

---

## 4. Required Event Categories

The following event categories shall be logged where technically feasible.

## 4.1 Authentication and session events
- successful logins
- failed logins
- MFA outcomes where logged by supporting systems
- session creation
- session expiration
- logout events
- account lockouts or authentication errors

## 4.2 Administrative actions
- privileged login attempts
- configuration changes
- service restarts for security-relevant services
- policy changes affecting OpenShell, AppArmor, firewall, or application authorization
- account or role changes
- log retention or deletion actions

## 4.3 User activity events
- query submissions
- project or repository access context
- response generation and delivery events
- export/download/print/copy actions where supported
- feedback or accept/reject actions tied to user identity

## 4.4 Agent and retrieval events
- tool invocation records
- file reads
- directory enumeration where policy treats it as significant
- retrieval requests against vector stores
- prompt assembly events where logged by design
- model request/response metadata sufficient for traceability

## 4.5 System and integrity events
- service failures
- audit subsystem failures
- unexpected listening services
- denied network attempts where available
- denied policy or sandbox actions
- integrity-relevant update/install events

---

## 5. Minimum Audit Record Content

Each audit record shall include, to the extent supported by the generating component:
- timestamp
- user or service identity
- host or system identifier
- session or correlation identifier
- event type
- object or resource accessed
- action performed
- status/outcome
- source IP or interface context where applicable

If a component cannot natively provide all fields, compensating correlation methods shall be documented.

---

## 6. Time Synchronization

The system shall use an approved authoritative time source and maintain synchronized time across system components so records can be correlated during reviews and investigations.

If the authoritative source is inherited from the enclave, the local implementation and synchronization method shall still be documented for the DGX Spark host.

---

## 7. Protection of Audit Information

## 7.1 Access restrictions
Access to raw logs shall be limited to authorized administrators, security personnel, and auditors with approved need.

## 7.2 Storage protections
Logs shall be stored in protected locations using file permissions, role separation, and other integrity controls. Where feasible, append-only or similarly tamper-resistant controls shall be used for critical logs.

## 7.3 CUI handling
Logs that contain prompts, code excerpts, outputs, internal file paths, or technical details derived from CUI shall be treated as CUI.

## 7.4 Administrative separation
Personnel who manage logs should be distinct from general users of the NemoClaw application. Administrative changes to log settings shall themselves be logged.

---

## 8. Review Requirements

## 8.1 Daily or operational review
Operational personnel shall review security-relevant events on an established schedule appropriate to system usage and risk, including:
- authentication anomalies
- failed admin actions
- logging failures
- denied policy events
- suspicious export behavior

## 8.2 Periodic review
A broader periodic review shall assess:
- completeness of event coverage
- adequacy of retention
- repeated anomalous user behavior
- integrity or availability issues in log sources
- whether reviewed events still match current risk scenarios

## 8.3 Triggered review
Immediate review shall occur after:
- suspected incident
- audit subsystem failure
- unauthorized configuration change
- unexpected egress attempt
- suspicious mass-query or extraction behavior
- suspected prompt injection or AI misuse event

---

## 9. Retention

Log retention periods shall be formally defined in the system retention schedule. At minimum, retention shall cover:
- auditd logs
- application and agent logs
- authentication logs
- exported evidence packages
- configuration-change records

Retention shall be long enough to support assessment, investigations, and incident response, while preserving CUI protections throughout the retention period.

---

## 10. Monitoring and Alerting

The system or supporting processes shall identify and escalate significant issues including:
- audit subsystem failure
- repeated failed authentication
- unauthorized privileged access attempts
- changes to key security configurations
- denied sandbox actions suggestive of policy bypass attempts
- unexpected external communication attempts
- unusual output/export patterns

If centralized alerting is inherited from the enclave, the integration for this system shall be documented.

---

## 11. Evidence and Review Records

The organization shall maintain evidence showing that logging and review are active, including:
- sample audit records
- log source inventory
- review checklists or tickets
- alerts and follow-up records
- retention configuration evidence
- access control settings for log stores

---

## 12. Roles and Responsibilities

### System Administrators
- maintain logging configuration
- protect log stores
- document configuration changes

### Security Reviewers
- perform scheduled reviews
- investigate anomalies
- document dispositions and follow-up

### Compliance Team
- verify that logging supports assessment needs
- validate coverage against SSP and control matrix

### Users
- report suspicious behavior or unexpected outputs
- do not tamper with logs or disable logging

---

## 13. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This standard primarily supports:
- **AU.L2-3.3.1** create and retain audit records
- **AU.L2-3.3.2** ensure audit records contain necessary information
- **AU.L2-3.3.3** review and update audited events
- **AU.L2-3.3.4** alert in the event of audit process failure
- **AU.L2-3.3.5** correlate audit review and analysis
- **AU.L2-3.3.6** provide audit reduction and reporting
- **AU.L2-3.3.7** provide authoritative time source support
- **AU.L2-3.3.8** protect audit information and tools
- **AU.L2-3.3.9** limit management of audit functionality
- **SI.L2-3.14.6** monitor systems and take action on findings
- **SI.L2-3.14.7** identify unauthorized use

---

## 14. NemoClaw-Specific Implementation Notes

For NemoClaw on DGX Spark, the audit design should specifically ensure that reviewers can answer:
- who asked the question?
- what code or objects were accessed?
- what tools were invoked?
- what output was generated?
- whether the output was exported?
- whether any policy denied actions occurred?
- whether the action was tied to a privileged change or unusual access pattern?

Reviewers should be able to correlate:
- user session IDs
- agent tool-call logs
- nginx access records
- application event logs
- system audit logs
- database/query records where enabled and appropriate
