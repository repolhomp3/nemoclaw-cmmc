# NemoClaw on DGX Spark - Incident Response Playbook Addendum

**Document Type:** Incident Response Playbook Addendum  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Security Operations / Incident Response Lead]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This addendum extends the organization’s enterprise incident response capability for the NemoClaw DGX Spark deployment.

It addresses system-specific scenarios involving:
- AI-assisted access to CUI source code
- derived CUI in embeddings, logs, prompts, and outputs
- prompt injection and hostile content
- suspicious extraction or over-disclosure behavior
- supply-chain intake concerns for models, images, packages, and update media
- loss of logging visibility or integrity on the single-node host

This document supplements, and does not replace, the organization’s enterprise IR plan.

---

## 2. Scope

This playbook applies to incidents involving:
- the DGX Spark host
- NemoClaw/OpenClaw/OpenShell components
- Ollama, Streamlit, nginx, PostgreSQL/pgvector, and SQLite stores
- removable media used for import/export
- logs, reports, and evidence bundles containing CUI or derived CUI
- administrative and user activities affecting the system

---

## 3. Trigger Conditions

Initiate this playbook when any of the following occur or are suspected:

1. **Prompt injection / hostile content behavior**
   - a code comment, prompt, or retrieved artifact appears to manipulate the agent into unsafe behavior
   - repeated denied agent actions suggest attempted policy bypass

2. **Excessive or suspicious extraction of source content**
   - large or unusual requests for verbatim code
   - repeated export/download activity outside normal patterns
   - signs of unauthorized aggregation of CUI-derived outputs

3. **Unexpected disclosure of derived CUI**
   - summaries, reports, logs, or embeddings exposed to unauthorized users
   - CUI-derived artifacts discovered outside approved storage locations

4. **Unauthorized access or privilege misuse**
   - suspicious user or admin logins
   - unexpected privilege changes
   - unexplained access to logs, export paths, or sensitive stores

5. **Logging failure or audit integrity issue**
   - auditd, app logging, or correlation mechanisms fail
   - logs appear altered, missing, or inaccessible

6. **Supply-chain or media intake issue**
   - checksum mismatch
   - unexpected image/model behavior after import
   - malware or vulnerability concern in imported artifacts

7. **Unexpected communications behavior**
   - attempted or successful outbound communications contrary to production policy
   - new listening service or undocumented connection path

---

## 4. Roles and Responsibilities

### Incident Commander / Security Lead
- declares the incident handling path
- coordinates containment, communications, and escalation
- approves major containment decisions when required

### System Administrator
- preserves host and application state
- executes approved containment actions
- gathers technical evidence from the DGX Spark and supporting systems

### Application Owner / NemoClaw Owner
- explains intended system behavior
- validates whether observed AI output or tool usage is expected
- helps identify affected repositories, users, sessions, and outputs

### Compliance / Records / CUI Authority
- determines impact to CUI handling obligations
- validates whether derived artifacts require additional containment or notification actions
- preserves assessment-relevant records

### Enterprise IR Team
- handles organization-wide escalation, legal/contractual reporting, and broader coordination

---

## 5. Evidence Preservation Priorities

For this system, preserve the following immediately where feasible:
- relevant nginx access/error logs
- Streamlit application logs
- NemoClaw/OpenClaw orchestration logs
- OpenShell deny/allow logs or policy traces
- auditd records and authentication logs
- PostgreSQL/SQLite records relevant to the event
- export/download records
- current firewall and listening-service state
- hashes, manifests, and intake records for recently imported artifacts
- screenshots or copies of suspicious prompts, responses, or generated reports
- user/session identifiers associated with the event

**Important:** Treat preserved prompt/response material and related logs as CUI or derived CUI unless explicitly sanitized.

---

## 6. Incident Categories and Response Actions

## 6.1 Prompt Injection / Hostile Content Event

### Indicators
- responses begin following instructions embedded in code comments or retrieved text rather than user intent/policy
- unusual attempts to access restricted files or tools
- spikes in denied policy actions from OpenShell
- outputs that include unusual operational instructions or attempts to elicit secret/system data

### Immediate actions
1. Identify affected user session(s), repository/retrieval context, and timestamps.
2. Preserve prompt, retrieval context, tool logs, and output.
3. Determine whether any restricted action was attempted or completed.
4. Temporarily suspend affected user session(s) if needed.
5. Consider disabling access to the affected repository, branch, or dataset until reviewed.
6. Open an incident ticket and link all relevant evidence.

### Containment questions
- Did the agent attempt prohibited actions?
- Did any CUI-derived output leave approved channels?
- Was the event isolated to one session or reproducible across users?

### Recovery / follow-up
- update risk register and prompt-injection test cases
- refine sandbox or retrieval policy if needed
- add user/admin awareness notes if behavior exposed training gaps

---

## 6.2 Excessive CUI Extraction / Over-Disclosure Event

### Indicators
- large code dumps in responses
- unusual frequency of export/download actions
- user behavior inconsistent with role or project need
- generated reports containing more detail than expected

### Immediate actions
1. Preserve all related session, export, and audit records.
2. Determine scope of data exposed: code, summaries, logs, reports, embeddings, or backups.
3. Suspend export capability for the user/session if required.
4. Notify compliance/CUI authority to assess disclosure impact.
5. Identify whether the issue was user-driven, model-behavior-driven, or policy/configuration-driven.

### Containment questions
- Was the user authorized for the underlying repository but not the volume or form of disclosure?
- Did the output reach removable media, printed reports, or other systems?
- Are there additional derived copies to quarantine or delete?

### Recovery / follow-up
- tune export restrictions and output review rules
- adjust retention/disposition actions for affected artifacts
- update acceptable-use training and monitoring thresholds

---

## 6.3 Logging Failure / Loss of Audit Integrity

### Indicators
- auditd stopped or unhealthy
- app logging stops unexpectedly
- correlation identifiers disappear across components
- logs missing, rotated unexpectedly, or altered without change records

### Immediate actions
1. Preserve current system state and service status.
2. Capture service health and configuration state.
3. Determine exact window of lost or suspect logging.
4. Restrict changes to the affected system until logging integrity is restored or exception approved.
5. Escalate to security lead if the visibility gap prevents reliable incident determination.

### Containment questions
- Did the failure affect only one source or all sources?
- Can unaffected logs reconstruct critical activity during the gap?
- Was the failure accidental, capacity-related, or malicious?

### Recovery / follow-up
- restore logging and validate end-to-end event capture
- document root cause and impact window
- consider compensating controls or expanded review after recovery

---

## 6.4 Supply-Chain / Media Intake Incident

### Indicators
- hash mismatch during import
- signature mismatch or missing provenance
- malware or severe vulnerability findings in imported artifact
- unexpected behavior after loading a model/image/package

### Immediate actions
1. Stop use of the affected artifact.
2. Preserve the artifact, intake record, scan output, and hash/signature records.
3. Identify all systems, containers, or services that used the artifact.
4. Quarantine or remove the artifact per approved process.
5. Review related imports for similar provenance or version risks.

### Containment questions
- Was the artifact imported into production or only staging?
- Did any output or system behavior indicate malicious execution?
- Are there dependent images, packages, or models that require rollback?

### Recovery / follow-up
- reload last known-good artifact
- revise intake controls if procedural weakness is found
- update vulnerability and configuration baselines

---

## 6.5 Unexpected Communications / Exposure Incident

### Indicators
- outbound connection attempts from a system expected to have no egress
- new listening port or service
- access from unauthorized network segments
- reverse-proxy or firewall changes outside process

### Immediate actions
1. Capture firewall state, network connections, and listening services.
2. Preserve relevant logs and recent change records.
3. Block the communication path if not already denied.
4. Determine whether the path was temporary admin activity, misconfiguration, or compromise.
5. Review recent changes to nginx, firewall, Docker, or host networking.

### Recovery / follow-up
- restore approved deny-by-default posture
- validate no residual egress or public exposure remains
- update monitoring to catch recurrence

---

## 7. Triage Questions for First Review

For any incident involving NemoClaw, answer these first:
1. Which user, service account, or admin identity was involved?
2. Which repositories, files, outputs, or logs were touched?
3. Did the event involve source CUI, derived CUI, or both?
4. Did any artifact leave approved storage or approved channels?
5. Were any restricted actions attempted or blocked?
6. Was the issue caused by user behavior, configuration, imported artifact, or platform behavior?
7. What is the earliest reliable timestamp and last known good state?

---

## 8. Containment Options

Depending on severity and business impact, containment may include:
- terminating or isolating user sessions
- temporarily disabling exports/downloads
- disabling access to a specific repository or dataset
- reverting to a last-known-good model/image/package
- tightening firewall/network rules
- disabling a vulnerable or suspect service
- freezing further imports from a suspect source
- restricting admin access to break-glass responders only

Containment decisions should be documented with time, approver, rationale, and expected rollback/recovery path.

---

## 9. Recovery Validation Checklist

Before returning the system to normal operations, verify:
- logging is complete and functioning
- firewall/listening-service posture matches approved baseline
- suspect artifacts are removed or quarantined
- affected accounts are reset/disabled as needed
- export restrictions and access controls are back in intended state
- no unmanaged copies of CUI-derived data remain in temporary or export locations
- lessons learned and corrective actions are recorded

---

## 10. Communications and Reporting

This playbook does not replace enterprise legal, contractual, or regulatory reporting requirements. Incident reporting outside the local team shall follow the organization’s approved IR escalation path.

At minimum, local records should capture:
- incident ID / ticket
- time discovered
- discovering party
- affected users/systems/data classes
- containment actions
- evidence preserved
- disposition and lessons learned

---

## 11. Testing and Exercises

The organization should exercise this addendum using scenarios such as:
- prompt injection via code comment
- excessive export of CUI-derived report content
- imported model artifact with failed hash verification
- loss of auditd visibility during active use
- unauthorized attempt to enable outbound access

Results should feed:
- IR improvement actions
- control matrix updates
- monitoring thresholds
- user/admin training updates

---

## 12. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This addendum primarily supports:
- **IR.L2-3.6.1** establish incident-handling capability
- **IR.L2-3.6.2** track, document, and report incidents
- **IR.L2-3.6.3** test incident response capability
- **AU.L2-3.3.1** retain relevant audit records
- **AU.L2-3.3.5** correlate audit information
- **SI.L2-3.14.6** monitor systems and take action on findings
- **SI.L2-3.14.7** identify unauthorized use
- **RA.L2-3.11.1** assess risk periodically

---

## 13. NemoClaw-Specific Notes

For this system, the fastest useful incident reconstruction usually requires correlating:
- nginx access logs
- user identity / session records
- Streamlit/NemoClaw application logs
- OpenShell tool and deny logs
- host audit/authentication logs
- export/download records
- intake records for any recently changed model/image/package

If those cannot be correlated for a suspected incident, the system should be treated as not yet operationally ready from an IR perspective.
