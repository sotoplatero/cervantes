# Evaluation scenarios — run before every release

Manual for now: run each scenario in a fresh Claude Code session, observe against expected behavior. A release ships only when all pass.

**Where these run.** Never against `cervantes/`. Build the package and open the unzipped copy:

```
bash dev/build-zip.sh <version> --test
cd ~/cervantes-testing/<version>/cervantes      # ← open THIS in Claude Code
```

`cervantes/` is the source tree; the ZIP is what a subscriber actually receives, and only the unzipped folder exercises the real thing — its `.claude/settings.json` at the project root, its skills registered, its hook firing before the first message. A scenario that passes in `cervantes/` can still be broken in the package. "A freshly unzipped folder" below always means a fresh `--test` build.

Scenarios 2 and 3 need a second folder (an older or seeded workspace) to migrate or move from: build it by hand under `~/cervantes-testing/fixtures/` — a `--test` build wipes only `~/cervantes-testing/<version>/`, so fixtures there survive rebuilds — and never point them at `cervantes/` or anywhere inside this repo.

## 1. A fresh copy starts itself
**Setup:** a freshly unzipped folder — no `voice/`, no `issues/`, no `published/`. **Prompt:** none. Just open it.
**Expected:** the session-start hook injects `STATE: not seeded` and Cervantes **opens the conversation on its own**: greets (2–3 lines) → prints the seven-line checklist → asks for URL/sample. The author never types a command. Then: announces before fetching → **delegates the import to the `importer` agent** (no raw page markup in the transcript) → relays count+titles + the language the importer detected → prints the FULL voice fingerprint as visible text with quoted examples → asks for corrections in plain chat → AskUserQuestion wizard (one call, inferred values recommended) → cover style → seeds `voice/` (profile v0.1 with a **length tier**, the newsletter name and the language recorded in it, journal, cover-style) + `issues/` + `published/` + the statusline in `settings.local.json` → recap with natural-language example phrases. Never ends a turn without a question or the hand-off.
**Fails if:** it waits to be asked; it copies the engine anywhere; it writes or regenerates `CLAUDE.md`; it touches anything under `.cervantes/` or `.claude/` except `settings.local.json`; it mentions a restart.

## 1b. A Windows machine without Git
**Setup:** a Windows machine (or VM) with Claude Code and **no** Git for Windows: no `bash.exe` under `Program Files\Git`, no `bash` on the PATH. A freshly unzipped folder. **Prompt:** none. Just open it.
**Expected:** no `<cervantes>` block arrives → `CLAUDE.md`'s fallback checks by hand, finds no `voice/`, starts onboarding **and** runs **Requirements** right after the greeting. It says in one plain line, in the author's language, that it's installing a small free program called Git and why → runs `winget` **itself, without asking**, warning that a Windows permission window may appear → checks again and confirms only once `bash` is really there → onboarding continues from step 1 → the hand-off asks them to close and reopen Claude Code once. Reopening the folder now produces a `<cervantes>` block with no `REQUIREMENTS:` line. **Variant:** decline the permission window (or remove `winget`) → only now does it involve the author, with the download page and plain steps; if they leave it, onboarding continues and it doesn't come back that session.
**Fails if:** it asks permission before installing (`AskUserQuestion` or "shall I?"); it hands the author a command to type; it says "bash" with no explanation; it blocks onboarding until Git is in; it tries to install an image tool; it claims success without checking again.

## 1c. GitHub backup at setup
**Setup:** a freshly unzipped folder on a machine with `git` and `gh` installed and `gh auth status` logged in. **Prompt:** none. Run onboarding to the end.
**Expected:** after seeding (step 6) and before the hand-off, one `AskUserQuestion` naming the logged-in account, with exactly two options: private (Recommended) / not now. On "private": Cervantes writes `.gitignore` (listing `.claude/settings.local.json`), runs `git init`, sets a folder-only noreply identity if none exists, commits, and runs `gh repo create … --private --source . --push` itself → confirms only after the push, and the hand-off carries the repo link. The checklist stays at seven lines. **Variant A:** `gh` missing or logged out → GitHub is never mentioned. **Variant B:** "not now" → no `.git/`, no repo, no second offer that session. **Variant C:** Move house from a folder with a GitHub remote → `.git/` is copied too, and one commit + push from the new folder. **Variant D:** after a later `ship`, the remote holds the new `published/NNN-slug/` folder.
**Fails if:** it creates a repo without the answer; it offers or creates a public repo; `settings.local.json` is committed; it installs or logs into `gh`; it hands the author a git command; it edits the global git config; it adds an eighth line to the checklist; a shipped issue never reaches the remote.

## 2. Migrate a v3.x workspace
**Setup:** the old layout — `cervantes/profile.md` (seeded, real content), `cervantes/journal.md`, `cervantes/cover-style.md`, `cervantes/archive/` with posts, `cervantes/engine/` with the 7 files, a `CLAUDE.md` carrying `<!-- cervantes: engine v3.0 -->`, plus `issues/` and `published/` with work in them. **Prompt:** any editorial request.
**Expected:** hook reports `STATE: legacy layout` → the memory files and `archive/` move to `voice/` **byte-identical** → `cervantes/engine/` is deleted → the old `CLAUDE.md` is replaced by this folder's static one, with no marker (never merged) → the name and language are confirmed present in `voice/profile.md` → one-line report → then it does the work that was asked. `issues/` and `published/` untouched.
**Fails if:** any memory line changes; the old `cervantes/` is deleted while still holding something the author put there; the author is re-onboarded.

## 3. Update = move house (the ZIP flow)
**Setup:** a seeded workspace ("old"), with content in `voice/archive/`, one issue in `issues/`, one in `published/`, and a statusline in `.claude/settings.local.json`. Unzip a fresh copy of the kit as "new". Open **new** in Claude Code.
**Expected:** the hook reports `not seeded` → the greeting offers the returning-author branch in one line ("if you already have a Cervantes folder, tell me where it is") **and** proceeds to step 1 without blocking → on being given the old path, it switches to **Move house**: **copies** (never moves) `voice/` (incl. `archive/`), `issues/`, `published/` and `settings.local.json` across **verbatim**, runs Repair once for schema drift, reports counts in one or two lines, and **leaves the old folder untouched** — saying so. Afterwards the old folder still holds everything: file counts per folder identical before and after.
**Fails if:** the old folder lost a file; it re-onboards over the copied profile; it asks the author to copy or drag anything themselves; it names `.cervantes/` or `.claude/` to the author; it deletes or offers to delete the old folder in the same breath as the move; any memory line changes.

**Schema drift, separately:** add a new required section header to `MEMORY-SCHEMA.md` that the author's `profile.md` lacks. **Expected:** Cervantes names what's new and offers to add the header, **preserving every existing line** — never blanking or rewriting one. If the missing piece is the **length tier** and the profile's length line is ambiguous, it asks once with `AskUserQuestion`. No version numbers appear anywhere in the exchange.

## 4. Draft with notes — structure before prose
**Setup:** seeded workspace, length tier `standard`. **Prompt:** "write a draft about X" + pasted notes with an opinion and one link.
**Expected:** syncs with the live site first (scenario 19) → reads profile+journal+WRITING-CRAFT → delegates research → offers 2–3 angles → 3 hook options (concrete, labeled, strongest marked) → creates `issues/NNN-slug/` and writes **`brief.md` FIRST**: angle, promise, single idea, tier, hook+tension+loop-close+callback, and an outline table where **every row names what feeds it** → asks for corrections and fills *Approved by the author* → **only then** writes `draft.md` section by section (each section's opening shape differs from the others) → seams pass → **spawns the `reader` agent** with only the draft → **spawns the `editor` agent** and resolves its Must-fix items → saves the single `.baseline.md` → hands off with the verdict summarized in one line.
**Fails if:** prose starts before the brief is approved; a section is written that the brief fed with nothing; variant file names appear (`draft.<topic>.md`, `draft.v2.md`); the editor is skipped; `draft.md` opens with a `---` frontmatter block.

## 4b. Brief rejected mid-flow
**Setup:** as above. **Prompt:** at brief approval, "no, el ángulo es otro: <X>".
**Expected:** the brief is rewritten (angle, promise, outline re-derived), re-approved, and no prose was written in the meantime. Zero words wasted — that's the whole point of the checkpoint.

## 4c. Interview for the gaps
**Setup:** seeded workspace. **Prompt:** "draft about X" with notes thin on personal material (a topic and an opinion, no story, no numbers).
**Expected:** the outline exposes sections fed by nothing → spawns the `interviewer` agent → asks its ranked questions as a **numbered list in plain chat** (not `AskUserQuestion`), the author answering in their own words → pastes the answers into the brief's *Interview answers*, quoted → sections that stay unfed are cut or marked `[[enrich:]]`, never filled with invention. If the archive already answers a gap, it says so instead of asking.
**Fails if:** the questions arrive through `AskUserQuestion`; any suggested answer appears as an option to pick.

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
**Expected:** lists the 2–4 self-contained atoms before writing → writes finished, postable copy per platform (Notes ≤~55-char first line; LinkedIn scannable; thread first-tweet-stands-alone) in the author's voice and language → varied hooks across posts, full anti-slop sweep, and an `editor` pass with pass=`social`, scoped to **tic census + voice fidelity only** (tics that pass once in a long issue are instant tells here) → nothing invented beyond the issue → saves to `issues/NNN-slug/social.md` (or `published/…`) grouped by platform → touches no `brief.md`, `draft.md`, snapshot, or memory file → posts/schedules nothing.

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
**Expected:** reads profile + `draft.md` + `brief.md` → names the tension the draft actually delivers, saying in one line that it follows the draft, not the brief → presents 3 subject variants in the author's language (archetype labeled, most concrete marked, <~50 chars), title + dek, and one preheader per variant (~40–90 chars, extends the subject, never repeats it) → zero anti-slop patterns unless profile-documented → on pick: updates `draft.md`'s title and dek, and mirrors **only those lines** into `.baseline.md` → logs subject + archetype to `voice/journal.md` with resonance fields open.
**Fails if:** a subject promises what the draft doesn't deliver; `.baseline.md`'s body gets regenerated (the author's hand edits vanish from the snapshot and the next `polish` diff protects nothing); the options come in English when the newsletter isn't.

## 18. Covers look like the same publication
**Setup:** seeded workspace, a fixed style block in `voice/cover-style.md` with a recorded style anchor, and a finished issue on a clearly different topic. **Prompt:** "haz la portada".
**Expected:** loads `voice/cover-style.md` + `draft.md` → offers one concrete visual concept (+1 alternative, author picks) tied to this issue's subject → builds the prompt per `MEMORY-SCHEMA.md`'s formula: the subject changes, the fixed style block is pasted **word for word**, format and exclusions appended, prompt in English whatever the newsletter's language → generates via an image tool if one is available, else saves `cover-prompt.txt` in the issue folder → checks the result against the anchor for consistency. **Variant:** no anchor recorded yet → it asks whether this cover should become the anchor, and records it only after the author says yes.
**Fails if:** the style block is paraphrased, trimmed, or "improved"; an anchor is recorded without the author's yes; the cover doesn't read as the same publication as the anchor; `voice/cover-style.md` gets edited without the author asking; the prompt comes out in the newsletter's language.

## 19. A new issue starts from what's live
**Setup:** seeded workspace whose profile has a real newsletter URL. On the site there are two posts the folder doesn't know about: one missing from `voice/archive/` whose `issues/NNN-slug/` folder still sits in `issues/` (published from the platform, never `ship`ped), and one with no folder at all. Add an empty `issues/0NN/` folder that shares its number with another folder. **Prompt:** "vamos con el próximo número, sobre X" — where X is close to a post that already went out.
**Expected:** before asking for material, delegates to the `importer` in **sync mode** (no post bodies in the main transcript) → the missing posts land in `voice/archive/` **verbatim** (word count close to the live post; a paywalled one carries `partial: true`) → reports in a line or two which issue went out without being closed and **offers** `ship` for it → names the duplicated number and asks, without renaming or deleting anything → says X is close to "<that post>" and asks whether it's a follow-up, another angle or a repeat → then carries on with `draft`.
**Fails if:** it starts the brief without syncing; it moves, renames or deletes a folder on its own; an archived post is a summary; it proposes an `NNN` already on a folder.

## 20. The story comes before the outline
**Setup:** seeded workspace. **Prompt:** "escribe sobre X" + notes that are mostly research links and findings, plus one line of the author's opinion; no word on what made them write it.
**Expected:** the brief holds a **spine** (root, problem, what nobody says, turn, takeaway, landing) written in plain sentences before the outline, with the root and "what nobody says" marked missing → those are the first interview questions → the outline follows the spine and has a "but"/"so" between rows → no row is "what source X found" → the draft weaves the research into the author's argument in their voice: no named research tools, no run of links → the central idea is said near the top and again at the end.
**Fails if:** the draft reads as a sequence of findings with subheads; the root or the uncomfortable truth is invented to fill the spine; the research tool or the search process is narrated in the prose.

## 20b. The type of piece holds
**Setup:** an approved brief of type *argument*, and a profile that rules the author out as a tutorial writer. **Prompt:** mid-draft, "déjalo solo en el tutorial, sin la introducción".
**Expected:** before rewriting, it says once, with the reason, that this turns the piece into another type and goes against the profile — then does what the author decides. If they confirm, the brief's type is updated. When they later reject an idea, it lands under **Ruled out** in the brief, and no later rewrite brings it back under another name.
**Fails if:** it silently strips the argument; it raises the concern only as a note in the brief; a ruled-out idea reappears.

## 21. A stranger reads it cold
**Setup:** a finished draft that uses one term or tool it never explains and has one section that restarts instead of following the previous one. **Prompt:** the end of a normal `draft`, or "léelo como alguien que no me conoce".
**Expected:** spawns the `reader` agent with **only** the path to `draft.md` (and at most one line on the target reader) → the agent opens nothing else — not `voice/`, not `brief.md` → its report names what it thinks the piece is about, the story it followed, and quotes the unexplained term and the jump → the main session compares the summary with the brief's promise and fixes the gaps, turning any it can't fill into a question for the author → then the `editor` → if fixes rewrote sections, the `editor` runs once more.
**Fails if:** the reader gets the brief or the profile; the main session plays the stranger itself; a hole the reader found is filled with invented material.

## 22. The draft on disk wins
**Setup:** a draft open in the author's editor. Between two turns the author changes a paragraph by hand and adds `[[aquí cuenta lo de la nota]]` in the text, then saves. **Prompt:** "redacta".
**Expected:** reads `draft.md` from disk again, finds the author's `[[...]]` mark and resolves it in place — no "what do you want me to write?" — and leaves their hand-edited paragraph untouched. Confirmations of anything learned arrive in the author's language, without a version number.
**Fails if:** it writes from a remembered version and the hand edit disappears; it asks what to write; it prints "Noted in your profile" in a Spanish conversation.

## 23. Compaction mid-onboarding
**Setup:** a freshly unzipped folder; run onboarding to step 3 or 4. **Prompt:** `/compact`, then "sigue".
**Expected:** the hook fires again with `source: compact`, still `not seeded`, and its ACTION carries the "already under way… continue from where it stands" line → Cervantes reprints the checklist with the same `[x]` marks it had and continues from the current step. Same for a resumed session (`claude --resume`).
**Fails if:** it greets a second time; the checklist restarts at step 1; it re-asks the URL or re-runs the import.

## 24. Profile lost in a live newsletter
**Setup:** seeded workspace with posts in `voice/archive/`, entries in `voice/journal.md` and at least one folder in `published/`. Delete `voice/profile.md` (variant: overwrite it with the `v0.0` template). **Prompt:** none. Just open it.
**Expected:** the hook reports `STATE: half-built … already has work` with ACTION **Repair → Re-seed** → Cervantes says in a line that the voice profile went missing and that it is rebuilding it from the archive → re-derives the fingerprint from `voice/archive/` and the journal → one confirmation, then on with what the author asks.
**Fails if:** it greets the author as new or prints the setup checklist; it asks for the newsletter URL or re-imports; `journal.md`, `archive/`, `issues/` or `published/` change.

## 25. The Voice version line, written by hand
**Setup:** seeded workspace (`cover-style.md` and `journal.md` present). Rewrite the profile's version line in turn as `- Voice version: v0.4`, `| Voice version | v0.4 |`, `> **Voice version:** 0.4`, `## Voice version: v0.4`, `Versión de voz: v0.4`, `version de voz: 0.4`, and plain `Voice version: v0.4` saved with a UTF-8 BOM and CRLF. **Prompt:** none, per form.
**Expected:** every form reports `STATE: ready — voice profile v0.4`. Run the hook by hand too: the JSON parses.
**Fails if:** any form reads as `not seeded` or `half-built`.

## 26. One journal entry per issue
**Setup:** seeded workspace, a drafted issue `issues/014-slug/`. **Prompt:** in turn "pule esto" (after a hand edit), "¿títulos?" (pick one), "ya lo publiqué" (paste the final text).
**Expected:** `voice/journal.md` ends with exactly one `## Issue 014` entry holding a sub-block per stage (polish diff, chosen subject + archetype, ship diff + open resonance fields), newest stage appended inside it.
**Fails if:** a second `## Issue 014` heading appears; a stage overwrites another's sub-block; the entries land outside the issue's heading.

## 27. What is learned, and what is only for this issue
**Setup:** seeded workspace, a brief approved. **Prompt:** mid-draft, "eso de la analogía con el fútbol, en este número no"; later, a turn with no correction at all.
**Expected:** the rejected idea lands in the brief's **Ruled out**, not in `voice/profile.md`; no voice-version bump. On the turn where nothing was written to memory, no "Anotado"/"Noted" line appears.
**Fails if:** a one-issue rejection becomes a profile rule; a confirmation line appears when no memory file changed.

## 28. Repurpose gets its own verdict
**Setup:** seeded workspace whose profile documents a tic; a finished issue. Plant the tic once in the issue. **Prompt:** "sácale posts para LinkedIn".
**Expected:** the `editor` runs with pass=`social` on `social.md` and returns a verdict; the tic, repeated across posts, is flagged with its count and fixed before hand-off; the verdict is summarised in one line.
**Fails if:** the editor is skipped, runs as a full `draft` pass, or the posts ship with the tic.

## 29. Sync on a large back-catalogue
**Setup:** seeded workspace whose `voice/archive/` holds posts up to a given date, on a newsletter with 60+ live posts, 20 of them newer than the newest archived one. **Prompt:** "vamos con el próximo número".
**Expected:** the `importer` in sync mode imports only posts newer than the newest archived one, at most 15 (the most recent), and says how many it left out → then `draft` continues.
**Fails if:** it re-imports the whole archive; it imports older posts; it imports more than 15; post bodies appear in the main transcript.

## 30. A question about the whole newsletter
**Setup:** seeded workspace with 10+ archived posts and journal entries with resonance. **Prompt:** "¿qué número merece segunda parte?".
**Expected:** delegates the archive read (no post bodies in the main transcript) → answers naming the issue(s) and **which record it read** (archive, journal resonance, or both) → writes a **Decision** entry to `voice/journal.md` once the author picks.
**Fails if:** it answers from memory without reading; it reads every post inline; no Decision entry after a choice; it starts drafting unasked.

## 31. "Let's discuss" is not "rewrite"
**Setup:** a draft on disk. **Prompt:** "no lo reescribas aún, hablemos del segundo apartado: ¿no es demasiado largo?".
**Expected:** an answer in chat — its view, with the reason, maybe a quoted line or a cut it would make — and a question back. `draft.md` is unchanged.
**Fails if:** a new version of the section or draft appears (in chat or on disk); `.baseline.md` is touched.

## Regression guards (from v0.1.x field testing)
- The kit is read-only: nothing ever writes inside `.cervantes/` or `.claude/` except `settings.local.json`. No engine copies, no skill copies, no generated `CLAUDE.md`.
- The workshop is not the product: nothing in `cervantes/` may reference `cervantes/`, and no eval is ever run against `cervantes/` in place. The packager enforces the first; this suite enforces the second.
- The author is never a developer: no `git`, no terminal command, no "copy this path over that one", and never a request to find or drag a folder whose name starts with a dot. If a file has to move, Cervantes moves it.
- Never work silently: announce before reading/fetching/analyzing.
- The setup checklist never changes shape mid-onboarding: seven lines, full labels, `[x]`/`[ ]` only, same translated strings, no invented markers.
- Never ask the author to evaluate content they haven't seen on screen.
- Never stall after the voice analysis — drive to the end.
- Never assume found content belongs to the author without confirming.
- Never create variant draft files: the working file is always `draft.md`, the plan always `brief.md`, the snapshot always the single `.baseline.md` (overwritten, never numbered or topic-named).
- Never start prose before the brief is approved, and never write a section the brief fed with nothing.
- Never pad to reach a length tier, and never hand back a short piece as if it were the tier asked for.
- The `reader` never sees anything but the draft, and never edits it.
- The `editor` never edits: it returns a verdict. On a polish pass its findings about the author's own sentences are shown, never applied.
- The `interviewer` never writes an answer, not even as an example — a suggested answer gets confirmed instead of corrected, which launders invention through the author's approval.
- `ship` never leaves an issue in both `issues/` and `published/`, never drops the `NNN-` edition prefix, and never invents resonance numbers or a publish date.
- `ship`/`repurpose` never publish, post, or schedule anything themselves — they record and write copy; broadcasting is always the author's action.
