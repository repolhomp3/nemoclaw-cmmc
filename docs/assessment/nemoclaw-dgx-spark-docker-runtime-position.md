# NemoClaw on DGX Spark - Docker Runtime Position

**Document Type:** Architecture / Control Position Note  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [System Owner / Security Architecture]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This note explains the current recommended runtime position for NemoClaw on the DGX Spark:

**retain Docker as the application runtime as designed, and manage Docker-specific risk through explicit hardening, evidence collection, monitoring, and POA&M items rather than attempting a late architecture pivot to Podman.**

This document exists because container-runtime choice can become a distracting design argument late in readiness work. For this system, the more credible path is to:
- keep the runtime aligned to the actual design assumptions,
- harden and constrain the Docker footprint,
- document the risk and control implications clearly,
- and collect host evidence that proves the deployed runtime is bounded and reviewable.

---

## 2. Current position

### Recommended near-term position
Use **NemoClaw as designed**, including the Docker-based local application/runtime model, and treat Docker as an **explicit in-scope control surface**.

### Not recommended at this stage
A late swap from Docker to Podman solely for appearance or policy comfort is **not recommended** unless there is a verified technical requirement and a tested compatibility plan.

### Why
Because for this repo and readiness effort, the core issue is no longer “which container runtime sounds cleaner.”
It is:
- what is actually deployed,
- how it is constrained,
- how it is monitored,
- and what evidence exists to support the control story.

A rushed runtime substitution can create more uncertainty than security.

---

## 3. Why retaining Docker can be the better readiness move

## 3.1 Architecture truth matters more than aesthetic purity
If NemoClaw is currently designed and expected to run on Docker, the most assessor-defensible position is usually:
- document Docker honestly,
- baseline it,
- harden it,
- and prove it is controlled.

That is usually better than introducing a compatibility pivot late in the cycle and inheriting untested assumptions.

## 3.2 The real control question is not “Docker or Podman?”
The real questions are:
- What privileges does the Docker daemon have?
- Who can access Docker administrative functions?
- What images are allowed?
- How are images introduced and scanned?
- Are containers exposing services beyond approved boundaries?
- Are containers running with unnecessary privileges?
- Are logs, config, and runtime state reviewed and protected?
- Can the team prove the runtime posture on the actual DGX host?

Those are the questions that matter in readiness work.

## 3.3 Late runtime changes can create new gaps
A shift to Podman at the wrong time can create new issues in:
- compatibility
- operator procedures
- logging expectations
- maintenance SOPs
- evidence binder content
- vulnerability management scope
- assessor explanation of what is actually deployed

The repo is already built around a Docker-aware system boundary. The lower-risk near-term move is to make that story stronger, not fuzzier.

---

## 4. Required control position for Docker in this system

If Docker remains in use, the following control position should be adopted and evidenced.

## 4.1 Docker is in scope
Docker is not “just plumbing.”
It is an in-scope runtime component because it can affect:
- process isolation
- service exposure
- image provenance
- update posture
- host privilege boundary
- log and maintenance scope

## 4.2 Docker administrative access is privileged access
Access to Docker administration is equivalent to privileged system control and should be treated accordingly.

This means:
- only authorized administrators may manage Docker
- membership in any Docker-admin-capable group must be tightly restricted and reviewed
- Docker administrative actions should be attributable and reviewable

## 4.3 Docker configuration must be baseline-controlled
At minimum, the assessed build should maintain baseline control over:
- Docker version/build
- daemon configuration
- image source and digest records
- container runtime flags
- bind mounts/volume mappings
- restart policies
- network exposure and port mappings
- logging driver/retention behavior

## 4.4 Container images are controlled intake artifacts
Images must be treated like any other imported software artifact:
- scanned before introduction where required by procedure
- tracked by digest
- approved through the intake process
- traceable to their source and review status

## 4.5 Container runtime posture must be evidenced
The team should be able to show, from the actual DGX Spark host:
- what containers are running
- which images/digests they use
- what ports are published
- what mounts they use
- what network exposure exists
- what privileges/capabilities are in use
- that only the intended front-door path is reachable

---

## 5. Recommended repository updates implied by this position

The repo should explicitly reflect the following:

1. Docker remains the runtime of record for the assessed build
2. Docker-specific configuration, access, and image governance are control topics
3. Docker is a tracked POA&M and evidence subject
4. Docker hardening and runtime proof are required before readiness claims are closed
5. Podman may remain a future option, but not as an implicit current-state assumption

---

## 6. Recommended evidence for this position

The following evidence should be collected from the actual DGX Spark host:
- Docker daemon version
- Docker daemon configuration file(s)
- administrative access/group membership
- running container list
- image digest inventory
- exposed ports and bind mappings
- effective container privileges/capabilities summary
- runtime logs as appropriate
- image intake and scan evidence
- change records for container/image updates

---

## 7. Bottom line

For this readiness package, the practical and credible answer is:

**keep NemoClaw as designed, keep Docker in scope, and manage Docker as an explicit controlled runtime with hardening, evidence, and POA&M closure criteria.**

That is a better path than making a late runtime substitution just to sound cleaner on paper.
