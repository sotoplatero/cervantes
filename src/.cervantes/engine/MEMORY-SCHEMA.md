# Memory schema — how Cervantes maintains the author's data

The memory files (`voice/profile.md`, `voice/journal.md`, `voice/cover-style.md`, `voice/archive/`) are **pure instance data**: they belong to the author and Cervantes maintains them. Every instruction about their structure lives HERE, in the engine — so the author can edit (or accidentally delete) anything in memory without disabling any behavior.

**Structural healing rule:** if a memory file is missing a section this schema defines, re-add the section header (empty) — and never delete, rewrite, or "clean up" the author's own content while doing it. The data is theirs; the structure is the engine's. This schema is also the only migration mechanism there is: when a newer engine defines a section the author's file lacks, the `cervantes` skill offers to add the header. No version numbers are involved.

**Golden rule:** everything under `.cervantes/` and `.claude/` ships with the folder and a fresh copy of Cervantes restores it. `voice/`, `issues/` and `published/` exist only here — they are the author's and they are sacred.

## `voice/profile.md` — the voice fingerprint

**Status marker:** the `Voice version` line. `v0.0` = unseeded — never write in the author's name; run the seeding first (archive import + interview). Seeding fills the file and bumps to `v0.1`; every meaningful update bumps it again (v0.1 → v0.2 …) and adds a dated line to the journal.

Sections:

- **Basic config** — newsletter name, author, URL (kept so the voice can be re-scraped later), platform, **language** (all content is written in it; detected from the published newsletter, not the chat), niche/topics, audience & what they come for, reader address (tú/usted/you/formal), **typical length** (the length tier: `short` / `standard` / `deep` — sets the word target and section budget per `STRUCTURE.md` §1), emojis & caps, loanwords raw or glossed, cadence, polish intensity (light/standard/deep), off-limits topics.
- **Voice fingerprint** — one row per dimension, filled ONLY from what is observed in real text (no invented traits): person & stance, sentence rhythm, paragraph size, lexicon, signature phrases, punctuation habits, humor & tone, typical openings, recurring moves/sections, closing style. Each with a short quoted example from the archive.
- **Hook-formula shortlist** — derived from the fingerprint per `HOOK-FORMULAS.md` § Narrowing: number + name + one line on why it fits; updated as resonance shows what wins.
- **Documented signatures (anti-slop exceptions)** — patterns from `ANTI-SLOP.md` that ARE this author's real voice, each with a quoted example from published text.
- **Standing preferences (from chat)** — dated instructions the author gave in conversation; re-read before every issue.
- **Things I NEVER do when writing as you** — hard constraints from explicit corrections, with dates. An edit that repeats across issues gets promoted here.
- **Your phrases & turns (voice bank)** — quotes from real published text only.

## `voice/journal.md` — the learning log

Newest entries first. The learning signal comes from four places: the **edit diff** (`.baseline.md` vs the draft after the author edited it by hand — logged by `polish`), the **published diff** (`draft.md` vs the version that actually went out — logged by `ship`, and often the most honest sample there is), **explicit corrections** in chat ("I'd never say it that way," "this is me"), and **resonance** (opens, replies, what won — logged by `ship` when the numbers arrive, and it sharpens future angle and subject choices). All four get logged here and carried into the profile.

Entry template (copy and fill):

```
## YYYY-MM-DD — Issue: "<title or topic>"

**Angle chosen:** (of the proposed options, which and why)
**Subject shipped:** "<subject>"  |  **Preheader:** "<preheader>"

**Draft vs. edited/published (the diff):**
- Cervantes drafted: ...
- the author kept/changed: ...
- the difference that matters: ... (cut / rewrote / added / reordered)

**Structure (from brief.md):** which outline sections survived, which got merged, cut, or reordered on
the way out — and the length that actually shipped vs the tier. A section the author cuts every time is
a structural lesson, not a one-off.

**Explicit corrections:** ("I'd never say...", "this is me")
**New patterns observed:** (turns of phrase, rhythm, structure)
**Profile changes applied:** (what was edited; new voice version)

**Resonance (fill when known):**
- open rate: ___ | reply rate: ___ | clicks: ___
- winning subject (if A/B): ___
- what landed / fell flat: ...
- carry-forward for next issue: ...
```

Patterns to watch over time: which **angle types** get replies (opinion vs tutorial vs story); which **subject archetypes** win opens; which **outline shapes** survive to publication; edits that repeat across issues → promote to the profile's "Things I NEVER do."

**Not memory:** `issues/NNN-slug/brief.md` is per-issue working data, not part of the author's memory — it belongs to its issue, travels with it to `published/`, and its skeleton lives in `.cervantes/engine/STRUCTURE.md` §9. Nothing in setup or repair touches it either, because nothing touches `issues/` at all.

**Continuous learning protocol:** every time the author writes anything — a chat message, an edit, a correction — scan it for voice and preference signals and write what's found to memory THAT SAME TURN, confirming in one short line ("Noted in your profile: …"). If a signal isn't written to a file, it didn't get learned — never rely on session recall.

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

## `voice/archive/` — the published record

Imported issues as `YYYY-MM-DD-slug.md` with frontmatter (`title`, `date`, `url`). It's the ground truth for the voice fingerprint. Seeded at onboarding by the `importer` agent (RSS → `/archive` → sitemap), and grown one issue at a time by the `ship` skill, which writes the **version that actually published** here — so the corpus tracks what the author truly ships, not drafts. The profile's URL allows re-running the `importer` to refresh with newly published issues. Never delete or rewrite archive files (one file per issue; skip on collision).

## `published/` — the shipped-issue record

Each shipped issue's full folder (`published/NNN-slug/`: its `brief.md`, `draft.md`, snapshot, cover, material), moved here from `issues/` by `ship`. Keeps the `NNN-` edition prefix so `draft`'s next-number lookup spans `issues/` + `published/`. Sacred; never rewritten. The *clean text* for voice lives in `archive/`; `published/` is the full record.
