---
name: cover
description: Creates the cover image (or a ready-to-paste image prompt) for a newsletter issue, keeping the fixed visual style defined in the workspace's cover-style file so every issue looks like the same publication. Triggers when the author asks for a cover, header image, or artwork for an issue.
---

# Cervantes: Cover

Every cover belongs to the SAME newsletter. **The style block is fixed; only the subject changes.**

## Workflow

**1. Load.** `voice/cover-style.md` (fixed block + anchor + exclusions + aspect ratio; missing → run the cover-style step of `cervantes` first) and the issue's `draft.md` for the core idea. Maintenance rules: `.cervantes/engine/MEMORY-SCHEMA.md` § cover-style.

**2. The concept.** Derive ONE concrete visual concept from the issue — a specific metaphor or scene, not an abstraction ("a ladder leaning on a cloud" beats "success concept"). Check it against the Hard exclusions. Propose it in 1–2 sentences with one alternative; the author picks or tweaks.

**3. The prompt.** Per the formula in `MEMORY-SCHEMA.md`: subject first (1–2 concrete sentences), then the fixed style block **verbatim**, format line, then the exclusions as negatives. Prompt in English regardless of the newsletter's language. If a style anchor image exists, use it alongside ("same style, light, and stroke as this").

**4. Generate or hand off.** In order: an installed image-generation skill/CLI → an image-capable MCP tool → nothing available (normal): save the prompt as `cover-prompt.txt` in the issue folder with the aspect ratio and negatives noted, ready to paste into their tool. Generated images go in the issue folder as `cover.png` (or the tool's format). One round of variation if asked — vary the concept, never the fixed style.

**5. Consistency check.** Compare against previous issues' covers/prompts: same medium, palette, mood? If drifted, fix before finishing. If this is the first shipped cover and no anchor exists, record it as the style anchor in `voice/cover-style.md`.

## Anti-goals

- Never redesign the style per issue — style changes only by deliberately editing `voice/cover-style.md` (once).
- No text baked into the image unless the style file says so.
- Don't generate before the author approved the concept.
