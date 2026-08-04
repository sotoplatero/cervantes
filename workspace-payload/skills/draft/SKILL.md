---
name: draft
description: Plans and writes a complete newsletter issue from the author's topic, notes, links, and data — outline first, then section by section, in their voice and language, applying the workspace's writing craft (hook method, structure, open loops, rhythm, anti-slop) and closing with an independent editor verdict. Triggers when the author wants to start a new issue, turn notes or ideas into a draft, or asks Cervantes to write an article or edition.
---

# Cervantes: Draft

Deliver a complete issue the author will *want* to edit — their voice, their language, one idea, a hook
that grabs, zero AI noise. **Structure before prose:** the outline gets agreed while it's still cheap to
change, then the piece gets written section by section.

## Preconditions

- `cervantes/profile.md` exists with `Voice version` ≥ v0.1. Missing or v0.0 → run `cervantes` first.
- Read the profile, the latest `cervantes/journal.md` entry (carry-forwards, resonance), and
  `cervantes/engine/WRITING-CRAFT.md`. Open `engine/STRUCTURE.md` at step 4, `engine/HOOK-FORMULAS.md`
  and `engine/TEMPLATES.md` when you reach hooks and skeletons.
- All author-facing text in the profile's **Language**.

## The golden rule (never breaks)

The author's facts, quotes, anecdotes, and emotions come **only** from their material. Bring outside
context and verified real links; deliver a complete draft — no `[FILL IN]`, no gaps. Pick the angle the
material **supports**; if an angle forces inventing connective tissue, it's the wrong angle.

## Workflow

**1. Gather the material.** Needed: the topic AND the author's take — notes, opinions, anecdotes, data,
links. If all you got is a topic, ask (2–3 questions max): what's YOUR opinion? any personal story? what
should the reader do or feel at the end? A draft without the author's viewpoint is generic filler —
don't write one.

**2. Research & verify — delegate to the `researcher` agent.** Situating the story means fetching pages,
and raw pages crowd out the profile and the craft you need loaded to write well. So spawn the
`researcher` agent (Agent tool, `subagent_type: "researcher"`) with the topic, the author's notes, and
their links; it returns a compact evidence brief — verified claims with real URLs, the accepted terms,
the debate, contradictions with the author's notes, and what it could NOT verify.

Work from the brief: outside links come from its **Verified** section only, everything under **Could not
verify** becomes `[[fact?: ...]]`, and a **Contradicts the author's notes** entry gets raised with the
author rather than silently written around — it's their call. Never invent what a source says. Skip the
delegation only when the issue is purely personal (no outside claims, no links) — then say so and move on.

**3. Find the angle and the hook.** Offer 2–3 angles the material supports; the author picks. For the
hook: name the tension → generate 8–10 options from `HOOK-FORMULAS.md` (profile shortlist first) → filter
through voice + `ANTI-SLOP.md` → present the 3 most concrete with one line each on why they work.

**4. Write the brief — the outline, before any prose.** Per `engine/STRUCTURE.md` (§3 method, §9
skeleton). Create the issue folder first:

- `issues/NNN-slug/` where **NNN is the edition number, zero-padded to 3 digits** (e.g. `012`) and
  `slug` is a short topic slug. Move any loose material the author gave into it.
- **Determine NNN** from the filesystem (the source of truth): the highest edition number already
  prefixing a folder in `issues/` and `published/`, plus 1. If none exist yet, ask the author which
  edition number this is, suggesting `(count of posts in cervantes/archive/) + 1` as the default.

Write `brief.md`: angle, promise, single idea, **length tier** (from the profile; `STRUCTURE.md` §1),
hook + tension + where the macro loop closes + the callback, and the **outline** — one row per H2
section with its subhead, its beat, **what feeds it**, and its word budget. A row fed by nothing is a
gap, not a section (step 5 resolves it). Run the sequence check.

**5. Fill the gaps with questions, not invention.** If the outline has sections that only the author's
own experience, number, or scene can carry, spawn the `interviewer` agent (Agent tool,
`subagent_type: "interviewer"`) with the brief, the author's material, and the archive. It returns the
ranked questions only the author can answer. **Ask them with the `AskUserQuestion` tool** (max 4 per
call, most valuable first) and paste the answers into the brief's *Interview answers* — quoted, not
paraphrased. Anything still unfed stays in *Open gaps*: cut the section or mark it `[[enrich:]]`.
Skip this step only when every outline row is already fed by real material.

**6. Get the brief approved.** Show it and ask for corrections in one round — angle, promise, tier,
section order, anything. Fill *Approved by the author*. **Prose starts only after this.** Their
correction here costs one line; the same correction after 2.000 written words costs the whole draft.

**7. Write section by section** into `draft.md`, in outline order (`STRUCTURE.md` §6). Start with a small
header (`subject:`, `preheader:`, `cta:` — provisional; finals come from `headlines`), then title + dek,
then each section: its beat, its budget (±20%), micro-loops opened and closed, inline links from the
approved sources, `[[enrich: ...]]` / `[[note: ...]]` / `[[fact?: ...]]` notes where the author's own
detail would land harder. **Vary the opening shape across sections** — five sections that all open the
same way read as machine cadence. Never announce structure in the prose; the subheads do that.

For each section load the brief, the profile, the section's material, and the **last paragraph already
written** (that's what makes the seam work). Don't re-read the whole draft each time — the brief is the
memory.

**File naming — EXACT, no variants.** An issue folder holds exactly three text files, named literally:
`brief.md` (the plan), `draft.md` (the living draft), `.baseline.md` (the single snapshot, leading dot).
No `draft.<topic>.md`, no `draft.v1/v2.md`, no dates or slugs in file names — the topic slug lives ONLY
in the folder name. There is exactly ONE snapshot, always overwritten in place.

**8. The seams pass.** Read the finished piece as a whole, once (`STRUCTURE.md` §7): every loop closed,
the callback landed, no orphan references, no repeated section openings, tic density counted across the
**whole** issue, and the real word count against the tier — under budget means naming what's thin, never
inflating it.

**9. The independent verdict.** Spawn the `editor` agent (Agent tool, `subagent_type: "editor"`) with
the paths to `draft.md`, `brief.md` and `cervantes/profile.md`, and pass `draft` as the pass. It returns
a compact pass/fail verdict with quoted evidence — tic census, voice drift, promise kept, structure,
truth. **Fix everything under Must fix before handing off**, and judge Should-fix items on merit. Then
save the exact copy as `.baseline.md` — the learning-diff baseline for `polish`.

You cannot grade your own draft honestly: you just made every one of those choices. That's why the
verdict comes from a context that didn't write it.

**10. Hand off.** Tell the author: where the draft is, what the verdict said in one line (including
anything you deliberately left), the 1–3 spots where their voice or judgment would help most, and that
the next step is editing the file by hand in any editor — then "polish it".

## Light mode (short pieces)

For a `short`-tier note or a one-scene personal issue, don't add ceremony (`STRUCTURE.md` §8): the brief
collapses to angle + promise + hook + two or three beats, it gets written in one pass, and steps 8–9
still run. Say in one line that you're going light, and move.

## Anti-goals

- No invented facts, numbers, quotes, or feelings. Unverifiable claim → `[[fact?: ...]]`.
- **Never start prose before the brief is approved**, and never write a section fed by nothing.
- No padding to hit the tier. Under-supported length gets named and the shorter tier proposed —
  the profile's length is a target, not a quota.
- Don't ask permission paragraph by paragraph — the brief is the checkpoint; after it, write the piece.
- Never skip the anti-slop sweep or the editor verdict: one "in the fast-paced world of" undoes everything.
