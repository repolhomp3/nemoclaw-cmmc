# NemoClaw CMMC Documentation Repo

This repository contains a working CMMC Level 2 / NIST SP 800-171 Rev. 2 documentation and evidence-preparation package for **NemoClaw on NVIDIA DGX Spark**.

It is built for a very specific purpose:

- bring a **new DGX Spark asset** into an **existing CMMC Level 2 enclave**
- document how NemoClaw processes **CUI source code** and **derived CUI artifacts**
- identify likely readiness gaps before formal review
- translate those gaps into concrete remediation and evidence-collection actions
- support internal review, readiness assessment, and eventual auditor / C3PAO preparation

This is not a generic policy repo. It is a **system-specific readiness workbench**.

---

## 1. Current State of the Repo

The repo now contains five layers of material:

1. **Scoping and system narrative**
   - what the system is
   - why it is in scope
   - how it fits into the enclave

2. **Control and assessment artifacts**
   - SSP draft
   - gap assessment
   - control matrix
   - auditor checklist

3. **Supporting standards, procedures, and risk documents**
   - derived CUI handling
   - logging and review
   - media/model/image intake
   - AI risk framing
   - incident response addendum
   - retention/disposition guidance
   - cryptographic implementation statement

4. **Execution and tracking artifacts**
   - POA&M
   - evidence binder index
   - evidence collection tracker

5. **Field-ready evidence collection kit**
   - DGX operator handoff note
   - DGX first-pass execution checklist
   - runbooks for key POA&M items
   - a read-only helper script for POAM-012

The repo is past the “blank template” stage. It is now in the **readiness execution** stage.

---

## 2. What This Repo Is For

Use this repo to:

- prepare the DGX Spark / NemoClaw system for CMMC L2 review
- keep technical, procedural, and assessor-facing artifacts in one place
- convert high-level control language into concrete system actions
- identify where documentation is strong but runtime proof is still weak
- organize evidence collection without pretending draft prose is the same as implementation

Do **not** use this repo to:

- claim final compliance without host evidence
- treat draft narrative as approved policy by default
- store highly sensitive raw evidence in GitHub just because it is convenient
- substitute evidence from a non-DGX system for the real assessed build

---

## 3. Core Assumptions Behind the Package

This documentation set assumes:

- NemoClaw runs on an **NVIDIA DGX Spark**
- the system is being brought into an **existing CMMC Level 2 boundary**, not deployed as a standalone greenfield enclave
- NemoClaw will process **CUI source code** once inside the boundary
- the system also generates **derived CUI** in:
  - prompts/responses
  - summaries
  - embeddings
  - conversation history
  - logs
  - exports and reports
- most internal services other than the intended front-door path should be **localhost-only**
- operational public internet egress is intended to be **blocked** in production use
- identity, MFA, some IR/HR/training/facility controls, and parts of governance are **inherited** from the existing enclave

If those assumptions change, several artifacts in this repo will need to be updated.

---

## 4. Repository Map

## 4.1 Core assessment documents

### `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
Prioritized gap assessment for bringing the DGX Spark into the existing CMMC L2 enclave.

### `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
System-specific control implementation matrix covering the CMMC L2 / NIST SP 800-171 Rev. 2 practices and mapping them to this deployment.

### `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
Assessor-oriented checklist that converts the control matrix into inspection, interview, test, evidence, and red-flag items.

### `docs/assessment/nemoclaw-dgx-spark-session-reconstruction-assessor-walkthrough.md`
A concise walkthrough for validating one end-to-end user session reconstruction in assessor-friendly terms.

### `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
Evidence collection index showing what artifacts should exist, who owns them, and what they support.

### `docs/assessment/nemoclaw-dgx-spark-poam.md`
POA&M translating the open issues into tracked remediation and evidence-collection work.

### `docs/assessment/nemoclaw-dgx-spark-docker-runtime-position.md`
Position note explaining why the readiness path should keep NemoClaw as designed, retain Docker as the runtime of record, and manage Docker explicitly through hardening, evidence, and POA&M closure instead of forcing a late Podman pivot.

---

## 4.2 SSP

### `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
Formal SSP draft for the NemoClaw DGX Spark system.

This is the central narrative document and should remain aligned with:
- the supporting standards/procedures
- the control matrix
- the evidence binder index
- the POA&M

---

## 4.3 Supporting standards and procedures

### `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
Defines how outputs, logs, embeddings, summaries, and other derived artifacts are handled as CUI unless formally sanitized.

### `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
Defines logging expectations, review requirements, retention considerations, and audit protection expectations.

### `docs/standards/nemoclaw-dgx-spark-retention-and-data-disposition-matrix.md`
Defines proposed retention, purge, and disposition rules for source data, derived data, logs, evidence, and related artifacts.

### `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`
Draft cryptographic protection statement and validation worksheet for in-transit and at-rest protection, especially SC.L2-3.13.11.

### `docs/standards/nemoclaw-dgx-spark-docker-hardening-standard.md`
Docker hardening profile for the assessed build covering daemon settings, administrative access, image control, runtime least privilege, ports, mounts, and exception handling.

### `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
Procedure for controlled import of models, images, packages, updates, and related artifacts into the enclave.

### `docs/procedures/nemoclaw-dgx-spark-approved-container-image-inventory-template.md`
Template for maintaining the approved Docker image set by digest and tying each image to intake, scanning, approval, and baseline references.

### `docs/procedures/nemoclaw-dgx-spark-incident-response-playbook-addendum.md`
System-specific IR addendum covering AI misuse, prompt injection, over-disclosure, logging failures, and intake incidents.

### `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`
AI-specific threat/risk framing for prompt injection, derived CUI sprawl, misuse, single-node concentration risk, and supply-chain concerns.

---

## 4.4 Evidence workspace

### `docs/evidence/README.md`
Guidance for how to store evidence artifacts safely and sanely.

### `docs/evidence/collection-tracker.md`
Working tracker for evidence collection status, owner, storage location, and review state.

### `docs/evidence/dgx-operator-handoff-note.md`
One-page handoff note for the person performing first-pass evidence capture on the DGX Spark.

### `docs/evidence/dgx-first-pass-execution-checklist.md`
The first-pass field checklist that ties together the three highest-priority runtime evidence tracks.

### `docs/evidence/poam-001-crypto-host-evidence-checklist.md`
Host-evidence checklist and decision worksheet for closing the cryptographic implementation gap.

### `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`
Runbook for collecting runtime proof of localhost-only internal service bindings and no-egress posture.

### `docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh`
Read-only helper script for POAM-012 evidence collection.

### `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`
Runbook for collecting one end-to-end session reconstruction evidence package.

### `docs/evidence/poam-020-docker-runtime-evidence-runbook.md`
Runbook for collecting Docker runtime evidence from the assessed DGX Spark build, including daemon config, admin access, running containers, image digests, published ports, mounts, and effective privilege posture.

### Evidence subfolders
These are scaffolds for evidence storage and organization:
- `docs/evidence/architecture/`
- `docs/evidence/identity-access/`
- `docs/evidence/logging-monitoring/`
- `docs/evidence/configuration-hardening/`
- `docs/evidence/media-intake/`
- `docs/evidence/incident-response/`
- `docs/evidence/retention-disposition/`
- `docs/evidence/cryptography/`
- `docs/evidence/physical-personnel/`
- `docs/evidence/session-reconstruction/`

---

## 5. Recommended Reading Order

If you are new to the repo, read in this order:

1. `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
2. `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
3. `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
4. `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
5. `docs/assessment/nemoclaw-dgx-spark-poam.md`
6. `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
7. `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
8. `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
9. `docs/standards/nemoclaw-dgx-spark-retention-and-data-disposition-matrix.md`
10. `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`
11. `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
12. `docs/procedures/nemoclaw-dgx-spark-incident-response-playbook-addendum.md`
13. `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`
14. `docs/standards/nemoclaw-dgx-spark-docker-hardening-standard.md`
15. `docs/procedures/nemoclaw-dgx-spark-approved-container-image-inventory-template.md`
16. `docs/evidence/README.md`
17. `docs/evidence/collection-tracker.md`
18. `docs/evidence/dgx-operator-handoff-note.md`
19. `docs/evidence/dgx-first-pass-execution-checklist.md`
20. `docs/evidence/poam-001-crypto-host-evidence-checklist.md`
21. `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`
22. `docs/evidence/poam-020-docker-runtime-evidence-runbook.md`
23. `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`
24. `docs/assessment/nemoclaw-dgx-spark-session-reconstruction-assessor-walkthrough.md`

---

## 6. If You Are the DGX Operator

If you are the person actually collecting runtime evidence on the DGX Spark, start here:

1. `docs/evidence/dgx-operator-handoff-note.md`
2. `docs/evidence/dgx-first-pass-execution-checklist.md`
3. `docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh`
4. `docs/evidence/poam-001-crypto-host-evidence-checklist.md`
5. `docs/evidence/poam-020-docker-runtime-evidence-runbook.md`
6. `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`
7. `docs/evidence/collection-tracker.md`

### The first-pass execution goal
Collect enough real evidence from the actual DGX Spark to meaningfully advance:
- **POAM-001** — crypto host evidence
- **POAM-012** — no-egress / localhost-only proof
- **POAM-020** — Docker runtime proof package
- **POAM-014** — end-to-end session reconstruction

### Important warning
Do **not** silently “fix things while you’re there” unless separately approved.

Baseline evidence first. Changes second.

---

## 7. If You Are the Compliance / Assessment Lead

Your main operating loop should be:

1. review POA&M priorities
2. send the DGX operator with the field kit
3. collect evidence
4. update the evidence tracker and binder index
5. revise the SSP / crypto statement / control matrix only after real findings come back
6. separate:
   - documentation gaps
   - technical gaps
   - approval gaps
   - inherited-control evidence gaps

This repo is designed to make those distinctions visible.

---

## 8. If You Are an Engineer or System Owner Reviewing This Repo

The most important practical truths in this package are:

- **derived CUI is broader than the source repo**
- **runtime proof matters more than polished prose**
- **one clean session reconstruction is worth a lot**
- **crypto/FIPS claims must be specific, not decorative**
- **localhost-only and no-egress posture must be demonstrated, not assumed**

---

## 9. Current Highest-Priority Remaining Work

The biggest remaining tasks are no longer “write another template.” They are:

### 9.1 Approval and decision items
- approve final retention values
- approve the cryptographic implementation position with real host evidence
- approve session timeout / reauthentication values
- approve export/download/copy/print restrictions
- approve physical custody procedures
- approve inherited vs local control boundaries where needed

### 9.2 Runtime evidence items
- collect no-egress / localhost-only evidence from the DGX
- collect actual crypto host evidence
- collect one end-to-end session reconstruction
- collect actual baseline config, logging, identity, scan, and intake records

### 9.3 Documentation tightening after evidence returns
- update the SSP where runtime reality differs from draft assumptions
- update the control matrix where evidence reveals exceptions or new gaps
- update the POA&M with real status, owners, dates, and blockers

---

## 10. What Still Needs to Be Added or Finalized

Potential future additions or cleanups include:
- a standalone boundary/scoping statement if split from the SSP
- a standalone inherited-controls matrix if the enclave owners want one
- finalized named owners, approvers, and dates across the entire package
- sanitized sample evidence bundles once runtime capture is complete
- additional operator scripts if repeatable evidence collection becomes necessary

---

## 11. Evidence Handling Rules

This is worth stating bluntly:

### Not all evidence belongs in GitHub
Some runtime artifacts may contain:
- CUI
- derived CUI
- sensitive host configuration details
- usernames, internal paths, logs, or network details

If an artifact is too sensitive for GitHub:
1. store it in the approved internal evidence repository
2. record its location in `docs/evidence/collection-tracker.md`
3. map it in `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
4. keep the repo reference clean and truthful

### Preserve originals
Do not “prettify” or over-redact the only copy of an artifact before preserving the original in an approved location.

### Do not substitute hosts
Evidence from the wrong machine is worse than no evidence because it creates false confidence.

---

## 12. How to Judge Whether This Repo Is Actually Helping

This repo is doing its job if it helps the team answer questions like:

- What exactly is in scope on the DGX Spark?
- Where does derived CUI live?
- Which controls are inherited and which are local?
- What proof do we still need from the real host?
- What is blocking readiness right now?
- Can we show an assessor one coherent session reconstruction?
- Can we defend the cryptographic story without hand-waving?

If the answer to those questions gets clearer over time, the repo is healthy.

---

## 13. Status

These are still **working drafts**, not final approved policy documents.

But they are no longer just placeholders.

This repo now functions as a:
- readiness package
- remediation tracker
- evidence planning kit
- operator handoff set
- assessor-prep scaffold

The next major value will come from **running the field kit on the actual DGX Spark** and feeding the results back into the repo.
