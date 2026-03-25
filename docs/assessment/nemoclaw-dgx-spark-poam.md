# NemoClaw on DGX Spark - POA&M

**Document Type:** Plan of Action & Milestones (POA&M)  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [System Owner / Compliance Owner]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This POA&M converts the current NemoClaw DGX Spark documentation set into a tracked remediation and readiness plan.

It is intended to:
- turn open SSP items into discrete action items
- assign ownership and target dates
- connect gaps to relevant CMMC / NIST SP 800-171 Rev. 2 practices
- track evidence needed for closure
- distinguish between **document completion**, **control implementation**, and **evidence collection**

---

## 2. Status Definitions

- **Open** — identified but not yet started
- **In Progress** — active work underway
- **Blocked** — requires external decision, owner input, or inherited-control evidence
- **Ready for Review** — work completed and awaiting approval or validation
- **Closed** — approved, implemented, and evidenced

---

## 3. Priority Definitions

- **Critical** — likely assessment blocker or major control weakness
- **High** — strong candidate for finding if left unresolved
- **Medium** — should be resolved for a clean readiness package
- **Low** — useful hardening/documentation improvement but not immediate blocker

---

## 4. POA&M Items

| ID | Title | Priority | Type | Related Practices / Families | Current Gap | Planned Action | Owner | Target Date | Evidence Needed | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| POAM-001 | Finalize cryptographic implementation statement | Critical | Decision + Evidence | SC.L2-3.13.8, SC.L2-3.13.11, SC.L2-3.13.16, IA.L2-3.5.10 | Current crypto document is still a draft worksheet and not a final host-backed claim | Identify exact deployed crypto modules/versions, confirm approved/FIPS basis, collect host evidence, approve final statement | [Security Architecture] | [TBD] | Module/version evidence, TLS/SSH configs, storage encryption proof, approved architecture decision | Open |
| POAM-002 | Approve retention values and disposition rules | Critical | Decision + Policy | AU.L2-3.3.1, MP.L2-3.8.1, MP.L2-3.8.3, SC.L2-3.13.16 | Retention matrix uses proposed defaults, not approved enterprise values | Review with compliance/records owner, reconcile with enterprise schedule, approve final values | [Compliance / Records Owner] | [TBD] | Signed retention matrix, backup retention mapping, exception process | Open |
| POAM-003 | Define session timeout and reauthentication values | High | Implementation + Evidence | AC.L2-3.1.10, AC.L2-3.1.11, SC.L2-3.13.9 | SSP references session controls but exact values are not finalized | Set approved timeout/re-auth values, implement in app/proxy/admin paths, validate behavior | [App Owner / Security] | [TBD] | Config screenshots, test results, policy reference | Open |
| POAM-004 | Define export/download/copy/print restrictions | Critical | Policy + Implementation | AC.L2-3.1.3, MP family, SC family | Export handling is described but not fully pinned down in approved settings and tests | Decide allowed export functions, implement restrictions/logging, test and document behavior | [System Owner / App Owner] | [TBD] | UI configuration, test evidence, export logs, approved policy | Open |
| POAM-005 | Document authoritative time source | High | Evidence | AU.L2-3.3.7 | Time synchronization requirement is referenced but exact source/method not finalized in evidence | Record enclave time source, host config, and cross-component validation method | [System Administrator / Network Team] | [TBD] | NTP/chrony config, sync status, architecture note | Open |
| POAM-006 | Finalize backup scope and protection statement | High | Decision + Evidence | SC.L2-3.13.16, MP family, AU.L2-3.3.1 | Backup handling is referenced but scope, retention, and encryption details are not fully captured | Document what is backed up, where, how it is encrypted, how deletion ages out, and who can access it | [Operations / Infrastructure] | [TBD] | Backup config, retention settings, encryption evidence, access controls | Open |
| POAM-007 | Approve physical custody procedure for DGX Spark | High | Procedure | PE family, MP.L2-3.8.5, MA.L2-3.7.3 | Portable-ish form factor increases custody risk; procedure not yet finalized | Define storage, movement authorization, custodian roles, and relocation logging | [Facilities / Asset Owner] | [TBD] | Custody procedure, room/cabinet controls, movement log template | Open |
| POAM-008 | Exercise and approve IR playbook addendum | High | Procedure + Test | IR family, AU family, SI family | IR addendum exists but has not yet been approved or exercised | Run tabletop for prompt injection / extraction / logging loss scenarios, update and approve playbook | [IR Lead / Security Operations] | [TBD] | Tabletop output, updated playbook, approval record | Open |
| POAM-009 | Build runtime evidence against evidence binder index | Critical | Evidence | Cross-family | Documentation set is strong, but runtime evidence has not yet been collected | Collect actual host, network, identity, logging, scan, and intake evidence into evidence workspace | [Assessment Lead / Multiple Owners] | [TBD] | Completed evidence binder entries and collected artifacts | In Progress |
| POAM-010 | Finalize inherited vs local control statements | High | Documentation | AC, IA, IR, PE, PS, RA, CA | Some inheritance is described, but assessor-facing dependency boundaries still need sharper wording/evidence | Produce explicit inherited-control mapping with enclave owner references | [Compliance / Enclave Owner] | [TBD] | Inheritance matrix, boundary statement, owner signoff | Open |
| POAM-011 | Build production configuration baseline package | Critical | Configuration | CM family, SC family, SI family | Baseline concepts exist, but production build package is not yet assembled as one authoritative artifact | Create baseline package covering packages, services, ports, configs, images, models, and hardening settings | [System Administrator / Security] | [TBD] | Baseline inventory, signed config set, scan snapshots | Open |
| POAM-012 | Validate no-egress and localhost-only service posture | Critical | Test + Evidence | SC.L2-3.13.1, SC.L2-3.13.6, AC.L2-3.1.20, CM.L2-3.4.6 | Architecture claims no-egrress/local-only posture; runtime proof still needed | Capture listen-port and firewall evidence, test blocked outbound paths, confirm local service binds. Use `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md` on the target DGX Spark host. | [System Administrator] | [TBD] | `ss` output, UFW rules, test results, denied connection evidence | In Progress |
| POAM-013 | Finalize wireless, Bluetooth, mobile, and remote-access posture | Medium | Decision + Policy | AC.L2-3.1.12 through AC.L2-3.1.19, SC.L2-3.13.7 | Current docs lean toward disable/prohibit, but final approved posture is not stated everywhere | Approve posture, implement disablement or controls, update SSP/control responses | [Security / Network / IAM] | [TBD] | Policy statement, service status, remote access architecture evidence | Open |
| POAM-014 | Produce one end-to-end user session reconstruction | Critical | Evidence + Test | AU family, SI family, assessor readiness | The package says this is key, but there is not yet a captured worked example | Capture one real or test session showing auth → query → retrieval → output → export/log review. Use `docs/evidence/poam-014-end-to-end-session-reconstruction-runbook.md` on the target DGX Spark host and `docs/assessment/nemoclaw-dgx-spark-session-reconstruction-assessor-walkthrough.md` for the assessor-facing review flow. | [Security Operations / App Owner] | [TBD] | Correlated evidence pack with timestamps and IDs | In Progress |
| POAM-015 | Finalize marking approach for exported reports and evidence bundles | Medium | Procedure | MP.L2-3.8.4, AC.L2-3.1.3 | Export handling exists conceptually but not fully templated/approved | Define templates and marking rules for generated reports, assessor bundles, and printed artifacts | [Compliance / App Owner] | [TBD] | Marked sample exports, approved template language | Open |
| POAM-016 | Finalize sanitization/decommission process for media and storage | High | Procedure | MP.L2-3.8.3, MA.L2-3.7.3, PE family | Retention/disposition matrix references sanitization, but detailed decommission evidence path is still light | Create detailed sanitization/decommission SOP and record template for removable media and NVMe | [Operations / Asset Management] | [TBD] | SOP, sample record, approval | Open |
| POAM-017 | Create boundary/scoping statement if split from SSP | Medium | Documentation | AC.L2-3.1.20, SC family, CA family | SSP contains boundary language, but some teams may want a standalone scoping artifact | Create a separate scoping statement that maps system boundary, inherited controls, and external dependencies | [Compliance / Architecture] | [TBD] | Boundary document, diagrams, owner approval | Open |
| POAM-018 | Replace remaining placeholders across document set | Medium | Documentation Hygiene | Cross-family | Many drafts still contain `[Insert Date]`, owner placeholders, and approval placeholders | Run document-finalization pass, assign owners/approvers, set versioning convention | [Assessment Lead] | [TBD] | Cleaned docs with named owners and dates | Open |

---

## 5. Recommended Execution Order

### Phase 1 — Assessment blockers
1. POAM-001 — cryptographic implementation statement  
2. POAM-002 — approved retention values  
3. POAM-004 — export/download/copy/print restrictions  
4. POAM-009 — evidence collection startup  
5. POAM-011 — production baseline package  
6. POAM-012 — no-egress / localhost-only runtime proof

### Phase 2 — Assessor-confidence items
7. POAM-003 — session timeout / reauthentication  
8. POAM-005 — authoritative time source evidence  
9. POAM-008 — IR playbook exercise  
10. POAM-010 — inherited vs local control mapping  
11. POAM-014 — end-to-end session reconstruction

### Phase 3 — Maturity and closure
12. POAM-006 — backup scope/protection statement  
13. POAM-007 — physical custody procedure  
14. POAM-013 — wireless/mobile/remote-access posture  
15. POAM-015 — marking templates  
16. POAM-016 — sanitization/decommission SOP  
17. POAM-017 — standalone scoping statement if needed  
18. POAM-018 — placeholder cleanup/finalization pass

---

## 6. Closure Standard

An item should not be marked **Closed** until all three conditions are met:
1. the decision, configuration, or procedure exists in approved form  
2. runtime or documentary evidence has been collected  
3. the related SSP / matrix / checklist language has been updated if needed

---

## 7. Notes

For this system, documentation maturity is no longer the main issue. The real risk now is ending up with a very polished set of drafts and not enough **runtime proof**.

That means the highest-value work from here is:
- collecting evidence
- resolving decisions
- demonstrating one or two end-to-end control stories clearly
rly
