# NemoClaw on DGX Spark - Cryptographic Implementation Statement

**Document Type:** Cryptographic Implementation Statement  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [System Owner / Security Architecture Owner]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This document identifies where cryptography is relied upon to protect CUI or derived CUI in the NemoClaw DGX Spark environment and describes the evidence required to support the system’s control response for:
- **SC.L2-3.13.8** protect confidentiality of CUI in transit
- **SC.L2-3.13.11** employ FIPS-validated cryptography when used to protect the confidentiality of CUI
- **SC.L2-3.13.16** protect confidentiality of CUI at rest
- related authentication and media-protection controls

---

## 2. Important Caution

This is a **draft implementation statement**, not a final attestation that all deployed cryptographic protections are already validated and evidenced.

For this system, the most common compliance mistake would be to say:
- “we use TLS 1.3”
- “we use LUKS”
- “the SSD is self-encrypting”

and stop there.

That is not enough for a defensible **SC.L2-3.13.11** position.

A final approval of this document requires:
1. identification of the exact cryptographic modules and versions used in production
2. confirmation of the approved operational mode or validated configuration where applicable
3. collection of host-side evidence from the deployed DGX Spark system
4. confirmation that the organization’s FIPS claim aligns with the actual software/hardware boundary being relied upon

Until that evidence exists, this document should be treated as a **target-state and validation worksheet**, not a finished claim.

---

## 3. Cryptographic Protection Objectives

For NemoClaw on DGX Spark, cryptography is intended to protect:
- user access to the UI over HTTPS
- administrative access over SSH and related remote-management paths
- directory/authentication traffic such as LDAPS
- confidentiality of CUI and derived CUI at rest on local storage
- confidentiality of CUI-bearing removable media where cryptographic transport protection is selected
- confidentiality of stored secrets, passwords, keys, and tokens where those mechanisms apply

---

## 4. CUI-Relevant Cryptographic Use Cases

| Use Case | Data Type | Intended Protection | Candidate / Expected Implementation | Validation Notes |
|---|---|---|---|---|
| Developer browser access to NemoClaw UI | CUI / derived CUI in transit | Confidentiality and integrity in transit | HTTPS via nginx using approved TLS configuration | Must identify exact TLS library/module, protocol set, cert/key handling, and production config. |
| Admin access to host or services | Admin credentials, system management traffic, possible CUI exposure | Confidentiality and integrity in transit | SSH using approved key-based auth and approved crypto settings | Must identify exact OpenSSH/OpenSSL or equivalent crypto dependency and mode. |
| Authentication to enterprise directory | Credentials and auth queries | Confidentiality in transit | LDAPS or approved secure auth path | Must identify TLS-protecting module and configuration used by client/service. |
| CUI / derived CUI on host storage | Source code, embeddings, logs, reports, DBs | Confidentiality at rest | Full-disk or volume encryption (e.g., LUKS/dm-crypt) layered with access controls; SED may be supplemental | Must identify whether at-rest protection claim relies on software FDE, hardware SED, or both, and which component carries the compliance claim. |
| CUI on removable media | Imported/exported digital media | Confidentiality during transport | Encrypted removable media or equivalent approved physical protection | If cryptography is the chosen control, exact mechanism and evidence must be documented. |
| Passwords / secrets / service credentials | Authentication secrets | Protected storage / transmission | OS/app-approved secret handling and cryptographically protected transport | Must verify actual storage method, exposure paths, and supporting module. |

---

## 5. Draft System Position

## 5.1 In-transit protection
The system is intended to protect in-transit CUI using secure protocols for:
- developer access to the web UI
- administrative access
- directory/authentication communications

The current architectural intent is:
- HTTPS for user access through nginx
- SSH for administrative access
- LDAPS or enterprise-secured equivalent for directory integration
- localhost-only binding for internal services wherever possible, minimizing external transit paths

### Assessment note
Local loopback traffic between host-resident services may reduce exposure, but it does **not** remove the need to identify where cryptography is actually relied upon for CUI-related network paths.

## 5.2 At-rest protection
The system is intended to protect CUI and derived CUI at rest using:
- full-disk or volume encryption for the host
- local file/database permissions
- restricted access to logs, stores, and backups
- optional/self-encrypting drive features as layered protection where approved

### Assessment note
If the compliance position relies on hardware self-encrypting drive features, the hardware capability, management model, and validation basis must be clearly documented. If the primary compliance claim relies on LUKS/dm-crypt or another software full-disk encryption mechanism, that software stack and evidence must be the focus of the FIPS analysis.

---

## 6. Current Draft Boundary Decisions

The following draft decisions are recommended unless enterprise policy dictates otherwise:

1. **Primary at-rest compliance claim should rely on the approved host encryption stack**, not on marketing statements about a self-encrypting SSD alone.
2. **SED should be treated as defense-in-depth unless its management and validated boundary are explicitly documented and approved.**
3. **Every store containing derived CUI must be covered by the at-rest protection statement**, including:
   - PostgreSQL/pgvector
   - SQLite conversation stores
   - audit/log directories
   - exported report directories
   - backups and retained evidence bundles
4. **Any removable media carrying CUI or derived CUI should either be encrypted or protected by an approved equivalent physical-control process with clear custody.**

---

## 7. Evidence Required Before Final Approval

A final version of this statement should not be approved until the following evidence is assembled from the deployed DGX Spark environment.

### 7.1 Host and package evidence
- exact OS release and patch level
- exact versions of nginx, OpenSSH, relevant TLS libraries, and disk-encryption components
- exact configuration files or outputs showing enabled protocols, ciphers, and modes

### 7.2 FIPS / validation evidence
- the specific cryptographic modules being relied upon for the compliance claim
- evidence of whether those modules are operating in an approved/validated mode where required
- mapping from deployed modules/versions to the organization’s accepted validation basis
- screenshots, command outputs, or vendor documentation used to support the claim

### 7.3 At-rest evidence
- proof of enabled host encryption for the storage volumes containing CUI or derived CUI
- evidence that logs, databases, reports, and backups reside on protected storage
- evidence showing whether SED is enabled, managed, and relied upon or merely supplemental

### 7.4 In-transit evidence
- TLS configuration for nginx
- SSH daemon/client configuration relevant to admin access
- LDAPS or equivalent secure directory-integration configuration
- certificate/key management records for relevant services

### 7.5 Removable media evidence
- encryption method if encrypted removable media is used
- custody and transport procedure if physical controls are used instead of crypto for a given case

---

## 8. Open Questions Requiring Final Decision

The following must be answered explicitly before assessment:

1. What exact cryptographic module/library is relied upon for HTTPS on the deployed platform?  
2. What exact cryptographic module/library is relied upon for SSH on the deployed platform?  
3. What exact cryptographic mechanism is relied upon for host at-rest protection?  
4. Is the organization claiming SED as a compliance-relevant control, defense-in-depth only, or not at all?  
5. What is the approved basis for the system’s FIPS claim under **SC.L2-3.13.11**?  
6. Are all CUI-derived stores and backups confirmed to reside within the protected cryptographic/storage boundary?  
7. Are removable-media use cases protected by cryptography, physical custody, or a combination of both?  

---

## 9. Assessor-Facing Statement Template (Draft)

The following is a **draft template** for the eventual control response once evidence is collected:

> NemoClaw on DGX Spark protects CUI and derived CUI in transit using approved secure protocols for user access, directory integration, and administrative access, and protects CUI and derived CUI at rest using approved host storage encryption and access controls. The organization’s final control response for SC.L2-3.13.11 is based on the specific cryptographic modules and versions deployed on the production DGX Spark host, as documented in the approved evidence package for this system. Hardware self-encrypting drive capabilities are treated [as primary / supplemental / not relied upon] according to the approved architecture decision record.

Do **not** use that text as a final assessment statement until the bracketed decisions and evidence are completed.

---

## 10. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This statement primarily supports:
- **SC.L2-3.13.8** protect CUI in transit
- **SC.L2-3.13.11** employ FIPS-validated cryptography when protecting CUI
- **SC.L2-3.13.16** protect confidentiality of CUI at rest
- **IA.L2-3.5.10** store/transmit passwords only using cryptographically-protected mechanisms
- **MP.L2-3.8.6** protect digital media during transport when cryptography is used

---

## 11. NemoClaw-Specific Notes

For this system, the cryptographic discussion must stay tied to real data flows and real stores. The most important mistake to avoid is documenting only the front-door TLS connection while forgetting that the assessment scope also includes:
- derived CUI in logs
- embeddings in PostgreSQL/pgvector
- conversation history in SQLite
- exported reports and evidence bundles
- backups and removable media

If those are not explicitly covered in the final cryptographic/storage protection narrative, the system’s control response will look incomplete even if HTTPS is configured perfectly.
