#!/bin/bash
# Scan agent-configuration surfaces (settings, hooks, MCP, CI workflows) for
# high-risk patterns. Deterministic, network-free, machine-readable output.
#
# Implements docs/security-scan-spec.md (critical/high detectors, v1).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

FORMAT="terminal"
MIN_SEVERITY="info"
FAIL_ON="high"

show_help() {
  cat <<'EOF'
Usage: scripts/security-scan.sh [OPTIONS]

Scan agent-configuration surfaces for high-risk patterns.

Options:
  --format FMT        Output format: terminal | json | markdown (default: terminal)
  --min-severity SEV  Only report findings at/above SEV: info|low|medium|high|critical (default: info)
  --fail-on SEV       Exit non-zero if any finding at/above SEV is found: never|low|medium|high|critical (default: high)
  -h, --help          Show this help

Detectors (v1):
  SEC-PERM-001  critical  Permission overreach (wildcard/bypass tool grants)
  SEC-SECRET-001 critical Hardcoded secret literal in committed config
  SEC-CI-001    high      Untrusted input interpolated inside a workflow run: block
EOF
}

severity_rank() {
  case "$1" in
    info) echo 0 ;; low) echo 1 ;; medium) echo 2 ;; high) echo 3 ;; critical) echo 4 ;;
    never) echo 99 ;;
    *) echo -1 ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format) FORMAT="${2:-}"; shift 2 ;;
    --min-severity) MIN_SEVERITY="${2:-}"; shift 2 ;;
    --fail-on) FAIL_ON="${2:-}"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 2 ;;
  esac
done

case "$FORMAT" in
  terminal|json|markdown) ;;
  *) printf '%s\n' "[ERR ] Invalid --format: $FORMAT" >&2; exit 2 ;;
esac
[[ "$(severity_rank "$MIN_SEVERITY")" -ge 0 ]] || { printf '%s\n' "[ERR ] Invalid --min-severity: $MIN_SEVERITY" >&2; exit 2; }
[[ "$(severity_rank "$FAIL_ON")" -ge 0 ]] || { printf '%s\n' "[ERR ] Invalid --fail-on: $FAIL_ON" >&2; exit 2; }

FINDINGS="$(mktemp)"
FILTERED="$(mktemp)"
trap 'rm -f "$FINDINGS" "$FILTERED"' EXIT

# add_finding ID SEVERITY CATEGORY FILE LINE EVIDENCE RATIONALE
add_finding() {
  local rel="${4#"$PROJECT_ROOT"/}"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$rel" "$5" "$6" "$7" >> "$FINDINGS"
}

# Files to consider per surface (skip dist/, .git/, node_modules/).
config_files() {
  find "$PROJECT_ROOT" \
    \( -path "$PROJECT_ROOT/.git" -o -path "$PROJECT_ROOT/dist" -o -path "$PROJECT_ROOT/node_modules" \) -prune \
    -o -type f \( -name "settings*.json" -o -name ".mcp.json" -o -name "*.mcp.json" \) -print 2>/dev/null \
    | grep -v '/\.vscode/' || true
}

workflow_files() {
  find "$PROJECT_ROOT/.github/workflows" -type f \( -name "*.yml" -o -name "*.yaml" \) 2>/dev/null || true
}

secret_scan_files() {
  find "$PROJECT_ROOT" \
    \( -path "$PROJECT_ROOT/.git" -o -path "$PROJECT_ROOT/dist" -o -path "$PROJECT_ROOT/node_modules" \) -prune \
    -o -type f \( -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.env" -o -name "*.toml" -o -name "*.ini" \) -print 2>/dev/null \
    || true
}

# --- SEC-PERM-001: permission overreach in agent config ----------------------
scan_permissions() {
  local f ln rest
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    while IFS=: read -r ln rest; do
      [[ -z "$ln" ]] && continue
      add_finding "SEC-PERM-001" "critical" "permissions" "$f" "$ln" "$(printf '%s' "$rest" | sed 's/^[[:space:]]*//')" "Unrestricted or bypassed tool permission grant"
    done < <(grep -nE '"Bash\(\*\)"|"defaultMode"[[:space:]]*:[[:space:]]*"bypassPermissions"|--dangerously-skip-permissions|"allow"[[:space:]]*:[[:space:]]*\[[[:space:]]*"\*"[[:space:]]*\]' "$f" 2>/dev/null || true)
  done < <(config_files)
}

# --- SEC-SECRET-001: hardcoded secret literals -------------------------------
scan_secrets() {
  local f ln rest
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    while IFS=: read -r ln rest; do
      [[ -z "$ln" ]] && continue
      add_finding "SEC-SECRET-001" "critical" "secrets" "$f" "$ln" "$(printf '%s' "$rest" | sed 's/^[[:space:]]*//' | cut -c1-80)" "Hardcoded credential literal in committed config"
    done < <(grep -nEi \
      -e '-----BEGIN [A-Z ]*PRIVATE KEY-----' \
      -e 'AKIA[0-9A-Z]{16}' \
      -e '(ghp|gho|ghs|ghu)_[A-Za-z0-9]{30,}' \
      -e 'github_pat_[A-Za-z0-9_]{30,}' \
      -e 'xox[baprs]-[A-Za-z0-9-]{10,}' \
      "$f" 2>/dev/null \
      | grep -viE 'secrets\.|\$\{|example|redacted|placeholder|your[_-]?token|<[a-z_]+>' || true)

    # Generic assignment form, excluding env/secret references and examples.
    while IFS=: read -r ln rest; do
      [[ -z "$ln" ]] && continue
      add_finding "SEC-SECRET-001" "critical" "secrets" "$f" "$ln" "$(printf '%s' "$rest" | sed 's/^[[:space:]]*//' | cut -c1-80)" "Hardcoded credential literal in committed config"
    done < <(grep -nEi '(api[_-]?key|auth[_-]?token|access[_-]?token|secret|password)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'$]{16,}["'"'"']' "$f" 2>/dev/null \
      | grep -viE 'secrets\.|\$\{|env\.|vault|example|redacted|placeholder|changeme|your[_-]|test[_-]?(token|key|secret)|dummy' || true)
  done < <(secret_scan_files)
}

# --- SEC-CI-001: untrusted interpolation inside run: blocks ------------------
scan_ci_injection() {
  local f
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    while IFS=: read -r ln rest; do
      [[ -z "$ln" ]] && continue
      add_finding "SEC-CI-001" "high" "ci-injection" "$f" "$ln" "$(printf '%s' "$rest" | sed 's/^[[:space:]]*//' | cut -c1-80)" "Attacker-controlled context interpolated into a run: shell block (script injection)"
    done < <(awk '
      # Pattern of attacker-controlled GitHub context.
      function is_untrusted(s) {
        return (s ~ /\$\{\{[^}]*github\.event\.[^}]*\.(body|title|message|name|email|label|ref)/ ||
                s ~ /\$\{\{[^}]*github\.(head_ref|event\.pull_request\.head\.ref)/ ||
                s ~ /\$\{\{[^}]*github\.event\.(comment|issue|review|pull_request|commits)/)
      }
      {
        line = $0
        # current indentation (leading spaces)
        match(line, /^ */); indent = RLENGTH
      }
      # entering a block scalar run: | or run: > (optionally a "- run:" seq item)
      /^[[:space:]]*(-[[:space:]]+)?run:[[:space:]]*[|>]/ {
        in_run = 1; run_indent = indent; next
      }
      # single-line run: command on same line
      /^[[:space:]]*(-[[:space:]]+)?run:[[:space:]]*[^|>[:space:]]/ {
        if (is_untrusted(line)) print NR ":" line
        in_run = 0; next
      }
      {
        if (in_run) {
          # block ends when a non-empty line is indented at/under the run: key
          if (line ~ /[^[:space:]]/ && indent <= run_indent) { in_run = 0 }
          else if (is_untrusted(line)) { print NR ":" line }
        }
      }
    ' "$f")
  done < <(workflow_files)
}

scan_permissions
scan_secrets
scan_ci_injection

# --- filter by min-severity --------------------------------------------------
MIN_RANK="$(severity_rank "$MIN_SEVERITY")"
while IFS=$'\t' read -r id sev cat file line ev rat; do
  [[ -z "$id" ]] && continue
  [[ "$(severity_rank "$sev")" -ge "$MIN_RANK" ]] && printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$sev" "$cat" "$file" "$line" "$ev" "$rat" >> "$FILTERED"
done < "$FINDINGS"

count="$(wc -l < "$FILTERED" | tr -d ' ')"

# --- render ------------------------------------------------------------------
render_terminal() {
  printf '%s\n' "Security scan: $PROJECT_ROOT"
  if [[ "$count" -eq 0 ]]; then
    printf '%s\n' "[ OK ] No findings at or above severity: $MIN_SEVERITY"
    return
  fi
  while IFS=$'\t' read -r id sev cat file line ev rat; do
    printf '[%s] %s  %s:%s\n      %s\n      ↳ %s | %s\n' \
      "$(printf '%s' "$sev" | tr '[:lower:]' '[:upper:]')" "$id" "$file" "$line" "$rat" "$cat" "$ev"
  done < "$FILTERED"
  printf '%s\n' "Findings: $count"
}

render_json() {
  printf '{\n  "root": "%s",\n  "findings": [\n' "$PROJECT_ROOT"
  local first=1
  while IFS=$'\t' read -r id sev cat file line ev rat; do
    [[ "$first" -eq 1 ]] && first=0 || printf ',\n'
    printf '    {"id":"%s","severity":"%s","category":"%s","file":"%s","line":%s,"evidence":"%s","rationale":"%s"}' \
      "$id" "$sev" "$cat" "$file" "$line" \
      "$(printf '%s' "$ev" | sed 's/\\/\\\\/g; s/"/\\"/g')" \
      "$(printf '%s' "$rat" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  done < "$FILTERED"
  printf '\n  ],\n  "count": %s\n}\n' "$count"
}

render_markdown() {
  printf '# Security scan report\n\n'
  if [[ "$count" -eq 0 ]]; then
    printf 'No findings at or above severity: **%s**.\n' "$MIN_SEVERITY"
    return
  fi
  printf '| Severity | ID | Location | Category | Rationale |\n| --- | --- | --- | --- | --- |\n'
  while IFS=$'\t' read -r id sev cat file line ev rat; do
    # shellcheck disable=SC2016  # backticks are literal markdown, not a subshell
    printf '| %s | %s | `%s:%s` | %s | %s |\n' "$sev" "$id" "$file" "$line" "$cat" "$rat"
  done < "$FILTERED"
  printf '\n**Total findings:** %s\n' "$count"
}

case "$FORMAT" in
  terminal) render_terminal ;;
  json) render_json ;;
  markdown) render_markdown ;;
esac

# --- exit code by --fail-on threshold ----------------------------------------
FAIL_RANK="$(severity_rank "$FAIL_ON")"
if [[ "$FAIL_RANK" -le 4 ]]; then
  while IFS=$'\t' read -r _ sev _ _ _ _ _; do
    [[ -z "$sev" ]] && continue
    if [[ "$(severity_rank "$sev")" -ge "$FAIL_RANK" ]]; then
      exit 1
    fi
  done < "$FILTERED"
fi
exit 0
