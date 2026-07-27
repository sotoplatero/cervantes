# Evaluation scenarios — run before every release

Manual for now: run each scenario in a fresh Claude Code session, observe against expected behavior. A release ships only when all pass.

## 1. Fresh install
**Setup:** empty folder. **Prompt:** `cervantes` (bare word).
**Expected:** greets first (2–3 lines) before touching anything → asks for URL/sample → announces before fetching → **delegates the import to a subagent** (spawns general-purpose reading `workspace-payload/agents/importer.md`; no raw page markup lands in the onboarding transcript) → relays count+titles + the language the importer detected → prints the FULL voice fingerprint as visible text with quoted examples → asks for corrections in plain chat → AskUserQuestion wizard (one call, inferred values recommended) → cover style → scaffolds (CLAUDE.md with version marker, engine/ 6 files, `.claude/skills/` with all SIX workflows draft·polish·headlines·cover·ship·repurpose, `.claude/agents/` with researcher.md + importer.md, profile v0.1, journal, cover-style, issues/, published/) → recap with natural-language example phrases, restart mentioned as optional and never as a blocker. Never ends a turn without a question or the hand-off.

## 2. Adopt (archive exists, no marker)
**Setup:** folder with `cervantes/archive/` (some posts), nothing else.
**Expected:** greets → reports inventory → asks "is this your newsletter?" BEFORE reading contents → on yes, skips import, resumes from fingerprint, completes all remaining steps.

## 3. Update (older engine)
**Setup:** workspace whose CLAUDE.md marker reads an older version (e.g. `engine v2.4`, before `ship`/`repurpose`/`importer`); memory files present with content; an extra author-owned skill in `.claude/skills/my-own/`.
**Expected:** re-copies engine AND all six workspace skills + `researcher.md` + `importer.md` (adding `ship/`, `repurpose/`, `importer.md` that the old install lacked), regenerates CLAUDE.md with new marker, memory files byte-identical after, `my-own/` untouched, one-line report, then proceeds to the user's actual request.

## 4. Draft with notes
**Setup:** installed workspace with seeded profile. **Prompt:** "write a draft about X" + pasted notes with an opinion and one link.
**Expected:** reads profile+journal+WRITING-CRAFT → offers 2–3 angles → 3 hook options (concrete, labeled, strongest marked) → complete draft in `issues/NNN-slug/draft.md` (NNN = edition number, e.g. `012`) + a single `.baseline.md` snapshot (exact names, no `draft.<topic>.md` variants): title+dek, subheads every 2–4 paragraphs, inline links, `[[enrich:]]` notes, ONE idea, zero anti-slop patterns, nothing invented beyond the notes, reader-as-hero framing (author's story reads as the reader's mirror, no mechanical hero's-journey mold) → self-validated against QUALITY-CHECKLIST before hand-off.

## 5. Polish author-written text
**Setup:** author drops their own raw text (no .baseline.md). **Prompt:** "polish what I wrote".
**Expected:** treats 100% as author's hand → fixes only objective errors → suggestions-not-applied section quotes original + proposes alternative → logs a journal entry + bumps profile voice version with one-line confirmation.

## 6. Repair
**Setup:** healthy workspace, then delete `cervantes/engine/ANTI-SLOP.md`, `.claude/agents/researcher.md`, `.claude/skills/ship/` and `issues/`. **Prompt:** any editorial request.
**Expected:** verify restores the engine file, the agent, the `ship` skill and the folder silently (one-line report at most), memory untouched, then does the requested work. No re-onboarding.

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

## 11. Ship close-out (close the loop)
**Setup:** installed workspace with a drafted+polished issue in `issues/012-slug/`. **Prompt:** "ya lo publiqué, salió esto:" + pasted final text that differs from `draft.md` in a few spots (or a URL to the live post).
**Expected:** captures the shipped version (URL → via the `researcher` agent, never inline; pasted → verbatim) → **diffs `draft.md` vs shipped** and logs the difference to `journal.md`, carrying repeated patterns into `profile.md` with a voice-version bump and a one-line confirm → writes the clean text to `cervantes/archive/YYYY-MM-DD-slug.md` with frontmatter → **moves** `issues/012-slug/` → `published/012-slug/` (not left in both; `012-` prefix kept) → opens the resonance block (fields empty, "fill when known") and offers a check-in → does NOT publish/post anything itself. Offers the repurpose next step.

## 12. Resonance-only (numbers for a past issue)
**Setup:** an issue already shipped (in `published/`, journal entry with empty resonance fields). **Prompt:** "el 012 hizo 41% de aperturas y ganó el asunto B".
**Expected:** finds that issue's journal entry and fills the resonance fields → promotes the winning subject's **archetype** to the profile's hook-formula shortlist and notes a carry-forward → bumps voice version with a one-line confirm → moves/archives NOTHING (it's already shipped).

## 13. Repurpose into social
**Setup:** installed workspace, a finished issue in `issues/` or `published/`. **Prompt:** "haz las versiones para LinkedIn y Notes".
**Expected:** lists the 2–4 self-contained atoms before writing → writes finished, postable copy per platform (Notes ≤~55-char first line; LinkedIn scannable; thread first-tweet-stands-alone) in the author's voice and language → varied hooks across posts, full anti-slop sweep (tics that pass once in a long issue are instant tells here) → nothing invented beyond the issue → saves to `issues/NNN-slug/social.md` (or `published/…`) grouped by platform → touches no `draft.md`, snapshot, or memory file → posts/schedules nothing.

## 14. Importer stays out of the main context
**Setup:** fresh install with a real newsletter URL. 
**Expected:** the archive import runs in a subagent, not the onboarding session — no full post HTML/markdown bodies appear in the main transcript, only the importer's compact report (count, titles, detected language). Files land in `cervantes/archive/` as `YYYY-MM-DD-slug.md` with frontmatter. If no feed/archive/sitemap exists, the importer returns a `Needs` note and onboarding asks the author for 3–5 links rather than guessing URLs.

## Regression guards (from v0.1.x field testing)
- Never work silently: announce before reading/fetching/analyzing.
- Never ask the author to evaluate content they haven't seen on screen.
- Never stall after the voice analysis — drive to the end.
- Never assume found content belongs to the author without confirming.
- Never create variant draft files: the working file is always `draft.md`, the snapshot always the single `.baseline.md` (overwritten, never numbered or topic-named).
- `ship` never leaves an issue in both `issues/` and `published/`, never drops the `NNN-` edition prefix, and never invents resonance numbers or a publish date.
- `ship`/`repurpose` never publish, post, or schedule anything themselves — they record and write copy; broadcasting is always the author's action.
