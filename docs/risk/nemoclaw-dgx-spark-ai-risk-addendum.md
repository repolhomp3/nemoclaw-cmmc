# NemoClaw on DGX Spark - AI Risk Addendum

**Document Type:** Risk Addendum  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Security / Risk Owner]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This addendum documents AI-specific risk scenarios, assumptions, threat considerations, and mitigation expectations for NemoClaw on the DGX Spark platform.

The goal is to supplement the organization’s general risk assessment with scenarios unique to AI-assisted processing of CUI source code.

---

## 2. System Context

NemoClaw is a local, on-premises AI coding assistant that:
- processes CUI source code
- uses retrieval and local model inference
- generates summaries and responses derived from protected technical content
- operates in a constrained, read-only analytical mode
- runs inside a sandboxed environment with no operational internet egress

Because the system uses AI to interpret and summarize code, risks exist that are not fully captured by traditional application-server assessments.

---

## 3. Key Assumptions

This addendum assumes:
- the system is deployed within an existing CMMC Level 2 enclave
- users are authenticated through enterprise identity and MFA
- the agent has read-only access to approved repositories
- local services other than the web endpoint bind to localhost only
- operational internet egress is blocked
- imported models and images enter through controlled media procedures

If these assumptions change, the risk assessment must be updated.

---

## 4. AI-Specific Risk Scenarios

## 4.1 Prompt injection through source content
**Scenario:** Malicious or crafted comments, strings, documentation, or code content influence model behavior in a way that causes over-disclosure, misleading outputs, or attempts to bypass intended safeguards.

**Potential impact:**
- excessive disclosure of code-derived information
- misleading recommendations
- attempted evasion of usage or policy constraints
- degraded analyst trust or decision quality

**Primary mitigations:**
- OpenShell sandbox restrictions
- no shell/process spawning by the agent
- no outbound network access for the agent
- logging of prompts, reads, and outputs as appropriate
- user/admin training on hostile-content scenarios
- incident procedures for suspected prompt injection

**Related practices:**
- **RA.L2-3.11.1**
- **CA.L2-3.12.1**
- **SC.L2-3.13.1**
- **SC.L2-3.13.8**
- **SI.L2-3.14.6**

## 4.2 Over-disclosure of CUI in outputs
**Scenario:** The model returns verbatim or overly detailed code, architecture descriptions, vulnerability details, or sensitive implementation logic beyond what is operationally required.

**Potential impact:**
- unauthorized disclosure to otherwise authorized users beyond need-to-know
- improper export of sensitive analysis
- generation of CUI-derived artifacts that are mishandled

**Primary mitigations:**
- role-based access control
- least privilege
- derived CUI handling standard
- export restrictions and logging
- user training and acceptable use rules

**Related practices:**
- **AC.L2-3.1.1**
- **AC.L2-3.1.2**
- **AC.L2-3.1.3**
- **MP.L2-3.8.1**
- **SC.L2-3.13.16**

## 4.3 Derived CUI persistence in secondary stores
**Scenario:** Embeddings, summaries, logs, caches, or reports contain sensitive information but are not handled with the same protection as the original source code.

**Potential impact:**
- hidden expansion of the CUI footprint
- incomplete scoping during assessment
- unauthorized access through overlooked storage locations

**Primary mitigations:**
- classify derived outputs as CUI by default
- inventory all derivative stores
- apply retention and destruction rules
- restrict access to logs and data stores

**Related practices:**
- **AC.L2-3.1.3**
- **AU.L2-3.3.1**
- **MP.L2-3.8.1**
- **MP.L2-3.8.3**
- **SC.L2-3.13.16**

## 4.4 Supply-chain compromise of model or application artifacts
**Scenario:** A model file, image, package, or update introduced into the enclave is malicious, tampered, or inconsistent with policy.

**Potential impact:**
- compromise of host or application integrity
- malicious behavior in processing or output generation
- persistence of unauthorized code in the environment

**Primary mitigations:**
- controlled intake SOP
- trusted hashes and signature verification
- scanning in staging environment
- approval workflow and custody records
- load by immutable digest where feasible

**Related practices:**
- **CM.L2-3.4.1**
- **CM.L2-3.4.3**
- **MA.L2-3.7.4**
- **MP.L2-3.8.6**
- **RA.L2-3.11.2**
- **SI.L2-3.14.1**

## 4.5 Misuse by authorized users
**Scenario:** A legitimate user uses the system to extract excessive code, generate unauthorized summaries, or create exportable packages beyond their business need.

**Potential impact:**
- insider misuse
- unauthorized aggregation of protected content
- difficulty distinguishing abuse from normal usage without logging

**Primary mitigations:**
- enforce need-to-know through role and repository scope
- log user queries and exports
- review anomalous usage patterns
- train users on acceptable use

**Related practices:**
- **AC.L2-3.1.1**
- **AC.L2-3.1.2**
- **AU.L2-3.3.1**
- **AU.L2-3.3.5**
- **AT.L2-3.2.1**

## 4.6 Single-node concentration risk
**Scenario:** Because UI, inference, storage, and local logging all run on the same host, a compromise or major misconfiguration could affect multiple security functions simultaneously.

**Potential impact:**
- broader blast radius from one host issue
- local loss of visibility if logging is impaired
- combined availability and confidentiality impact

**Primary mitigations:**
- host hardening
- least functionality
- restricted local bindings
- protected audit stores
- configuration management and change control

**Related practices:**
- **CM.L2-3.4.1**
- **SC.L2-3.13.8**
- **AU.L2-3.3.8**
- **SI.L2-3.14.6**

---

## 5. Risk Treatment Expectations

The following controls are expected as minimum treatment for AI-specific risk:
- sandbox enforcement for agent actions
- no unrestricted shell or process execution by the agent
- no operational internet egress
- localhost-only bindings for internal services
- strong logging and review of user, admin, and agent activity
- treatment of derived outputs as CUI by default
- controlled import process for images, models, and updates
- periodic reassessment when system architecture or AI behavior changes

---

## 6. Assessment and Test Considerations

The organization should include AI-specific tests in its assessment program, including:
- prompt injection test cases using benign simulated hostile content
- verification that agent policy denies unauthorized actions
- validation that outputs and exports are attributable to user identity
- checks that derived stores are included in scope and protection
- confirmation that model/image provenance records exist
- review of suspicious or abnormal extraction scenarios

---

## 7. Incident Response Triggers

The following AI-related events should trigger review or incident procedures:
- evidence of prompt-injection-driven behavior
- repeated attempts to elicit large sensitive code dumps
- unexplained changes in model or agent behavior
- unexpected exports or mass downloads
- evidence of tampered model or container artifacts
- unexplained denied-action spikes in sandbox logs

---

## 8. Residual Risk Statement

Even with strong controls, residual AI-related risk remains due to:
- imperfect model behavior
- ambiguity in how summarized outputs may reveal sensitive details
- challenges distinguishing normal expert usage from subtle misuse
- dependence on procedural controls for sanitization and export decisions

Residual risks shall be tracked in the system risk register and reviewed whenever major changes occur.

---

## 9. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This addendum primarily supports:
- **RA.L2-3.11.1** periodically assess risk
- **RA.L2-3.11.2** scan for vulnerabilities
- **RA.L2-3.11.3** remediate vulnerabilities
- **CA.L2-3.12.1** assess security controls periodically
- **CA.L2-3.12.3** monitor controls on an ongoing basis
- **SC.L2-3.13.1** monitor, control, and protect communications
- **SC.L2-3.13.8** implement boundary protections
- **SI.L2-3.14.6** monitor systems and take action on findings
- **SI.L2-3.14.7** identify unauthorized use

---

## 10. NemoClaw Implementation Notes

For NemoClaw on DGX Spark, this addendum should be read together with:
- the SSP draft
- the derived CUI handling standard
- the logging and review standard
- the media/model/image intake SOP
- the system-specific incident response playbook once created
