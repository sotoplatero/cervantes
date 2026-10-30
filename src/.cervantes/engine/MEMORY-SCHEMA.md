# Memory schema — how Cervantes maintains the author's data

The memory files (`voice/profile.md`, `voice/journal.md`, `voice/cover-style.md`, `voice/archive/`) are **pure instance data**: they belong to the author and Cervantes maintains them. Every instruction about their structure lives HERE, in the engine — so the author can edit (or accidentally delete) anything in memory without disabling any behavior.

**Structural healing rule:** if a memory file is missing a section this schema defines, re-add the section header (empty) — and never delete, rewrite, or "clean up" the author's own content while doing it. The data is theirs; the structure is the engine's. This schema is also the only migration mechanism there is: when a newer engine defines a section the author's file lacks, the `cervantes` skill offers to add the header. No version numbers are involved.

**Golden rule:** everything under `.cervantes/` and `.claude/` ships with the folder and a fresh copy of Cervantes restores it. `voice/`, `issues/` and `published/` exist only here — they are the author's and they are sacred.

## `voice/profile.md` — the voice fingerprint

**Status marker:** the `Voice version` line. `v0.0` = unseeded — never write in the author's name; run the seeding first (archive import + interview). Seeding fills the file and bumps to `v0.1`; every meaningful update bumps it again (v0.1 → v0.2 …) and adds a dated line to the journal. The line stays exactly `Voice version: vX.Y`, in English, even when the rest of the profile is in the author's language — the start-up check reads it literally.

Sections:

- **Basic config** — newsletter name, author, URL (kept so the voice can be re-scraped later), platform, **language** (all content is written in it; detected from the published newsletter, not the chat), niche/topics, audience & what they come for, reader address (tú/usted/you/formal), **typical length** (the length tier: `short` / `standard` / `deep` — sets the word target and section budget per `STRUCTURE.md` §1), emojis & caps, loanwords raw or glossed, cadence, polish intensity (light/standard/deep), off-limits topics.
- **Voice fingerprint** — one row per dimension, filled ONLY from what is observed in real text (no invented traits): person & stance, sentence rhythm, paragraph size, lexicon, signature phrases, punctuation habits, humor & tone, typical openings, recurring moves/sections, closing style. Each with a short quoted example from the archive.
- **Hook-formula shortlist** — derived from the fingerprint per `HOOK-FORMULAS.md` § Narrowing: number + name + one line on why it fits; updated as resonance shows what wins.
- **Documented signatures (anti-slop exceptions)** — patterns from `ANTI-SLOP.md` that ARE this author's real voice, each with a quoted example from published text.
- **Anti-slop forms in {language}** — only for a language other than Spanish or English: that language's equivalents of the `ANTI-SLOP.md` devices, one line each with its `[flat]`/`[freq]` tag, derived once (at onboarding or the first sweep) and read by every sweep after. Empty for ES/EN.
- **Standing preferences (from chat)** — dated instructions the author gave in conversation; re-read before every issue.
- **Things I NEVER do when writing as you** — hard constraints from explicit corrections, with dates. An edit that repeats across issues gets promoted here.
- **Your phrases & turns (voice bank)** — quotes from real published text, plus lines the author wrote into a draft by hand, marked `(from edit, YYYY-MM-DD)`. Never a line Cervantes wrote.

**Keeping the lists lean.** In Things I NEVER do, Standing preferences and the voice bank: no duplicates — a signal already recorded gets its date refreshed, not a second line. A newer preference that contradicts an older one **replaces** it, dated. The voice bank holds ~15 quotes; past that, a new one replaces the weakest (the most generic, or the one the fingerprint already covers).

**Re-deriving the fingerprint.** Every ~10 issues newly added to `voice/archive/` since the last derivation, offer to re-derive the Voice fingerprint table from the archive: show the new table beside the old, the author corrects, then it's written and the version bumped. Never silently.

## `voice/journal.md` — the learning log

The learning signal comes from four places: the **edit diff** (`.baseline.md` vs the draft after the author edited it by hand — logged by `polish`), the **published diff** (`draft.md` vs the version that actually went out — logged by `ship`, and often the most honest sample there is), **explicit corrections** in chat ("I'd never say it that way," "this is me"), and **resonance** (opens, replies, what won — logged by `ship` when the numbers arrive, and it sharpens future angle and subject choices). All four get logged here; what passes § What counts as a learning signal is carried into the profile.

**One entry per issue, keyed by edition number.** Each skill finds the entry by `Issue NNN`, appends its own dated sub-block under it, and creates the entry only if none exists. Issue entries are ordered newest-first by issue number. Entries in the older `## YYYY-MM-DD — Issue: "…"` shape are left exactly as they are — never rewritten into the new one.

```
## Issue NNN — "<title or topic>"

**Angle chosen:** (of the proposed options, which and why — written by draft)

### Polish round N (YYYY-MM-DD)
- Cervantes drafted: ... | the author changed: ... | the difference that matters: ... (cut / rewrote / added / reordered)
- Explicit corrections: ...  ·  Profile changes applied: ...

### Headlines (YYYY-MM-DD)
- Subject chosen: "<subject>"  |  Preheader: "<preheader>"  (chosen, not yet shipped)

### Shipped (YYYY-MM-DD)
- Published diff: draft.md vs what went out — what was cut, rewritten, added
- Structure survival: which outline sections survived, merged, were cut or reordered; length shipped vs tier
- Subject that actually went out: "<subject>"
- Profile changes applied: ...

### Resonance (YYYY-MM-DD)
- open rate: ___ | reply rate: ___ | clicks: ___ | winning subject (if A/B): ___
- what landed / fell flat: ...
- carry-forward for next issue: ...
```

A section the author cuts every time is a structural lesson, not a one-off. Patterns to watch across entries: which **angle types** get replies (opinion vs tutorial vs story), which **subject archetypes** win opens, which **outline shapes** survive to publication, and edits that repeat across issues (→ the profile's "Things I NEVER do").

### Compaction — `## Patterns so far`

The journal keeps the **last 5 issue entries in full**. When a sixth arrives, the oldest is folded into a `## Patterns so far` digest at the top of the file — winning subject archetypes, structural cuts that repeat, recurring edits, carry-forwards still open — and its body is removed, leaving one line in its place: `- Issue NNN — "<title>" → folded into Patterns so far`. The digest is rewritten as a whole each time, kept short, never appended to blindly. Anything that reads "the latest journal entry" reads `## Patterns so far` plus the most recent issue entry. Decision entries are not compacted.

### Editorial decisions — the second kind of entry

Not every decision belongs to an issue. Which published post deserves a second part, a topic parked on purpose, a pattern that only shows up across several issues, an angle ruled out and why — these have no `brief.md` to live in and no issue to be filed under. Without a record the author has the same conversation again next session, and the reasoning that took a real reading of the archive gets thrown away. Same file, same newest-first order:

```
## YYYY-MM-DD — Decision: "<the question, in the author's words>"

**Consulted:** (which archive files, which journal entries, which resonance numbers — or "titles only")
**Decision:** ...
**Why:** (the evidence it rests on, not the impression)
**Follow-through:** (what it becomes: an issue to draft, an option discarded and why, a standing preference)
```

Two rules. The **Consulted** line is never optional: a decision with nothing under it is an opinion, and months later nobody can tell the two apart. And when a decision does turn into an issue, its `NNN` gets written back here, so the thread from question to published piece stays readable.

**Not memory:** `issues/NNN-slug/brief.md` is per-issue working data, not part of the author's memory — it belongs to its issue, travels with it to `published/`, and its skeleton lives in `.cervantes/engine/STRUCTURE.md` §9. Nothing in setup or repair touches it either, because nothing touches `issues/` at all.

**Continuous learning protocol:** every time the author writes anything — a chat message, an edit, a correction — scan it for voice and preference signals and write what passes the threshold below to memory THAT SAME TURN, confirming in one short line, **in the author's language**, that says what was learned — never an English stock phrase in a conversation held in another language, and never the voice version number. If a signal isn't written to a file, it didn't get learned — never rely on session recall.

### What counts as a learning signal

Only two things are written to the profile:

1. **An explicit standing preference or voice correction** — "never…", "I'd never say…", "always…".
2. **A pattern seen in the author's own edits at least twice** (across rounds or issues, per the journal).

A choice that only concerns the current issue — an idea rejected, an angle picked, an example dropped — goes to that issue's `brief.md` § Ruled out, not to the profile. Nothing else is written. The confirmation line is said only when something was actually written; no signal, no line. During onboarding the protocol is suspended: the `cervantes` skill's final seeding step writes everything at once.

## Edition numbers

The next issue's `NNN` = the highest number among the folders in `issues/` and `published/`, plus 1. If there are none, ask the author which edition this is, suggesting (the number of posts in `voice/archive/`) + 1. Always three digits (`007`, `112`).

## `voice/cover-style.md` — the fixed visual block

Why it exists: every issue's cover must look like it belongs to the SAME newsletter. Consistency isn't magic — it's repeating the same style block, **word for word**, and changing only the subject.

The golden rule of consistency:

1. The **subject** changes each issue (from the issue's topic).
2. The **fixed style block** does NOT change: copy it identically every time.
3. The **Reference image** section holds the current **style anchor**: the reference image the author handed at onboarding, or — if none — the first shipped cover once it exists (**save it** when it ships). When generating, use the anchor alongside the prompt ("same style, light, and stroke as this") — it anchors the look better than text.
4. If the style drifts after several edits, start fresh and paste the full block again.

Where the fixed block comes from (set at onboarding, by priority): (1) the author's reference image — describe what it actually shows (palette, treatment, mood, composition, medium); (2) the newsletter URL's look; (3) the wizard's style-direction answer or a sensible default. The author can swap the block once for a stronger look — then it stays fixed.

Per-issue prompt formula (in English, whatever the newsletter's language — image models respond best to it):

```
[ISSUE SUBJECT, 1–2 sentences, as concrete as possible]
+ [THE FIXED STYLE BLOCK, pasted the same every time]
+ Format: [aspect ratio from the style file, e.g. 16:9 header + 1:1 social]
+ Avoid: [the style file's exclusions] + glossy 3D render, generic stock photo,
  busy backgrounds, logos or watermarks, loose text or letters.
```

The default is **no text on the image**. "Loose text or letters" leaves the exclusions only when the author asked for text on the cover, and then the style block says exactly which text.

## `voice/archive/` — the published record

Imported issues as `YYYY-MM-DD-slug.md` with frontmatter (`title`, `date`, `url`). It's the ground truth for the voice fingerprint. Seeded at onboarding by the `importer` agent (RSS → `/archive` → sitemap), and grown one issue at a time by the `ship` skill, which writes the **version that actually published** here — so the corpus tracks what the author truly ships, not drafts. The profile's URL allows re-running the `importer` to refresh with newly published issues. Never delete or rewrite archive files (one file per issue; skip on collision).

## `published/` — the shipped-issue record

Each shipped issue's full folder (`published/NNN-slug/`: its `brief.md`, `draft.md`, snapshot, cover, material), moved here from `issues/` by `ship`. Keeps the `NNN-` edition prefix so `draft`'s next-number lookup spans `issues/` + `published/`. Sacred; never rewritten. The *clean text* for voice lives in `archive/`; `published/` is the full record.
