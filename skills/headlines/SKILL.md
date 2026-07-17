---
name: headlines
description: Generate title options, email subject line, and preheader for a finished newsletter draft, in the author's voice and language. Use when the author asks for titles, headlines, subject lines, or naming help for an issue.
---

# Cervantes: Headlines

The title decides whether the issue gets opened. Generate options in the author's register — not clickbait unless clickbait IS their register.

## Preconditions

Read `cervantes/profile.md` (voice, taboos, language) and the target draft in `drafts/`. Scan 3-4 titles in `cervantes/archive/` to match the author's existing title style.

## Produce

All in the profile's language:

1. **6 title options**, deliberately varied across styles — label each:
   - *Direct benefit* (what the reader gains)
   - *Curiosity gap* (without lying)
   - *Specific / number-driven*
   - *Contrarian or tension*
   - *Personal / story-led*
   - *In the author's own historical style* (modeled on the archive)
2. **Email subject line** for the top 2 titles — ≤ 50 characters, front-load the hook (mobile truncates).
3. **Preheader** for each subject (≤ 90 chars) that adds information, never repeats the subject.
4. One-line note: which option YOU would pick and why (one sentence, then shut up).

## Apply

When the author picks one, update the draft's frontmatter `title:` and the working title in the body. Also refresh the snapshot in `drafts/.snapshots/` if one exists.

## Anti-goals

- No title that overpromises what the draft doesn't deliver.
- Respect the profile's taboos in titles too.
- Don't generate 20 options; six good ones beat a wall of noise.
