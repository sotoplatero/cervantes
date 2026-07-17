# Cervantes

**Your newsletter writing system, inside Claude Code.**

Cervantes turns any folder into a personal editorial workspace. It learns your voice from what you've already published, drafts new issues from your ideas and data, polishes your edits without erasing you, and keeps your cover art visually consistent — in your language, whatever it is.

## What makes it different

- **It learns your voice first.** Give it the URL of your newsletter and it downloads your published archive, studies it, and builds a voice profile. Everything it writes afterwards is measured against *you*, not a generic "engaging tone".
- **Your edits are sacred.** Cervantes distinguishes between text it drafted and text you wrote by hand. When polishing, it fixes typos and rhythm in your passages — it never rewrites your opinions, anecdotes, or judgment calls.
- **You write anywhere.** Your issues are plain Markdown files. Edit them in VS Code, Obsidian, Notepad — Cervantes works on the same files when you call it.
- **Consistent covers.** Define your visual style once; every issue gets cover art (or a ready-to-paste image prompt) that looks like part of the same publication.
- **Any language.** The system is written in English, but it detects and writes in *your* language automatically.

## Requirements

- [Claude Code](https://claude.com/claude-code) (CLI or desktop app)
- A folder for your newsletter (can be empty)

## Install

```
/plugin marketplace add <your-github-user>/cervantes
/plugin install cervantes@cervantes
```

Then open your newsletter folder in Claude Code and run:

```
/cervantes:start
```

Cervantes will interview you (and read your published archive if you share the URL), then set up your workspace.

## The workflow

You run **one command, once**: `/cervantes:start`. After that, you just talk — in your own language, in your own words:

> "Write a draft about X — here are my notes and a couple of links."
> "Polish what I wrote."
> "Give me title options and a subject line."
> "Make the cover for this issue."

Cervantes recognizes what you want and runs the right specialist. A typical issue:

```
you: "draft this from my notes"  →  first draft lands in drafts/
        ↓
you edit the draft by hand, in any editor, on your own time
        ↓
you: "polish it"                 →  fixes and tightens WITHOUT touching your voice
you: "titles?"                   →  title options + email subject + preheader
you: "cover"                     →  cover art in your visual style
```

Or start from your own raw text: drop it in `drafts/` and say "polish what I wrote" — when every word is yours, Cervantes protects all of it.

## Your workspace after setup

```
your-newsletter/
├── CLAUDE.md              ← Cervantes' brain for this folder
├── cervantes/
│   ├── profile.md         ← your voice, audience, language, structure
│   ├── cover-style.md     ← your visual identity for covers
│   └── archive/           ← your imported published issues
├── drafts/                ← work in progress
├── covers/                ← generated cover images / prompts
└── published/             ← finished issues
```

Everything is plain text in your folder. Nothing leaves your machine except what you choose to publish.

## FAQ

**Do I have to write inside Claude Code?**
No. Your drafts are Markdown files. Write and edit wherever you like; call Cervantes when you want research, a first draft, a polish pass, or headlines.

**Will it make my newsletter sound like AI?**
That's the whole point of the voice profile and the polish rules: Cervantes adapts to you, not the other way around. Your hand-written passages are never rewritten.

**What if I don't have a newsletter yet?**
Run `/cervantes:start` anyway — the interview covers everything the archive would have taught it.
