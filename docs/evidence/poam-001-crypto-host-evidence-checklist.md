# POAM-001 Checklist - Cryptographic Host Evidence and Decision Worksheet

**POA&M Item:** POAM-001  
**Objective:** Convert the draft cryptographic implementation statement into a host-backed, assessor-usable control response by collecting real evidence from the deployed DGX Spark system and recording the resulting architecture decisions.

---

## 1. Why This Exists

For this system, one of the biggest assessment risks is a vague answer to **SC.L2-3.13.11**.

Weak answer:
- "we use TLS 1.3"
- "we use LUKS"
- "the SSD is self-encrypting"

Better answer:
- identify the exact deployed cryptographic mechanisms
- identify where they protect CUI or derived CUI
- identify what evidence supports the claim
- identify what is primary vs defense-in-depth
- identify what still requires approval before the claim is final

This checklist is meant to produce that better answer.

---

## 2. Scope Note

This checklist must be completed against the **actual DGX Spark deployment** intended for assessment.

Do not substitute:
- a developer workstation
- a generic Ubuntu test VM
- a staging host with different package versions or crypto settings
- marketing material for the hardware

---

## 3. Control Focus

This checklist primarily supports:
- **SC.L2-3.13.8** protect confidentiality of CUI in transit
- **SC.L2-3.13.11** employ FIPS-validated cryptography when used to protect the confidentiality of CUI
- **SC.L2-3.13.16** protect confidentiality of CUI at rest
- **IA.L2-3.5.10** store/transmit passwords only using cryptographically-protected mechanisms
- **MP.L2-3.8.6** protect digital media during transport when cryptography is used

---

## 4. What the Final Evidence Package Must Answer

For each CUI-relevant cryptographic use case, the package must answer:

1. What data is being protected?  
2. What exact mechanism protects it?  
3. What exact software/hardware component provides that protection?  
4. What version or build is deployed?  
5. Is that mechanism the **primary compliance-relevant control** or just defense-in-depth?  
6. What evidence proves the mechanism is actually enabled and in use on the host?  
7. What is the organization’s approved basis for any FIPS-related claim?  

---

## 5. CUI-Relevant Crypto Use Cases to Evaluate

Fill this table after host review:

| Use Case | CUI / Derived CUI Involved | Intended Mechanism | Primary or Supplemental? | Evidence Collected? | Final Decision |
|---|---|---|---|---|---|
| HTTPS access to NemoClaw UI | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |
| SSH admin access | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |
| LDAPS / secure auth path | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |
| At-rest protection for source/derived stores | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |
| Removable media transport | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |
| Secret/password handling | [fill] | [fill] | [Primary/Supplemental] | [Yes/No] | [fill] |

---

## 6. Evidence to Collect on the DGX Spark Host

## 6.1 Host identity and versions
Collect:
```bash
date -Is
hostnamectl
uname -a
cat /etc/os-release
```

Record:
- system identity
- OS version
- patch level context

## 6.2 HTTPS / nginx crypto evidence
Collect the deployed nginx configuration and supporting TLS information.

Possible evidence commands / captures:
```bash
nginx -V
sudo nginx -T
openssl version -a
```

Review for:
- enabled TLS protocols
- certificate/key paths
- cipher or ciphersuite configuration
- TLS library version in use
- whether the config reflects the approved baseline

## 6.3 SSH crypto evidence
Collect SSH daemon information.

Possible evidence commands / captures:
```bash
sshd -T
ssh -V
openssl version -a
```

Review for:
- allowed protocol behavior
- key exchange and crypto policy
- password vs key-based admin access
- linkage to approved administrative access design

## 6.4 LDAPS / secure auth path evidence
Collect the relevant configuration for directory/auth integration.

Possible evidence sources:
- application configuration
- reverse-proxy/app connector config
- host trust store / TLS validation config
- screenshots or config snippets showing secure directory path use

Review for:
- secure transport requirement
- certificate validation approach
- exact component responsible for the protected connection

## 6.5 At-rest protection evidence
Collect host-side storage encryption evidence.

Possible evidence commands / captures:
```bash
lsblk -o NAME,FSTYPE,MOUNTPOINT,TYPE,SIZE
sudo blkid
sudo cryptsetup status <mapped-device>
mount
```

If LUKS/dm-crypt or equivalent is used, identify:
- encrypted volume(s)
- mapped device names
- protected mount points
- whether all CUI and derived-CUI stores sit on protected storage

Also identify whether SED is enabled and, if so, whether it is being relied upon for compliance or only treated as supplemental.

## 6.6 Password / secret handling evidence
Collect evidence for:
- how admin credentials are protected in transit
- how any service credentials/secrets are stored
- whether plaintext credential exposure exists in configs or scripts

Evidence sources may include:
- config inspection
- secret storage path documentation
- auth-flow design notes

## 6.7 Removable media crypto evidence
If encrypted removable media is used, collect:
- approved encryption method
- how keys/passphrases are handled
- a sample approved process record

If physical safeguards are used instead of crypto for a given use case, record that clearly so the compliance claim stays honest.

---

## 7. FIPS Claim Decision Worksheet

This is the core decision section.

### 7.1 HTTPS
- Exact component/library relied upon: [fill]
- Version/build: [fill]
- Why it matters for CUI: [fill]
- Evidence collected: [fill]
- Approved basis for SC.L2-3.13.11 claim: [fill]
- Residual caveat: [fill]

### 7.2 SSH
- Exact component/library relied upon: [fill]
- Version/build: [fill]
- Why it matters for CUI/admin path: [fill]
- Evidence collected: [fill]
- Approved basis for SC.L2-3.13.11 claim: [fill]
- Residual caveat: [fill]

### 7.3 At-rest protection
- Exact primary mechanism relied upon: [fill]
- Version/build: [fill]
- Protected stores covered: [fill]
- Is SED primary, supplemental, or not relied upon?: [fill]
- Evidence collected: [fill]
- Approved basis for SC.L2-3.13.11 / SC.L2-3.13.16 position: [fill]
- Residual caveat: [fill]

### 7.4 Removable media
- Crypto used or physical controls only?: [fill]
- Exact mechanism if crypto is used: [fill]
- Evidence collected: [fill]
- Assessment note: [fill]

---

## 8. Red Flags

Treat any of these as unresolved blockers or major gaps until addressed:
- no one can name the exact component/library being relied upon
- the final claim depends on vague vendor marketing language
- HTTPS/SSH are configured, but the team has no module/version evidence
- at-rest protection discussion covers only `/opt/codebase/` and ignores DBs/logs/backups
- SED is assumed to satisfy the requirement with no management or validation basis
- removable-media handling is described inconsistently across documents
- the team cannot explain what part of the crypto story is primary vs supplemental

---

## 9. Assessor-Facing Output Template

Once this checklist is completed, the team should be able to write a short final statement like:

> The DGX Spark deployment protects CUI and derived CUI in transit using approved secure protocols for user, admin, and directory-related paths, and protects CUI and derived CUI at rest using the approved host storage protection stack documented for this deployment. The organization’s SC.L2-3.13.11 position is based on the specific deployed cryptographic components and versions evidenced on the production host and approved in the system’s cryptographic implementation statement. Supplemental mechanisms, including hardware self-encrypting drive features where present, are identified separately and are not relied upon beyond their approved architectural role.

Do not use that text as final until the filled worksheet and approvals exist.

---

## 10. Binder Mapping

Update these evidence binder entries after collection:
- TLS configuration for nginx
- SSH cryptographic configuration
- LDAPS or secure auth-path evidence
- host encryption evidence for protected volumes
- cryptographic implementation statement approval
- FIPS validation basis / module evidence
- removable-media encryption evidence if used

---

## 11. Closure Criteria for POAM-001

POAM-001 should only be closed when:
1. the host evidence has been collected on the DGX Spark itself  
2. the primary vs supplemental crypto decisions are documented  
3. the approved basis for the SC.L2-3.13.11 claim is recorded  
4. the cryptographic implementation statement is updated from draft worksheet to approved position  
5. the evidence binder and tracker are updated
