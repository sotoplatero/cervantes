---
name: ship
description: Closes out a published issue — records the version that actually went out, moves the issue from issues/ to published/, adds the clean text to the voice archive, learns from the draft-vs-published diff, and opens the resonance entry so opens/replies/winners feed the next issue. Triggers when the author says they published, shipped, or sent an issue, pastes the final published version or its URL, or brings resonance numbers (opens, replies, clicks) for a past issue.
---

# Cervantes: Ship

Publishing is where two of the three learning signals live — **what actually went out** (it often differs from the polished draft) and **how it performed**. This skill captures both, so the archive grows with real published text and the profile sharpens issue over issue. Without it the loop stays open: `draft → polish → …nothing`.

## Two entry points

1. **"I published it" / "this is what went out"** → run the full close-out (steps 1–6).
2. **"Here are the numbers" for a past issue** → jump straight to **Resonance** (step 6) for that issue; do not move or re-archive anything.

Detect which from the author's message. If ambiguous, ask one line: "Closing it out (moving to published + archiving), or just logging the numbers?"

## Close-out workflow

**1. Identify the issue.** The `issues/NNN-slug/` folder in question (ask only if ambiguous — usually it's the most recent, or the one they name).

**2. Capture the version that actually shipped.** In priority order:
- **A URL** → delegate to the `researcher` agent (Agent tool, `subagent_type: "researcher"`) to fetch the live post and return its clean text — never fetch the page inline, it floods the session with markup. Save the returned markdown.
- **Pasted final text** → use it verbatim.
- **Neither** ("I shipped it as-is") → the shipped version *is* `draft.md`. Confirm that in one line before proceeding.

**3. Learn from the draft-vs-published diff — the signal `polish` can't see.** Diff `draft.md` (the last state Cervantes had) against the shipped version from step 2:
- Everything the author changed on the way out is high-value voice data — the edits they made that Cervantes never got to watch.
- Log a journal entry per `cervantes/engine/MEMORY-SCHEMA.md` (what Cervantes/last-draft had → what actually shipped → the difference that matters).
- Carry repeated patterns into `cervantes/profile.md` (voice bank, or "Things I NEVER do" when an edit recurs), bump `Voice version`, confirm in one line: "Noted in your profile: …".
- If the shipped version equals `draft.md` (no changes), say so and skip the profile edit — nothing new to learn from the text this time.

**4. Archive the clean text — this is what feeds the voice fingerprint.** Write the shipped version to `cervantes/archive/YYYY-MM-DD-slug.md` with frontmatter (`title`, `date` = publish date, `url` if known), body as clean Markdown (no nav/footers). From now on the archive holds **real published issues**, so every future fingerprint read and every `headlines`/`repurpose` pass works from what the author truly ships, not from drafts. Never overwrite or rewrite an existing archive file — one file per issue.

**5. Move the issue to `published/`.** Move the whole `issues/NNN-slug/` folder to `published/NNN-slug/` (keep the `NNN-slug` name — the edition number must stay so `draft`'s next-number lookup keeps working across `issues/` + `published/`). The folder keeps its `draft.md`, snapshot, cover, and material as the full record. If a move isn't clean, copy then remove the source; never leave the issue in both places.

**6. Open the resonance entry (and, optionally, a reminder).** Add the resonance block to this issue's journal entry per `MEMORY-SCHEMA.md`, fields empty and marked "fill when known": open rate, reply rate, clicks, winning subject (if A/B). Then offer — don't force — a nudge: "Want me to check back in ~4 days for the numbers?" Only if the author says yes AND a scheduling tool is actually available (e.g. a `send_later`-style tool) set one; otherwise just leave the block open for when they return.

**7. Report** in the author's language, 3–4 lines: shipped version recorded, what the diff taught (or "shipped unchanged"), archived as `<file>`, moved to `published/NNN-slug/`, resonance open. Then offer the natural next step: "Want the social versions? — say *repurpose*."

## Resonance-only path (numbers for a past issue)

When the author brings numbers for an already-shipped issue:
1. Find that issue's journal entry; fill the resonance fields (open rate, reply rate, clicks, winning subject).
2. **Turn numbers into voice signal:** the winning subject's **archetype** goes to the profile's hook-formula shortlist as a proven winner; note what landed / fell flat as a carry-forward for the next issue's angle.
3. Bump `Voice version` if the profile changed; confirm in one line.

This is what makes the *next* `headlines` and `draft` pick angles and subjects this list has already rewarded.

## Anti-goals

- Never leave an issue in both `issues/` and `published/`, and never rename away its `NNN-` edition prefix.
- Never publish, send, or post anything yourself — `ship` runs *after* the author has already published. It records; it does not broadcast.
- Never overwrite or "tidy" an existing archive file, and never touch another issue's memory.
- Never skip the diff learning: an unlogged published version is the single most honest voice sample there is, wasted.
- Never invent resonance numbers or a publish date — if unknown, leave the field open.
