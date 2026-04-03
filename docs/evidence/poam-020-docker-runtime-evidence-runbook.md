# Docker Runtime Evidence Runbook for Assessed DGX Spark Build

**Document Type:** Evidence Runbook  
**System:** NemoClaw AI Coding Assistant on NVIDIA DGX Spark  
**Primary POA&M Item:** **POAM-020** — Produce Docker runtime proof package for assessed build  
**Related POA&M Items:** **POAM-019** Docker administrative access, **POAM-021** approved image allowlist, **POAM-011** production baseline package, **POAM-012** localhost-only / no-egress validation  
**Version:** Draft v0.1  
**Owner:** [System Administrator / Assessment Lead]  
**Last Updated:** [Insert Date]

---

## 1. Purpose

This runbook provides a practical, read-mostly method for collecting the Docker runtime evidence needed to prove the deployed NemoClaw container posture on the **actual assessed DGX Spark host**.

The goal is to capture one coherent runtime package that shows:
- how Docker is configured on the host
- who has Docker-administrative access
- which containers are running
- which image digests they use
- which ports are published
- which mounts they use
- what effective privilege posture exists
- how that posture aligns with the baseline and approved image set

This runbook is intended to close the gap between broad Docker narrative and host-backed evidence.

---

## 2. Scope

This runbook applies to the Docker daemon and Docker-managed containers supporting the assessed NemoClaw build on the DGX Spark host.

It is not intended for:
- a developer workstation that is not the assessed host
- a documentation laptop
- a staging VM with different images or configuration
- Kubernetes evidence collection
- Podman evidence collection

If the target system is not the actual assessed DGX Spark build, stop and record that mismatch before collecting anything.

---

## 3. Collection Principles

1. Collect **baseline evidence before changing settings**.
2. Prefer **read-only inspection** first.
3. Preserve raw command output before making a summary.
4. Record the exact host, date, operator, and command context.
5. Treat outputs as potentially sensitive because they may contain usernames, internal paths, bind mounts, container arguments, or network details.
6. If an artifact is too sensitive for Git, store it in the approved evidence repository and record its location in `docs/evidence/collection-tracker.md` and the binder index.

---

## 4. What This Runbook Should Produce

At minimum, this runbook should produce:
- Docker version and daemon status evidence
- daemon configuration evidence
- Docker-admin-capable user/group evidence
- running and stopped container inventory
- image inventory with immutable digests
- published-port evidence
- mount/bind evidence
- effective privilege posture summary
- runtime/network correlation notes showing how Docker exposure does or does not match the localhost-only design
- references to intake/scanning evidence for approved images

---

## 5. Output Folder Structure

Create a dated evidence folder in the approved repository, for example:

- `YYYY-MM-DD-docker-runtime-proof/`

Suggested subfolders:
- `raw/`
- `screenshots/`
- `summaries/`

Suggested output files:
- `raw/docker-version.txt`
- `raw/docker-info.txt`
- `raw/docker-system-df.txt`
- `raw/docker-ps-a.txt`
- `raw/docker-images-digests.txt`
- `raw/docker-network-ls.txt`
- `raw/docker-volume-ls.txt`
- `raw/docker-groups-and-access.txt`
- `raw/daemon-json.txt`
- `raw/systemctl-docker.txt`
- `raw/container-inspect-<name>.json`
- `summaries/docker-runtime-summary.md`

Record the final location in:
- `docs/evidence/collection-tracker.md`
- `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`

---

## 6. Pre-Flight Checklist

Before running commands:

- [ ] Confirm the host is the assessed DGX Spark build.
- [ ] Confirm the output location is approved.
- [ ] Confirm whether command output may be stored in Git or must remain external.
- [ ] Confirm Docker CLI access is available.
- [ ] Confirm sudo access is available for read-only inspection of Docker config and host service state.
- [ ] Open these documents alongside this runbook:
  - `docs/assessment/nemoclaw-dgx-spark-poam.md`
  - `docs/assessment/nemoclaw-dgx-spark-docker-runtime-position.md`
  - `docs/standards/nemoclaw-dgx-spark-docker-hardening-standard.md`
  - `docs/procedures/nemoclaw-dgx-spark-approved-container-image-inventory-template.md`
  - `docs/evidence/poam-012-no-egress-and-localhost-proof-runbook.md`

---

## 7. Evidence Collection Steps

## Step 1 - Capture host and Docker service identity

Record the basic host and service context first.

```bash
date -Is | tee raw/collection-timestamp.txt
hostname | tee raw/hostname.txt
uname -a | tee raw/uname.txt
cat /etc/os-release | tee raw/os-release.txt
which docker | tee raw/which-docker.txt
docker version | tee raw/docker-version.txt
sudo systemctl status docker --no-pager | tee raw/systemctl-docker.txt
sudo systemctl cat docker | tee raw/systemctl-cat-docker.txt
```

If `systemctl` is not present, capture the equivalent service-management evidence used by the target OS.

### Success criteria
- [ ] exact host/date captured
- [ ] Docker client/server versions captured
- [ ] Docker service state captured
- [ ] service unit or launch configuration captured

---

## Step 2 - Capture Docker daemon configuration and baseline settings

Collect the daemon configuration used by the assessed build.

```bash
sudo sh -c 'test -f /etc/docker/daemon.json && cat /etc/docker/daemon.json' | tee raw/daemon-json.txt
sudo docker info | tee raw/docker-info.txt
sudo docker system df | tee raw/docker-system-df.txt
```

Also capture any local drop-ins or related config files if present:

```bash
sudo find /etc/docker -maxdepth 2 -type f -print | tee raw/etc-docker-file-list.txt
sudo find /etc/systemd/system -maxdepth 3 -type f \( -name '*docker*' -o -path '*/docker.service.d/*' \) -print | tee raw/docker-systemd-related-files.txt
```

### Review points
Look for and note:
- whether TLS, remote API, or TCP listeners are enabled
- logging driver configuration
- default cgroup/iptables/userns settings
- insecure registries or registry mirrors
- live-restore setting
- data-root location
- any deviation from the approved hardening profile

### Success criteria
- [ ] daemon config captured or absence documented
- [ ] related service/drop-in files captured
- [ ] material settings summarized for review

---

## Step 3 - Capture Docker administrative access evidence

Docker administrative access is privileged access and should be treated like root-equivalent control.

Collect:

```bash
id | tee raw/current-user-id.txt
getent group docker | tee raw/docker-group.txt
getent group sudo | tee raw/sudo-group.txt
getent group wheel | tee raw/wheel-group.txt
sudo getfacl /var/run/docker.sock | tee raw/docker-sock-acl.txt
ls -l /var/run/docker.sock | tee raw/docker-sock-ls.txt
ps aux | grep -i '[d]ockerd' | tee raw/dockerd-process.txt
```

If `getent` or `getfacl` is unavailable, capture the platform-appropriate alternative.

### Review points
Determine and record:
- who can access Docker directly
- whether Docker socket permissions are broader than expected
- whether remote Docker administration exists
- whether access matches the approved admin list

### Success criteria
- [ ] Docker-admin-capable groups/users captured
- [ ] Docker socket permissions captured
- [ ] reviewable access summary written

---

## Step 4 - Capture container inventory

Record the full running and historical container inventory.

```bash
sudo docker ps --no-trunc | tee raw/docker-ps.txt
sudo docker ps -a --no-trunc | tee raw/docker-ps-a.txt
sudo docker container ls --format '{{.ID}}|{{.Image}}|{{.Names}}|{{.Ports}}|{{.Status}}' | tee raw/docker-container-summary.txt
```

Then create one inspect file per relevant container:

```bash
for c in $(sudo docker ps -aq); do
  sudo docker inspect "$c" > "raw/container-inspect-${c}.json"
done
```

### Review points
For each container, identify:
- container name and purpose
- image and digest
- running state and restart policy
- command/entrypoint
- published ports
- host/network mode
- mounts and bind sources
- user identity inside container if set

### Success criteria
- [ ] running container list captured
- [ ] stopped container list captured
- [ ] per-container inspect output captured
- [ ] one summary table created for assessor use

---

## Step 5 - Capture image inventory and immutable digests

Document exactly which images are present and which are active in the assessed build.

```bash
sudo docker images --digests --no-trunc | tee raw/docker-images-digests.txt
sudo docker image ls --digests --no-trunc --format '{{.Repository}}|{{.Tag}}|{{.Digest}}|{{.ID}}|{{.CreatedSince}}|{{.Size}}' | tee raw/docker-image-summary.txt
```

For key images, also capture detailed inspect output:

```bash
for i in $(sudo docker image ls -q | sort -u); do
  sudo docker image inspect "$i" > "raw/image-inspect-${i}.json"
done
```

### Review points
Confirm:
- whether running containers point to approved images
- whether mutable tags are being relied on without digest tracking
- whether unapproved or orphaned images are present
- whether image set matches the approved inventory template

### Success criteria
- [ ] image list with digests captured
- [ ] image inspect output captured
- [ ] approved vs present comparison started

---

## Step 6 - Capture network, published ports, and exposure posture

This step should be correlated with the POAM-012 localhost-only / no-egress package.

Collect Docker network and publish details:

```bash
sudo docker network ls | tee raw/docker-network-ls.txt
for n in $(sudo docker network ls -q); do
  sudo docker network inspect "$n" > "raw/network-inspect-${n}.json"
done
sudo docker port $(sudo docker ps -q) 2>/dev/null | tee raw/docker-port-mappings.txt
```

Then correlate with host listen evidence:

```bash
sudo ss -lntup | tee raw/ss-lntup.txt
sudo ss -lnx | tee raw/ss-lnx.txt
```

### Review points
Identify:
- which ports are published to host interfaces
- whether published ports bind to `127.0.0.1` or broader interfaces
- whether any unexpected management/debug ports are exposed
- whether Docker bridge/NAT behavior introduces exposure that contradicts the intended architecture

### Success criteria
- [ ] Docker network inventory captured
- [ ] published ports captured
- [ ] host listen-state correlation captured
- [ ] unexpected exposure documented as a finding if present

---

## Step 7 - Capture mounts, volumes, and host-path exposure

Document what data and host paths are exposed into containers.

```bash
sudo docker volume ls | tee raw/docker-volume-ls.txt
for v in $(sudo docker volume ls -q); do
  sudo docker volume inspect "$v" > "raw/volume-inspect-${v}.json"
done
```

Use the container inspect output to summarize:
- bind mounts from host paths
- named volumes
- read-only vs read-write mounts
- mounts that expose source repos, secrets, credentials, or Docker socket
- mounts that allow broad host filesystem access

### Review points
Flag immediately if any container mounts:
- `/var/run/docker.sock`
- `/`
- large host directories without need
- credential or secret material in plain-text paths

### Success criteria
- [ ] volume list captured
- [ ] volume inspect files captured
- [ ] bind-mount summary produced
- [ ] risky mounts flagged

---

## Step 8 - Capture effective privilege posture

Use container inspect output and targeted formatting to determine the effective privilege posture for each running container.

Suggested commands:

```bash
sudo docker inspect $(sudo docker ps -q) | tee raw/running-container-inspect-bulk.json
sudo docker ps -q | while read c; do
  echo "=== $c ===" | tee -a raw/container-privilege-summary.txt
  sudo docker inspect "$c" --format 'Name={{.Name}} Privileged={{.HostConfig.Privileged}} User={{.Config.User}} PidMode={{.HostConfig.PidMode}} IpcMode={{.HostConfig.IpcMode}} NetworkMode={{.HostConfig.NetworkMode}} ReadonlyRootfs={{.HostConfig.ReadonlyRootfs}} CapAdd={{json .HostConfig.CapAdd}} CapDrop={{json .HostConfig.CapDrop}} SecurityOpt={{json .HostConfig.SecurityOpt}} Devices={{json .HostConfig.Devices}}' | tee -a raw/container-privilege-summary.txt
 done
```

Where feasible, also capture process/user views from inside the container for the main services:

```bash
sudo docker exec <container-name> id | tee raw/docker-exec-id-<container-name>.txt
sudo docker exec <container-name> ps -ef | tee raw/docker-exec-ps-<container-name>.txt
```

Only run `docker exec` if approved and operationally safe.

### Review points
Determine whether each container:
- runs as root or non-root
- is privileged
- adds capabilities beyond baseline need
- disables AppArmor/seccomp/no-new-privileges equivalents
- uses host PID/IPC/network namespaces
- has a read-only root filesystem where expected
- maps devices beyond approved need

### Success criteria
- [ ] per-container privilege summary captured
- [ ] root vs non-root posture identified
- [ ] privileged/cap-add/device usage identified
- [ ] exceptions recorded for review

---

## Step 9 - Correlate runtime evidence to approved image and baseline documents

Use the approved image inventory template and baseline package to map runtime evidence into a reviewable set.

At minimum, create a summary table with these columns:
- container name
- function
- image repo/tag
- immutable digest
- approved image inventory reference
- published ports
- major mounts
- privilege notes
- approved / not approved / needs review

This summary should support:
- `docs/procedures/nemoclaw-dgx-spark-approved-container-image-inventory-template.md`
- `docs/assessment/nemoclaw-dgx-spark-poam.md`
- `docs/assessment/nemoclaw-dgx-spark-evidence-binder-index.md`

---

## 8. Minimum Summary Template

Use this or an equivalent summary in `summaries/docker-runtime-summary.md`.

```markdown
# Docker Runtime Summary - Assessed DGX Spark Build

Date:
Host:
Collected by:
Reviewed by:

## Docker daemon
- Version:
- Service state:
- Daemon config file present?:
- Notable settings:

## Docker administrative access
- Docker group members:
- Docker socket permissions:
- Approved admin list matched?:

## Running containers
| Container | Purpose | Image | Digest | Ports | Mounts | Privilege Notes | Status |
|---|---|---|---|---|---|---|---|
| [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [fill] | [Approved / Needs Review] |

## Key findings
- [fill]

## Exceptions / surprises
- [fill]

## Follow-up actions
1. [fill]
2. [fill]
3. [fill]
```

---

## 9. Evidence Quality Checks

Before closing collection, confirm:
- [ ] raw outputs exist for each major command area
- [ ] every running container has inspect output
- [ ] every active image is tied to a digest
- [ ] published ports are correlated with host listeners
- [ ] privileged posture has been explicitly reviewed, not assumed
- [ ] Docker-admin access evidence is captured
- [ ] approved-image and baseline references are linked

---

## 10. Common Red Flags

Flag these immediately if found:
- Docker API exposed on TCP without approved architecture and protection
- broad or unreviewed membership in Docker-admin-capable groups
- running containers from images not tracked by digest
- privileged containers without documented justification
- host network mode without documented need
- container mounts of Docker socket or sensitive host paths
- unexpected published ports on non-loopback interfaces
- stale or orphaned containers that look production-relevant
- insecure registries or unreviewed external registries

---

## 11. Deliverables

At the end of this runbook, the operator should hand back:

1. a dated Docker runtime evidence folder  
2. a concise Docker runtime summary  
3. an updated image inventory template  
4. tracker updates in `docs/evidence/collection-tracker.md`  
5. binder-index references for Docker access, config, runtime, and image evidence  
6. POA&M updates or notes for POAM-019, POAM-020, and POAM-021

---

## 12. Stop Conditions

Pause and escalate if:
- Docker is reachable remotely in a way the SSP does not describe
- unexpected privileged containers are running
- the host does not match the assessed build
- images cannot be tied to approved intake evidence
- published ports contradict the intended localhost-only design
- evidence outputs appear too sensitive for the planned storage location

---

## 13. Bottom Line

This runbook is successful if an assessor or reviewer can look at the resulting package and answer, without guessing:
- who can administer Docker
- what is actually running
- what images it came from
- how exposed it is
- how privileged it is
- and whether that runtime state matches the approved NemoClaw build
