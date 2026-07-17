---
name: start
description: Set up Cervantes in this folder — one-time onboarding. Interviews the author, optionally imports their published newsletter archive from a URL, extracts their voice, defines a cover art style, and generates the workspace (profile, folders, CLAUDE.md). Use when the user wants to start/set up their newsletter workspace, or when any Cervantes skill finds cervantes/profile.md missing.
---

# Cervantes: Start (onboarding)

You are setting up a personal newsletter writing system for this author, in this folder. The outcome: a workspace where every future skill knows their voice without being told.

## Rule 0 — language

Detect the author's language from their messages (and later, their archive). Conduct the ENTIRE onboarding in that language. Record it in the profile — every future skill writes in it. File names, folder names, and file structure stay in English.

## Rule 1 — don't re-onboard

If `cervantes/profile.md` already exists, say so, summarize what's in it, and ask what they want to update instead of starting over.

## Step 1 — welcome and the one big question

Briefly introduce what will happen (2-3 lines, no lecture). Then ask:

> Do you already publish a newsletter? If so, give me its URL — I'll read it to learn your voice instead of asking you twenty questions.

## Step 2 — import the archive (if they gave a URL)

Goal: download recent published issues as local Markdown so Cervantes can consult them forever.

1. Create `cervantes/archive/`.
2. Discover post URLs:
   - **Substack**: fetch `<url>/archive` and/or `<url>/feed` (RSS covers ~20 recent posts and is the most reliable).
   - **Ghost / WordPress / other**: try `<url>/rss`, `<url>/feed`, or `<url>/sitemap.xml`.
   - If nothing works, ask the author to paste 3-5 links to their favorite issues.
3. Fetch up to **15 recent posts**. For each, save `cervantes/archive/YYYY-MM-DD-slug.md` with frontmatter:
   ```yaml
   ---
   title: "..."
   date: YYYY-MM-DD
   url: https://...
   ---
   ```
   Body: the post converted to clean Markdown (drop nav, footers, subscribe buttons, comments).
4. Report what was imported (count + titles). If a post fails to fetch, skip it and note it — don't stall.

## Step 3 — extract the voice from the archive

Read the imported posts and derive, with EVIDENCE (quote short examples):

- Tone and mood; person and how they address the reader
- Sentence rhythm and paragraph length
- Signature moves: recurring openings, sign-offs, section names, humor style, recurring phrases
- Typical structure of an issue and typical length
- Topics covered; what they clearly avoid
- Language of publication

Then present it and ask for corrections — in that order, as two separate acts:

1. **First, print the full analysis as visible message text** — a structured summary ("here's what I learned about your voice") with the short quoted examples. NEVER bury the analysis inside a question dialog, a collapsed tool call, or a file the author hasn't seen: the author must be able to READ the analysis on screen before being asked anything about it.
2. Only after the analysis is on screen, ask (in plain conversation, not a multiple-choice dialog) what feels wrong or missing. **The author's corrections always beat your analysis.**

## Step 4 — interview (fill the gaps)

Ask ONLY what the archive couldn't answer — in batches of 2-3 questions, never a wall of questions:

1. Newsletter name, platform, cadence (if not evident).
2. Audience: who reads it, what they come for, their knowledge level.
3. Taboos: words, tones, clichés they never want to see.
4. Workflow: do they prefer Cervantes to draft first from their notes ("ai-first"), or do they write raw and want polish only ("author-first")? Polish intensity: light / standard / deep.
5. Off-limits topics, if any.

If the author has NO newsletter yet, this interview carries the full weight: add questions about tone by offering 2-3 contrasting sample paragraphs on their topic and asking which feels like them.

## Step 5 — cover style

Explain that every issue can get a cover image with one consistent style. Ask:

1. Medium (flat illustration / photography / 3D / collage / watercolor / other) — offer examples.
2. Palette (3-5 colors), mood, things to always exclude.
3. Text on the image or not; aspect ratio for their platform (Substack: 1200×600 / 16:9 is a safe default).
4. Any reference images or covers they love (URL or description).

If the author doesn't care about covers, write a minimal sensible default and move on.

## Step 6 — generate the workspace

Templates live in this plugin at `${CLAUDE_PLUGIN_ROOT}/templates/`. Fill their `{PLACEHOLDERS}` with everything gathered:

1. `cervantes/profile.md` ← from `templates/profile.md`
2. `cervantes/cover-style.md` ← from `templates/cover-style.md`
3. `./CLAUDE.md` ← from `templates/workspace-CLAUDE.md`. If a CLAUDE.md already exists in the folder, show the author what you'd add and merge — never silently overwrite.
4. Create folders: `drafts/`, `drafts/.snapshots/`, `covers/`, `published/`.

## Step 7 — hand over the keys

Close with a short recap in the author's language:

- What was created and where their voice lives (`cervantes/profile.md` — "edit it whenever you like").
- The workflow: `/cervantes:draft` → edit by hand in any editor → `/cervantes:polish` → `/cervantes:headlines` → `/cervantes:cover`.
- Invite them to start their first issue now.

## Anti-goals

- Never ask the author to evaluate something they haven't seen — print it in full first, then ask.
- Don't invent voice attributes the archive or the author didn't support.
- Don't make onboarding feel like a tax form — keep it conversational, batch questions.
- Don't touch anything outside this folder.
