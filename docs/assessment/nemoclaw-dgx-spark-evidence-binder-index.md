# NemoClaw on DGX Spark - Evidence Binder Index

**Document Type:** Evidence Binder / Collection Index  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Assessment Lead / Compliance Owner]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This index organizes the evidence that should be assembled to support the NemoClaw DGX Spark CMMC L2 documentation set.

It is intended to help the team answer four practical questions:
1. What evidence do we need?  
2. Where does it come from?  
3. Who owns it?  
4. Which control families or documents does it support?  

---

## 2. Use Instructions

For each evidence item, track:
- **Status**: Not Started / Requested / Collected / Reviewed / Approved
- **Owner**: person or team responsible for producing it
- **Location**: where the artifact is stored
- **Date Collected**: when the artifact was captured
- **Supports**: SSP section, control family, or specific practice(s)

This file is an index, not the evidence repository itself.

---

## 3. Core Documentation Set

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| SSP draft | Compliance / System Owner | Overall system narrative, inherited/local control framing | Draft exists |
| Gap assessment | Compliance / Assessment Lead | Remediation planning, risk prioritization | Draft exists |
| Control matrix | Compliance / Assessment Lead | Practice-by-practice implementation mapping | Draft exists |
| Auditor checklist | Assessment Lead | Readiness testing and audit walkthroughs | Draft exists |
| Derived CUI handling standard | Compliance / Data Owner | AC, MP, SC, AU | Draft exists |
| Logging and review standard | Security Operations | AU, SI | Draft exists |
| Media/model/image intake SOP | Operations / Security | CM, MP, MA, SI | Draft exists |
| AI risk addendum | Security / Risk Owner | RA, CA, SI, SC | Draft exists |
| Incident response playbook addendum | IR Team / Security Operations | IR, AU, SI | To collect / approve |
| Retention and data disposition matrix | Records / Compliance | AU, MP, SC | To collect / approve |
| Cryptographic implementation statement | Security Architecture | SC, IA, MP | To collect / approve |

---

## 4. Architecture and Boundary Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Approved system diagram | Architecture / System Owner | SSP architecture sections, AC, SC | Needed |
| Data flow diagram | Architecture / Compliance | AC.L2-3.1.3, SC family | Needed |
| Boundary definition / asset scoping statement | Compliance / Enclave Owner | SSP boundary, inherited vs local controls | Needed |
| Asset inventory record for DGX Spark | Asset Management | CM.L2-3.4.1, PE family | Needed |
| Service inventory / listen-port capture | System Administrator | SC.L2-3.13.1, CM.L2-3.4.6 | Needed |
| Firewall ruleset capture | System Administrator | SC.L2-3.13.1, SC.L2-3.13.6, AC.L2-3.1.20 | Needed |
| External connection inventory | Architecture / Network Team | AC.L2-3.1.20, SC.L2-3.13.8 | Needed |

---

## 5. Identity, Access, and Session Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| AD/LDAP group mapping for NemoClaw roles | IAM / App Owner | AC family, IA family | Needed |
| MFA configuration evidence | IAM / Security | IA.L2-3.5.2, IA.L2-3.5.3 | Needed |
| UI role/authorization screenshots or config | App Owner | AC.L2-3.1.1, AC.L2-3.1.2 | Needed |
| SSH configuration and admin-account policy | System Administrator | AC, IA, SC | Needed |
| Session timeout / reauthentication settings | App Owner / Security | AC.L2-3.1.10, AC.L2-3.1.11, SC.L2-3.13.9 | Needed |
| Access approval records | IAM / Management | AC.L2-3.1.1, PS family | Needed |

---

## 6. Logging, Monitoring, and Review Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Log source inventory | Security Operations | AU family | Needed |
| auditd configuration and sample output | System Administrator | AU family, SI family | Needed |
| nginx access/error log samples | System Administrator | AU, SC | Needed |
| NemoClaw/OpenClaw application log samples | App Owner | AU, SI | Needed |
| OpenShell deny/allow policy logs | App / Security | AU, SI, RA | Needed |
| Sample correlated user-session reconstruction | Security Operations | AU.L2-3.3.5, auditor walkthrough | Needed |
| Logging review records / tickets | Security Operations | AU.L2-3.3.3, AU.L2-3.3.6 | Needed |
| Alert/failure evidence for logging outage handling | Security Operations | AU.L2-3.3.4 | Needed |
| Time synchronization evidence | System Administrator / Network | AU.L2-3.3.7 | Needed |

---

## 7. Configuration, Hardening, and Vulnerability Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Production baseline package list | System Administrator | CM.L2-3.4.1, CM.L2-3.4.6 | Needed |
| Approved configuration baseline | Security / Operations | CM.L2-3.4.2 | Needed |
| Docker daemon configuration capture | System Administrator | CM family, SC family, POAM-019/020 | Needed |
| Docker administrative access review | System Administrator / Security | AC family, CM family, POAM-019 | Needed |
| Docker runtime inventory package | System Administrator / Assessment Lead | CM family, SC family, SI family, POAM-020 | Needed |
| Approved container image inventory by digest | Operations / Security | CM.L2-3.4.1, SI.L2-3.14.1, POAM-021 | Needed |
| OpenShell policy files and approval history | App Owner / Security | AC, CM, SC | Needed |
| AppArmor profile evidence | System Administrator | CM, SC | Needed |
| UFW rules and verification tests | System Administrator | CM, SC | Needed |
| STIG/SCAP scan results | Security / Operations | CM, CA, RA | Needed |
| Container image scan results | Security / DevSecOps | RA.L2-3.11.2, SI.L2-3.14.1 | Needed |
| Dependency / package vulnerability review | App Owner / DevSecOps | RA, SI | Needed |
| POA&M / remediation tracker | Compliance / Security | CA.L2-3.12.2, RA.L2-3.11.3 | Needed |

---

## 8. Data Handling, Media, and Retention Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Approved storage locations for CUI / derived CUI | System Owner / Compliance | MP family, SC.L2-3.13.16 | Needed |
| Export/download control evidence | App Owner | AC.L2-3.1.3, MP family | Needed |
| Sample marked report/export | Compliance / App Owner | MP.L2-3.8.4 | Needed |
| Media transfer log / custody form | Operations / Security | MP.L2-3.8.5, MP.L2-3.8.6 | Needed |
| Sanitization / decommission procedure and record template | Operations / Asset Management | MP.L2-3.8.3, MA.L2-3.7.3 | Needed |
| Retention schedule approval | Records / Compliance | AU, MP, SC | Needed |
| Backup scope and retention evidence | Infrastructure / Operations | MP, SC, AU | Needed |

---

## 9. Supply Chain and Intake Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Approved intake request ticket | Operations / Requestor | CM, SI, MP | Needed |
| Hash manifest / checksum evidence | Operations / Security | SI, MP, CM | Needed |
| Signature verification evidence where available | Security / Operations | SI, CM | Needed |
| Malware / vulnerability scan evidence for imported artifact | Security | RA, SI, MA | Needed |
| Media ID and custody record | Operations | MP.L2-3.8.5, MP.L2-3.8.6 | Needed |
| Import-side verification record | Import Administrator | SI, CM | Needed |
| Artifact digest/version inventory | Operations / App Owner | CM.L2-3.4.1, SI.L2-3.14.1 | Needed |
| Approved-to-runtime image comparison sheet | Operations / Assessment Lead | CM family, assessor readiness, POAM-020/021 | Needed |

---

## 10. Incident Response, Risk, and Training Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Enterprise IR plan reference | IR Team | IR family | Needed |
| NemoClaw IR playbook addendum approval | IR Team / Security | IR, SI | Needed |
| Tabletop / exercise records | IR Team / Security | IR.L2-3.6.3 | Needed |
| AI risk register entries | Risk Owner | RA family | Needed |
| User training records | Training / Management | AT family | Needed |
| Admin/reviewer role-based training records | Training / Security | AT.L2-3.2.2 | Needed |
| Insider-risk training references | Training / Security | AT.L2-3.2.3 | Needed |

---

## 11. Cryptographic and At-Rest Protection Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| TLS configuration for nginx | System Administrator | SC.L2-3.13.8, SC.L2-3.13.15 | Needed |
| SSH cryptographic configuration | System Administrator | AC remote access, SC family | Needed |
| LDAPS or secure auth-path evidence | IAM / System Admin | IA, SC | Needed |
| Host encryption evidence for protected volumes | System Administrator | SC.L2-3.13.16 | Needed |
| Cryptographic implementation statement approval | Security Architecture | SC.L2-3.13.11 | Needed |
| FIPS validation basis / module evidence | Security Architecture | SC.L2-3.13.11 | Needed |
| Removable-media encryption evidence if used | Operations / Security | MP.L2-3.8.6, SC family | Needed |

---

## 12. Physical and Personnel Evidence

| Evidence Item | Source / Owner | Supports | Status |
|---|---|---|---|
| Facility / room access controls | Facilities / Security | PE family | Needed |
| Device custody / storage assignment | Asset Owner | PE family | Needed |
| Visitor escort / access logs | Facilities / Security | PE family | Needed |
| Personnel screening reference | HR / Security | PS.L2-3.9.1 | Needed |
| Offboarding / deprovisioning record sample | HR / IAM | PS.L2-3.9.2, IA family | Needed |

---

## 13. Priority Collection Order

If the team needs a fast readiness pack, collect these first:

1. System diagram, data flow, and boundary statement  
2. Firewall rules and listening-service evidence  
3. AD/MFA role mapping and session settings  
4. Sample end-to-end user-session log reconstruction  
5. OpenShell policy and app authorization evidence  
6. STIG/SCAP plus container/dependency scan evidence  
7. One complete media/model/image intake package  
8. Host encryption and crypto evidence  
9. IR tabletop / incident handling evidence  
10. Retention schedule approval and media sanitization procedure

---

## 14. Assessment Note

A strong evidence binder for this system should prove not only that controls exist, but that they work together.

For NemoClaw, the highest-value proof is the ability to reconstruct one real user session across:
- authentication
- query submission
- retrieval/file access
- output generation
- export behavior
- logging and review

If the evidence package cannot do that cleanly, the documentation set will still look incomplete even if the policies are well written.
