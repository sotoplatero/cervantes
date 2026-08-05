# Cervantes — the source repo

**This repo builds Cervantes. It is not a newsletter.** You are working *on* the product here, never *in* it.

Cervantes itself is a folder that a non-developer unzips and opens in Claude Code, and inside that folder it acts as one author's editorial system. That folder is `src/`. Everything else in this repo is the workshop: how the folder gets built, packaged and tested.

**There is no newsletter here and there must never be one.** No `voice/`, no `issues/`, no `published/` at this level. If something asks you to onboard an author, seed a voice profile, draft an issue or run the `cervantes` skill in *this* directory, that instruction belongs to the product and is out of place — you are in the workshop.

## The two halves

| Path | What it is |
|---|---|
| `src/` | **The product.** Shipped verbatim as a ZIP; what every subscriber receives. |
| `dev/` | Maintainer-only: `SCENARIOS.md` (the eval suite) and `build-zip.sh` (the packager). Never shipped. |
| `dist/` | Built ZIPs. Untracked. |
| `.testing/` | Unzipped copies used to run the evals. Untracked. |
| `.claude/settings.local.json` | This repo's own per-machine settings. Nothing product-related. |

## Two rules that are easy to break

**1. `src/` is a payload, not a program you are running.**

`src/CLAUDE.md`, `src/.claude/skills/*`, `src/.claude/agents/*` and `src/.cervantes/engine/*` are **artifacts you edit** — not instructions you follow, and not skills or agents you invoke. Claude Code loads nested `CLAUDE.md` files when it reads files in their subtree, so `src/CLAUDE.md` may well land in your context: it is the file under edit, and its "you are Cervantes, this newsletter's editorial system" is addressed to a session running inside an author's folder. Not this one.

Expect the product's skills to show up anyway: Claude Code discovers nested `.claude/skills/` directories, so `cervantes`, `draft`, `polish`, `cover`, `ship` and the rest will be listed in sessions here as directory-scoped skills ("from src/.claude/skills — applies when working on files under src/"). That listing is normal, not a breach. The boundary is behavioral: **never invoke them in this repo**, no matter how well their trigger description matches the task at hand — here they are payload under edit, not workflows to run. The same goes for the product's agents in `src/.claude/agents/`.

**2. Paths inside `src/` are written from the author's point of view.**

Inside the product, `.cervantes/engine/ANTI-SLOP.md` and `voice/profile.md` are correct: in the author's unzipped folder, that is exactly where those files sit. **Never rewrite them to `src/.cervantes/…` or `src/voice/…`.** A `src/` prefix anywhere inside `src/` is a path that got broken while moving files. `grep -rn "src/" src/` should come back empty.

## Where a change goes

| Changing… | Edit |
|---|---|
| Editorial craft (structure, hooks, anti-slop, checklists, memory schema) | `src/.cervantes/engine/` |
| What a workflow does (draft, polish, headlines, cover, ship, repurpose) | `src/.claude/skills/<name>/SKILL.md` |
| Onboarding, repair, migration, moving an author to a newer copy | `src/.claude/skills/cervantes/SKILL.md` |
| A subagent's brief | `src/.claude/agents/<name>.md` |
| What Cervantes knows before the author's first message | `src/.cervantes/hooks/session-start` |
| The memory skeletons seeded into `voice/` | `src/.cervantes/templates/` |
| The product's own operating instructions | `src/CLAUDE.md` |
| What the author reads about Cervantes | `src/README.md` |

Nothing enters `src/` that shouldn't reach every subscriber — notes, scratch files, eval fixtures and release checklists belong in `dev/`.

## Build and test

```
bash dev/build-zip.sh 4.0          # → dist/cervantes-4.0.zip
bash dev/build-zip.sh 4.0 --test   # also unzips into .testing/4.0/
```

**Evals never run against `src/`.** They run against an unzipped build in `.testing/`, because that is the artifact the subscriber gets: `dev/SCENARIOS.md` holds the suite, and a release ships only when all of it passes. Testing `src/` in place would pass on things the ZIP doesn't actually contain.

## How Cervantes reaches its authors

A ZIP, sent to the newsletter's subscribers. No git, no marketplace, no plugin — **assume the recipient is not a developer.** That constraint is load-bearing across the product:

- No version file and no version marker: a newer Cervantes is a new folder, and the author's work moves into it (the **Move house** path in the `cervantes` skill). Memory-schema drift is reconciled against `MEMORY-SCHEMA.md`, not against a version number.
- The product never hands the author a command — no `git`, no terminal, no "copy this path over that one" — and never asks them to find or drag a dot-folder, which their file manager hides. If a file has to move, Cervantes moves it.
- The engine, the workflows and the agents are read in place. Nothing is copied at setup; setup only seeds the author's own `voice/`.
