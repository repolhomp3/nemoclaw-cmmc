# NemoClaw CMMC Documentation Repo

This repository contains draft CMMC Level 2 / NIST SP 800-171 Rev. 2 documentation for **NemoClaw on NVIDIA DGX Spark**.

The document set is being built around a practical sequence:

1. scope the system correctly
2. identify likely gaps
3. draft the SSP
4. add supporting standards, procedures, and risk documents
5. build the control matrix and auditor checklist
6. close the biggest assessment holes with IR, retention, crypto, and evidence-binder artifacts

## Current document map

### Core assessment documents
- `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
  - prioritized gap assessment for bringing the DGX Spark into an existing CMMC L2 enclave
- `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
  - control-by-control implementation and gap mapping for the DGX Spark system
- `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
  - assessor-oriented inspection, interview, and test checklist
- `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
  - collection index for evidence needed to support the package

### SSP
- `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
  - formal SSP draft for the NemoClaw system

### Supporting standards and procedures
- `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
  - handling rules for outputs, logs, embeddings, summaries, and other CUI-derived artifacts
- `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
  - logging coverage, review cadence, retention expectations, and audit protections
- `docs/standards/nemoclaw-dgx-spark-retention-and-data-disposition-matrix.md`
  - proposed retention, purge, and disposition rules for CUI, derived CUI, and evidence data classes
- `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`
  - draft cryptographic protection statement and validation worksheet for SC.L2-3.13.11 and related controls
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
  - controlled intake procedure for models, images, packages, and updates entering the enclave
- `docs/procedures/nemoclaw-dgx-spark-incident-response-playbook-addendum.md`
  - incident-response playbook addendum for AI misuse, prompt injection, over-disclosure, and intake incidents
- `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`
  - AI-specific threat scenarios and risk treatment expectations

## Suggested reading order

If you are reviewing the package for the first time:

1. `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
2. `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
3. `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
4. `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
5. `docs/assessment/nemoclaw-dgx-spark-poam.md`
6. `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
7. `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
8. `docs/standards/nemoclaw-dgx-spark-retention-and-data-disposition-matrix.md`
9. `docs/standards/nemoclaw-dgx-spark-cryptographic-implementation-statement.md`
10. `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
11. `docs/procedures/nemoclaw-dgx-spark-incident-response-playbook-addendum.md`
12. `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`
13. `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
14. `docs/evidence/README.md`
15. `docs/evidence/collection-tracker.md`

## What still needs to be added or finalized

The biggest remaining work is no longer document creation from scratch; it is approval, evidence capture, and closing open implementation decisions.

Primary remaining items:
- boundary/scoping statement if split out from the SSP
- approved retention values instead of draft proposed defaults
- approved cryptographic implementation statement backed by real module/version evidence
- evidence collection against the binder index
- system-specific approved values for session timeout, reauthentication, export restrictions, and remote-access posture
- decommission/sanitization procedures and records for media and storage

## Status

These are **working drafts**, not final approved policy documents.

They are intended to help:
- structure assessment preparation
- identify missing evidence
- accelerate SSP and control-response development
- prepare for internal review, C3PAO review, or remediation planning
celerate SSP and control-response development
- prepare for internal review, C3PAO review, or remediation planning
