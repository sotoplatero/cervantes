---
name: cover
description: Create the cover image (or a ready-to-use image prompt) for a newsletter issue, following the fixed visual style in cervantes/cover-style.md. Use when the author asks for a cover, header image, or article artwork.
---

# Cervantes: Cover

Every issue gets a cover that looks like it belongs to the same publication. **The style is fixed; only the concept changes.**

## Step 1 — load style and article

1. Read `cervantes/cover-style.md` in full. If missing, run the cover-style section of `/cervantes:start` first (a short interview), save the file, then continue.
2. Read the target draft to understand its core idea.

## Step 2 — find the concept

Derive ONE visual concept from the article: a concrete metaphor or scene that captures the core idea. Prefer specific over abstract ("a ladder leaning on a cloud" beats "success concept"). Check it against the style guide's **Hard exclusions**.

Propose the concept to the author in one or two sentences, with one alternative. Let them pick or tweak — it's their cover.

## Step 3 — build the prompt

Fill the style guide's **Base prompt skeleton**: insert the concept, keep every fixed style element verbatim (medium, palette, mood, composition, texture, aspect ratio, exclusions as negative hints). The result must be a single self-contained prompt in English (image models respond best to English, regardless of the author's language).

## Step 4 — generate or hand off

Check what image generation is actually available in this environment, in order:

1. **An installed image-generation skill or CLI** (e.g. an `ai-image-generation` skill, `inference.sh`, or similar) — use it, at the style guide's aspect ratio.
2. **An image-capable MCP tool** connected to the session — use it.
3. **Nothing available** — this is normal and fine: save the prompt to `covers/<draft-slug>-prompt.txt` and tell the author to paste it into their image tool (Midjourney, DALL·E, Ideogram, Canva...). Include the aspect ratio and, if their tool supports it, the negative prompt separately.

When an image is generated, save it as `covers/<draft-slug>.png` (or the tool's output format). Show it to the author; offer ONE round of variation if they want changes (adjust the concept, never the fixed style).

## Consistency check

Before finishing, compare against previous covers/prompts in `covers/`: same medium, same palette, same mood? If something drifted, fix the prompt — consistency is the product.

## Anti-goals

- Never redesign the visual style per-issue; style changes only happen by editing `cervantes/cover-style.md` deliberately.
- No text baked into the image unless the style guide says so (models garble text).
- Don't generate before the author approved the concept.
