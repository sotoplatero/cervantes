<p align="center">
  <img src=".cervantes/assets/logo.svg" alt="Cervantes" width="140">
</p>

<h1 align="center">Cervantes</h1>

<p align="center"><strong>Your newsletter writing system, inside Claude Code.</strong></p>

Cervantes turns any folder into a personal editorial workspace. It learns your voice from what you've already published, drafts complete issues from your ideas and data, polishes your edits without erasing you, keeps your covers visually consistent — and gets better at being you with every issue, in your language, whatever it is.

## What makes it different

- **It learns your voice first — from evidence.** Give it your newsletter URL and it downloads your published archive, extracts a voice fingerprint (rhythm, signature phrases, humor, openings — each with quoted proof), and shows it to you for corrections before writing a word in your name.
- **It knows the craft.** Every workspace ships with a writing engine: hook formulas, open-loop and rhythm techniques, issue skeletons, subject-line archetypes, and a hard **anti-slop** rule set that bans the patterns that make text smell like AI ("It's not X, it's Y", "What if I told you…", inflated adjectives, unearned morals). A quality checklist runs before anything is handed back.
- **It plans before it writes.** For anything longer than a short note, Cervantes writes the brief first — angle, promise, the outline with a word budget per section, and *what material feeds each section* — and you approve it before a single paragraph exists. Correcting an outline costs you one line; correcting 2.000 written words costs the whole draft. Then it writes section by section against that plan, so the middle doesn't sag and the piece comes out the length you asked for. The brief is also why a long issue survives a closed laptop: it resumes exactly where it stopped.
- **A second pair of eyes that didn't write it.** Nothing reaches you until an independent editor pass grades the finished text cold. It *counts* every AI tic across the whole issue (a device that appears once per section is a tic, even when no single section overused it), checks that the hook's promise actually gets paid off, and flags the passages where the prose drifted into competent-but-neutral — the one thing no writer catches in their own work. On a polish pass it never touches your sentences: what it finds in your hand comes to you as a suggestion.
- **Your edits are sacred — and it learns from them.** Cervantes distinguishes its text from yours. Polishing fixes typos in your passages, never your opinions. Then it diffs what you changed, logs the lesson to a journal, and updates your voice profile — so the next draft needs less fixing.
- **It closes the loop after you hit send.** When you publish, Cervantes records the version that actually went out (often not the polished one), archives it as fresh voice ground-truth, and learns from that final diff too. Bring the numbers later — opens, replies, the winning subject — and it promotes what worked into your profile, so the next issue's angle and subject start from what your list has already rewarded.
- **One issue becomes a week of social.** Ask it to repurpose and it atomizes the issue into native posts for LinkedIn, X, or Substack Notes — in your voice, with the same anti-slop bar, nothing invented beyond what the issue earned.
- **Nothing invented, ever.** Your facts, quotes, and anecdotes come only from your material. Outside context is gathered by a separate research agent that only reports what it actually read — verified claims with links it actually opened, plus an explicit list of what it *couldn't* confirm, including anything in your own notes it found contradicted. Where only YOUR detail would land harder, it asks you one short, specific question — drawn from the actual gaps in the outline, never a generic questionnaire — or leaves a deletable `[[enrich:]]` note. It never writes the answer for you, not even as a suggestion.
- **It lives in your folder, not in your way.** The folder *is* the workspace: the engine, the workflows and the agents ship inside it, ready from the first session. Nothing to install, nothing to copy, and nothing Cervantes-specific loads when you open your other projects.
- **You write anywhere.** Issues are plain Markdown in your folder. Edit in VS Code, Obsidian, Notepad — Cervantes works on the same files when you call it.
- **Consistent covers.** One fixed visual style, defined once; every issue's cover looks like the same publication.
- **Any language.** The engine is English; Cervantes detects your newsletter's language and writes everything in it.

## Requirements

- [Claude Code](https://claude.com/claude-code) (CLI or desktop app)
- Nothing else — no install, no plugin, no terminal, no account to create

## Getting started

Cervantes is a folder. You already have it.

**1. Unzip it** wherever you keep your work, and **rename the folder to your newsletter**. One folder per newsletter — to run a second one, unzip a second copy. Two newsletters never share a voice profile.

**2. Open that folder in Claude Code.** That's it — there is no command to type and nothing to configure. Cervantes sees it's a fresh newsletter and starts on its own: it asks for your archive URL, reads what you've published, shows you the voice it found, asks only what it couldn't work out by itself, and sets your memory up.

The first session asks you once to approve the folder's session-start check — say yes. It's the small script that lets Cervantes know, every time you open the folder, whether your newsletter is ready.

## Updating

**A newer Cervantes is a new folder, not a patch.** So you never overwrite anything:

1. Unzip the new Cervantes next to your current one.
2. Open **the new folder** in Claude Code.
3. Say: *"bring my work over from my old folder"* — and tell it where that folder is.

Cervantes moves your `voice/`, `issues/` and `published/` across, checks whether the new engine expects anything new in your profile (and asks before adding it), and gets back to work. **Your old folder is left exactly as it was**, so it's your backup until you're sure.

Nothing of yours is ever rewritten: your voice, your learning log, your archive and your drafts move as they are. And if a copy of Cervantes ever gets damaged, the fix is the same three steps — your work was never the part that broke.

## The workflow — you just talk

> "Write a draft about X — here are my notes and a couple of links."
> "Polish what I wrote."
> "Titles?"
> "Make the cover."
> "I published it — here's what went out."
> "Repurpose it for LinkedIn and Notes."

A typical issue:

```
"draft this from my notes"   →  angles offered → hooks offered → brief with the
                                outline, for you to approve (a line, not a form)
                                → any question only you can answer
                                → written section by section, then checked by
                                an editor that didn't write it
                                → complete draft in issues/012-your-topic/draft.md
        ↓
you edit the draft by hand, in any editor, on your own time
        ↓
"polish it"                  →  cleans WITHOUT touching your voice,
                                learns from your edits, logs the lesson
"titles?"                    →  3 concrete subjects + preheaders, strongest marked
"cover"                      →  cover in your fixed style (or a ready-to-paste prompt)
        ↓
you publish on your platform, then tell Cervantes
        ↓
"I shipped it"               →  records what actually went out, archives it as new
                                voice ground-truth, moves it to published/, learns
                                from the final diff, opens the resonance entry
"repurpose it"               →  native posts for LinkedIn · X · Notes, in your voice
(later) "42% opens, B won"   →  logs resonance, promotes the winning subject
                                archetype — next issue starts from what worked
```

Or start from your own raw text: drop it in and say "polish what I wrote" — when every word is yours, Cervantes protects all of it.

## Your workspace

Three folders are yours. Everything Cervantes runs on is out of the way in one place.

```
your-newsletter/
├── voice/                     ← YOURS. Edit any of it, any time.
│   ├── profile.md             ← your voice fingerprint, your preferences, your language
│   ├── journal.md             ← what it learns from your edits, issue by issue
│   ├── cover-style.md         ← your fixed visual identity
│   └── archive/               ← your published issues (imported at setup, grown by "ship")
├── issues/012-slug/           ← work in progress (NNN = edition number): brief.md (the approved
│                                plan), material, draft.md, .baseline.md snapshot, cover, social.md
├── published/012-slug/        ← shipped issues, moved here by "ship" (edition prefix kept)
│
├── CLAUDE.md                  ← Cervantes' brain. The same for every author.
├── .cervantes/                ← the kit: engine (the writing craft), memory templates,
│                                the session-start check. Never edit it — a newer
│                                Cervantes replaces it wholesale.
└── .claude/
    ├── skills/                ← cervantes (setup) · draft · polish · headlines · cover · ship · repurpose
    ├── agents/                ← researcher (verifies sources) · importer (imports your archive)
    │                            interviewer (finds the questions) · editor (judges the draft)
    ├── settings.json          ← registers the session-start check (the one you approve on day one)
    └── settings.local.json    ← created at setup: your statusline (per-machine)
```

The three at the top are yours and only exist here — those move when you update, and so does `settings.local.json`, which setup created for you. Everything else below the gap came in the ZIP and is identical for every author, so losing it costs you nothing.

The last two start with a dot, which means your computer hides them: on a Mac, Finder won't show them; on Windows, the Explorer won't either. That's on purpose — there is nothing in there for you to open. You never have to find them, and Cervantes never asks you to.

## Make it yours

- **Statusline.** On setup, your workspace shows `✎ Cervantes · <your newsletter>` in the status bar, so you always know which newsletter you're in.
- **Quiet self-check.** Every time you open the folder, Cervantes confirms your memory is intact before you type anything — silently when all is well, and offering to fix or finish it when it isn't. That same check is what starts your onboarding on day one.

## FAQ

**Do I have to write inside Claude Code?**
No. Drafts are Markdown files. Write wherever; call Cervantes for research, a first draft, a polish pass, or headlines.

**Will it sound like AI?**
The anti-slop rules exist precisely for that, and the voice profile is built from your published text with quoted evidence. Your hand-written passages are never rewritten — and every edit you make teaches it your voice a little better.

**What if I don't have a newsletter yet?**
Open the folder anyway. When you say you have nothing published yet, a short interview and 3–6 paragraphs of your writing replace the archive.

---

Craft libraries adapted from [newsletter-ghostwriter](https://github.com/sotoplatero) (MIT, same author). Hook formula library based on "75 fórmulas de ganchos" by Oscar Feito, used as internal reference. Anti-slop catalogue expanded from ["Las 20 notas que querrías haber leído antes"](https://nataliapapiol.substack.com/p/las-20-notas-que-no-querrias-haber) by Natalia Papiol, used as internal reference.
