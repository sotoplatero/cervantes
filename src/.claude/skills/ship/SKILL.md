---
name: ship
description: Closes out a published issue — records the version that actually went out, moves the issue from issues/ to published/, adds the clean text to the voice archive, learns from the draft-vs-published diff, and later logs resonance so opens/replies/winners feed the next issue. Triggers when the author says they published, shipped, or sent an issue, pastes the final published version or its URL, or brings resonance numbers (opens, replies, clicks) for a past issue.
---

# Cervantes: Ship

Publishing is where two of the three learning signals live — **what actually went out** (it often differs from the polished draft) and **how it performed**. This skill captures both, so the archive grows with real published text and the profile sharpens issue over issue. Without it the loop stays open: `draft → polish → …nothing`.

## Two entry points

1. **"I published it" / "this is what went out"** → run the full close-out (steps 1–8).
2. **"Here are the numbers" for a past issue** → jump straight to the **resonance-only path** for that issue; do not move or re-archive anything.

Detect which from the author's message. If ambiguous, ask one line: "Closing it out (moving to published + archiving), or just logging the numbers?"

## Close-out workflow

**1. Identify the issue.** The `issues/NNN-slug/` folder in question (ask only if ambiguous — usually it's the most recent, or the one they name).

**2. Capture the version that actually shipped.** In priority order:
- **Already in the archive** → if `voice/archive/` already holds this post (match by URL, or by title — `draft`'s sync often imports it first), that file is the shipped version. Skip the import; step 4 is done.
- **A URL** → delegate to the `importer` agent (Agent tool, `subagent_type: "importer"`) in its single-post mode: give it the post URL and `voice/archive/` as the target, and it fetches the live post, cleans it to Markdown, and writes `voice/archive/YYYY-MM-DD-slug.md` with frontmatter — step 4 done. Never fetch the page inline (it floods the session with markup), and don't send `researcher` — it returns an evidence brief, never full post text. Read the file the importer wrote; that's the shipped version for the diffs below.
- **Pasted final text** → use it verbatim.
- **Neither** ("I shipped it as-is") → the shipped version *is* `draft.md`. Confirm that in one line before proceeding.

**3. Learn from the draft-vs-published diff — the signal `polish` can't see.** Diff `draft.md` (the last state Cervantes had) against the shipped version from step 2:
- Everything the author changed on the way out is high-value voice data — the edits they made that Cervantes never got to watch.
- In `voice/journal.md`, find this issue's entry (`## Issue NNN — "<title>"`) — create it only if none exists — and append a `### Shipped (date)` block per `.cervantes/engine/MEMORY-SCHEMA.md`: what the last draft had → what actually shipped → the difference that matters.
- **Also diff the structure against `brief.md`:** which outline sections survived, which got merged, cut, or reordered, and the shipped length vs the tier. A section the author cuts on the way out every single time is a structural lesson — log it, and after it repeats, carry it into the profile.
- Carry into `voice/profile.md` only what meets MEMORY-SCHEMA's learning-signal bar (a pattern now seen twice, or a standing preference). When the profile changed, bump `Voice version` and confirm in one short line in the author's language (never the version number).
- If the shipped version equals `draft.md` (no changes), say so and skip the profile edit — nothing new to learn from the text this time.

**4. Archive the clean text — this is what feeds the voice fingerprint.** If the file was already in the archive or the `importer` wrote it in step 2, verify the file and its frontmatter and move on. Otherwise write the shipped version to `voice/archive/YYYY-MM-DD-slug.md` with frontmatter (`title`, `date` = publish date, `url` if known), body as clean Markdown (no nav/footers). From now on the archive holds **real published issues**, so every future fingerprint read and every `headlines`/`repurpose` pass works from what the author truly ships, not from drafts. Never overwrite or rewrite an existing archive file — one file per issue.

**5. Move the issue to `published/`.** Move the whole `issues/NNN-slug/` folder to `published/NNN-slug/` (keep the `NNN-slug` name — the edition number must stay so `draft`'s next-number lookup keeps working across `issues/` + `published/`). The folder keeps its `brief.md`, `draft.md`, snapshot, cover, and material as the full record. If a move isn't clean, copy then remove the source; never leave the issue in both places.

**6. Leave resonance open.** The numbers don't exist yet: the `### Resonance` block gets appended to this issue's entry when they arrive (resonance-only path below). Tell the author in one line when to bring them — open rate, reply rate, clicks, winning subject if they A/B tested — usually after about four days.

**7. Check, then keep the backup current.** Run `.cervantes/engine/QUALITY-CHECKLIST.md` § Ship. Then, if the folder has a GitHub remote (`git remote` comes back non-empty), commit everything and push, silently, with a plain message in the author's language ("Published NNN — <title>"). If it fails, say so in one line and carry on — never troubleshoot git with the author. No remote → skip without a word.

**8. Report** in the author's language, 3–4 lines: shipped version recorded, what the diff taught (or "shipped unchanged"), archived as `<file>`, moved to `published/NNN-slug/`, when to bring the numbers. Then offer the natural next step: "Want the social versions? — say *repurpose*."

## Resonance-only path (numbers for a past issue)

When the author brings numbers for an already-shipped issue:
1. Find that issue's entry in `voice/journal.md` by `Issue NNN` and append a `### Resonance (date)` block per `MEMORY-SCHEMA.md` (open rate, reply rate, clicks, winning subject). Never invent a field the author didn't give.
2. **Turn numbers into voice signal:** the winning subject's **archetype** goes to the profile's hook-formula shortlist as a proven winner; note what landed / fell flat as a carry-forward for the next issue's angle.
3. Bump `Voice version` if the profile changed; confirm in one line.

This is what makes the *next* `headlines` and `draft` pick angles and subjects this list has already rewarded.

## Anti-goals

- Never leave an issue in both `issues/` and `published/`, and never rename away its `NNN-` edition prefix.
- Never publish, send, or post anything yourself — `ship` runs *after* the author has already published. It records; it does not broadcast. (Pushing to the author's own private backup is not publishing.)
- Never overwrite or "tidy" an existing archive file, and never touch another issue's memory.
- Never skip the diff learning: an unlogged published version is the single most honest voice sample there is, wasted.
- Never invent resonance numbers or a publish date — if unknown, leave the field open.
