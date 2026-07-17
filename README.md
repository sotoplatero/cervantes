<p align="center">
  <img src="assets/logo.svg" alt="Cervantes" width="140">
</p>

<h1 align="center">Cervantes</h1>

<p align="center"><strong>Your newsletter writing system, inside Claude Code.</strong></p>

Cervantes turns any folder into a personal editorial workspace. It learns your voice from what you've already published, drafts complete issues from your ideas and data, polishes your edits without erasing you, keeps your covers visually consistent — and gets better at being you with every issue, in your language, whatever it is.

## What makes it different

- **It learns your voice first — from evidence.** Give it your newsletter URL and it downloads your published archive, extracts a voice fingerprint (rhythm, signature phrases, humor, openings — each with quoted proof), and shows it to you for corrections before writing a word in your name.
- **It knows the craft.** Every workspace ships with a writing engine: hook formulas, open-loop and rhythm techniques, issue skeletons, subject-line archetypes, and a hard **anti-slop** rule set that bans the patterns that make text smell like AI ("It's not X, it's Y", "What if I told you…", inflated adjectives, unearned morals). A quality checklist runs before anything is handed back.
- **Your edits are sacred — and it learns from them.** Cervantes distinguishes its text from yours. Polishing fixes typos in your passages, never your opinions. Then it diffs what you changed, logs the lesson to a journal, and updates your voice profile — so the next draft needs less fixing.
- **Nothing invented, ever.** Your facts, quotes, and anecdotes come only from your material. Outside context arrives researched, with real inline links. Where only YOUR detail would land harder, it leaves a deletable `[[enrich:]]` note instead of making something up.
- **You write anywhere.** Issues are plain Markdown in your folder. Edit in VS Code, Obsidian, Notepad — Cervantes works on the same files when you call it.
- **Consistent covers.** One fixed visual style, defined once; every issue's cover looks like the same publication.
- **Any language.** The engine is English; Cervantes detects your newsletter's language and writes everything in it.

## Requirements

- [Claude Code](https://claude.com/claude-code) (CLI or desktop app)
- A folder for your newsletter (can be empty)

## Install

```
/plugin marketplace add <your-github-user>/cervantes
/plugin install cervantes@cervantes
```

Open your newsletter folder in Claude Code and type:

```
cervantes
```

That's it — and it's the only "command" you'll ever need. Cervantes onboards you (reads your archive, shows you what it learned, asks only what it couldn't infer) and sets up your workspace.

## The workflow — you just talk

> "Write a draft about X — here are my notes and a couple of links."
> "Polish what I wrote."
> "Titles?"
> "Make the cover."

A typical issue:

```
"draft this from my notes"   →  angles offered → hooks offered → complete draft
                                in issues/2026-07-17-your-topic/draft.md
        ↓
you edit the draft by hand, in any editor, on your own time
        ↓
"polish it"                  →  cleans WITHOUT touching your voice,
                                learns from your edits, logs the lesson
"titles?"                    →  3 concrete subjects + preheaders, strongest marked
"cover"                      →  cover in your fixed style (or a ready-to-paste prompt)
```

Or start from your own raw text: drop it in and say "polish what I wrote" — when every word is yours, Cervantes protects all of it.

## Your workspace

```
your-newsletter/
├── CLAUDE.md                  ← Cervantes' brain here (versioned)
├── cervantes/
│   ├── engine/                ← the writing craft (hooks, anti-slop, checklists)
│   ├── profile.md             ← your voice fingerprint — YOURS, never auto-overwritten
│   ├── journal.md             ← what it learns from your edits, issue by issue
│   ├── cover-style.md         ← your fixed visual identity
│   └── archive/               ← your imported published issues
├── issues/2026-07-17-slug/    ← one folder per issue: material, draft, snapshot, cover
└── published/
```

Updates refresh the engine and never touch your memory: profile, journal, archive, and issues are sacred.

## Make it yours

- **Theme.** Cervantes ships a gold-on-ink terminal theme. Run `/theme` and pick **Cervantes**.
- **Statusline.** On setup, your workspace shows `✎ Cervantes · <your newsletter>` in the status bar, so you always know which newsletter you're in.
- **Quiet self-check.** Open your newsletter folder and Cervantes silently confirms the workspace is healthy — and offers to repair or finish setup if anything's missing.

## FAQ

**Do I have to write inside Claude Code?**
No. Drafts are Markdown files. Write wherever; call Cervantes for research, a first draft, a polish pass, or headlines.

**Will it sound like AI?**
The anti-slop rules exist precisely for that, and the voice profile is built from your published text with quoted evidence. Your hand-written passages are never rewritten — and every edit you make teaches it your voice a little better.

**What if I don't have a newsletter yet?**
Type `cervantes` anyway — a short interview and a writing sample replace the archive.

---

Craft libraries adapted from [newsletter-ghostwriter](https://github.com/sotoplatero) (MIT, same author). Hook formula library based on "75 fórmulas de ganchos" by Oscar Feito, used as internal reference.
