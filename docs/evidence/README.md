# NemoClaw Evidence Workspace

This directory is for **collected evidence artifacts**, not narrative documents.

Use it to store:
- screenshots
- command outputs
- configuration exports
- sample logs
- scan results
- approved tickets / approval records
- hashed intake records
- marked sample exports
- tabletop outputs

## Recommended subfolders

- `architecture/`
- `identity-access/`
- `logging-monitoring/`
- `configuration-hardening/`
- `media-intake/`
- `incident-response/`
- `retention-disposition/`
- `cryptography/`
- `physical-personnel/`
- `session-reconstruction/`

## Active runbooks and helpers

- `dgx-operator-handoff-note.md`
- `dgx-first-pass-execution-checklist.md`
- `poam-001-crypto-host-evidence-checklist.md`
- `poam-012-no-egress-and-localhost-proof-runbook.md`
- `scripts/poam-012-no-egress-and-localhost-proof.sh`
- `poam-020-docker-runtime-evidence-runbook.md`
- `poam-014-end-to-end-session-reconstruction-runbook.md`

These are the first evidence-capture runbooks and checklists to execute on the actual DGX Spark host. The operator handoff note is the fastest starting point for the person doing the work, the DGX first-pass checklist ties the active evidence tracks together, the POAM-012 script is a read-only helper to collect the baseline command outputs on the target machine, and the POAM-020 runbook adds the Docker-specific runtime proof package needed to show actual daemon, container, image, port, mount, and privilege posture on the assessed build.

## Suggested naming convention

Use a date plus short description, for example:
- `2026-03-25-ss-listen-ports.txt`
- `2026-03-25-ufw-rules.txt`
- `2026-03-25-mfa-login-screenshot.png`
- `2026-03-25-model-intake-hash-manifest.pdf`

## Rules

1. Treat collected evidence as potentially sensitive.
2. Assume many artifacts will contain CUI or derived CUI unless reviewed otherwise.
3. Do not drop raw evidence into random locations in the repo.
4. Prefer stable filenames and keep the evidence binder index updated.
5. If an artifact is too sensitive for git, note its location in the evidence binder index instead of committing it here.

## Important note

This repo can track metadata and selected sanitized evidence, but that does **not** mean all production evidence should automatically be committed to GitHub.

For especially sensitive runtime evidence, the better pattern is often:
- store the real artifact in an approved internal evidence repository
- reference its location, owner, and collection date in the binder index
