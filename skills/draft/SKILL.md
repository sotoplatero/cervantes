---
name: draft
description: Write the first draft of a newsletter issue from the author's topic, notes, links, and data — in the author's voice and language, per cervantes/profile.md. Use when the author wants to start a new issue, turn notes into a draft, or asks Cervantes to write an article.
---

# Cervantes: Draft

Write a first draft the author will *want* to edit — in their voice, their language, their structure.

## Preconditions

- `cervantes/profile.md` must exist. If missing, stop and run `/cervantes:start` first.
- Write ALL content in the profile's **Language**. Talk to the author in it too.

## Step 1 — gather the raw material

The draft is built from the AUTHOR'S inputs, not from thin air. You need:

1. **Topic / angle** — what this issue is about.
2. **Their material** — notes, bullet points, links, data, anecdotes, a voice-memo transcript... whatever they have.

If they gave you nothing but a topic, ask for their take first (2-3 questions max): What's YOUR opinion here? Any personal story? What should the reader do or feel at the end? A draft without the author's viewpoint is generic filler — don't write one.

If they provided links, fetch and read them. Facts from sources must be attributable; never invent statistics, quotes, or events.

## Step 2 — load the voice

1. Read `cervantes/profile.md` in full.
2. Read 2-3 issues from `cervantes/archive/` (prefer recent ones or ones on a similar topic) to calibrate rhythm and structure.

## Step 3 — write the draft

- Follow the profile's **Structure**, **Length**, **Tone**, **Signature moves**. Respect **Never does** absolutely.
- Weave the author's material and opinions through the piece — their anecdotes and takes are the spine, sourced facts are support.
- Working title at the top (final titles come later via `/cervantes:headlines`).

Save to `drafts/YYYY-MM-DD-slug.md` (today's date, short slug from the topic) with frontmatter:

```yaml
---
title: "Working title"
date: YYYY-MM-DD
status: draft
---
```

## Step 4 — snapshot (critical for polish)

Save an EXACT copy of the file to `drafts/.snapshots/<same-filename>`. This is how `/cervantes:polish` will later distinguish the author's hand edits from machine text. Overwrite any previous snapshot of the same file.

## Step 5 — hand off

Tell the author, briefly:

- Where the draft is.
- 1-3 spots where you most want THEIR voice or judgment (mark them in the text with `<!-- TODO: ... -->` comments if useful).
- Next step: edit the file by hand in any editor, then run `/cervantes:polish`.

## Anti-goals

- No invented facts, quotes, or numbers. If a claim needs a source you don't have, mark it `<!-- VERIFY -->`.
- Don't pad to hit a word count; the profile's length is a target, not a quota.
- Don't ask permission for every paragraph — write the whole draft, then hand it over.
