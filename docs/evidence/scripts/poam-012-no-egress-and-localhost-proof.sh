#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y-%m-%d_%H%M%S)"
OUTDIR="docs/evidence/configuration-hardening/${STAMP}-poam-012"
WITH_EGRESS_TESTS=0

usage() {
  cat <<'EOF'
Usage:
  poam-012-no-egress-and-localhost-proof.sh [--outdir PATH] [--with-egress-tests]

Purpose:
  Read-only evidence capture for POAM-012 on the actual DGX Spark target host.

Notes:
  - Run this on the assessed DGX Spark system, not a developer workstation.
  - The script does not change host configuration.
  - Live egress tests are OPTIONAL and only run with --with-egress-tests.
  - Review outputs before committing them anywhere; they may be sensitive.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --outdir)
      OUTDIR="$2"
      shift 2
      ;;
    --with-egress-tests)
      WITH_EGRESS_TESTS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

mkdir -p "$OUTDIR"

note() {
  printf '%s\n' "$*"
}

write_meta() {
  cat > "$OUTDIR/00-capture-metadata.txt" <<EOF
POAM-012 capture metadata
Timestamp: $(date -Is)
Hostname: $(hostname 2>/dev/null || echo unknown)
Working directory: $(pwd)
Output directory: $OUTDIR
With live egress tests: $WITH_EGRESS_TESTS
EOF
}

can_sudo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    return 0
  fi
  if command -v sudo >/dev/null 2>&1 && sudo -n true >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

run_sh() {
  local label="$1"
  local cmd="$2"
  local outfile="$OUTDIR/${label}.txt"
  {
    echo "# label: $label"
    echo "# timestamp: $(date -Is)"
    echo "# command: $cmd"
    echo
    bash -lc "$cmd"
  } >"$outfile" 2>&1 || true
}

run_sudo_sh() {
  local label="$1"
  local cmd="$2"
  local outfile="$OUTDIR/${label}.txt"
  {
    echo "# label: $label"
    echo "# timestamp: $(date -Is)"
    echo "# command: $cmd"
    echo
    if [[ "$(id -u)" -eq 0 ]]; then
      bash -lc "$cmd"
    elif can_sudo; then
      sudo bash -lc "$cmd"
    else
      echo "SKIPPED: sudo/root access not available for this read-only capture"
    fi
  } >"$outfile" 2>&1 || true
}

write_templates() {
  cat > "$OUTDIR/98-localhost-bind-validation-template.md" <<'EOF'
# Localhost Bind Validation Template

| Service | Expected Bind | Observed Bind | Result | Notes |
|---|---|---|---|---|
| nginx | `0.0.0.0:443` or approved internal interface only | [fill] | [Pass/Fail] | [fill] |
| Ollama | `127.0.0.1:11434` | [fill] | [Pass/Fail] | [fill] |
| PostgreSQL | `127.0.0.1:5432` | [fill] | [Pass/Fail] | [fill] |
| Streamlit | `127.0.0.1:8501` | [fill] | [Pass/Fail] | [fill] |
| Other listeners | none unless approved | [fill] | [Pass/Fail] | [fill] |
EOF

  cat > "$OUTDIR/99-review-summary-template.md" <<'EOF'
# POAM-012 Review Summary Template

## Assertions to validate
1. nginx is the only intended externally reachable application listener.
2. Ollama binds to localhost only.
3. PostgreSQL binds to localhost only.
4. Streamlit binds to localhost only.
5. No unexpected application listeners are present.
6. Firewall posture matches approved baseline.
7. Unauthorized public egress is blocked in production mode.

## Reviewer conclusion
- Result: [Pass / Pass with exceptions / Fail]
- Reviewer: [fill]
- Date: [fill]
- Notes: [fill]
EOF
}

note "[+] Writing capture metadata to $OUTDIR"
write_meta
write_templates

note "[+] Capturing host and OS details"
run_sh "01-date-and-host" "date -Is; echo; hostnamectl || true; echo; uname -a; echo; cat /etc/os-release"

note "[+] Capturing listening services"
run_sh "02-ss-ltnp" "command -v ss >/dev/null 2>&1 && ss -ltnp || echo 'ss not available'"
run_sh "03-ss-ltnup" "command -v ss >/dev/null 2>&1 && ss -ltnup || echo 'ss not available'"
run_sudo_sh "04-lsof-listen" "command -v lsof >/dev/null 2>&1 && lsof -nP -iTCP -sTCP:LISTEN || echo 'lsof not available'"

note "[+] Capturing firewall state"
run_sudo_sh "05-ufw-status" "command -v ufw >/dev/null 2>&1 && ufw status verbose || echo 'ufw not available'"
run_sudo_sh "06-nft-ruleset" "command -v nft >/dev/null 2>&1 && nft list ruleset || echo 'nft not available'"
run_sudo_sh "07-iptables" "command -v iptables >/dev/null 2>&1 && iptables -S || echo 'iptables not available'"
run_sudo_sh "08-ip6tables" "command -v ip6tables >/dev/null 2>&1 && ip6tables -S || echo 'ip6tables not available'"

note "[+] Capturing interfaces and routes"
run_sh "09-ip-addr" "command -v ip >/dev/null 2>&1 && ip addr || echo 'ip not available'"
run_sh "10-ip-route" "command -v ip >/dev/null 2>&1 && ip route || echo 'ip not available'"

note "[+] Capturing OpenClaw status if available"
run_sh "11-openclaw-status" "command -v openclaw >/dev/null 2>&1 && openclaw status || echo 'openclaw not available'"
run_sh "12-openclaw-status-deep" "command -v openclaw >/dev/null 2>&1 && openclaw status --deep || echo 'openclaw not available'"

if [[ "$WITH_EGRESS_TESTS" -eq 1 ]]; then
  note "[+] Running OPTIONAL live egress tests"
  run_sh "13-egress-curl-example-com" "command -v curl >/dev/null 2>&1 && curl -I --max-time 5 https://example.com || echo 'curl test failed or curl not available'"
  run_sh "14-egress-curl-1.1.1.1" "command -v curl >/dev/null 2>&1 && curl -I --max-time 5 https://1.1.1.1 || echo 'curl test failed or curl not available'"
  run_sh "15-egress-nc-1.1.1.1-443" "command -v nc >/dev/null 2>&1 && nc -zvw 5 1.1.1.1 443 || echo 'nc test failed or nc not available'"
else
  cat > "$OUTDIR/13-egress-tests-skipped.txt" <<'EOF'
Live egress tests were not run.
Re-run the script with --with-egress-tests only if that test activity is approved for the target environment.
EOF
fi

note "[+] Capture complete: $OUTDIR"
note "[+] Review outputs for sensitivity before committing or sharing them"
