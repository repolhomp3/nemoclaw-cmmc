# DGX Operator Handoff Note

**Audience:** The person who will execute the first-pass evidence collection on the actual NVIDIA DGX Spark host.  
**Goal:** Collect initial runtime evidence for the NemoClaw CMMC readiness package without making unapproved configuration changes.

---

## What you are being asked to do

Run the **first-pass evidence collection** on the actual DGX Spark target host for three priority areas:

1. **POAM-012** — prove localhost-only service bindings and no-egress posture  
2. **POAM-001** — collect host-backed cryptographic evidence  
3. **POAM-014** — capture one controlled end-to-end session reconstruction  

This is an **evidence collection task**, not a hardening task.

---

## Start here

Use these documents in this order:

1. `docs/evidence/dgx-first-pass-execution-checklist.md`  
2. `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`  
3. `docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh`  
4. `docs/evidence/poam-001-crypto-host-evidence-checklist.md`  
5. `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`  
6. `docs/assessment/nemoclaw-dgx-spark-session-reconstruction-assessor-walkthrough.md`  
7. `docs/evidence/collection-tracker.md`  
8. `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`

---

## Critical rules

1. **Run this on the actual DGX Spark host**, not on a laptop, staging VM, or documentation machine.  
2. **Prefer read-only collection first.**  
3. **Do not change firewall, SSH, nginx, crypto, or app settings** unless separately approved.  
4. **Do not assume evidence is safe for GitHub.** If in doubt, store it in the approved internal evidence repository and record the location in the tracker/binder.  
5. If you find something surprising, **stop and document it** rather than quietly fixing it mid-capture.

---

## What “good” looks like at the end of the first pass

You should be able to hand back:

- baseline host/network evidence
- listen-port and firewall captures
- localhost-bind validation notes
- first-pass HTTPS / SSH / at-rest crypto evidence
- one controlled session reconstruction evidence pack
- updated evidence tracker entries
- a short findings summary listing confirmed items, unclear items, blockers, and next actions

---

## Minimum command path

### For POAM-012
Run the helper script from the repo root on the DGX host:

```bash
./docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh --outdir <approved-output-path>
```

Only if approved for live testing:

```bash
./docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh --outdir <approved-output-path> --with-egress-tests
```

### For POAM-001
Use the crypto checklist and collect host evidence for:
- nginx / TLS
- SSH
- LDAPS / secure auth path
- at-rest storage protection
- removable-media protection approach
- secret/password handling

### For POAM-014
Use one benign, controlled session and capture:
- auth/session start
- ingress log
- app query log
- tool/retrieval log
- output record
- export/download record if applicable

---

## Stop conditions

Pause and escalate if any of the following happen:
- public egress succeeds unexpectedly
- internal services are not localhost-bound as expected
- the crypto story differs materially from what the SSP currently suggests
- session reconstruction logs are missing or cannot be correlated
- the host under test is not the actual assessed build
- evidence appears too sensitive for the intended storage location

---

## What not to do

Do **not**:
- “clean up” or redact originals before preserving them
- make unapproved remediation changes while collecting baseline evidence
- substitute a different machine because it is more convenient
- mark a POA&M item closed just because you collected some data
- claim SC.L2-3.13.11 is resolved before the crypto worksheet is actually completed and approved

---

## Deliverables back to the team

When you are done, provide:

1. the evidence folder location(s)  
2. the updated `docs/evidence/collection-tracker.md` entries  
3. the updated binder references or external storage references  
4. a short findings summary in this format:

```markdown
# DGX First-Pass Findings Summary

Date:
Host:
Collected by:
Reviewed by:

## Confirmed
- [fill]

## Unclear / Needs follow-up
- [fill]

## Potential blockers
- [fill]

## Recommended next actions
1. [fill]
2. [fill]
3. [fill]
```

---

## Final reminder

The goal of this first pass is to make the package **more honest and more provable**.

If you discover that the current documentation overstates the runtime posture, that is useful. Document it clearly and hand it back. That is better than forcing the evidence to fit the draft.
