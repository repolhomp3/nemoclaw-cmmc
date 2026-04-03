# NemoClaw on DGX Spark - Docker Hardening Standard

**Document Type:** Standard  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Baseline:** CMMC Level 2 / NIST SP 800-171 Rev. 2  
**Version:** Draft v0.1  
**Owner:** [Security Operations / System Administrator]  
**Approved By:** [Approving Authority]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This standard defines the minimum hardening expectations for Docker as the approved container runtime for the assessed NemoClaw build on NVIDIA DGX Spark.

Its purpose is to ensure Docker is treated as an explicit in-scope control surface rather than as invisible plumbing.

The standard focuses on:
- daemon configuration
- administrative access
- image control
- runtime least privilege
- network exposure
- mount discipline
- logging and review
- evidence expectations for the actual assessed build

---

## 2. Scope

This standard applies to:
- the Docker daemon and related service configuration
- Docker administrative access paths
- Docker socket handling
- Docker-managed images, volumes, and networks
- Docker-managed containers used by NemoClaw and directly supporting services
- baseline and evidence artifacts used to prove the Docker posture

This standard does not replace host OS hardening, firewall policy, identity policy, or general media intake procedures. It supplements them for the Docker-specific layer.

---

## 3. Control Position

1. Docker is an in-scope runtime component for the assessed NemoClaw build.
2. Docker administrative access is privileged access and shall be controlled accordingly.
3. Only approved container images may be run in the assessed build.
4. Containers shall run with the least privilege and least functionality necessary.
5. Network exposure shall be restricted to the intended front-door path and approved local service bindings.
6. Docker configuration and runtime state shall be baseline-controlled and reviewable.
7. Exceptions shall be documented, justified, approved, and evidenced.

---

## 4. Roles and Responsibilities

### System Administrator
- maintains Docker daemon configuration
- restricts Docker administrative access
- captures host/runtime evidence
- implements approved baseline settings

### Security Operations / Security Reviewer
- reviews hardening posture and exceptions
- verifies image approval and scan evidence
- reviews runtime findings and remediations

### App Owner
- confirms which containers and ports are required
- validates operational need for any exception
- coordinates baseline updates when application changes occur

### Compliance / Assessment Lead
- ties hardening evidence back to POA&M, SSP, and assessor-facing materials

---

## 5. Docker Daemon Hardening Requirements

## 5.1 Approved service posture
The Docker daemon shall run only as required for the approved assessed build.

The assessed build shall document:
- Docker version
- service enablement state
- service unit or launch configuration
- daemon configuration file(s)
- local storage/data-root location

## 5.2 Remote daemon exposure
The Docker daemon shall **not** expose an unauthenticated or unnecessary remote administration interface.

Unless an approved architecture specifically requires it, Docker remote API access over TCP shall be disabled.

If remote administration is approved as an exception, the configuration shall document:
- business need
- interface and port
- mutual authentication / encryption method
- access restriction method
- approval record
- logging and review expectations

## 5.3 Daemon configuration control
Daemon configuration shall be maintained as a baseline-controlled artifact.

At minimum, the assessed build shall record and review:
- `/etc/docker/daemon.json` or platform equivalent
- service drop-ins or overrides
- insecure registry settings
- registry mirrors
- logging driver settings
- data-root path
- any user namespace or security-option defaults

## 5.4 Unsupported or high-risk settings
The following shall be prohibited unless explicitly approved and documented as exceptions:
- insecure registries without compensating review and approval
- Docker API exposure beyond approved local administrative use
- broad default runtime changes that reduce isolation without review
- unreviewed daemon startup flags that bypass intended controls

---

## 6. Administrative Access Requirements

## 6.1 Docker access is privileged
Users able to manage Docker, access the Docker socket, or otherwise control Docker runtime state shall be treated as privileged administrators.

## 6.2 Group membership restrictions
Membership in Docker-admin-capable groups such as `docker`, `sudo`, or `wheel` shall be:
- limited to authorized personnel
- documented
- periodically reviewed
- removed promptly when no longer required

## 6.3 Docker socket handling
Access to `/var/run/docker.sock` shall be tightly restricted.

Containers shall not mount the Docker socket unless there is a specifically approved administrative need with documented justification.

## 6.4 Administrative accountability
Docker-administrative actions should be attributable through host account use, administrative procedures, change records, and supporting logs where available.

---

## 7. Approved Image Requirements

## 7.1 Approved image set
Only images listed in the approved image inventory for the assessed build may be used in production or assessment-scoped operation.

## 7.2 Digest-based control
Images shall be tracked by immutable digest where feasible and shall not rely on mutable tags alone as the authoritative approval reference.

## 7.3 Intake and scanning linkage
Each approved image shall be traceable to:
- source registry/repository
- tag and digest
- intake request or approval record
- vulnerability scan results
- any exception or risk acceptance record
- baseline configuration reference

## 7.4 Orphaned or stale images
Unused, stale, or unapproved images on the assessed build shall be reviewed and either:
- documented as non-production artifacts pending cleanup, or
- removed through approved change control

---

## 8. Container Runtime Hardening Requirements

## 8.1 Privilege model
Containers shall run without `--privileged` unless explicitly approved and documented as an exception.

## 8.2 User identity
Containers should run as a non-root user where technically feasible.

If a container runs as root, the build shall document:
- why root is required
- what compensating controls exist
- whether the condition is temporary or baseline-approved

## 8.3 Capabilities
Linux capabilities shall be minimized.

Additional capabilities beyond default shall require documentation and justification. Capability drops should be used where feasible.

## 8.4 Namespace isolation
Use of host namespaces such as `host` network mode, host PID, or host IPC shall be prohibited unless operationally required and explicitly approved.

## 8.5 Filesystem posture
Containers should use a read-only root filesystem where technically feasible.

Writable paths should be limited to the smallest necessary set of volumes or mounts.

## 8.6 Devices
Direct device mappings shall be limited to approved operational needs, such as required GPU access, and shall be explicitly documented.

## 8.7 Security options
Docker runtime security options that weaken isolation shall not be disabled without documented review.

The assessed build should document the status of:
- seccomp posture
- AppArmor posture
- `no-new-privileges` or equivalent
- user namespace settings if used

---

## 9. Network and Port Exposure Requirements

## 9.1 Intended exposure model
Container-published ports shall align with the approved NemoClaw architecture.

Internal supporting services that do not need direct external reachability should remain localhost-only or otherwise constrained to the approved front-door path.

## 9.2 Published ports
Every published port shall have:
- a business purpose
- an owning service
- an approved bind/interface expectation
- supporting firewall posture
- evidence showing the actual runtime binding

## 9.3 Non-loopback exposure
Ports bound to non-loopback interfaces require explicit review and approval.

## 9.4 Docker networks
Docker bridge and custom networks shall be documented sufficiently to explain:
- service-to-service communication
- front-door exposure
- any egress or routing implications

---

## 10. Mount and Volume Requirements

## 10.1 Bind-mount discipline
Bind mounts shall be restricted to necessary host paths only.

Broad host-path mounts shall be avoided unless specifically approved.

## 10.2 Sensitive paths
Mounting the following into containers is prohibited unless explicitly approved and justified:
- `/var/run/docker.sock`
- `/`
- credential or secret stores not intended for container use
- large host directories that exceed operational need

## 10.3 Read/write restrictions
Mounts should be read-only where feasible.

Read-write access shall be limited to paths necessary for application function.

## 10.4 Volume inventory
Named volumes and bind mounts shall be included in the baseline package and runtime evidence set.

---

## 11. Logging, Monitoring, and Review Requirements

Docker-related evidence shall be sufficient to support administrative review and assessment readiness.

At minimum, the assessed build shall be able to show:
- Docker version and daemon status
- daemon configuration
- Docker-admin-capable users/groups
- running containers and images
- published ports
- volume and bind-mount usage
- effective privilege posture
- correlation with host listen-state and firewall evidence

Docker findings shall be reviewed when:
- images change
- containers or compose definitions change
- published ports change
- exceptions are introduced
- assessment evidence is refreshed

---

## 12. Baseline and Change-Control Requirements

## 12.1 Baseline package
The production baseline package for the assessed build shall include Docker-specific artifacts covering:
- approved images
- daemon configuration
- running services/containers
- ports
- mounts
- privilege-sensitive runtime settings

## 12.2 Change review
Changes to Docker version, daemon settings, image digests, exposed ports, major mounts, or privilege posture shall be reviewed as configuration changes.

## 12.3 Evidence refresh
Docker runtime evidence should be refreshed after material change and before major readiness review milestones.

---

## 13. Exceptions

Any exception to this standard shall document:
- the exact setting or condition
- the operational need
- affected container(s) or host components
- security impact
- compensating controls
- approving authority
- review frequency
- target removal date if temporary

Examples include:
- root-required containers
- host-network use
- added capabilities
- broad bind mounts
- device mappings beyond approved GPU need
- remote Docker administration

---

## 14. Evidence of Compliance

Evidence supporting this standard should include:
- `docs/evidence/poam-020-docker-runtime-evidence-runbook.md` outputs
- Docker daemon configuration files
- Docker group membership evidence
- container and image inventory by digest
- scan and intake records tied to approved images
- configuration baseline records
- review or approval records for exceptions

---

## 15. Mapping to NIST SP 800-171 Rev. 2 / CMMC L2

This standard primarily supports:
- **AC family** — control of privileged and administrative access
- **CM.L2-3.4.1** baseline configurations
- **CM.L2-3.4.2** establish and enforce security configuration settings
- **CM.L2-3.4.3** track, review, approve, and document changes
- **CM.L2-3.4.6** least functionality
- **RA.L2-3.11.2** vulnerability scanning support through image governance
- **SC.L2-3.13.1** monitor, control, and protect communications
- **SC.L2-3.13.6** deny network communications traffic by exception where applicable
- **SI.L2-3.14.1** identify, report, and correct system flaws
- **SI.L2-3.14.6** monitor systems and security-impacting changes

---

## 16. NemoClaw Implementation Notes

For NemoClaw on DGX Spark, the practical intent of this standard is not to pretend Docker disappears. It is to make Docker reviewable enough that the team can show:
- Docker is the runtime of record for this assessed build
- Docker administration is bounded
- only approved images are used
- exposed services match the design
- container privileges are known and minimized
- mounts and runtime exceptions are visible rather than implicit

A clean readiness story here is not “we used containers.”

It is: **we know exactly which containers, images, ports, mounts, and privileges exist on the assessed host, and we can prove they are controlled.**
