#!/usr/bin/env bash
# Packages src/ as the Cervantes ZIP that goes out to subscribers.
#
#   bash dev/build-zip.sh [version] [--test]
#
# The version only names the file. Omit it and dev/VERSION is used, which is
# what CI does — one number in one place. Note where that file lives: the
# workshop tracks a version, the product does not carry one. Nothing writes it
# into src/, and nothing in the ZIP mentions it.
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

usage() { echo "usage: bash dev/build-zip.sh [version] [--test]" >&2; exit 1; }

VERSION=""
if [ $# -ge 1 ]; then
  case "$1" in
    --*) ;;                       # an option — the version is coming from the file
    ''|-*) usage ;;
    *) VERSION="$1"; shift ;;
  esac
fi
if [ -z "$VERSION" ]; then
  [ -f "${ROOT}/dev/VERSION" ] || { echo "ABORT: no version given and no dev/VERSION" >&2; exit 1; }
  VERSION="$(tr -d '[:space:]' < "${ROOT}/dev/VERSION")"
  [ -n "$VERSION" ] || { echo "ABORT: dev/VERSION is empty" >&2; exit 1; }
fi

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

# The packager copies the working tree, so anything untracked or git-ignored
# inside src/ would ship to every subscriber. Abort until src/ is clean in
# git's eyes (.DS_Store excepted — it's deleted from the stage below).
strays="$(git -C "$ROOT" status --porcelain --ignored -- src/ 2>/dev/null | grep -E '^(\?\?|!!)' | grep -v '\.DS_Store' || true)"
if [ -n "$strays" ]; then
  echo "ABORT: untracked or ignored files inside src/ would ship in the ZIP:" >&2
  echo "$strays" >&2
  exit 1
fi

cp -R "${ROOT}/src" "$DEST"
find "$DEST" -name '.DS_Store' -delete

# --- invariants --------------------------------------------------------------
# An author's newsletter must never be in the package. src/ has no business
# holding one, so finding one means somebody ran onboarding in the source tree.
for leak in voice issues published .git .gitignore .claude/settings.local.json; do
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
for t in profile journal cover-style; do
  [ -f "${DEST}/.cervantes/templates/${t}.md" ] || { echo "ABORT: missing template ${t}.md" >&2; exit 1; }
done
[ -f "${DEST}/CLAUDE.md" ] || { echo "ABORT: missing CLAUDE.md" >&2; exit 1; }
[ -f "${DEST}/README.md" ] || { echo "ABORT: missing README.md (the author's docs)" >&2; exit 1; }

# settings.json is the only thing that registers the SessionStart hook — without
# it the unzipped folder does nothing on open, and every eval that starts from
# the hook dies. Existence isn't enough: it must point at the launcher.
[ -f "${DEST}/.claude/settings.json" ] || { echo "ABORT: missing .claude/settings.json" >&2; exit 1; }
grep -q 'run-hook\.cmd' "${DEST}/.claude/settings.json" || {
  echo "ABORT: .claude/settings.json no longer registers run-hook.cmd" >&2; exit 1
}

# Paths inside the product are relative to the author's folder. A "src/" in
# there is a path that got broken while moving files around.
if grep -rlq 'src/\.cervantes\|src/\.claude\|src/voice' "$DEST" 2>/dev/null; then
  echo "ABORT: a src/-prefixed path leaked into the product:" >&2
  grep -rln 'src/\.cervantes\|src/\.claude\|src/voice' "$DEST" >&2
  exit 1
fi

# --- package -----------------------------------------------------------------
mkdir -p "${ROOT}/dist"
rm -f "$OUT"

# Info-ZIP is the reference packager. Where it's missing — a stock Git for
# Windows shell ships unzip but no zip — Python writes the same archive, setting
# the Unix mode bits by hand. That is not cosmetic: settings.json runs the
# launcher as a command, so run-hook.cmd has to arrive executable or the
# SessionStart hook cannot start on macOS or Linux. A native Windows archiver
# would flatten every entry to 0644, because NTFS has no executable bit to read.
if command -v zip >/dev/null 2>&1; then
  ( cd "$STAGE" && zip -q -r -X "$OUT" cervantes )
else
  PY=""
  for c in python3 python py; do
    if command -v "$c" >/dev/null 2>&1 && "$c" -c '' >/dev/null 2>&1; then PY="$c"; break; fi
  done
  [ -n "$PY" ] || { echo "ABORT: neither zip nor python is available to package" >&2; exit 1; }
  # Native Python cannot resolve the shell's /tmp- and /c-style paths.
  if command -v cygpath >/dev/null 2>&1; then
    PY_STAGE="$(cygpath -w "$STAGE")"; PY_OUT="$(cygpath -w "$OUT")"
  else
    PY_STAGE="$STAGE"; PY_OUT="$OUT"
  fi
  "$PY" - "$PY_STAGE" "$PY_OUT" <<'PYZIP'
import os, stat, sys, time, zipfile

stage, out = sys.argv[1], sys.argv[2]
on_windows = os.name == "nt"

def walk(root):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames.sort()
        filenames.sort()
        yield dirpath, True
        for f in filenames:
            yield os.path.join(dirpath, f), False

with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for path, is_dir in walk(stage):
        rel = os.path.relpath(path, stage).replace(os.sep, "/")
        if rel == ".":
            continue
        st = os.stat(path)
        info = zipfile.ZipInfo(rel + "/" if is_dir else rel,
                               date_time=time.localtime(st.st_mtime)[:6])
        info.create_system = 3  # Unix, so unzip honours the mode below
        if is_dir:
            info.external_attr = (0o40755 << 16) | 0x10
            z.writestr(info, b"")
            continue
        # Everything under .cervantes/hooks/ is a script that gets executed.
        executable = "/.cervantes/hooks/" in "/" + rel or (
            not on_windows and bool(st.st_mode & stat.S_IXUSR))
        info.external_attr = (0o100755 if executable else 0o100644) << 16
        info.compress_type = zipfile.ZIP_DEFLATED
        with open(path, "rb") as fh:
            z.writestr(info, fh.read())
PYZIP
fi

echo "→ dist/cervantes-${VERSION}.zip  ($(unzip -Z1 "$OUT" | grep -vc '/$') files)"

if [ -n "$TEST_UNZIP" ]; then
  TESTDIR="${ROOT}/.testing/${VERSION}"
  rm -rf "$TESTDIR"
  mkdir -p "$TESTDIR"
  unzip -q "$OUT" -d "$TESTDIR"
  echo "→ .testing/${VERSION}/cervantes  (open this in Claude Code; suite: dev/SCENARIOS.md)"
fi
