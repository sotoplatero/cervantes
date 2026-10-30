---
name: headlines
description: Generates the final title options, email subject line, and preheader for a finished newsletter draft, in the author's voice and language, using the workspace's hook formulas and anti-slop rules. Triggers when the author asks for titles, headlines, subject lines, or naming help for an issue.
---

# Cervantes: Headlines

The subject decides the open. It gets written LAST, from the finished draft — by then the most compelling hook is known.

## Preconditions

Read `voice/profile.md` (voice, shortlist, taboos, language), the issue's `draft.md` and its
`brief.md` (the **promise** recorded there is what the subject may promise — no more), `.cervantes/engine/TEMPLATES.md`
§ Subject line, and `.cervantes/engine/HOOK-FORMULAS.md` (shortlist first). Scan 3–4 titles in `voice/archive/`
to match the author's historical title style. Check `## Patterns so far` in `voice/journal.md` for
winning subject archetypes from past resonance.

## Method

1. **Name the tension** the finished draft actually delivers (one sentence). Check it against the
   brief's promise: if the draft ended up delivering something else, the subject follows the **draft**,
   and you say so in one line — the text is what the reader gets.
2. **Generate ~8–10 subject candidates** across different formulas, built from concrete details IN the draft — a real noun, number, or action. Filter through voice + `.cervantes/engine/ANTI-SLOP.md` (it applies to titles hardest of all).
3. **Present 3 variants**, each labeled with its archetype (concrete noun/number · honest curiosity gap · first-person admission · specific question), **mark the most concrete one** and say in one line why. Each fits the mobile preview (~45–55 characters) and addresses the reader the way the profile records. If a variant could top anyone's post, it's already deleted.
4. **Title + dek** for the post page (title can breathe longer than the subject; dek states the promise).
5. **Preheader** for each subject variant: extends — never repeats — the subject, ~40–90 chars. Subject + preheader read as one two-line promise.
6. **One CTA** suggestion if the draft's is weak (concrete and verbal; early lists: prompt a reply).
7. **Check before presenting:** run `.cervantes/engine/QUALITY-CHECKLIST.md` § Headlines on the set.

## Apply

When the author picks: update the title/dek at the top of `draft.md` (and the CTA in the body, if they took a new one), and mirror **those same lines** into `.baseline.md`. Subject and preheader never go into the file — no header block, no frontmatter: give them to the author in chat, ready to paste into their platform. Never regenerate the snapshot's body: the author may have hand-edited the draft since it was taken, and a full refresh would erase the diff `polish` uses to protect their sentences. In `voice/journal.md`, find this issue's entry (`## Issue NNN — "<title>"`) — create it only if none exists — and append a `### Headlines (date)` block per `.cervantes/engine/MEMORY-SCHEMA.md` with the **Subject chosen** and its archetype. It is the subject chosen, not shipped: `ship` records what went out.

## Anti-goals

- Never promise what the draft doesn't deliver — the curiosity gap must be paid off in the body.
- No anti-slop patterns in titles (antithesis, "What if I told you", colon formats, tricolons) unless the profile documents them as the author's signature.
- A handful of strong options beats twenty; don't flood.
