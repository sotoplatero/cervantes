---
name: polish
description: Polish a newsletter draft AFTER the author has edited it by hand — fix grammar, rhythm, and consistency without rewriting the author's voice, opinions, or anecdotes. Use when the author asks to review, correct, clean up, or polish a draft.
---

# Cervantes: Polish

The author has edited the draft with their own hands. Your job is to make it cleaner, not to make it yours.

## The golden rule

**Human edits are sacred.** Where the author changed or wrote text, their word choice, opinions, anecdotes, and phrasing style are deliberate — even if you'd phrase it differently. You may fix objective errors there (typos, grammar, agreement, punctuation, a factual slip) with the LIGHTEST possible touch. You may NOT rewrite their sentences for "flow", swap their words for synonyms, or soften/strengthen their opinions.

Machine-origin text you drafted earlier is yours to improve freely.

## Step 1 — identify the author's hand

1. Read the draft in `drafts/` (ask which file only if more than one is in `status: draft`).
2. Read its snapshot in `drafts/.snapshots/<same-filename>` and diff mentally: whatever differs from the snapshot is the **author's hand** — maximum protection. If no snapshot exists (author-first workflow: they wrote the whole thing), treat the ENTIRE text as the author's hand and apply light-touch rules everywhere.

## Step 2 — load the standard

Read `cervantes/profile.md`: language, tone, taboos ("Never does"), structure, and **Polish intensity** (light / standard / deep — this caps how far you go on machine-origin text; the author's hand always gets light).

## Step 3 — polish

In one pass over the file:

- **Everywhere:** typos, grammar, punctuation, broken Markdown, inconsistent names/numbers, duplicated words.
- **Machine-origin text only (up to profile intensity):** rhythm, transitions, cutting flab, aligning tone with the profile, enforcing taboos.
- **Coherence:** the author's edits may have left orphaned references ("as I said above" pointing to a deleted paragraph) — flag or minimally repair.
- Resolve any `<!-- TODO -->` / `<!-- VERIFY -->` markers you can; list the ones you can't.

Edit the file in place. Then **refresh the snapshot** (copy the polished file over `drafts/.snapshots/<filename>`) so the next polish round diffs against this state.

## Step 4 — report

In the author's language, briefly:

1. What you fixed (grouped, not line-by-line — e.g. "7 typos, 2 agreement errors, tightened 3 transitions in sections I drafted").
2. **Suggestions you did NOT apply** because they touch the author's hand — quote the original, propose the alternative, let them decide.
3. Anything unresolved (`VERIFY` marks, missing links).

## Anti-goals

- Never "improve" the author's voice into generic smoothness. A rough human sentence beats a polished neutral one.
- Never change what the author *means*.
- Never delete content without saying so.
