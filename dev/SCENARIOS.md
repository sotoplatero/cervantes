# Evaluation scenarios — run before every release

Manual for now: run each scenario in a fresh Claude Code session, observe against expected behavior. A release ships only when all pass.

**Where these run.** Never against `src/`. Build the package and open the unzipped copy:

```
bash dev/build-zip.sh <version> --test
cd .testing/<version>/cervantes      # ← open THIS in Claude Code
```

`src/` is the source tree; the ZIP is what a subscriber actually receives, and only the unzipped folder exercises the real thing — its `.claude/settings.json` at the project root, its skills registered, its hook firing before the first message. A scenario that passes in `src/` can still be broken in the package. "A freshly unzipped folder" below always means a fresh `--test` build.

Scenarios 2 and 3 need a second folder (an older or seeded workspace) to migrate or move from: build it by hand under `.testing/fixtures/` — a `--test` build wipes only `.testing/<version>/`, so fixtures there survive rebuilds — and never point them at `src/`.

## 1. A fresh copy starts itself
**Setup:** a freshly unzipped folder — no `voice/`, no `issues/`, no `published/`. **Prompt:** none. Just open it.
**Expected:** the session-start hook injects `STATE: not seeded` and Cervantes **opens the conversation on its own**: greets (2–3 lines) → prints the seven-line checklist → asks for URL/sample. The author never types a command. Then: announces before fetching → **delegates the import to the `importer` agent** (no raw page markup in the transcript) → relays count+titles + the language the importer detected → prints the FULL voice fingerprint as visible text with quoted examples → asks for corrections in plain chat → AskUserQuestion wizard (one call, inferred values recommended) → cover style → seeds `voice/` (profile v0.1 with a **length tier**, the newsletter name and the language recorded in it, journal, cover-style) + `issues/` + `published/` + the statusline in `settings.local.json` → recap with natural-language example phrases. Never ends a turn without a question or the hand-off.
**Fails if:** it waits to be asked; it copies the engine anywhere; it writes or regenerates `CLAUDE.md`; it touches anything under `.cervantes/` or `.claude/` except `settings.local.json`; it mentions a restart.

## 2. Migrate a v3.x workspace
**Setup:** the old layout — `cervantes/profile.md` (seeded, real content), `cervantes/journal.md`, `cervantes/cover-style.md`, `cervantes/archive/` with posts, `cervantes/engine/` with the 7 files, a `CLAUDE.md` carrying `<!-- cervantes: engine v3.0 -->`, plus `issues/` and `published/` with work in them. **Prompt:** any editorial request.
**Expected:** hook reports `STATE: legacy layout` → the memory files and `archive/` move to `voice/` **byte-identical** → `cervantes/engine/` is deleted → the old `CLAUDE.md` is replaced by this folder's static one, with no marker (never merged) → the name and language are confirmed present in `voice/profile.md` → one-line report → then it does the work that was asked. `issues/` and `published/` untouched.
**Fails if:** any memory line changes; the old `cervantes/` is deleted while still holding something the author put there; the author is re-onboarded.

## 3. Update = move house (the ZIP flow)
**Setup:** a seeded workspace ("old"), with content in `voice/archive/`, one issue in `issues/`, one in `published/`, and a statusline in `.claude/settings.local.json`. Unzip a fresh copy of the kit as "new". Open **new** in Claude Code.
**Expected:** the hook reports `not seeded` → the greeting offers the returning-author branch in one line ("if you already have a Cervantes folder, tell me where it is") **and** proceeds to step 1 without blocking → on being given the old path, it switches to **Move house**: moves `voice/` (incl. `archive/`), `issues/`, `published/` and `settings.local.json` across **verbatim**, runs Repair once for schema drift, reports counts in one or two lines, and **leaves the old folder untouched** — saying so.
**Fails if:** it re-onboards over the moved profile; it asks the author to copy or drag anything themselves; it names `.cervantes/` or `.claude/` to the author; it deletes or offers to delete the old folder in the same breath as the move; any memory line changes.

**Schema drift, separately:** add a new required section header to `MEMORY-SCHEMA.md` that the author's `profile.md` lacks. **Expected:** Cervantes names what's new and offers to add the header, **preserving every existing line** — never blanking or rewriting one. If the missing piece is the **length tier** and the profile's length line is ambiguous, it asks once with `AskUserQuestion`. No version numbers appear anywhere in the exchange.

## 4. Draft with notes — structure before prose
**Setup:** seeded workspace, length tier `standard`. **Prompt:** "write a draft about X" + pasted notes with an opinion and one link.
**Expected:** reads profile+journal+WRITING-CRAFT → delegates research → offers 2–3 angles → 3 hook options (concrete, labeled, strongest marked) → creates `issues/NNN-slug/` and writes **`brief.md` FIRST**: angle, promise, single idea, tier, hook+tension+loop-close+callback, and an outline table where **every row names what feeds it** → asks for corrections and fills *Approved by the author* → **only then** writes `draft.md` section by section (each section's opening shape differs from the others) → seams pass → **spawns the `editor` agent** and resolves its Must-fix items → saves the single `.baseline.md` → hands off with the verdict summarized in one line.
**Fails if:** prose starts before the brief is approved; a section is written that the brief fed with nothing; variant file names appear (`draft.<topic>.md`, `draft.v2.md`); the editor is skipped.

## 4b. Brief rejected mid-flow
**Setup:** as above. **Prompt:** at brief approval, "no, el ángulo es otro: <X>".
**Expected:** the brief is rewritten (angle, promise, outline re-derived), re-approved, and no prose was written in the meantime. Zero words wasted — that's the whole point of the checkpoint.

## 4c. Interview for the gaps
**Setup:** seeded workspace. **Prompt:** "draft about X" with notes thin on personal material (a topic and an opinion, no story, no numbers).
**Expected:** the outline exposes sections fed by nothing → spawns the `interviewer` agent → asks its ranked questions via **`AskUserQuestion`** (not as chat prose) → pastes the answers into the brief's *Interview answers*, quoted → sections that stay unfed are cut or marked `[[enrich:]]`, never filled with invention. If the archive already answers a gap, it says so instead of asking.

## 4d. Length tier honesty (anti-padding)
**Setup:** profile tier `deep` (~1800–2500). **Prompt:** "draft about X" with material that only supports ~900 words.
**Expected:** says so **before writing** and proposes the shorter tier, naming what's missing (and offers the interview to get the material). Does NOT deliver a padded 2.000-word piece, and does NOT silently hand back 900 words as if it were the `deep` issue asked for.

## 5. Polish author-written text
**Setup:** author drops their own raw text (no .baseline.md). **Prompt:** "polish what I wrote".
**Expected:** treats 100% as author's hand → fixes only objective errors → runs the `editor` agent with pass=`polish`, and its findings that land on the author's sentences appear under **suggestions NOT applied** (quote original + proposed alternative) instead of being applied → logs a journal entry + bumps profile voice version with one-line confirmation.
**Fails if:** an editor finding gets treated as permission to rewrite the author's sentence.

## 5b. Editor verdict has teeth
**Setup:** healthy workspace. Plant a draft that repeats a tic across sections (e.g. a one-word pause in four of five sections) and a passage of neutral prose with no voice markers.
**Expected:** the `editor` returns FAIL with a **tic census carrying real counts** and a **voice drift** entry quoting the neutral passage; the writer fixes both before hand-off and says what it fixed. A PASS here is a failed eval.

## 6. Repair, and the line it won't cross
**Setup:** seeded workspace. Delete `voice/journal.md` and `issues/`; separately delete `.cervantes/engine/STRUCTURE.md` and `.claude/agents/editor.md`. **Prompt:** any editorial request.
**Expected:** the memory file is recreated **empty from its template** (saying it needs re-seeding) and `issues/` is created — one-line report at most, `profile.md` untouched. For the two kit files it does **not** improvise the content and does **not** hand over a command: it says this copy of Cervantes is damaged, that the author's work is not the part that broke, and walks them through **Move house** (download a fresh Cervantes, open it, Cervantes carries the work over). No re-onboarding.
**Fails if:** it writes an engine file or an agent from recall; it overwrites a memory file that still exists; it tells the author to run `git`, a terminal command, or to copy a dot-folder by hand.

## 7. The hook only speaks about this folder
**Setup:** from an unzipped build, run `bash .cervantes/hooks/session-start` in a directory that is not a newsletter folder.
**Expected:** it reports `not seeded` for the directory it was run in and never reaches outside it — every probe is relative (`./voice/`, `./issues/`). Cervantes is folder-scoped by being *in* the folder, not by staying quiet inside it. Also verify the Windows path: `run-hook.cmd session-start` produces the same JSON.

## 8. The hook replaces the self-check
**Setup:** seeded workspace. **Prompt:** an editorial request.
**Expected:** a `<cervantes>` block with `STATE: ready` is in context before the first turn; Claude does NOT stat `voice/`, list `.cervantes/engine/`, or narrate a verification, and goes straight to the work. Then delete `voice/cover-style.md` and restart: the block reports it under `missing` and the repair happens from that line, without a fresh filesystem sweep.

## 9. Research is delegated, not inlined
**Setup:** seeded workspace. **Prompt:** "draft about X" with two external links and one checkable claim in the notes.
**Expected:** spawns the `researcher` agent rather than fetching pages in the main session; no raw page content lands in the transcript; the returned brief drives the draft — links used are ones the agent actually opened, unverified claims become `[[fact?: ...]]`, and a contradiction with the author's notes is raised with the author instead of being written around silently.

## 10. Skills are live from the first session
**Setup:** a freshly unzipped folder, first session ever. **Prompt:** "polish what I wrote" with pasted text.
**Expected:** `polish` is already a registered skill — it ships in `.claude/skills/`, so there is nothing to install and no restart to wait for. Since the profile is unseeded, onboarding takes priority (scenario 1) and the polish happens after it; on a seeded workspace the same first-session prompt behaves exactly as scenario 5. Nothing in the session mentions restarting.

## 11. Ship close-out (close the loop)
**Setup:** seeded workspace with a drafted+polished issue in `issues/012-slug/`. **Prompt:** "ya lo publiqué, salió esto:" + pasted final text that differs from `draft.md` in a few spots (or a URL to the live post).
**Expected:** captures the shipped version (URL → via the `importer` agent in single-post mode, which writes the clean archive file directly; never fetched inline; pasted → verbatim) → **diffs `draft.md` vs shipped** and logs the difference to `voice/journal.md`, carrying repeated patterns into `voice/profile.md` with a voice-version bump and a one-line confirm → writes the clean text to `voice/archive/YYYY-MM-DD-slug.md` with frontmatter → **moves** `issues/012-slug/` → `published/012-slug/` (not left in both; `012-` prefix kept) → opens the resonance block (fields empty, "fill when known") and offers a check-in → does NOT publish/post anything itself. Offers the repurpose next step.

## 12. Resonance-only (numbers for a past issue)
**Setup:** an issue already shipped (in `published/`, journal entry with empty resonance fields). **Prompt:** "el 012 hizo 41% de aperturas y ganó el asunto B".
**Expected:** finds that issue's journal entry and fills the resonance fields → promotes the winning subject's **archetype** to the profile's hook-formula shortlist and notes a carry-forward → bumps voice version with a one-line confirm → moves/archives NOTHING (it's already shipped).

## 13. Repurpose into social
**Setup:** seeded workspace, a finished issue in `issues/` or `published/`. **Prompt:** "haz las versiones para LinkedIn y Notes".
**Expected:** lists the 2–4 self-contained atoms before writing → writes finished, postable copy per platform (Notes ≤~55-char first line; LinkedIn scannable; thread first-tweet-stands-alone) in the author's voice and language → varied hooks across posts, full anti-slop sweep, and an `editor` pass scoped to **tic census + voice fidelity only** (tics that pass once in a long issue are instant tells here) → nothing invented beyond the issue → saves to `issues/NNN-slug/social.md` (or `published/…`) grouped by platform → touches no `brief.md`, `draft.md`, snapshot, or memory file → posts/schedules nothing.

## 14. Importer stays out of the main context
**Setup:** fresh copy with a real newsletter URL.
**Expected:** the archive import runs in the `importer` agent, not the onboarding session — no full post HTML/markdown bodies appear in the main transcript, only the importer's compact report (count, titles, detected language). Files land in `voice/archive/` as `YYYY-MM-DD-slug.md` with frontmatter. If no feed/archive/sitemap exists, the importer returns a `Needs` note and onboarding asks the author for 3–5 links rather than guessing URLs.

## 15. A long issue survives a new session (resumability)
**Setup:** a `deep` issue with an approved `brief.md` and `draft.md` containing the first 3 of 6 outline sections. Start a **fresh** session. **Prompt:** "sigue con el 012".
**Expected:** reads the brief and the draft, states where it left off (section 4 of 6), and continues in outline order — same angle, same promise, same tier, seams intact. It does NOT re-ask the angle, re-offer hooks, or restart the piece. This is what the brief exists for; if it can't resume from disk, the artifact isn't doing its job.

## 16. The setup checklist keeps its shape
**Setup:** fresh copy, run onboarding all the way to the hand-off. **Watch:** every reprint of the progress block.
**Expected:** identical shape from the first print to the last — seven lines inside a fenced block, each with its full translated label, only `- [x]` and `- [ ]` as markers, at most a trailing ` ←` on the current line, and the same label strings every time.
**Fails if** it degrades into a compressed line such as `Progreso: [x] 1 [x] 2 [x] 3 [x] 4. Preferencias ✓ [→] 5. Portada [ ] 6 [ ] 7` — bare numbers, mixed markers, dropped labels. (Field-reported: the pull to compress gets stronger the longer onboarding runs, which is exactly when the author needs to read it.)

## 17. Headlines follow the draft — and spare the snapshot
**Setup:** seeded workspace with a finished issue whose `draft.md` drifted from the brief's promise AND carries hand edits made by the author after `.baseline.md` was last saved. **Prompt:** "¿títulos?".
**Expected:** reads profile + `draft.md` + `brief.md` → names the tension the draft actually delivers, saying in one line that it follows the draft, not the brief → presents 3 subject variants in the author's language (archetype labeled, most concrete marked, <~50 chars), title + dek, and one preheader per variant (~40–90 chars, extends the subject, never repeats it) → zero anti-slop patterns unless profile-documented → on pick: updates `draft.md`'s header and title, and mirrors **only those lines** into `.baseline.md` → logs subject + archetype to `voice/journal.md` with resonance fields open.
**Fails if:** a subject promises what the draft doesn't deliver; `.baseline.md`'s body gets regenerated (the author's hand edits vanish from the snapshot and the next `polish` diff protects nothing); the options come in English when the newsletter isn't.

## 18. Covers look like the same publication
**Setup:** seeded workspace, a fixed style block in `voice/cover-style.md` with a recorded style anchor, and a finished issue on a clearly different topic. **Prompt:** "haz la portada".
**Expected:** loads `voice/cover-style.md` + `draft.md` → offers one concrete visual concept (+1 alternative, author picks) tied to this issue's subject → builds the prompt per `MEMORY-SCHEMA.md`'s formula: the subject changes, the fixed style block is pasted **word for word**, format and exclusions appended, prompt in English whatever the newsletter's language → generates via an image tool if one is available, else saves `cover-prompt.txt` in the issue folder → checks the result against the anchor for consistency.
**Fails if:** the style block is paraphrased, trimmed, or "improved"; the cover doesn't read as the same publication as the anchor; `voice/cover-style.md` gets edited without the author asking; the prompt comes out in the newsletter's language.

## Regression guards (from v0.1.x field testing)
- The kit is read-only: nothing ever writes inside `.cervantes/` or `.claude/` except `settings.local.json`. No engine copies, no skill copies, no generated `CLAUDE.md`.
- The workshop is not the product: nothing in `src/` may reference `src/`, and no eval is ever run against `src/` in place. The packager enforces the first; this suite enforces the second.
- The author is never a developer: no `git`, no terminal command, no "copy this path over that one", and never a request to find or drag a folder whose name starts with a dot. If a file has to move, Cervantes moves it.
- Never work silently: announce before reading/fetching/analyzing.
- The setup checklist never changes shape mid-onboarding: seven lines, full labels, `[x]`/`[ ]` only, same translated strings, no invented markers.
- Never ask the author to evaluate content they haven't seen on screen.
- Never stall after the voice analysis — drive to the end.
- Never assume found content belongs to the author without confirming.
- Never create variant draft files: the working file is always `draft.md`, the plan always `brief.md`, the snapshot always the single `.baseline.md` (overwritten, never numbered or topic-named).
- Never start prose before the brief is approved, and never write a section the brief fed with nothing.
- Never pad to reach a length tier, and never hand back a short piece as if it were the tier asked for.
- The `editor` never edits: it returns a verdict. On a polish pass its findings about the author's own sentences are shown, never applied.
- The `interviewer` never writes an answer, not even as an example — a suggested answer gets confirmed instead of corrected, which launders invention through the author's approval.
- `ship` never leaves an issue in both `issues/` and `published/`, never drops the `NNN-` edition prefix, and never invents resonance numbers or a publish date.
- `ship`/`repurpose` never publish, post, or schedule anything themselves — they record and write copy; broadcasting is always the author's action.
