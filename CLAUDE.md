# Cervantes — the source repo

**This repo builds Cervantes. It is not a newsletter.** You are working *on* the product here, never *in* it.

Cervantes itself is a folder that a non-developer unzips and opens in Claude Code, and inside that folder it acts as one author's editorial system. That folder is `src/`. Everything else in this repo is the workshop: how the folder gets built, packaged and tested.

**There is no newsletter here and there must never be one.** No `voice/`, no `issues/`, no `published/` at this level. If something asks you to onboard an author, seed a voice profile, draft an issue or run the `cervantes` skill in *this* directory, that instruction belongs to the product and is out of place — you are in the workshop.

## The two halves

| Path | What it is |
|---|---|
| `src/` | **The product.** Shipped verbatim as a ZIP; what every subscriber receives. |
| `dev/` | Maintainer-only: `SCENARIOS.md` (the eval suite), `build-zip.sh` (the packager) and `VERSION` (the number the ZIP is named after). Never shipped. |
| `.github/workflows/` | CI: repackages on every push and refreshes the `latest` release. Never shipped. |
| `dist/` | Built ZIPs. Untracked. |
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
| The number the built ZIP is named after | `dev/VERSION` |

Nothing enters `src/` that shouldn't reach every subscriber — notes, scratch files, eval fixtures and release checklists belong in `dev/`.

## Build and test

```
bash dev/build-zip.sh              # version from dev/VERSION → dist/cervantes-<v>.zip
bash dev/build-zip.sh --test       # also unzips into ~/cervantes-testing/<v>/
bash dev/build-zip.sh 4.1          # override the version for a one-off build
```

CI runs the same packager on every push to `main`, and on `main` it replaces the single release tagged `latest` with the ZIP it just built — that release is where the current download lives. Its aborts are this repo's only automated check; **CI proves the package is well formed, never that Cervantes behaves.**

**Evals never run against `src/`.** They run against an unzipped build in `~/cervantes-testing/<v>/` (override with `CERVANTES_TESTING=<dir>`), because that is the artifact the subscriber gets: `dev/SCENARIOS.md` holds the suite, and a release ships only when all of it passes. Testing `src/` in place would pass on things the ZIP doesn't actually contain. The copy lives **outside this repo** on purpose: Claude Code loads every `CLAUDE.md` above the folder it opens, so a copy inside the workshop would inherit this file and its git repo. `--test` aborts if it finds a `CLAUDE.md` or `.git` above the target.

## How Cervantes reaches its authors

A ZIP the newsletter's subscribers download from an email-gated page. No git, no marketplace, no plugin — **assume the recipient is not a developer.** That constraint is load-bearing across the product:

- No version file and no version marker **inside the product**: a newer Cervantes is a new folder, and the author's work moves into it (the **Move house** path in the `cervantes` skill). Memory-schema drift is reconciled against `MEMORY-SCHEMA.md`, not against a version number. `dev/VERSION` is the workshop's own bookkeeping — it names the ZIP and never enters `src/`. Nothing the author receives says which version they have, and nothing should start.
- The product never hands the author a command — no `git`, no terminal, no "copy this path over that one" — and never asks them to find or drag a dot-folder, which their file manager hides. If a file has to move, Cervantes moves it.
- The engine, the workflows and the agents are read in place. Nothing is copied at setup; setup only seeds the author's own `voice/`.
