# NemoClaw on DGX Spark - Media, Model, and Image Intake SOP

**Document Type:** Procedure / SOP  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Version:** Draft v0.1  
**Owner:** [Operations / Security Owner]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This procedure defines the approved process for introducing software, container images, AI model weights, packages, updates, patches, and related artifacts into the NemoClaw DGX Spark environment.

The objective is to control supply-chain risk, preserve chain of custody, verify integrity, and prevent unauthorized or malicious software from entering the CMMC Level 2 boundary.

---

## 2. Scope

This procedure applies to all imports into the DGX Spark environment, including:
- Docker/container images
- NemoClaw/OpenClaw/OpenShell releases
- Ollama runtime packages
- AI model weights and manifests
- Python packages or application dependencies
- PostgreSQL, nginx, or OS update bundles
- firmware and approved maintenance packages
- security tools and scanning content

---

## 3. Roles and Responsibilities

### Requestor
- identifies the required artifact
- provides business justification
- identifies intended use and target version

### Intake Administrator
- obtains artifacts from approved sources
- records acquisition details
- coordinates scanning and integrity verification
- maintains custody records

### Security Reviewer
- reviews origin, scan results, hashes, signatures, and risk
- approves or rejects intake

### Import Administrator
- transfers approved artifacts into the enclave
- verifies hashes before import
- records final import and installation status

---

## 4. Approved Sources

Artifacts may only be obtained from approved sources, such as:
- vendor-maintained official repositories
- approved internal mirrors
- approved release archives maintained by the organization
- approved source-controlled internal build outputs

Unverified mirrors, personal repositories, ad hoc downloads, or unofficial artifact exchanges are prohibited.

For AI models, source provenance shall be documented, including vendor name, version, acquisition location, and any organization policy constraints such as US-origin requirements.

---

## 5. Intake Workflow Overview

1. Request artifact and document business need.
2. Acquire artifact in the approved staging environment.
3. Record version, source URL/repository, date, and requestor.
4. Verify vendor signatures or checksums where available.
5. Scan artifact using approved security tools.
6. Compute organization-trusted cryptographic hashes.
7. Review results and approve or reject.
8. Transfer approved artifact using approved media.
9. Re-verify hash inside or immediately before import into the enclave.
10. Install/load artifact using approved procedures.
11. Record installation, version, date, and operator.

---

## 6. Required Intake Records

Each intake event shall record at minimum:
- request ID or ticket number
- requestor identity
- artifact name
- artifact type
- version/tag/digest
- source location
- acquisition date/time
- hash value(s)
- signature verification result if available
- scan tools used and results
- security reviewer decision
- media identifier used for transfer
- import date/time
- operator identity
- target host/system
- final disposition (approved/imported/rejected/quarantined)

---

## 7. Security Validation Requirements

## 7.1 Integrity verification
Before transfer into the enclave, the intake administrator shall:
- verify vendor or publisher checksums/signatures when available
- compute a local trusted hash for the final artifact
- store the hash in the intake record

## 7.2 Scanning requirements
Artifacts shall be scanned in the staging environment using approved tools appropriate to the artifact type, such as:
- malware scanning for files and archives
- container image scanning for images
- package vulnerability scanning for dependencies
- software composition or SBOM review where available

## 7.3 Review requirements
The security reviewer shall confirm:
- source legitimacy
- acceptable scan results or documented risk acceptance
- expected versioning and release history
- consistency of hash/signature data
- policy compliance, including source/provenance restrictions

---

## 8. Approved Transfer Media Requirements

Artifacts entering the enclave shall use approved media only. Approved media shall:
- be organization-controlled
- be labeled or uniquely identified
- be protected during transport
- be scanned before use where required
- be sanitized before reuse according to approved procedures

Personal USB drives or untracked transfer devices are prohibited.

---

## 9. Import into the Enclave

Before import, the import administrator shall:
- verify the media identifier matches the intake record
- re-verify the hash of the artifact
- confirm the artifact was approved for import
- confirm destination path and system are correct

After import, the administrator shall:
- record the date/time of import
- record the installed or loaded version
- confirm successful load/install
- retain logs or screenshots of the action where required

---

## 10. Special Requirements for AI Models

For AI model artifacts, intake records shall also document:
- model family and exact version
- source organization/vendor
- provenance chain
- any license restrictions
- whether the model is public base weight, internal derivative, or fine-tuned artifact
- whether policy requires geographic or national-origin restrictions

For NemoClaw, the intake process shall verify that only approved model families are loaded into the DGX Spark environment.

If any future fine-tuned model is trained on CUI, the resulting weights and derivative artifacts shall be treated under the organization’s CUI handling rules.

---

## 11. Special Requirements for Container Images

For container images, intake records shall include:
- image name
- registry/repository source
- tag and immutable digest
- base image lineage if known
- scan results
- configuration deviations from approved baseline

Images shall be loaded by digest where feasible, not by mutable tag alone.

---

## 12. Rejection and Quarantine

Artifacts shall be rejected or quarantined if any of the following occur:
- source cannot be verified
- expected checksum/signature does not match
- malware is detected
- vulnerabilities exceed policy thresholds without approval
- provenance or licensing is inconsistent with policy
- request lacks documented business need

Rejected artifacts shall not be imported. Quarantined artifacts shall be isolated pending security review.

---

## 13. Emergency Intake

Emergency intake is permitted only when approved by designated management and security personnel. Emergency imports shall still require:
- documented justification
- integrity validation
- minimum required scanning
- post-import review
- after-action documentation

Emergency intake shall not bypass recording requirements.

---

## 14. Retention of Intake Records

Intake records, scan outputs, hash logs, and approval decisions shall be retained according to the organization’s record retention schedule and be available for audit.

---

## 15. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This SOP primarily supports:
- **CM.L2-3.4.1** baseline configurations
- **CM.L2-3.4.2** security configuration enforcement
- **CM.L2-3.4.3** change control
- **CM.L2-3.4.4** impact analysis
- **CM.L2-3.4.6** least functionality
- **CM.L2-3.4.8** allow-by-exception / deny-by-default principles
- **MA.L2-3.7.4** check media with diagnostic and test tools
- **MP.L2-3.8.5** control transport of media
- **MP.L2-3.8.6** protect digital media during transport
- **SI.L2-3.14.1** identify, report, and correct flaws
- **RA.L2-3.11.2** scan for vulnerabilities

---

## 16. NemoClaw Implementation Notes

For NemoClaw on DGX Spark, this SOP shall be used for:
- initial loading of approved Docker images
- transfer of Ollama model blobs/manifests
- import of application updates
- security tool content updates introduced by approved media
- approved firmware and maintenance bundles

Associated evidence should include request tickets, hash manifests, scan reports, media IDs, and installation logs.
