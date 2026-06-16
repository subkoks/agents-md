#!/bin/bash
# Build machine-queryable structured rule artifacts from src/gotcha.md.
#
# Parses the canonical prose rules into deterministic, addressable records and
# emits two generated artifacts under dist/rules/ (gitignored, regenerated):
#   - gotcha.rules.json : LLM-native interchange (schema: gotcha-rules/v1)
#   - gotcha.rules.tsv  : flat table for dependency-free shell queries
# Both derive from a single parse, so they cannot disagree.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE="$PROJECT_ROOT/src/gotcha.md"
DIST_DIR="$PROJECT_ROOT/dist/rules"
JSON_OUT="$DIST_DIR/gotcha.rules.json"
TSV_OUT="$DIST_DIR/gotcha.rules.tsv"

MODE="build"
VERBOSE=0

show_help() {
  cat <<'EOF'
Usage: scripts/build-structured-rules.sh [OPTIONS]

Parse src/gotcha.md into structured, queryable rule artifacts.

Options:
  -h, --help     Show help
  -v, --verbose  Show detailed output
      --stdout   Print the JSON to stdout; write nothing
      --check    Regenerate to a temp dir and compare against the on-disk
                 artifacts. Exit non-zero if missing or drifted. (Asserts the
                 generator is deterministic and the artifacts are current.)

Outputs (default):
  dist/rules/gotcha.rules.json   LLM-native interchange (gotcha-rules/v1)
  dist/rules/gotcha.rules.tsv    flat table for shell queries
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -v|--verbose) VERBOSE=1; shift ;;
    --stdout) MODE="stdout"; shift ;;
    --check) MODE="check"; shift ;;
    *) printf '%s\n' "[ERR ] Unknown option: $1" >&2; show_help; exit 1 ;;
  esac
done

if [[ ! -f "$SOURCE" ]]; then
  printf '%s\n' "[ERR ] Rule source missing: $SOURCE" >&2
  exit 1
fi

# Parse src/gotcha.md. Emits JSON on stdout and writes the TSV to the path in
# the awk var `tsv`. Deterministic: ids are per-section ordinal, no timestamps.
render() {
  local tsv_path="$1"
  awk -v tsv="$tsv_path" '
    function slug(s,   r) {
      r = tolower(s)
      gsub(/[^a-z0-9]+/, "-", r)
      gsub(/^-+|-+$/, "", r)
      return r
    }
    function jesc(s) {
      gsub(/\\/, "\\\\", s)
      gsub(/"/, "\\\"", s)
      gsub(/\t/, " ", s)
      return s
    }
    function trim(s) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
      return s
    }
    function classify(key,   k) {
      # severity:type by nearest heading slug; default info:guideline.
      if (key in sev) return sev[key] ":" typ[key]
      return "info:guideline"
    }
    BEGIN {
      n = split("hard-stop:critical:hard-stop " \
                "security:high:policy " \
                "git:high:policy " \
                "testing:medium:policy " \
                "error-handling:medium:policy " \
                "performance:medium:guideline " \
                "code-quality:medium:style " \
                "universal-rules:medium:style " \
                "language-depth:medium:style " \
                "tool-and-command-policy:medium:policy " \
                "tool-integration:medium:policy " \
                "file-change-rules:medium:policy", M, " ")
      for (i = 1; i <= n; i++) {
        c = split(M[i], a, ":")
        sev[a[1]] = a[2]; typ[a[1]] = a[3]
      }
      rc = 0
      section = ""; secslug = ""
      subsec = ""; subslug = ""
    }
    # h3 subsection (check before h2/h1)
    /^### / {
      subsec = trim(substr($0, 5)); subslug = slug(subsec); next
    }
    /^## / {
      section = trim(substr($0, 4)); secslug = slug(section)
      subsec = ""; subslug = ""; next
    }
    /^# / { next }                       # h1 title
    /^\*\*.*\*\*[[:space:]]*$/ { next }  # bold preamble line, not a rule
    # indented continuation bullet -> fold into the current rule
    /^[[:space:]]+[-*][[:space:]]/ {
      if (rc > 0) {
        line = $0
        sub(/^[[:space:]]+[-*][[:space:]]+/, "", line)
        rtext[rc] = rtext[rc] " — " trim(line)
      }
      next
    }
    # top-level bullet -> a new rule
    /^[-*][[:space:]]/ {
      line = $0
      sub(/^[-*][[:space:]]+/, "", line)
      line = trim(line)
      if (line == "") next
      key = (subslug != "" ? subslug : secslug)
      cnt[key]++
      rc++
      rid[rc]  = sprintf("%s-%03d", key, cnt[key])
      rsec[rc] = section
      rsub[rc] = subsec
      split(classify(key), cl, ":")
      rsev[rc]  = cl[1]
      rtype[rc] = cl[2]
      rtext[rc] = line
      next
    }
    END {
      # TSV
      print "id\ttype\tseverity\tsection\tsubsection\ttext" > tsv
      for (i = 1; i <= rc; i++) {
        t = rtext[i]; gsub(/\t/, " ", t)
        printf "%s\t%s\t%s\t%s\t%s\t%s\n", \
          rid[i], rtype[i], rsev[i], rsec[i], rsub[i], t > tsv
      }
      # JSON
      print "{"
      print "  \"schema\": \"gotcha-rules/v1\","
      print "  \"source\": \"src/gotcha.md\","
      printf "  \"rule_count\": %d,\n", rc
      print "  \"rules\": ["
      for (i = 1; i <= rc; i++) {
        printf "    {\n"
        printf "      \"id\": \"%s\",\n", jesc(rid[i])
        printf "      \"section\": \"%s\",\n", jesc(rsec[i])
        if (rsub[i] != "")
          printf "      \"subsection\": \"%s\",\n", jesc(rsub[i])
        else
          printf "      \"subsection\": null,\n"
        printf "      \"type\": \"%s\",\n", rtype[i]
        printf "      \"severity\": \"%s\",\n", rsev[i]
        # tags: section slug, plus subsection slug when distinct
        tags = "\"" jesc(slug(rsec[i])) "\""
        if (rsub[i] != "" && slug(rsub[i]) != slug(rsec[i]))
          tags = tags ", \"" jesc(slug(rsub[i])) "\""
        printf "      \"tags\": [%s],\n", tags
        printf "      \"text\": \"%s\"\n", jesc(rtext[i])
        printf "    }%s\n", (i < rc ? "," : "")
      }
      print "  ]"
      print "}"
    }
  ' "$SOURCE"
}

case "$MODE" in
  stdout)
    tmp_tsv="$(mktemp)"
    render "$tmp_tsv"
    rm -f "$tmp_tsv"
    ;;
  build)
    mkdir -p "$DIST_DIR"
    tmp_json="$(mktemp)"
    render "$TSV_OUT" > "$tmp_json"
    mv "$tmp_json" "$JSON_OUT"
    [[ "$VERBOSE" -eq 1 ]] && printf '%s\n' "[DBG ] rules: $(grep -c '"id":' "$JSON_OUT")"
    printf '%s\n' "[ OK ] Built: $JSON_OUT"
    printf '%s\n' "[ OK ] Built: $TSV_OUT"
    ;;
  check)
    tmp_dir="$(mktemp -d)"
    render "$tmp_dir/gotcha.rules.tsv" > "$tmp_dir/gotcha.rules.json"
    rc=0
    for f in gotcha.rules.json gotcha.rules.tsv; do
      if [[ ! -f "$DIST_DIR/$f" ]]; then
        printf '%s\n' "[WARN] Missing artifact: $DIST_DIR/$f" >&2
        rc=1
      elif ! cmp -s "$tmp_dir/$f" "$DIST_DIR/$f"; then
        printf '%s\n' "[WARN] Drift detected: $DIST_DIR/$f" >&2
        rc=1
      else
        printf '%s\n' "[ OK ] In sync: $DIST_DIR/$f"
      fi
    done
    rm -rf "$tmp_dir"
    if [[ "$rc" -ne 0 ]]; then
      printf '%s\n' "[ERR ] Structured rules drift or missing — run scripts/build-structured-rules.sh" >&2
      exit 1
    fi
    printf '%s\n' "[ OK ] Structured rules in sync"
    ;;
esac
