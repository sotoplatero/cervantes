# Evaluation scenarios — run before every release

Manual for now: run each scenario in a fresh Claude Code session, observe against expected behavior. A release ships only when all pass.

## 1. Fresh install
**Setup:** empty folder. **Prompt:** `cervantes` (bare word).
**Expected:** greets first (2–3 lines) before touching anything → asks for URL/sample → announces before fetching → imports archive with count+titles report → prints the FULL voice fingerprint as visible text with quoted examples → asks for corrections in plain chat → AskUserQuestion wizard (one call, inferred values recommended) → cover style → scaffolds (CLAUDE.md with version marker, engine/ 6 files, `.claude/skills/` with all four workflows, `.claude/agents/researcher.md`, profile v0.1, journal, cover-style, issues/, published/) → recap with natural-language example phrases, restart mentioned as optional and never as a blocker. Never ends a turn without a question or the hand-off.

## 2. Adopt (archive exists, no marker)
**Setup:** folder with `cervantes/archive/` (some posts), nothing else.
**Expected:** greets → reports inventory → asks "is this your newsletter?" BEFORE reading contents → on yes, skips import, resumes from fingerprint, completes all remaining steps.

## 3. Update (older engine)
**Setup:** workspace whose CLAUDE.md marker reads an older version (e.g. `engine v1.0`); memory files present with content; an extra author-owned skill in `.claude/skills/my-own/`.
**Expected:** re-copies engine AND the four workspace skills + `researcher.md`, regenerates CLAUDE.md with new marker, memory files byte-identical after, `my-own/` untouched, one-line report, then proceeds to the user's actual request.

## 4. Draft with notes
**Setup:** installed workspace with seeded profile. **Prompt:** "write a draft about X" + pasted notes with an opinion and one link.
**Expected:** reads profile+journal+WRITING-CRAFT → offers 2–3 angles → 3 hook options (concrete, labeled, strongest marked) → complete draft in `issues/NNN-slug/draft.md` (NNN = edition number, e.g. `012`) + a single `.baseline.md` snapshot (exact names, no `draft.<topic>.md` variants): title+dek, subheads every 2–4 paragraphs, inline links, `[[enrich:]]` notes, ONE idea, zero anti-slop patterns, nothing invented beyond the notes, reader-as-hero framing (author's story reads as the reader's mirror, no mechanical hero's-journey mold) → self-validated against QUALITY-CHECKLIST before hand-off.

## 5. Polish author-written text
**Setup:** author drops their own raw text (no .baseline.md). **Prompt:** "polish what I wrote".
**Expected:** treats 100% as author's hand → fixes only objective errors → suggestions-not-applied section quotes original + proposes alternative → logs a journal entry + bumps profile voice version with one-line confirmation.

## 6. Repair
**Setup:** healthy workspace, then delete `cervantes/engine/ANTI-SLOP.md`, `.claude/agents/researcher.md` and `issues/`. **Prompt:** any editorial request.
**Expected:** verify restores the engine file, the agent and the folder silently (one-line report at most), memory untouched, then does the requested work. No re-onboarding.

## 7. Hook stays out of every other project
**Setup:** any folder that is NOT a newsletter workspace (no `cervantes/`, no marker in CLAUDE.md) with the plugin installed. **Prompt:** anything unrelated.
**Expected:** the SessionStart hook emits nothing, exits 0, and the session shows no trace of Cervantes. Verify directly too: `cd <folder> && bash hooks/session-start` prints zero bytes.

## 8. Hook replaces the self-check
**Setup:** healthy workspace. **Prompt:** an editorial request.
**Expected:** a `<cervantes-workspace>` block with `STATE: healthy` is in context before the first turn; Claude does NOT stat `cervantes/`, list `engine/`, or narrate a verification, and goes straight to the work. Then delete `cervantes/engine/ANTI-SLOP.md` and restart: the block reports it under MISSING and the repair happens from that list, without a fresh filesystem sweep.

## 9. Research is delegated, not inlined
**Setup:** seeded workspace. **Prompt:** "draft about X" with two external links and one checkable claim in the notes.
**Expected:** spawns the `researcher` agent rather than fetching pages in the main session; no raw page content lands in the transcript; the returned brief drives the draft — links used are ones the agent actually opened, unverified claims become `[[fact?: ...]]`, and a contradiction with the author's notes is raised with the author instead of being written around silently.

## 10. Workspace skills work before a restart
**Setup:** run a fresh install to completion, then WITHOUT restarting, prompt "polish what I wrote" with pasted text.
**Expected:** the `polish` skill isn't registered yet, so Claude reads `.claude/skills/polish/SKILL.md` and follows it — same behavior as scenario 5. It does not improvise, and does not demand a restart first.

## Regression guards (from v0.1.x field testing)
- Never work silently: announce before reading/fetching/analyzing.
- Never ask the author to evaluate content they haven't seen on screen.
- Never stall after the voice analysis — drive to the end.
- Never assume found content belongs to the author without confirming.
- Never create variant draft files: the working file is always `draft.md`, the snapshot always the single `.baseline.md` (overwritten, never numbered or topic-named).
