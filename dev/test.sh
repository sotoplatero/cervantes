#!/usr/bin/env bash
# The workshop's automated checks. They gate the build and, in CI, publishing.
#
#   bash dev/test.sh                  # hook tests + lint over src/
#   bash dev/test.sh <zip>            # the same, plus the ZIP assertions
#   bash dev/test.sh --lint           # lint only (dev/build-zip.sh runs this before zipping)
#   bash dev/test.sh --hooks          # hook tests only
#   bash dev/test.sh --zip <zip>      # ZIP assertions only (dev/build-zip.sh runs this after)
#
# Like the packager's aborts, these prove the package is well formed and the
# session-start hook answers correctly. They do NOT prove Cervantes behaves —
# that is dev/SCENARIOS.md, run by hand against an unzipped build.
#
# Portable bash, no jq. JSON is checked with python when one is present; without
# it those checks are skipped with a warning rather than faked.
set -uo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"
SRC="${ROOT}/src"
HOOK="${SRC}/.cervantes/hooks/session-start"
LAUNCHER="${SRC}/.cervantes/hooks/run-hook.cmd"

usage() { echo "usage: bash dev/test.sh [--hooks] [--lint] [--zip <file>] [<file>.zip]" >&2; exit 2; }

DO_HOOKS="" DO_LINT="" ZIP=""
while [ $# -gt 0 ]; do
  case "$1" in
    --hooks) DO_HOOKS=yes ;;
    --lint)  DO_LINT=yes ;;
    --zip)   [ $# -ge 2 ] || usage; ZIP="$2"; shift ;;
    -h|--help) usage ;;
    -*) echo "unknown option: $1" >&2; usage ;;
    *) ZIP="$1"; DO_HOOKS=yes; DO_LINT=yes ;;
  esac
  shift
done
[ -n "$DO_HOOKS$DO_LINT$ZIP" ] || { DO_HOOKS=yes; DO_LINT=yes; }

FAILS=0
PASSES=0
fail() { echo "FAIL: $*" >&2; FAILS=$((FAILS + 1)); }
pass() { PASSES=$((PASSES + 1)); }
warn() { echo "WARN: $*" >&2; }

# A python that actually runs (the Windows Store alias exists but doesn't).
PY=""
for c in python3 python py; do
  if command -v "$c" >/dev/null 2>&1 && "$c" -c 'import json' >/dev/null 2>&1; then PY="$c"; break; fi
done
[ -n "$PY" ] || warn "no python found — JSON validity checks are skipped"

# json_ok < file: exit 0 when stdin parses as JSON (or when there is no python).
json_ok() {
  [ -n "$PY" ] || { cat >/dev/null; return 0; }
  "$PY" -c 'import json,sys; json.load(sys.stdin)' 2>/dev/null
}

SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT

# ============================================================== hooks ======
if [ -n "$DO_HOOKS" ]; then
  echo "── hook tests"
  TPL="${SRC}/.cervantes/templates"
  CASE_N=0

  # new_folder → sets $d to a fresh, empty newsletter folder whose path has a
  # space and accented letters, as real authors' folders do. Not called in a
  # $(subshell): the counter has to survive between cases.
  new_folder() {
    CASE_N=$((CASE_N + 1))
    d="${SCRATCH}/case ${CASE_N}/Mi revista – año ñ"
    mkdir -p "$d"
  }
  # seed_rest DIR → the two memory files besides the profile, from the templates.
  seed_rest() {
    mkdir -p "$1/voice"
    cp "${TPL}/journal.md" "$1/voice/journal.md"
    cp "${TPL}/cover-style.md" "$1/voice/cover-style.md"
  }
  # profile DIR CONTENT → voice/profile.md with exactly that content (printf %b).
  profile() {
    mkdir -p "$1/voice"
    printf '%b' "$2" > "$1/voice/profile.md"
  }

  # run_case NAME DIR STDIN EXPECT [MUST-CONTAIN] [MUST-NOT-CONTAIN] [via-launcher]
  run_case() {
    local name="$1" dir="$2" stdin="$3" expect="$4" want="${5:-}" nowant="${6:-}" via="${7:-}"
    local out ctx rc
    if [ -n "$via" ]; then
      out="$(printf '%s' "$stdin" | CLAUDE_PROJECT_DIR="$dir" bash "$LAUNCHER" session-start 2>&1)"; rc=$?
    else
      out="$(printf '%s' "$stdin" | CLAUDE_PROJECT_DIR="$dir" bash "$HOOK" 2>&1)"; rc=$?
    fi
    [ "$rc" -eq 0 ] || { fail "hook[$name]: exit code $rc"; return; }
    if [ -n "$PY" ]; then
      ctx="$(printf '%s' "$out" | "$PY" -c '
import json, sys
d = json.load(sys.stdin)
h = d["hookSpecificOutput"]
assert h["hookEventName"] == "SessionStart", h["hookEventName"]
sys.stdout.write(h["additionalContext"])
' 2>&1)" || { fail "hook[$name]: output is not valid SessionStart JSON: ${ctx}"; return; }
    else
      printf '%s' "$out" | grep -q '"hookEventName": "SessionStart"' \
        || { fail "hook[$name]: no hookEventName SessionStart"; return; }
      ctx="$out"
    fi
    printf '%s\n' "$ctx" | grep -q "^STATE: ${expect}" \
      || { fail "hook[$name]: expected 'STATE: ${expect}', got: $(printf '%s\n' "$ctx" | grep -m1 'STATE:' || echo '<no STATE line>')"; return; }
    if [ -n "$want" ] && ! printf '%s' "$ctx" | grep -qF -- "$want"; then
      fail "hook[$name]: output lacks '${want}'"; return
    fi
    if [ -n "$nowant" ] && printf '%s' "$ctx" | grep -qF -- "$nowant"; then
      fail "hook[$name]: output should not contain '${nowant}'"; return
    fi
    pass
  }

  STARTUP='{"session_id":"t","source":"startup"}'
  COMPACT='{"source":"compact"}'
  CRLF='\r\n'

  new_folder
  run_case "fresh" "$d" "$STARTUP" "not seeded" "voice profile absent"

  new_folder; seed_rest "$d"; cp "${TPL}/profile.md" "$d/voice/profile.md"
  run_case "template v0.0, no work" "$d" "$STARTUP" "not seeded" "voice profile v0.0"

  new_folder; seed_rest "$d"; profile "$d" '# P\n\nVoice version: v1.2\n'
  run_case "Voice version: v1.2" "$d" "$STARTUP" "ready" "voice profile v1.2,"

  new_folder; seed_rest "$d"; profile "$d" "# P${CRLF}${CRLF}**Voice version:** v1.2${CRLF}"
  run_case "bold + CRLF" "$d" "$STARTUP" "ready" "voice profile v1.2,"

  new_folder; seed_rest "$d"; profile "$d" '# P\n\n- Voice version: v0.3\n'
  run_case "list item" "$d" "$STARTUP" "ready" "voice profile v0.3,"

  new_folder; seed_rest "$d"; profile "$d" '# P\n\n| Field | Value |\n|---|---|\n| Voice version | v0.3 |\n'
  run_case "table row" "$d" "$STARTUP" "ready" "voice profile v0.3,"

  new_folder; seed_rest "$d"; profile "$d" '\357\273\277Voice version: v1.2\n'
  run_case "UTF-8 BOM" "$d" "$STARTUP" "ready" "voice profile v1.2,"

  new_folder; seed_rest "$d"; profile "$d" '# P\n\nVersi\303\263n de voz: v1.2\n'
  run_case "Versión de voz" "$d" "$STARTUP" "ready" "voice profile v1.2,"

  new_folder; seed_rest "$d"; profile "$d" '# P\n\nVoice: second edition\n'
  run_case "unreadable version line" "$d" "$STARTUP" "half-built" "unreadable" "Re-seed"

  new_folder; seed_rest "$d"; rm "$d/voice/journal.md"; profile "$d" 'Voice version: v1.2\n'
  run_case "seeded, journal missing" "$d" "$STARTUP" "half-built" "missing: voice/journal.md"

  new_folder; seed_rest "$d"; mkdir -p "$d/voice/archive" "$d/published/001-uno"
  printf 'old post\n' > "$d/voice/archive/001-uno.md"
  run_case "profile lost over archive + published" "$d" "$STARTUP" "half-built" "Repair → Re-seed"

  new_folder; seed_rest "$d"; cp "${TPL}/profile.md" "$d/voice/profile.md"; mkdir -p "$d/issues/001-primero"
  run_case "v0.0 + an issue folder" "$d" "$STARTUP" "half-built" "Repair → Re-seed"

  new_folder; mkdir -p "$d/cervantes/engine"
  run_case "cervantes/engine/ (v3.x)" "$d" "$STARTUP" "legacy layout"

  new_folder; mkdir -p "$d/cervantes"
  run_case "bare cervantes/ dir" "$d" "$STARTUP" "not seeded"

  new_folder
  run_case "compact on fresh" "$d" "$COMPACT" "not seeded" "do not greet again"

  new_folder; seed_rest "$d"; profile "$d" 'Voice version: v1.2\n'
  run_case "compact on ready" "$d" "$COMPACT" "ready" "" "do not greet again"

  new_folder
  run_case "fresh, through run-hook.cmd" "$d" "$STARTUP" "not seeded" "" "" via-launcher

  new_folder
  run_case "no stdin at all" "$d" "" "not seeded"
fi

# =============================================================== lint ======
if [ -n "$DO_LINT" ]; then
  echo "── lint over src/"
  [ -d "$SRC" ] || { fail "no src/"; }

  # frontmatter FIELD FILE → the value of FIELD in the leading --- block.
  frontmatter() {
    awk -v k="$1" '
      NR == 1 { sub(/^\357\273\277/, ""); if ($0 != "---") exit; next }
      /^---[[:space:]]*$/ { exit }
      index($0, k ":") == 1 {
        v = substr($0, length(k) + 2); gsub(/^[[:space:]]+|[[:space:]\r]+$/, "", v)
        if (v ~ /^[>|][-+]?$/) { want = 1; next }   # folded/literal block: take next line
        print v; exit
      }
      want { v = $0; gsub(/^[[:space:]]+|[[:space:]\r]+$/, "", v); print v; exit }
    ' "$2"
  }

  # 1. Paths inside the product are author-relative; "src/" is always a broken one.
  hits="$(grep -rnE 'src/' "$SRC" 2>/dev/null || true)"
  if [ -n "$hits" ]; then fail "a 'src/' string inside src/:"; echo "$hits" >&2; else pass; fi

  # 2. Agents: frontmatter name = filename, and src/CLAUDE.md knows about each.
  for f in "$SRC"/.claude/agents/*.md; do
    a="$(basename "$f" .md)"
    n="$(frontmatter name "$f")"
    [ "$n" = "$a" ] && pass || fail "agent ${a}.md: frontmatter name is '${n}'"
    grep -qF "\`${a}\`" "$SRC/CLAUDE.md" && pass || fail "agent ${a} is not mentioned in src/CLAUDE.md"
  done

  # 3. Every subagent_type: "x" names an agent that ships.
  for a in $(grep -rhoE 'subagent_type:[[:space:]]*"[^"]+"' "$SRC" | sed -E 's/.*"([^"]+)"/\1/' | sort -u); do
    [ -f "$SRC/.claude/agents/${a}.md" ] && pass || fail "subagent_type \"${a}\" has no src/.claude/agents/${a}.md"
  done

  # 4. Skills: frontmatter name = directory, description present.
  for f in "$SRC"/.claude/skills/*/SKILL.md; do
    s="$(basename "$(dirname "$f")")"
    n="$(frontmatter name "$f")"
    [ "$n" = "$s" ] && pass || fail "skill ${s}: frontmatter name is '${n}'"
    [ -n "$(frontmatter description "$f")" ] && pass || fail "skill ${s}: empty or missing description"
  done

  # 5. Backticked kit paths in the docs must exist. Globs and placeholders are
  #    patterns, not paths. settings.local.json is created per machine at setup,
  #    so it is mentioned but never shipped.
  refs="$(grep -rhoE '`\.(cervantes|claude)/[^`]*`' --include='*.md' "$SRC" | tr -d '`' | sort -u)"
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    case "$p" in *'*'*|*'<'*|*'{'*|*NNN*) continue ;; esac
    p="${p%% *}"
    case "$p" in .claude/settings.local.json) continue ;; esac
    [ -e "$SRC/$p" ] && pass || fail "path \`${p}\` is referenced in src/ but does not exist"
  done <<< "$refs"

  # 6. settings.json registers the hook, so it has to parse.
  if [ -n "$PY" ]; then
    json_ok < "$SRC/.claude/settings.json" && pass || fail "src/.claude/settings.json is not valid JSON"
  fi

  # 7. Nothing that looks like a credential.
  hits="$(grep -rnE 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-ant-[A-Za-z0-9_-]{10,}|AKIA[0-9A-Z]{16}|xox[bp]-[A-Za-z0-9-]{10,}' "$SRC" 2>/dev/null || true)"
  if [ -n "$hits" ]; then fail "possible secret in src/:"; echo "$hits" | cut -c1-160 >&2; else pass; fi

  # 8. LF only. .gitattributes pins every file (hooks included) to eol=lf, so
  #    there is no CRLF exception. A CR here means the working tree was checked
  #    out with autocrlf before that rule existed — the packager copies the
  #    working tree, so it would ship. Fix: strip the CRs (content is unchanged).
  # tr, not grep -U $'\r': Git for Windows' grep matches every file with that.
  hits=""
  while IFS= read -r f; do
    [ "$(tr -cd '\r' < "$f" | wc -c | tr -d ' ')" = 0 ] || hits="${hits}${f}
"
  done < <(find "$SRC" -type f ! -name '*.svg')
  hits="${hits%
}"
  if [ -n "$hits" ]; then fail "CR bytes (CRLF) in product files:"; echo "$hits" >&2; else pass; fi
fi

# ================================================================ zip ======
if [ -n "$ZIP" ]; then
  echo "── ZIP assertions: $(basename "$ZIP")"
  if [ ! -f "$ZIP" ]; then
    fail "no such ZIP: $ZIP"
  elif ! command -v unzip >/dev/null 2>&1; then
    fail "unzip is not installed — cannot inspect the ZIP"
  else
    # Exec bits: settings.json runs the launcher as a command, and the launcher
    # execs the script. Without 755 the hook can't start on macOS or Linux.
    for h in run-hook.cmd session-start; do
      mode="$(unzip -Z "$ZIP" "cervantes/.cervantes/hooks/${h}" 2>/dev/null | awk 'NR==1{print $1}')"
      case "$mode" in
        -rwx*) pass ;;
        '') fail "zip: cervantes/.cervantes/hooks/${h} is missing" ;;
        *) fail "zip: ${h} is not executable (${mode})" ;;
      esac
    done

    # File list = dev/MANIFEST. Adding or removing a product file is a
    # deliberate act; the manifest makes it a visible one.
    actual="${SCRATCH}/zip-files"
    unzip -Z1 "$ZIP" | grep -v '/$' | sed 's#^cervantes/##' | LC_ALL=C sort > "$actual"
    if [ ! -f "${ROOT}/dev/MANIFEST" ]; then
      fail "dev/MANIFEST is missing"
    elif diff <(tr -d '\r' < "${ROOT}/dev/MANIFEST" | LC_ALL=C sort) "$actual" > "${SCRATCH}/manifest.diff"; then
      pass
    else
      fail "zip contents differ from dev/MANIFEST (< manifest only, > zip only). If the change is intended, update dev/MANIFEST:"
      grep -E '^[<>]' "${SCRATCH}/manifest.diff" >&2
    fi

    # Every entry sits under the single top-level cervantes/ folder.
    stray="$(unzip -Z1 "$ZIP" | grep -v '^cervantes/' || true)"
    [ -z "$stray" ] && pass || fail "zip entries outside cervantes/: ${stray}"

    junk="$(unzip -Z1 "$ZIP" | grep -E '(^|/)(Thumbs\.db|\.DS_Store|desktop\.ini|settings\.local\.json|CLAUDE\.local\.md)$|(^|/)\.git(/|$)' || true)"
    [ -z "$junk" ] && pass || { fail "junk in the zip:"; echo "$junk" >&2; }
  fi
fi

echo
if [ "$FAILS" -gt 0 ]; then
  echo "dev/test.sh: ${FAILS} failed, ${PASSES} passed" >&2
  exit 1
fi
echo "dev/test.sh: all ${PASSES} checks passed"
