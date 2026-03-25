# POAM-012 Runbook - No-Egress and Localhost-Only Runtime Proof

**POA&M Item:** POAM-012  
**Objective:** Produce assessor-usable runtime evidence that the production NemoClaw DGX Spark system enforces:
- localhost-only bindings for internal services
- intended listening ports only
- deny-by-default or otherwise controlled network posture
- no operational internet egress in production mode

---

## 1. Important Scope Note

This runbook must be executed on the **actual DGX Spark target host inside the intended deployment mode**.

Do **not** substitute evidence from:
- a developer laptop
- the documentation workstation
- a staging machine with different network rules
- a generic Ubuntu system that is not the assessed host

---

## 2. Evidence Outputs to Collect

Store outputs under `docs/evidence/configuration-hardening/` and `docs/evidence/architecture/` only if sanitized and approved for git. Otherwise store in the approved internal evidence repository and note the location in the binder index.

Suggested filenames:
- `YYYY-MM-DD-host-os-version.txt`
- `YYYY-MM-DD-listening-services.txt`
- `YYYY-MM-DD-firewall-status.txt`
- `YYYY-MM-DD-routing-and-interfaces.txt`
- `YYYY-MM-DD-localhost-bind-validation.txt`
- `YYYY-MM-DD-egress-test-results.txt`
- `YYYY-MM-DD-openclaw-status.txt`

---

## 3. Baseline Capture Commands

Run these read-only commands on the target DGX Spark host.

### 3.1 Host identity and OS
```bash
date -Is
hostnamectl
uname -a
cat /etc/os-release
```

### 3.2 Listening services
Use one or more of the following:
```bash
ss -ltnp
ss -ltnup
sudo lsof -nP -iTCP -sTCP:LISTEN
```

### 3.3 Firewall state
Collect whichever applies to the actual build:
```bash
sudo ufw status verbose
sudo nft list ruleset
sudo iptables -S
sudo ip6tables -S
```

### 3.4 Interfaces and routes
```bash
ip addr
ip route
```

### 3.5 OpenClaw / service health snapshot
```bash
openclaw status
openclaw status --deep
```

---

## 4. Expected Runtime Assertions to Validate

The assessor-ready evidence should support the following assertions:

1. nginx is the only intended externally reachable application listener.  
2. Ollama binds to `127.0.0.1:11434` only.  
3. PostgreSQL binds to `127.0.0.1:5432` only.  
4. Streamlit binds to `127.0.0.1:8501` only.  
5. No additional unexpected application listeners are present.  
6. Host firewall rules reflect approved inbound allowances and restricted outbound behavior.  
7. Production-mode egress to the public internet is blocked or otherwise denied by approved architecture.  

---

## 5. Localhost Binding Validation Worksheet

For each expected service, capture:
- process name
- port
- bind address
- whether exposure matches the approved baseline

Suggested table to fill in after command capture:

| Service | Expected Bind | Observed Bind | Result | Notes |
|---|---|---|---|---|
| nginx | `0.0.0.0:443` or approved internal interface only | [fill] | [Pass/Fail] | [fill] |
| Ollama | `127.0.0.1:11434` | [fill] | [Pass/Fail] | [fill] |
| PostgreSQL | `127.0.0.1:5432` | [fill] | [Pass/Fail] | [fill] |
| Streamlit | `127.0.0.1:8501` | [fill] | [Pass/Fail] | [fill] |
| Other listeners | none unless approved | [fill] | [Pass/Fail] | [fill] |

---

## 6. Egress Validation

### 6.1 Safer first step: rules review
Before any live outbound connectivity test, review firewall and route rules to determine whether egress should already be demonstrably blocked by configuration.

### 6.2 Live egress tests
Only run live egress tests if they are approved under the enclave test plan.

Example controlled tests:
```bash
curl -I --max-time 5 https://example.com
curl -I --max-time 5 https://1.1.1.1
nc -zvw 5 1.1.1.1 443
```

Capture:
- command run
- date/time
- result (timeout, blocked, refused, unexpectedly successful)
- any corresponding firewall or audit evidence

### 6.3 Expected result
In production mode, unauthorized public egress should fail in a way consistent with the approved architecture.

If any public egress succeeds unexpectedly, treat it as a POA&M issue or incident candidate depending on context.

---

## 7. Assessor Notes

The most persuasive evidence for this control story is not just a firewall screenshot. It is:
- bind/listen output
- firewall configuration output
- route/interface output
- one or more approved egress test results
- explanation of which interface or boundary permits nginx inbound access while preserving local-only service bindings

---

## 8. Binder Mapping

Update these evidence binder entries after collection:
- service inventory / listen-port capture
- firewall ruleset capture
- external connection inventory
- OpenClaw status snapshot
- no-egress validation notes

---

## 9. Closure Criteria for POAM-012

POAM-012 should only be closed when:
1. runtime evidence has been collected from the DGX Spark itself  
2. the evidence matches the approved baseline  
3. any exceptions are documented and approved  
4. the evidence binder and collection tracker are updated
