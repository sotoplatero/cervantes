# Structure — how a long issue gets planned before it gets written

`WRITING-CRAFT.md` governs the prose. This file governs the **shape**: how an issue is outlined, how
long each part gets, how it's written section by section, and how the seams are checked. It exists
because a long issue written in one pass sags — the middle drifts, the sections come out uneven, the
loops opened at the top never close, and the piece lands shorter than the author asked for.

The order is always: **material → angle → brief (outline approved) → sections → seams → verdict.**

## 1. Length tiers

The author's tier lives in `voice/profile.md` (**Typical length**). It sets the word target and,
from it, the section count:

| Tier | Words | H2 sections | Words per section |
|---|---|---|---|
| `short` | ~600–900 | 2–3 | ~250–300 |
| `standard` | ~1000–1500 | 3–5 | ~300–350 |
| `deep` | ~1800–2500+ | 5–8 | ~300–400 |

These are budgets, not quotas. Two rules govern them, in this order:

1. **Never pad to reach a tier.** Filler to hit a number is the fastest way to produce the empty
   connective tissue `ANTI-SLOP.md` bans.
2. **If the material doesn't support the tier, say so before writing** and propose the tier below it,
   naming what's missing. A tight `standard` beats a padded `deep`. The author decides — and if they
   want the longer piece, that's what the interview questions are for (§4): get the material, then
   write long. Don't quietly deliver 900 words when they asked for 2000, and don't quietly inflate.
3. **An idea that finishes early is finished.** If the piece says everything it has to say and lands
   under target, that is a complete issue, not a deficient one: report the count in one line and hand it
   over. Length is never a completion criterion, and "still under budget" is never a reason to keep
   writing. The only question that settles it is whether a beat in the outline is unfinished or a
   promise the hook made went unpaid — if neither, the issue is done at whatever length that took.

## 2. The brief locks the decisions

Before any prose, `draft` writes `issues/NNN-slug/brief.md` from the skeleton in §9 and the author
approves it in one round. It holds the angle, the promise, the single idea, the tier, the outline, the
hook and its tension, where the macro loop closes, the callback, the approved sources, and the
interview answers.

Two reasons it exists, both load-bearing:

- **Cheap correction.** Fixing a wrong angle in an outline costs one line; fixing it in 2.000 written
  words costs the whole draft — and the author has to read the whole thing to find it.
- **Resumability.** A long issue outlives a session and a context window. `brief.md` + `draft.md` are
  enough to resume cold: the brief says what was decided, the draft says how far it got. Nothing
  important lives only in the chat.

## 3. The outline method

From the approved angle and the one-sentence promise, derive the sections. For each one, the brief
records four things — and a section missing any of them is not ready:

1. **Subhead** — concrete and in the author's voice, per `WRITING-CRAFT.md` §8. Not a label
   ("Introduction", "Context"): the actual point of the section.
2. **The beat it carries** — one beat per section. Two beats means two sections, or one of them is
   padding.
3. **What feeds it** — a specific pointer: this note of the author's, this **Verified** item from the
   `researcher` brief, this answer from the interview, this `[[enrich:]]` gap. A section fed by nothing
   is where invention happens. Either get the material or cut the section.
4. **Word budget** — from the tier table.

Then check the whole outline as a sequence:

- The sections **in order** tell the before → what happened → after arc (`WRITING-CRAFT.md` §3). If
  reordering them changes nothing, there's no arc — it's a list wearing subheads.
- The **macro loop** the hook opens has a named section where it closes.
- Every section **earns the next**. Read the subheads alone: they should read as the shape of the
  issue, and a reader who skims only those should get the argument.
- **One idea** still holds. The outline is where a second idea gets caught and saved for another issue.

## 4. Gaps become questions, not invention

An outline makes the holes visible: the sections where only the author's own experience, number, or
anecdote can carry the beat. That list is the input to the interview (`interviewer` agent → questions
asked in the main session). Answers go into the brief and become the material that section is fed by.

This is the point of outlining before writing: the gaps get found while they're still cheap to fill,
instead of being papered over with generic prose at 1 a.m. of the writing pass.

## 5. Subhead hierarchy

- **H2** for each section in the outline — every ~250–400 words. An issue with no internal subheads is
  incomplete regardless of tier.
- **H3** only in the `deep` tier, and only when a section genuinely carries two or three named beats.
  In `short` and `standard`, H3 is clutter.
- No colon formats, no "The Definitive Guide" (`ANTI-SLOP.md`).

## 6. Writing section by section

Write one section at a time, in outline order, appending to `draft.md`.

For each section, what needs to be loaded is: the **brief**, `voice/profile.md`, the section's own
material, and the **last paragraph already written** — that last paragraph is what makes the seam work.
Don't re-read the entire draft before each section: it burns the context the voice profile and the
craft need, and by the end there's no room left for either. The brief is the memory; that's its job.

Per section: hit its beat, respect its budget (±20%), open and close its micro-loops, vary the opening
shape — **the openings across sections must differ from each other.** Five sections that all start
with a short declarative sentence read as machine cadence even when each one is fine alone.

**A subhead is not a reset.** Each section continues the argument the previous one left standing: its
first sentence picks up that thread and moves it, so a reader going straight through the heading never
stumbles. This is the opposite of announcing structure — the continuity is carried by the *thought*
(the consequence, the objection, the next step in the same reasoning), never by a signpost. It is why
the last paragraph already written gets loaded before each section, and it is why openings that differ
in **shape** still have to connect in **substance**. Varied openings that each restart the piece read as
a stack of notes stapled together instead of one letter, and that is exactly how a draft comes out
jumpy while every individual section looks fine.

Never announce structure in the prose ("In this section we'll see…", "First, let's look at…"). The
subheads already do that work.

## 7. The seams pass (before the verdict)

After the last section, read the piece **as a whole once** — this is the one time the full draft gets
read in one go, and it's checking things that only exist between sections:

- **Every loop opened is closed**, macro and micro. An unpaid loop is clickbait.
- **The callback** from the opening is planted at the end.
- **Orphan references** — "as I said above" pointing at something that ended up in a different section,
  or a term introduced twice because two sections each defined it.
- **Rhythm across boundaries** — the last line of one section and the first of the next shouldn't have
  the same shape.
- **Continuity across boundaries** — read each seam as a pair of sentences with the subhead covered up.
  Does the second follow from the first, or does the piece start over? A section that could be moved
  anywhere else in the outline without anyone noticing is not connected to its neighbours: give its
  opening the thread the previous section left, or fix the order. This is the check that catches a draft
  that reads as a series of jumps.
- **Tic density over the whole piece.** This is where the `ANTI-SLOP.md` frequency rule actually
  applies: a device used once per section is a tic even though no single section overused it. Count
  across the issue, not within a section.
- **Length reality check** — the real word count against the tier, reported rather than corrected.
  Under budget with every beat delivered and every loop paid is a finished issue: state the number and
  move on. Under budget *because* a beat is thin is a real finding — name the beat, and never inflate
  the prose around it. Over budget: cut the weakest section, don't trim every section evenly.

Then hand the draft to the `editor` agent for the independent verdict. The seams pass is what the
writer owes; the verdict is what the writer cannot honestly give themselves.

## 8. When to keep it light

A `short` tier note, a one-scene personal issue, or a piece the author already drafted by hand doesn't
need ceremony: the brief collapses to angle + promise + hook + the two or three beats, and it gets
written in one pass with a seams pass after. Outlining exists to make long pieces hold, not to add
process to a 700-word letter. Say which mode is being used in one line, and move.

## 9. The brief skeleton

Copy this into `issues/NNN-slug/brief.md` and fill it. Keep the headings — the `editor` agent reads
them, and `headlines` validates the subject against the promise recorded here.

```markdown
# Brief — issue {NNN}: {WORKING_TITLE}

## The decision
- **Angle:** {the one chosen, of the options offered}
- **Promise (one sentence):** {…}
- **The single idea:** {…}
- **Reader & what they take away:** {…}
- **Length tier:** {short | standard | deep} — target {N} words

## The hook
- **Chosen hook:** {…}
- **Tension it opens:** {curiosity | pain | contradiction | desire | identification}
- **Where the macro loop closes:** {the section that pays it off}
- **Callback planted:** {the detail from the opening that returns at the end}

## Outline
| # | Subhead (concrete, in voice) | The beat it carries | Fed by | Words |
|---|---|---|---|---|
| 1 | {…} | {…} | {…} | {…} |

**Sequence check:** {does the order carry before → what happened → after? does each section earn the
next? do the subheads alone give the shape?}

## Approved sources
<!-- ONLY the researcher brief's Verified section. Unverified claims stay out and become [[fact?: ]]. -->
- {claim} — {source title}, {url}

## Interview answers
<!-- Quote the author, don't paraphrase. Each answer is material a section is fed by. -->
- **Q:** {…}
  **A:** {…}

## Open gaps
<!-- Sections still fed by nothing. Each is cut before writing or marked [[enrich:]] — never invented. -->
- {…}

---
**Approved by the author:** {date}
```

Prose starts only once that last line is filled. If the angle, promise, or tier changes after approval,
re-confirm in one line and update the brief — it stays the source of truth for what the issue is.
