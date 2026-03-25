# NemoClaw on DGX Spark - Session Reconstruction Assessor Walkthrough

**Document Type:** Assessor Walkthrough  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Assessment Lead]  
**Last Updated:** [Insert Date]

---

## 1. Goal

In one short review, show that the team can reconstruct a single NemoClaw user session from authentication through response generation and any export activity.

This walkthrough is meant to validate that logging and correlation are strong enough for assessor review.

---

## 2. Use Case

Use one controlled, benign test session on the actual DGX Spark deployment.

Recommended scenario:
- one approved user
- one harmless prompt against an approved test repository or low-risk example
- no mass extraction
- no production-sensitive surprise cases

The point is traceability, not drama.

---

## 3. Ask for These Artifacts First

Request these six items for the same session:

1. authentication/session establishment record  
2. nginx or front-door access record  
3. application log entry for the query  
4. agent/tool or retrieval log showing what was accessed  
5. output record showing what the user received  
6. export/download record if any export occurred  

If the team cannot produce those six artifacts for one session, stop and treat it as a readiness gap.

---

## 4. Eight Questions the Team Must Answer

For the chosen session, the team should be able to answer:

1. Who ran the session?  
2. When did it occur?  
3. What prompt or request was submitted?  
4. What repository, file, object, or retrieval context was accessed?  
5. What tools were invoked?  
6. What output was generated?  
7. Was anything exported or downloaded?  
8. How do we know all of those events belong to the same session?  

---

## 5. Five-Minute Walkthrough Flow

### Step 1: Identity
Show the authenticated user and session start.

### Step 2: Ingress
Show the request arriving at the front door (nginx or equivalent).

### Step 3: Application event
Show the application-side record of the submitted request.

### Step 4: Tool / retrieval activity
Show the file reads, retrieval actions, or tool calls associated with the session.

### Step 5: Output and export
Show the returned output and whether it was exported, downloaded, or otherwise persisted.

### Step 6: Correlation
Show the common identifiers or timestamp chain that ties all artifacts together.

---

## 6. Pass / Fail Standard

### Pass
The walkthrough is a pass if:
- the artifacts are attributable to one user/session
- timestamps and identifiers are consistent
- the data access story is understandable
- output and export behavior are visible
- the reviewer does not need tribal knowledge to understand the flow

### Fail
The walkthrough is a fail if any of the following are true:
- no user identity is attached to the query
- file/tool activity cannot be tied to the request
- output exists but access/retrieval evidence does not
- export behavior is possible but unlogged
- the team cannot explain how the records correlate

---

## 7. Red Flags

Watch for these immediately:
- “We know it was probably this user” instead of hard attribution
- timestamps that do not line up across components
- logs that show auth and output but nothing in the middle
- agent actions visible only in debug consoles, not retained records
- session reconstruction that depends on one admin’s memory

---

## 8. Related Artifacts

Use this walkthrough together with:
- `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`
- `docs/assessment/nemoclaw-dgx-spark-auditor-checklist.md`
- `docs/assessment/nemoclaw-dgx-spark-control-matrix.md`
- `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`

---

## 9. Why This Matters

For this system, one clean session reconstruction is one of the best proofs available that multiple controls actually work together:
- access control
- audit and accountability
- monitoring
- derived CUI handling discipline
- incident response readiness

If the team can do this well, the rest of the package becomes much more believable.
