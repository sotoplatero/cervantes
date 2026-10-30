# Quality checklist — the final pass, by stage

**Run only the section for the current stage.** `draft` and `polish` run § Draft and polish; `headlines`
runs § Headlines; `ship` runs § Ship. If an item fails, go back and fix it first — this is a feedback
loop, not a report. Every item is a test you can check against the text, not a feeling about it.

## Draft and polish

The list is **split by who can honestly check it.** The writer certifies what it can verify about its own
work; the rest goes to the `editor` agent, which reads the finished text cold. Two things are genuinely
impossible to self-assess: whether the prose still sounds like the author (you just chose every word), and
how often a device repeats across the whole piece (counting, not impression). Those are the editor's.

### What the writer certifies

**Substance**
- [ ] **One single focus.** The brief's promise fits in one sentence, and every section serves it.
- [ ] **The hook is concrete.** The first sentence carries a concrete noun, number or scene from the
      author's material — not a question, not a generality.
- [ ] **The reader takes something away** that the brief's takeaway line names: a step, a method, a
      decision rule, an example they can copy.
- [ ] **The reader is the hero.** At least one passage turns the author's story toward the reader's own
      situation, addressed the way the profile records. (No mechanical hero's-journey mold — see
      WRITING-CRAFT §13.)

**Truth**
- [ ] **Every fact, quote, example, and anecdote of the AUTHOR'S is in their material.** If any was
      invented to make the angle fit → cut it.
- [ ] **Every outside claim was checked by `researcher`** (it's in the brief's Approved sources) **or is
      marked unverified** as `[[fact?: ...]]`.
- [ ] **Links are INLINE on the relevant word** — NO references/"Sources"/footnotes section at the end.
- [ ] **Links within the tier's cap** (`WRITING-CRAFT.md` §11: short 0–2, standard 2–4, deep 3–5, at most
      one per section). Counted, not eyeballed.
- [ ] **Names and technical terms are correct.** Every number has a source.
- [ ] **The `[[...]]` notes are deletable** without breaking a sentence.

**Craft**
- [ ] **The spine is readable in the subheads** (or, in a letter-style piece, in the first line of each
      section), in the order of the type's beats (`WRITING-CRAFT.md` §3).
- [ ] **Research supports the author's story** in their voice — no section whose beat is "what source X
      found", no named research tools, no two links in one sentence.
- [ ] **The central idea is stated in the first section** and is still there after every restructure.
      Callback and restated idea at the end only if the brief planned them.
- [ ] **Nothing from the brief's Ruled out came back.**
- [ ] **`draft.md` opens with the title** — no `---` frontmatter block above it.
- [ ] **Title + dek + subheads** per `STRUCTURE.md` §5 (the one density rule), unless the profile records
      a letter-style archive.
- [ ] **Rhythm against the profile:** no run of four sentences of near-equal length; paragraph sizes
      vary around the profile's Paragraph size row.
- [ ] **No colon glosses** in the prose or the subheads (`ANTI-SLOP.md` § The colon gloss).
- [ ] **No section restarts the piece.** Each seam, read with the subhead covered, links by "but" or
      "so" (`STRUCTURE.md` §6–§7).
- [ ] **`[[enrich: ...]]` notes seeded** where the author's own example would strengthen the text.
- [ ] **Deliberate colloquialisms respected**; only slips fixed.

**Structure** (long pieces — `STRUCTURE.md`)
- [ ] **Every section in the brief's outline is present**, carrying the beat it was assigned.
- [ ] **The seams pass ran:** loops closed, planned callback landed, no orphan references, no two
      sections opening the same way.
- [ ] **Word count against the tier — reported, not chased.** Short with every beat delivered and every
      loop paid is *finished*; short because a beat is thin gets that beat named, never padded around.
- [ ] **One CTA.**

### What the `reader` reports

Handed only `draft.md` — no brief, no profile, nothing about the author. It tells you what a stranger
thinks the piece is about, the story they followed, and where they got lost, stopped caring, or didn't
believe it. It certifies nothing; it shows the holes that everyone who knows the plan reads straight past.

- [ ] **Its one-sentence summary matches the brief's promise.** If it doesn't, that's fixed first.
- [ ] **Every "got lost" spot is fixed**, or turned into a question for the author when only they can
      fill it.

### What the `editor` certifies

Handed off per the `editor` agent spec. It returns a pass/fail verdict with quoted evidence; **Must fix**
items are resolved before the author sees the piece.

- [ ] **Promise kept.** The tension the hook opens is closed in the text; the title/dek promise, if one
      exists, matches what the body delivers.
- [ ] **Tic census against `ANTI-SLOP.md`'s tags**, counted across the whole issue: every `[flat]` hit is
      a finding; a `[freq]` device used twice, or once per section, is a finding.
- [ ] **Voice fidelity (the positive check).** Measured against the profile's voice bank: where does the
      text stop sounding like the author and start sounding like competent neutral prose?
- [ ] **On a polish pass: the author's hand untouched.** Findings that land on their sentences are shown
      to them as suggestions, never applied.

## Headlines

- [ ] **Subject fits the mobile preview** (~45–55 characters), one focus, built from a concrete noun,
      number or action in the draft (`TEMPLATES.md` § Subject line).
- [ ] **3 variants offered**, the most concrete marked.
- [ ] **Preheader set**, extends the subject without repeating a word of it.
- [ ] **Title and dek promise only what the body delivers** — the brief's promise, checked line by line.
- [ ] **No `[flat]` device** in title, dek, subject or preheader, and no `[freq]` one either.
- [ ] **Journal:** `### Headlines (YYYY-MM-DD)` appended under the issue's entry (`MEMORY-SCHEMA.md`).

## Ship

- [ ] **The published version is what got archived** in `voice/archive/`, not the draft.
- [ ] **Journal updated** under the issue's entry with `### Shipped (YYYY-MM-DD)`: the published diff,
      structure survival, and the subject that actually went out.
- [ ] **Only signals that pass `MEMORY-SCHEMA.md` § What counts as a learning signal** were carried into
      the profile.
- [ ] **Resonance**, when the numbers arrive, goes under `### Resonance (YYYY-MM-DD)` with one
      carry-forward for the next issue's angle and subject.
