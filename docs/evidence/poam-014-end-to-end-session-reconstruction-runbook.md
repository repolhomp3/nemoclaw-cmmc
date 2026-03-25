# POAM-014 Runbook - End-to-End Session Reconstruction

**POA&M Item:** POAM-014  
**Objective:** Capture one assessor-usable, end-to-end NemoClaw session that proves the team can reconstruct:
- who authenticated
- what query was submitted
- what files or objects were accessed
- what tools were invoked
- what output was produced
- whether anything was exported
- how logs correlate across layers

---

## 1. Important Scope Note

This runbook must be executed on the **actual target DGX Spark deployment** using a controlled test account and a benign, approved test scenario.

Do not use live sensitive examples if a safe test repository or benign query can prove the control story.

---

## 2. Recommended Test Scenario

Use a single controlled user and a harmless prompt against an approved test repository, for example:
- ask for a high-level explanation of one module
- ask for a file/function summary
- avoid mass export or unusual extraction behavior

The scenario should be simple enough that an assessor can understand it in under five minutes.

---

## 3. Evidence Outputs to Collect

Store sanitized outputs under `docs/evidence/session-reconstruction/` if approved for git; otherwise use the approved internal evidence repository and reference it in the binder index.

Suggested filenames:
- `YYYY-MM-DD-session-scenario-summary.md`
- `YYYY-MM-DD-nginx-access-log-snippet.txt`
- `YYYY-MM-DD-auth-log-snippet.txt`
- `YYYY-MM-DD-app-log-snippet.txt`
- `YYYY-MM-DD-agent-tool-log-snippet.txt`
- `YYYY-MM-DD-output-capture.txt`
- `YYYY-MM-DD-export-log-snippet.txt`
- `YYYY-MM-DD-session-correlation-map.md`

---

## 4. Required Evidence Sources

For one selected session, collect as many of the following as are implemented:
- UI / access log showing request arrival
- authentication or session establishment record
- application event log for query submission
- agent tool-call log showing file reads / retrieval actions
- OpenShell allow/deny trace if available
- output record showing response generation
- export/download log if any export was performed
- relevant host audit log confirming associated activity

---

## 5. Reconstruction Questions the Evidence Must Answer

The final evidence pack must answer all of these clearly:

1. **Who** performed the action?  
2. **When** did it happen?  
3. **What question** was submitted?  
4. **What repository / file / object** was accessed?  
5. **What tools** were invoked?  
6. **What output** was produced?  
7. **Was anything exported or downloaded?**  
8. **How do we know these events are all the same session?**  

If the evidence pack cannot answer those eight questions, the reconstruction story is not ready.

---

## 6. Minimal Reconstruction Workflow

### Step 1: Start with user/session identity
Capture the session or authentication record that identifies the user and timestamp.

### Step 2: Find the incoming request
Capture the nginx or equivalent front-door record for the session.

### Step 3: Capture the application event
Collect the application-side event showing the submitted prompt or normalized request metadata.

### Step 4: Capture tool/retrieval activity
Collect any logs showing:
- file reads
- retrieval operations
- vector lookups
- tool-call sequence

### Step 5: Capture the generated output
Collect the output record or response snippet showing what was returned to the user.

### Step 6: Capture export behavior
If the session involved export/download/print/copy behavior, collect the corresponding event records.

### Step 7: Build the correlation map
Produce a short narrative or table showing how the session IDs, timestamps, user IDs, or request IDs line up.

---

## 7. Suggested Correlation Table

| Layer | Artifact | Key Identifier | Timestamp | Notes |
|---|---|---|---|---|
| Auth / session | [fill] | [fill] | [fill] | [fill] |
| nginx / ingress | [fill] | [fill] | [fill] | [fill] |
| Application | [fill] | [fill] | [fill] | [fill] |
| Agent / tool log | [fill] | [fill] | [fill] | [fill] |
| Output record | [fill] | [fill] | [fill] | [fill] |
| Export log | [fill] | [fill] | [fill] | [fill] |
| Host audit | [fill] | [fill] | [fill] | [fill] |

---

## 8. Assessor Notes

A clean session reconstruction is one of the highest-value evidence artifacts for this system because it demonstrates multiple controls at once:
- AC (authorized access and function use)
- AU (logging completeness and correlation)
- SC/SI (system behavior monitoring)
- derived CUI handling discipline

The evidence does not need to be flashy. It needs to be traceable.

---

## 9. Red Flags During Collection

Treat these as readiness problems if encountered:
- no user identity attached to the query
- file/tool logs exist but cannot be tied to a user session
- timestamps are inconsistent across components
- output records exist but retrieval/file-access records do not
- export/download behavior is possible but unlogged
- app logs are too sparse to explain what happened

---

## 10. Binder Mapping

Update these evidence binder entries after collection:
- sample correlated user-session reconstruction
- nginx access/error log samples
- application log samples
- OpenShell deny/allow policy logs
- auditd configuration and sample output
- export/download control evidence

---

## 11. Closure Criteria for POAM-014

POAM-014 should only be closed when:
1. one controlled session has been fully reconstructed  
2. the reconstruction answers the required questions clearly  
3. the artifact is reviewable by an assessor without extra tribal knowledge  
4. the evidence binder and tracker are updated
