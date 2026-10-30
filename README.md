<p align="center">
  <img src="src/.cervantes/assets/logo.svg" alt="Cervantes" width="120">
</p>

<h1 align="center">Cervantes — source repo</h1>

<p align="center"><strong>The workshop that builds the folder authors get.</strong></p>

Cervantes is a newsletter writing system that runs inside Claude Code: it learns one author's voice from what they've published, then drafts, polishes, illustrates and ships their issues in it. It ships as a **folder** — a subscriber unzips it, opens it in Claude Code, and it onboards them on its own.

**This repo is not that folder. It builds it.** The folder is `src/`.

For what Cervantes actually does for an author, read [`src/README.md`](src/README.md) — that's the one that travels in the ZIP.

## Layout

```
.
├── src/                    ← THE PRODUCT. Zipped verbatim; what a subscriber receives.
│   ├── CLAUDE.md               the product's brain (static, same for every author)
│   ├── README.md               author-facing docs
│   ├── .cervantes/
│   │   ├── engine/             the writing craft — 7 libraries, read on demand
│   │   ├── templates/          the 3 memory skeletons seeded into voice/
│   │   ├── hooks/              session-start check + its Windows launcher
│   │   └── assets/             logo
│   └── .claude/
│       ├── skills/             cervantes · draft · polish · headlines · cover · ship · repurpose
│       ├── agents/             researcher · importer · interviewer · editor
│       └── settings.json       registers the session-start hook
├── dev/                    ← maintainer-only. Never shipped.
│   ├── SCENARIOS.md            the eval suite: scenarios + regression guards
│   ├── build-zip.sh            the packager
│   └── VERSION                 the number the ZIP is named after
├── .github/workflows/      ← CI: repackages on push, refreshes the `latest` release
└── dist/                   ← built ZIPs (untracked)
```

Inside `src/`, every path is written from the **author's** point of view — `.cervantes/engine/ANTI-SLOP.md`, `voice/profile.md` — because that's where those files sit once the folder is unzipped. A `src/` prefix inside `src/` is always a bug.

## Build

```
bash dev/build-zip.sh              # version from dev/VERSION → dist/cervantes-<v>.zip
bash dev/build-zip.sh --test       # also unzips into ~/cervantes-testing/<v>/
bash dev/build-zip.sh 4.1          # override the version for a one-off build
```

The packager stages `src/` as a folder named `cervantes`, then zips it. It aborts if `src/` holds untracked or git-ignored files (the copy is of the working tree, so they would ship); if a newsletter (`voice/`, `issues/`, `published/`, a stray `settings.local.json`) or a `.git`/`.gitignore` ends up in the package; if any skill, agent, engine library, memory template, the author's `README.md`, `CLAUDE.md`, or the hook-registering `.claude/settings.json` is missing; if a hook carries CRLF line endings (a CRLF checkout breaks the scripts under bash on Windows); or if a `src/`-prefixed path leaked into the product.

CI ([`.github/workflows/build.yml`](.github/workflows/build.yml)) runs that same packager on every push, which makes those aborts this repo's only automated check. On `main` it then replaces the single release tagged **`latest`** with the ZIP it just built, so the current download always sits in one place. The Linux build is the reference one: `zip` is present and the hooks keep the `100755` mode they carry in git's index, whereas a local Windows build has to reconstruct those bits by hand. A green run says the package is well formed — not that Cervantes works.

## Test

Evals run against an **unzipped build in `~/cervantes-testing/<v>/`**, never against `src/`. The ZIP is the artifact a subscriber gets; testing the source tree in place would pass on things the package doesn't contain. The copy sits outside this repo because Claude Code loads every `CLAUDE.md` above the folder it opens — inside the workshop, the evals would inherit the workshop's instructions. Set `CERVANTES_TESTING=<dir>` to put it elsewhere; `--test` aborts if a `CLAUDE.md` or `.git` sits above it.

```
bash dev/build-zip.sh 4.0 --test
cd ~/cervantes-testing/4.0/cervantes      # open this in Claude Code and work through dev/SCENARIOS.md
```

A release ships only when every scenario and regression guard in `dev/SCENARIOS.md` passes. Scenario 1 is the one to check first: open a freshly unzipped folder and Cervantes should greet and start onboarding without the author typing anything.

## Distribution

A ZIP the newsletter's subscribers download from an email-gated page. No git, no marketplace, no plugin — **the recipient is assumed not to be a developer**, and that constraint shapes the product:

- **No version file, no version marker in the product.** A newer Cervantes is a new folder; the author's work moves into it. Memory-schema drift is reconciled against `MEMORY-SCHEMA.md` rather than a version number. `dev/VERSION` is the workshop's bookkeeping: it names the ZIP and never enters `src/`, so nothing the author receives states which version it is.
- **The product never hands the author a command** — no `git`, no terminal, no "copy this path over that one" — and never asks them to find a dot-folder their file manager hides. If a file has to move, Cervantes moves it.
- **Nothing is copied at setup.** The engine, workflows and agents are read in place; setup only seeds the author's own `voice/`.

## Working on it

`CLAUDE.md` at this root governs sessions in this repo and spells out the workshop/product boundary. The short version: `src/` is a payload you edit, not a program you run — its skills and its `CLAUDE.md` are addressed to a session running inside an author's folder, not to yours.

---

Craft libraries adapted from [newsletter-ghostwriter](https://github.com/sotoplatero) (MIT, same author). Hook formula library based on "75 fórmulas de ganchos" by Oscar Feito, used as internal reference. Anti-slop catalogue expanded from ["Las 20 notas que querrías haber leído antes"](https://nataliapapiol.substack.com/p/las-20-notas-que-no-querrias-haber) by Natalia Papiol, used as internal reference.
