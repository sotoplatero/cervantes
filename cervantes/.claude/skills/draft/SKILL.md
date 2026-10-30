---
name: draft
description: Plans and writes a complete newsletter issue from the author's topic, notes, links, and data — first syncing the folder with what's already live, then the story spine and outline, then section by section, in their voice and language, applying the workspace's writing craft (story, hook method, structure, open loops, rhythm, anti-slop) and closing with a stranger's cold read and an independent editor verdict. Triggers when the author wants to start a new issue, turn notes or ideas into a draft, asks Cervantes to write an article or edition, or asks to continue or resume an issue already under way ("sigue con…").
---

# Cervantes: Draft

Deliver a complete issue the author will *want* to edit — their voice, their language, one idea, a hook
that grabs, zero AI noise. **Structure before prose:** the outline gets agreed while it's still cheap to
change, then the piece gets written section by section.

## Preconditions

- `voice/profile.md` exists with `Voice version` ≥ v0.1. Missing or v0.0 → run `cervantes` first.
- Read the profile, `## Patterns so far` and the most recent issue entry in `voice/journal.md`
  (carry-forwards, resonance), and `.cervantes/engine/WRITING-CRAFT.md`. Open `.cervantes/engine/STRUCTURE.md`
  at step 4 and `.cervantes/engine/TEMPLATES.md` when you reach skeletons.
- All author-facing text in the profile's **Language**.
- **Resuming an issue** ("sigue con…"): its `brief.md` is the resume point. Read it and `draft.md` from
  disk, skip step 0, and pick up at the first step the brief shows unfinished.

Per CLAUDE.md's golden rule: nothing of the author's is invented, and the draft is complete — no
`[FILL IN]`. Here that means the angle is the one the material **supports**.

## Workflow

**0. Sync with what's live — before anything else.** A new issue starts from what the newsletter actually
published, not from what this folder believes it published. Authors publish from the platform, edit
there, and forget to say "I published it", so `published/` and `voice/archive/` drift behind the site
without anyone noticing — and then the next-number lookup is wrong, the archive misses the newest voice
samples, and a topic gets proposed that went out last week.

Spawn the `importer` agent in **sync mode** (Agent tool, `subagent_type: "importer"`) with the profile's
newsletter URL, `voice/archive/` as the target, and the lists of folders in `issues/` and `published/`.
It imports, verbatim, the live posts dated after the newest one in the archive (at most 15, and it says
how many more exist), and returns a reconciliation against every live title: new posts, issue
folders that match something already live, folders it can't match, and numbering problems. Then:

- **Nothing new and nothing out of place** → say it in one line ("archive up to date: N posts") and move on.
- **Posts that went out but were never closed** → those issues were published outside `ship`. Tell the
  author in one or two lines which ones, and offer to close them out now with `ship` (it moves the folder,
  diffs draft vs published and learns from it — the edits they made on the platform are the most honest
  voice data there is). If they agree, run `ship` for each before continuing; if not, note it and go on.
- **Numbering problems** (two folders sharing an `NNN`, empty folders, a folder with no number) → name them
  and ask what to do. Never renumber or delete a folder on your own.
- **The new topic** — once the author names it, check it against the archive titles. If something close
  already went out, say which post and ask whether this is a follow-up, a different angle, or a repeat.

It runs once per new issue — not when resuming one that already has a `brief.md`. Skip it also when the profile has no URL (the newsletter isn't online yet) or the agent can't reach
the site — then say so in one line and carry on from the folder as it is.

**1. Gather the material.** Needed: the topic AND the author's take — notes, opinions, anecdotes, data,
links. If all you got is a topic, ask (2–3 questions max): what's YOUR opinion? what happened that made you
want to write this? what should the reader do or feel at the end? A draft without the author's viewpoint
is generic filler — don't write one.

**Inventory the thing before describing it.** When the issue is about something the author built or uses
(a tool, a folder, a workflow), read what it actually contains and does — its files, its README, its
real steps — before the brief. Every capability, step or limitation in the draft must come from that
inventory or from the author. A step the thing doesn't need, or a feature it doesn't have, is invention
even when it sounds plausible.

**2. Research & verify — delegate to the `researcher` agent.** Situating the story means fetching pages,
and raw pages crowd out the profile and the craft you need loaded to write well. So spawn the
`researcher` agent (Agent tool, `subagent_type: "researcher"`) with the topic, the author's notes, and
their links; it returns a compact evidence brief — verified claims with real URLs, the accepted terms,
the debate, contradictions with the author's notes, and what it could NOT verify.

Work from the brief: outside links come from its **Verified** section only, everything under **Could not
verify** becomes `[[fact?: ...]]`, and a **Contradicts the author's notes** entry gets raised with the
author rather than silently written around — it's their call. Never invent what a source says. Skip the
delegation only when the issue is purely personal (no outside claims, no links) — then say so and move on.

**3. Find the story, then the angle and the hook.** First write the **spine** — the piece as a story in
five or six plain sentences: root, problem, what nobody says, turn, takeaway, landing
(`WRITING-CRAFT.md` §3). Do it from the author's material, with the research brief only as support. Where
a line has nothing to stand on (very often the root and "what nobody says"), mark it missing — those
become the first interview questions in step 5, never something you supply. Then decide the **type of
piece** (argument, story, how-to, announcement) and check it against the profile: if the author asked for
a type their own profile or brand rules against, say so now, once, with the reason — not in a note in the
brief that you then write straight past.

Then offer 2–3 angles the spine supports; the author picks. For the
hook: name the tension → generate 8–10 options from the profile's hook shortlist → filter through voice +
`ANTI-SLOP.md` → present the 3 most concrete with one line each on why they work. The shortlist plus the
method at the top of `.cervantes/engine/HOOK-FORMULAS.md` (§ Method) is enough; read the full library
only when the profile's shortlist is empty or the author asks to refresh it.

**4. Write the brief — the outline, before any prose.** Per `.cervantes/engine/STRUCTURE.md` (§3 method, §9
skeleton). Create the issue folder first:

- `issues/NNN-slug/` where **NNN is the edition number, zero-padded to 3 digits** (e.g. `012`) and
  `slug` is a short topic slug. Move any loose material the author gave into it.
- **Determine NNN** per `.cervantes/engine/MEMORY-SCHEMA.md` § Edition numbers, after the step-0 sync
  has reconciled the folders.

Write `brief.md`: type of piece, angle, promise, single idea, **length tier** (from the profile;
`STRUCTURE.md` §1), **the spine**, hook + tension + where the macro loop closes + the callback, and the
**outline** — one row per H2 section with its subhead, its beat, **what feeds it**, and its word budget —
cut from the spine. A row fed by nothing is a gap, not a section (step 5 resolves it). Run the sequence
check, including the "but / so" word between every pair of rows.

**Ruled out** starts empty and grows for the life of the issue: every idea, method, example or framing the
author rejects goes there with their words, the moment they reject it. Read it before every rewrite.
Bringing a rejected idea back under a new name is the fastest way to show the author you weren't
listening.

**5. Fill the gaps with questions, not invention.** If the outline has sections that only the author's
own experience, number, or scene can carry, spawn the `interviewer` agent (Agent tool,
`subagent_type: "interviewer"`) with the brief, the author's material, and the archive. It returns the
ranked questions only the author can answer. **Ask them in plain chat, as a numbered list**, most
valuable first — never through `AskUserQuestion`: its options would be suggested answers, which is
exactly what the interviewer refuses to write. (`AskUserQuestion` is for genuine choices: the angle, the
tier, follow-up vs repeat, yes/no.) Paste the answers into the brief's *Interview answers* — quoted, not
paraphrased. Anything still unfed stays in *Open gaps*: cut the section or mark it `[[enrich:]]`.
Skip this step only when every outline row is already fed by real material.

**6. Get the brief approved.** Show it and ask for corrections in one round — angle, promise, tier,
section order, anything. Fill *Approved by the author*. **Prose starts only after this.** Their
correction here costs one line; the same correction after 2.000 written words costs the whole draft.

**7. Write section by section** into `draft.md`, in outline order (`STRUCTURE.md` §6). **The file's first
line is the title**, then the dek — never a `---` frontmatter block above them, even though the files in
`voice/archive/` carry one (that metadata belongs to the archive, not to a draft the author pastes into
their platform). No `subject:`/`preheader:`/`cta:` lines either; those come from `headlines` and never
live in the file. Then each section: its beat, its budget (±20%), micro-loops opened and closed, inline links from the
approved sources, `[[enrich: ...]]` / `[[note: ...]]` / `[[fact?: ...]]` notes where the author's own
detail would land harder. **Vary the opening shape across sections** — five sections that all open the
same way read as machine cadence. Never announce structure in the prose; the subheads do that.

For each section load the brief, the profile, the section's material, and the **last paragraph already
written** (that's what makes the seam work). Don't re-read the whole draft each time — the brief is the
memory.

**File naming — EXACT, no variants.** The writing lives in exactly three files, named literally:
`brief.md` (the plan), `draft.md` (the living draft), `.baseline.md` (the single snapshot, leading dot).
Beside them sit `cover-prompt.txt` (seeded at step 10, refined by `cover`), `social.md` from
`repurpose`, and the author's loose material. What never exists is a variant of
the draft: no `draft.<topic>.md`, no `draft.v1/v2.md`, no `final.md`, no dates or slugs in file names —
the topic slug lives ONLY in the folder name. There is exactly ONE snapshot, always overwritten in place.

**8. The seams pass.** Read the finished piece as a whole, once (`STRUCTURE.md` §7): every loop closed,
the callback landed, no orphan references, no repeated section openings, the spine still readable in the
subheads and the central idea said at the top and at the end, tic density counted across the **whole**
issue, and the real word count against the tier — under budget means naming what's thin, never inflating
it.

**8b. The writer's checklist.** Run `.cervantes/engine/QUALITY-CHECKLIST.md` § Draft and polish — your
half — and fix what fails before anyone else reads the piece.

**9a. The cold read.** Spawn the `reader` agent (Agent tool, `subagent_type: "reader"`) with **only** the
path to `draft.md` and, optionally, one line describing the target reader taken from the profile's
audience — never the brief, the profile, the archive or anything about the author. It reads as a stranger
and reports what it thinks the piece is about, the story it followed, and where it got lost, stopped
caring or didn't believe it.

Compare its one-sentence summary with the brief's promise: if they don't match, the piece doesn't say what
it was meant to say, and that comes first. Then act on its findings like any other: an unexplained term or
a jump between sections you fix; a hole that only the author can fill (a missing reason, the root, a
"why should I care") becomes a question or an `[[enrich:]]`, never something you make up. Don't send it a
second time unless the fixes rewrote whole sections.

**9b. The independent verdict.** Spawn the `editor` agent (Agent tool, `subagent_type: "editor"`) with
the paths to `draft.md`, `brief.md` and `voice/profile.md`, and pass `draft` as the pass. It returns
a compact pass/fail verdict with quoted evidence — tic census, voice drift, promise kept, structure,
truth. **Fix everything under Must fix before handing off**, and judge Should-fix items on merit. If the
fixes went beyond wording — a section moved, rewritten or added — send the new version to the `editor`
once more; its first verdict was about a text that no longer exists. Then save the exact copy as
`.baseline.md` — the learning-diff baseline for `polish`.

You cannot grade your own draft honestly: you just made every one of those choices. That's why both reads
come from contexts that didn't write it — one that knows nothing, one that knows the author.

**10. The cover prompt.** The visual concept only exists once the piece does, so it gets built here
instead of waiting to be asked for. Derive ONE concrete visual concept from the finished draft — a
specific scene or metaphor, never an abstraction — check it against the Hard exclusions, build the
prompt per `voice/cover-style.md` (subject first, then the fixed style block **verbatim**, format line,
exclusions as negatives; formula in `.cervantes/engine/MEMORY-SCHEMA.md` § cover-style) and save it as
`cover-prompt.txt` in the issue folder. Prompt in English regardless of the newsletter's language.

**Don't generate the image, and don't stop to get the concept approved** — this is a starting point the
author takes as-is or changes when they run `cover`, which owns the alternatives, the approval and the
consistency check. If `voice/cover-style.md` is missing, skip this step and say so in one line.

**11. Hand off.** Tell the author: where the draft is, what the stranger understood and what the verdict
said, one line each (including anything you deliberately left), the 1–3 spots where their voice or judgment would help most, that the
cover prompt is already sitting in `cover-prompt.txt` if they want it, and that the next step is editing
the file by hand in any editor — then "polish it".

## Light mode (short pieces)

For a `short`-tier note or a one-scene personal issue, don't add ceremony (`STRUCTURE.md` §8): the brief
collapses to angle + promise + hook + two or three beats, it gets written in one pass, and steps 8–10
still run. Say in one line that you're going light, and move.

## Anti-goals

- No invented facts, numbers, quotes, or feelings. Unverifiable claim → `[[fact?: ...]]`.
- **Never start prose before the brief is approved**, and never write a section fed by nothing.
- No padding to hit the tier. Under-supported length gets named and the shorter tier proposed —
  the profile's length is a target, not a quota.
- Don't ask permission paragraph by paragraph — the brief is the checkpoint; after it, write the piece.
- Never skip the anti-slop sweep, the cold read or the editor verdict: one "in the fast-paced world of" undoes everything.
- Never lay research out as a sequence of findings and links. It supports the author's story, in their
  voice, or it stays in the researcher brief.
- Never bring back anything listed under the brief's **Ruled out**.
- Never open `draft.md` or `.baseline.md` with a `---` frontmatter block.
