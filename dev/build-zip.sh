#!/usr/bin/env bash
# Packages src/ as the Cervantes ZIP that goes out to subscribers.
#
#   bash dev/build-zip.sh <version> [--test]
#
# There is no exclusion list, on purpose: src/ contains the product and nothing
# else, so packaging is "copy src/, name it cervantes, zip it". The checks below
# are cheap insurance against that invariant being broken, not a filter.
#
# --test also unzips the result into .testing/<version>/, which is where the
# eval suite in dev/SCENARIOS.md runs. Evals never run against src/ itself.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"

if [ $# -lt 1 ]; then
  echo "usage: bash dev/build-zip.sh <version> [--test]" >&2
  exit 1
fi
VERSION="$1"; shift
TEST_UNZIP=""
for arg in "$@"; do
  case "$arg" in
    --test) TEST_UNZIP="yes" ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

OUT="${ROOT}/dist/cervantes-${VERSION}.zip"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
DEST="${STAGE}/cervantes"

[ -d "${ROOT}/src" ] || { echo "ABORT: no src/ — is this the Cervantes repo?" >&2; exit 1; }

mkdir -p "${ROOT}/dist"
cp -R "${ROOT}/src" "$DEST"
find "$DEST" -name '.DS_Store' -delete

# --- invariants --------------------------------------------------------------
# An author's newsletter must never be in the package. src/ has no business
# holding one, so finding one means somebody ran onboarding in the source tree.
for leak in voice issues published .git .gitignore; do
  if [ -e "${DEST}/${leak}" ]; then
    echo "ABORT: ${leak} ended up in the package — src/ is polluted" >&2
    exit 1
  fi
done

# The hooks must arrive as LF and executable, or they break under bash on
# Windows ("bad interpreter: \r") and on any shell that can't exec them.
for h in session-start run-hook.cmd; do
  f="${DEST}/.cervantes/hooks/${h}"
  [ -f "$f" ] || { echo "ABORT: missing hook ${h}" >&2; exit 1; }
  if LC_ALL=C grep -q $'\r' "$f"; then
    echo "ABORT: ${h} has CRLF line endings" >&2; exit 1
  fi
  [ -x "$f" ] || chmod +x "$f"
done

# The seven skills and four agents are what make the folder work at all.
for s in cervantes draft polish headlines cover ship repurpose; do
  [ -f "${DEST}/.claude/skills/${s}/SKILL.md" ] || { echo "ABORT: missing skill ${s}" >&2; exit 1; }
done
for a in researcher importer interviewer editor; do
  [ -f "${DEST}/.claude/agents/${a}.md" ] || { echo "ABORT: missing agent ${a}" >&2; exit 1; }
done
for e in STRUCTURE WRITING-CRAFT HOOK-FORMULAS ANTI-SLOP TEMPLATES QUALITY-CHECKLIST MEMORY-SCHEMA; do
  [ -f "${DEST}/.cervantes/engine/${e}.md" ] || { echo "ABORT: missing engine ${e}.md" >&2; exit 1; }
done
[ -f "${DEST}/CLAUDE.md" ] || { echo "ABORT: missing CLAUDE.md" >&2; exit 1; }

# Paths inside the product are relative to the author's folder. A "src/" in
# there is a path that got broken while moving files around.
if grep -rlq 'src/\.cervantes\|src/\.claude\|src/voice' "$DEST" 2>/dev/null; then
  echo "ABORT: a src/-prefixed path leaked into the product:" >&2
  grep -rln 'src/\.cervantes\|src/\.claude\|src/voice' "$DEST" >&2
  exit 1
fi

# --- package -----------------------------------------------------------------
rm -f "$OUT"
( cd "$STAGE" && zip -q -r -X "$OUT" cervantes )

echo "→ dist/cervantes-${VERSION}.zip  ($(unzip -Z1 "$OUT" | grep -vc '/$') files)"

if [ -n "$TEST_UNZIP" ]; then
  TESTDIR="${ROOT}/.testing/${VERSION}"
  rm -rf "$TESTDIR"
  mkdir -p "$TESTDIR"
  unzip -q "$OUT" -d "$TESTDIR"
  echo "→ .testing/${VERSION}/cervantes  (open this in Claude Code; suite: dev/SCENARIOS.md)"
fi
