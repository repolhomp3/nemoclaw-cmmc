# NemoClaw on DGX Spark - Approved Container Image Inventory Template

**Document Type:** Template / Procedure Aid  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Version:** Draft v0.1  
**Owner:** [Operations / Security / Configuration Management]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This template provides a practical format for documenting the **approved container image set** for the assessed NemoClaw DGX Spark build.

It is intended to tie each image to:
- approved source and provenance
- immutable digest
- intake and scanning evidence
- runtime use in the assessed build
- baseline configuration references
- any risk acceptance or exception records

The point is to prevent the assessed build from relying on vague statements like “we use the latest approved image.”

For readiness and assessor review, the team should be able to show exactly **which image digests are allowed** and why.

---

## 2. How to Use This Template

Use one row per approved production or assessment-scoped image.

Update this inventory when:
- a new image is introduced
- a digest changes
- a new scan is performed
- an image is removed from the approved set
- a major baseline package update occurs

This template should be maintained together with:
- `docs/procedures/nemoclaw-dgx-spark-media-model-image-intake-sop.md`
- `docs/standards/nemoclaw-dgx-spark-docker-hardening-standard.md`
- `docs/evidence/poam-020-docker-runtime-evidence-runbook.md`
- the production baseline package referenced in the POA&M

---

## 3. Completion Guidance

### Required minimums for approval
Each approved image entry should identify:
- image purpose
- registry/repository source
- tag
- immutable digest
- runtime owner or service owner
- intake request/reference
- scan reference and date
- approval status
- baseline reference

### Do not approve an image based only on:
- a mutable tag with no digest
- a screenshot without source metadata
- “it came with the system”
- informal verbal approval
- stale scan results with no review

### If the image is present on the host but not approved
Mark it clearly as one of:
- **Needs Review**
- **Quarantined**
- **Removal Planned**
- **Not for Assessed Build**

Do not blur that distinction.

---

## 4. Approved Container Image Inventory

| Service / Function | Runtime Need | Repository / Image Name | Source Registry | Tag | Immutable Digest | Container(s) Using Image | Baseline Configuration Reference | Intake Request / Ticket | Hash / Manifest Reference | Vulnerability Scan Reference | Scan Date | Approval Status | Approved By | Exception / Risk Acceptance Reference | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| [Example: NemoClaw UI / app service] | [Required for assessed build] | [registry.example.com/team/nemoclaw-app] | [Approved internal mirror / vendor registry] | [v1.2.3] | [sha256:...] | [nemoclaw-app] | [Baseline package section / file] | [INTAKE-###] | [hash-manifest-2026-..] | [scan-report-###] | [YYYY-MM-DD] | [Approved / Needs Review / Rejected / Retired] | [Name / Role] | [RA-### if applicable] | [free text] |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

---

## 5. Recommended Supporting Tabs or Companion Tables

If the image set grows, split the information into a compact inventory table plus supporting sections.

Suggested supporting sections are below.

### 5.1 Runtime-to-image mapping summary

| Container Name | Purpose | Image Name | Digest | Ports | Major Mounts | Privilege Notes | Runtime Evidence Reference |
|---|---|---|---|---|---|---|---|
| [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [POAM-020 evidence path] |

### 5.2 Image retirement / supersession log

| Old Image / Digest | Replaced By | Removal Date | Approved Change Reference | Notes |
|---|---|---|---|---|
| [fill] | [fill] | [fill] | [fill] | [fill] |

### 5.3 Exception register for approved images

| Image / Digest | Exception Type | Reason | Compensating Controls | Approval Reference | Review Due |
|---|---|---|---|---|---|
| [fill] | [fill] | [fill] | [fill] | [fill] | [fill] |

---

## 6. Field Definitions

### Service / Function
What system function this image supports, such as NemoClaw application, reverse proxy, database, model-serving sidecar, or utility service.

### Runtime Need
Why the image is needed for the assessed build. Avoid vague descriptions.

### Repository / Image Name
The full image repository path or canonical image name.

### Source Registry
The approved registry or mirror from which the image was obtained.

### Tag
The human-readable tag used during intake or deployment.

### Immutable Digest
The authoritative image identifier for approval purposes.

### Container(s) Using Image
The actual running container names or compose service names expected to use the image.

### Baseline Configuration Reference
Where this image is referenced in the baseline package, compose definition, deployment record, or approved build sheet.

### Intake Request / Ticket
The request, change, or intake ID proving the image was formally introduced.

### Hash / Manifest Reference
The stored hash manifest, image archive manifest, SBOM, or similar integrity reference.

### Vulnerability Scan Reference
The report or ticket showing the image was scanned.

### Approval Status
Recommended values:
- Approved
- Approved with Exception
- Needs Review
- Rejected
- Retired

### Exception / Risk Acceptance Reference
Record any approved exception if vulnerabilities, root use, unsupported packages, or other issues remain.

---

## 7. Minimum Review Questions

For each image, reviewers should be able to answer:
- Is this image actually needed for the assessed build?
- Is the source registry approved?
- Do we know the immutable digest?
- Do we have intake and scan evidence?
- Does the runtime evidence show this image is actually what is running?
- Is this the current approved digest, or just a leftover copy on the host?
- Are any exceptions documented and time-bounded?

If the answer to any of those is no, the image is not fully under control.

---

## 8. Sample Filled Entry

| Service / Function | Runtime Need | Repository / Image Name | Source Registry | Tag | Immutable Digest | Container(s) Using Image | Baseline Configuration Reference | Intake Request / Ticket | Hash / Manifest Reference | Vulnerability Scan Reference | Scan Date | Approval Status | Approved By | Exception / Risk Acceptance Reference | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Reverse proxy | Required front-door TLS termination for assessed build | registry.internal.example/platform/nginx | Approved internal mirror | 1.27.0-alpine | sha256:1234exampledigest | nemoclaw-nginx | Baseline package §3.2 / compose file rev 2026-04-01 | INTAKE-042 | HM-2026-04-01-nginx | SCAN-2026-04-01-nginx | 2026-04-01 | Approved | J. Smith / Security |  | Runtime evidence captured in 2026-04-03-docker-runtime-proof |

---

## 9. Storage and Evidence Notes

This inventory template may be stored in Git if it contains only sanitized metadata.

Do not place raw scan reports, full private registry credentials, or sensitive image export bundles in Git unless specifically approved.

If supporting evidence is stored externally, reference it clearly by:
- artifact name
- owner
- date
- approved repository or ticket location

---

## 10. Relationship to CMMC / NIST 800-171 Readiness

This template helps support:
- baseline configuration control
- configuration change review
- least functionality
- vulnerability-management evidence
- supply-chain intake discipline
- assessor understanding of what is actually deployed

For this repo, its main job is simple:

**make the approved Docker image set explicit enough that the team can compare “what should run” to “what is actually running” on the assessed DGX Spark host.**
