# NemoClaw CMMC Documentation Repo

This repository contains draft CMMC Level 2 / NIST SP 800-171 Rev. 2 documentation for **NemoClaw on NVIDIA DGX Spark**.

The document set is being built around a practical sequence:

1. scope the system correctly
2. identify likely gaps
3. draft the SSP
4. add supporting standards, procedures, and risk documents
5. build the control matrix and auditor checklist

## Current document map

### Core assessment documents
- `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
  - prioritized gap assessment for bringing the DGX Spark into an existing CMMC L2 enclave

### SSP
- `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
  - formal SSP draft for the NemoClaw system

### Supporting standards and procedures
- `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
  - handling rules for outputs, logs, embeddings, summaries, and other CUI-derived artifacts
- `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
  - logging coverage, review cadence, retention expectations, and audit protections
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
  - controlled intake procedure for models, images, packages, and updates entering the enclave
- `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`
  - AI-specific threat scenarios and risk treatment expectations

## Suggested reading order

If you are reviewing the package for the first time:

1. `docs/assessment/nemoclaw-dgx-spark-gap-assessment.md`
2. `docs/ssp/nemoclaw-dgx-spark-ssp-draft.md`
3. `docs/standards/nemoclaw-dgx-spark-derived-cui-handling-standard.md`
4. `docs/standards/nemoclaw-dgx-spark-logging-and-review-standard.md`
5. `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
6. `docs/risk/nemoclaw-dgx-spark-ai-risk-addendum.md`

## What still needs to be added

Planned next artifacts:
- control implementation matrix for all applicable NIST SP 800-171 Rev. 2 requirements
- auditor checklist / test procedures
- incident response playbook addendum
- retention schedule and data disposition matrix
- boundary/scoping statement if split out from the SSP
- cryptographic implementation statement for SC.L2-3.13.11

## Status

These are **working drafts**, not final approved policy documents.

They are intended to help:
- structure assessment preparation
- identify missing evidence
- accelerate SSP and control-response development
- prepare for internal review, C3PAO review, or remediation planning
