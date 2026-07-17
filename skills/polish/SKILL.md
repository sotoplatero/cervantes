---
name: polish
description: Polishes a newsletter draft after the author edited it by hand — fixes grammar, rhythm, and coherence without rewriting the author's voice, opinions, or anecdotes, then logs what it learned from their edits. Triggers when the author asks to review, correct, clean up, or polish a draft or any text they wrote.
---

# Cervantes: Polish

The author edited with their own hands. Make the text cleaner — not yours — and learn from every change they made.

## The golden rule

**The author's hand is sacred.** Where they changed or wrote text, word choice, opinions, anecdotes, and phrasing are deliberate. Fix objective errors there (typos, grammar, agreement, punctuation, factual slips) with the lightest touch. Never rewrite their sentences for "flow", swap synonyms, or soften/strengthen opinions. Machine-origin text is yours to improve freely.

## Workflow

**1. Identify the author's hand.** Read the issue's `draft.md` (ask which issue only if ambiguous) and diff against `draft.v1.md` in the same folder: what differs is the author's hand — maximum protection. No `draft.v1.md` (author wrote everything raw) → the ENTIRE text is their hand; if it arrived outside an issue folder, create `issues/YYYY-MM-DD-slug/` and move it in as `draft.md`.

**2. Load the standard.** `cervantes/profile.md` (language, voice, taboos, **polish intensity** — caps how far you go on machine text; the author's hand always gets light), `engine/ANTI-SLOP.md`, and `engine/WRITING-CRAFT.md` § rhythm.

**3. Polish in one pass over the file:**
- Everywhere: typos, grammar, punctuation, broken Markdown, inconsistent names/numbers.
- Machine-origin only (up to intensity): rhythm (short-short-long), transitions, cutting flab, anti-slop sweep.
- Coherence: orphaned references left by their edits ("as I said above" pointing at a deleted paragraph) — flag or minimally repair.
- Resolve `[[...]]` notes you can; list the ones you can't. Respect deliberate colloquialisms; fix only slips.

**4. Validate** against `engine/QUALITY-CHECKLIST.md`. Fix failures before reporting.

**5. LEARN (never skip).** The diff from step 1 is the highest-value voice signal that exists:
- Log a journal entry per `engine/MEMORY-SCHEMA.md` (what Cervantes drafted vs what they changed; the difference that matters).
- Carry patterns into `cervantes/profile.md` (new turns of phrase to the voice bank; repeated edits → "Things I NEVER do"), bump `Voice version`, confirm in one line: "Noted in your profile: …".
- Refresh `draft.v1.md` (copy the polished file over it) so the next round diffs against this state.

**6. Report** briefly, in the author's language: what was fixed (grouped, not line-by-line); **suggestions NOT applied** because they touch the author's hand (quote original → propose alternative → they decide); anything unresolved.

## Anti-goals

- Never "improve" the author's voice into neutral smoothness. A rough human sentence beats a polished generic one.
- Never change what the author means. Never delete content without saying so.
- Never end without the journal entry — an unlogged edit is a lesson lost.
