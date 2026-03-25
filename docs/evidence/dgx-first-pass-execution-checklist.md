# DGX Spark First-Pass Evidence Execution Checklist

**Purpose:** Provide a practical, first-pass field checklist for collecting the initial runtime evidence needed to advance the highest-priority NemoClaw POA&M items on the actual DGX Spark host.

**Primary POA&M items covered:**
- **POAM-001** — cryptographic host evidence
- **POAM-012** — no-egress and localhost-only service proof
- **POAM-014** — end-to-end session reconstruction

---

## 1. Scope and Ground Rules

This checklist is intended for execution on the **actual DGX Spark target host** and its associated approved admin workstation, not on a documentation laptop or an arbitrary staging machine.

### Do not use this checklist on:
- a developer laptop
- a documentation workstation
- a test VM with different package versions
- any system that is not the assessed DGX Spark deployment

### Ground rules
1. Prefer **read-only collection first**.
2. Do not change firewall, SSH, crypto, or app settings while gathering baseline evidence unless separately approved.
3. Save evidence in approved locations only.
4. Assume many artifacts may contain sensitive information or derived CUI.
5. If an artifact is too sensitive for GitHub, store it in the approved internal evidence repository and record its location in the binder index / collection tracker.

---

## 2. What This First Pass Should Produce

At the end of this first pass, the team should have:
- host/network baseline outputs
- initial no-egress / localhost-binding evidence
- first-pass crypto evidence captures
- one planned path for a controlled end-to-end session reconstruction
- updated evidence tracker and binder entries
- POA&M items that can move from generic “In Progress” to evidence-backed follow-up work

---

## 3. Suggested Roles for the First Pass

| Role | Responsibility |
|---|---|
| System Administrator | Runs host commands and captures configuration/runtime evidence |
| App Owner / NemoClaw Owner | Explains app behavior, log locations, and session flow |
| Security / Compliance Reviewer | Verifies evidence quality and updates tracker / binder |
| Optional Witness / Assessor Prep Lead | Confirms evidence is understandable to an outsider |

---

## 4. Pre-Flight Checklist

Before collecting anything:

- [ ] Confirm you are on the correct DGX Spark host.
- [ ] Confirm output storage location is approved.
- [ ] Confirm whether live egress tests are approved.
- [ ] Confirm whether sanitized evidence may be placed in this repo.
- [ ] Confirm sudo/root access availability for read-only inspection.
- [ ] Open these documents side-by-side:
  - `docs/assessment/nemoclaw-dgx-spark-poam.md`
  - `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`
  - `docs/evidence/collection-tracker.md`
  - `docs/evidence/poam-001-crypto-host-evidence-checklist.md`
  - `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`
  - `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`

---

## 5. Execution Order

## Step 1 - Create a dated evidence working folder

Create a folder either in the approved internal evidence repository or, if sanitized and approved, under the local repo evidence tree.

Suggested naming:
- `YYYY-MM-DD-dgx-first-pass/`

Record the chosen location in:
- `docs/evidence/collection-tracker.md`
- the evidence binder index if stored externally

---

## Step 2 - Run POAM-012 baseline capture first

Start with the network/bind posture because it gives the fastest hard proof.

### Primary document
- `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`

### Helper script
- `docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh`

### Recommended first command
```bash
./docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh --outdir <approved-output-path>
```

### Only if approved for live testing
```bash
./docs/evidence/scripts/poam-012-no-egress-and-localhost-proof.sh --outdir <approved-output-path> --with-egress-tests
```

### First-pass success criteria
- [ ] listening services captured
- [ ] firewall state captured
- [ ] route/interface state captured
- [ ] OpenClaw status captured
- [ ] localhost-bind validation template filled in enough to identify pass/fail questions
- [ ] any surprising listeners or successful egress paths flagged immediately

### Immediate follow-up
Update:
- evidence tracker
- binder entries for listen ports, firewall rules, external connections, OpenClaw status

---

## Step 3 - Collect POAM-001 crypto evidence next

Once host/network baseline is captured, move to the cryptographic evidence worksheet.

### Primary document
- `docs/evidence/poam-001-crypto-host-evidence-checklist.md`

### Focus areas for first pass
- HTTPS / nginx crypto evidence
- SSH crypto evidence
- LDAPS or secure auth path evidence
- at-rest storage encryption evidence
- removable media crypto/protection approach
- secret/password handling evidence

### First-pass evidence captures to prioritize
```bash
date -Is
hostnamectl
uname -a
cat /etc/os-release
nginx -V
sudo nginx -T
openssl version -a
sshd -T
ssh -V
lsblk -o NAME,FSTYPE,MOUNTPOINT,TYPE,SIZE
sudo blkid
mount
```

If applicable and approved:
```bash
sudo cryptsetup status <mapped-device>
```

### First-pass success criteria
- [ ] exact TLS/SSH stack versions identified
- [ ] at-rest protection mechanism identified
- [ ] primary vs supplemental crypto story starts to become clear
- [ ] SED is not being casually treated as a complete compliance claim without evidence
- [ ] the team can name what still requires architecture/security approval

### Immediate follow-up
Update:
- crypto checklist
- cryptographic implementation statement
- evidence tracker
- binder entries for TLS, SSH, LDAPS, storage encryption, and FIPS-basis evidence

---

## Step 4 - Plan and execute one controlled POAM-014 session

Do this after the host baseline and crypto captures, so the team already understands the environment and log sources.

### Primary documents
- `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md`
- `docs/assessment/nemoclaw-dgx-spark-session-reconstruction-assessor-walkthrough.md`

### Controlled scenario guidance
Use:
- one approved user
- one benign prompt
- one approved test repository or low-risk example
- no mass extraction
- no unnecessary production-sensitive content

### Minimum artifacts to collect
1. auth/session establishment record  
2. nginx/front-door access record  
3. application log entry for the query  
4. tool/retrieval/file-access evidence  
5. output record  
6. export/download record if applicable

### First-pass success criteria
- [ ] one session can be tied to one user
- [ ] the request path is understandable across layers
- [ ] tool/file access is visible
- [ ] output is visible
- [ ] export behavior is visible or explicitly absent
- [ ] correlation method is documented in a short table or narrative

### Immediate follow-up
Update:
- session reconstruction evidence folder
- evidence tracker
- binder entries for session reconstruction, logs, exports, and audit correlation

---

## Step 5 - Review findings before changing anything

After the first pass, stop and review before making config changes.

### Ask these questions
- Did we find unexpected listeners?
- Did any egress test succeed unexpectedly?
- Do we now know the real crypto story, or just parts of it?
- Can we reconstruct a session, or do the logs still break in the middle?
- What is a documentation gap versus a real technical gap?

This prevents evidence collection from quietly turning into unsanctioned hardening.

---

## 6. Deliverables to Hand Back After the First Pass

At the end of the run, produce:

1. **Captured output folder(s)** for POAM-012 and POAM-001  
2. **One session reconstruction evidence pack** for POAM-014  
3. **Updated `docs/evidence/collection-tracker.md`**  
4. **Updated binder index references**  
5. **Short findings summary** listing:
   - confirmed controls
   - unclear areas
   - likely blockers
   - next actions

---

## 7. Minimum Findings Summary Template

Use this format after the first pass:

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

## 8. Stop Conditions

Pause and escalate if any of the following happen:
- unexpected public egress succeeds
- sensitive evidence appears unsafe to store in the planned location
- encryption posture is not what the SSP currently claims
- required logs do not exist for session reconstruction
- the host being tested is discovered not to match the intended assessed build

---

## 9. What Not to Do During This First Pass

Do **not**:
- change firewall rules on the fly
- tweak nginx/SSH settings mid-capture
- “clean up” evidence before preserving originals
- claim SC.L2-3.13.11 is satisfied before the crypto worksheet is actually completed
- use a nicer-looking non-DGX machine as a stand-in

---

## 10. Recommended Next Step After This Checklist

Once the first pass is complete, the next best move is to convert the findings into:
- POA&M status updates
- concrete remediation tickets
- targeted evidence recapture where needed
- a short assessor-ready summary of what is already proven versus still pending
