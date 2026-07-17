# Evaluation scenarios — run before every release

Manual for now: run each scenario in a fresh Claude Code session, observe against expected behavior. A release ships only when all pass.

## 1. Fresh install
**Setup:** empty folder. **Prompt:** `cervantes` (bare word).
**Expected:** greets first (2–3 lines) before touching anything → asks for URL/sample → announces before fetching → imports archive with count+titles report → prints the FULL voice fingerprint as visible text with quoted examples → asks for corrections in plain chat → AskUserQuestion wizard (one call, inferred values recommended) → cover style → scaffolds (CLAUDE.md with version marker, engine/ 6 files, profile v0.1, journal, cover-style, issues/, published/) → recap with natural-language example phrases. Never ends a turn without a question or the hand-off.

## 2. Adopt (archive exists, no marker)
**Setup:** folder with `cervantes/archive/` (some posts), nothing else.
**Expected:** greets → reports inventory → asks "is this your newsletter?" BEFORE reading contents → on yes, skips import, resumes from fingerprint, completes all remaining steps.

## 3. Update (older engine)
**Setup:** workspace whose CLAUDE.md marker reads an older version (e.g. `engine v1.0`); memory files present with content.
**Expected:** re-copies engine, regenerates CLAUDE.md with new marker, memory files byte-identical after, one-line report, then proceeds to the user's actual request.

## 4. Draft with notes
**Setup:** installed workspace with seeded profile. **Prompt:** "write a draft about X" + pasted notes with an opinion and one link.
**Expected:** reads profile+journal+WRITING-CRAFT → offers 2–3 angles → 3 hook options (concrete, labeled, strongest marked) → complete draft in `issues/YYYY-MM-DD-slug/draft.md` + `draft.v1.md`: title+dek, subheads every 2–4 paragraphs, inline links, `[[enrich:]]` notes, ONE idea, zero anti-slop patterns, nothing invented beyond the notes → self-validated against QUALITY-CHECKLIST before hand-off.

## 5. Polish author-written text
**Setup:** author drops their own raw text (no draft.v1.md). **Prompt:** "polish what I wrote".
**Expected:** treats 100% as author's hand → fixes only objective errors → suggestions-not-applied section quotes original + proposes alternative → logs a journal entry + bumps profile voice version with one-line confirmation.

## 6. Repair
**Setup:** healthy workspace, then delete `cervantes/engine/ANTI-SLOP.md` and `issues/`. **Prompt:** any editorial request.
**Expected:** verify restores the engine file and folder silently (one-line report at most), memory untouched, then does the requested work. No re-onboarding.

## Regression guards (from v0.1.x field testing)
- Never work silently: announce before reading/fetching/analyzing.
- Never ask the author to evaluate content they haven't seen on screen.
- Never stall after the voice analysis — drive to the end.
- Never assume found content belongs to the author without confirming.
