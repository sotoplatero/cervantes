---
name: cervantes
description: Onboards the author of this newsletter folder and keeps their memory healthy. Imports their published archive from a URL, extracts a voice fingerprint, defines a fixed cover style, and seeds voice/. Checks that the computer has what the folder needs (bash; on Windows, Git for Windows) and installs whatever is missing. Offers a private GitHub backup when the machine is ready for it. Also repairs or rebuilds a half-built memory and moves an existing newsletter into a newer copy of Cervantes. Triggers when the session-start hook reports the profile is not seeded or half-built, when the user types "cervantes" or "/cervantes", greets Cervantes in a folder that isn't set up yet, asks to set up their newsletter, asks to bring their work over from another folder, or asks how to update Cervantes.
---

# Cervantes: setup & repair

This folder is one newsletter. The engine, the workflows and the agents already ship inside it — **none of them is installed**. The one thing the folder may need from the computer is bash, and the **Requirements** section below checks for it and installs it for the author. The only thing missing in a fresh copy is the author's own memory, and seeding it is this skill's job. Assume the author is not a developer: they downloaded a ZIP and opened the folder. Never hand them a git command, a terminal command, or a file path to fix by hand — if a file has to move, you move it.

| Ships with the folder (read-only) | What this skill creates |
|---|---|
| `.cervantes/engine/` — the craft, read in place | — (never copied) |
| `.cervantes/templates/` — 3 skeletons | `voice/profile.md`, `voice/journal.md`, `voice/cover-style.md` |
| `.claude/skills/`, `.claude/agents/` | — (already live) |
| `CLAUDE.md` | — (static and versioned; never regenerate it) |

**Never edit anything under `.cervantes/` or `.claude/`.** It's identical for every author, and a newer copy of Cervantes would overwrite the edit anyway. Everything author-specific goes in `voice/`.

## Rule 0 — route by one question

Is `voice/profile.md` present with a real `Voice version:`?

| State | Path |
|---|---|
| No `voice/` and no `cervantes/`, or profile at `v0.0` with no work anywhere | **Onboard** — the whole thing, below |
| No `voice/`, but `cervantes/` exists (engine v3.x) | **Migrate**, then Onboard only what's still missing |
| Profile missing or at `v0.0`, but the newsletter has work (journal entries, archive posts, issues or published) — the hook says `STATE: half-built` | **Repair → Re-seed** |
| `voice/` exists but another file is missing, or its headers don't match `MEMORY-SCHEMA.md` | **Repair** |
| `voice/` complete and seeded | Nothing to do. Say nothing about setup; do what the author actually asked |
| The author says they already have a Cervantes folder with their work (or asks how to update) | **Move house** — last section |
| No `<cervantes>` block arrived, or it carries a `REQUIREMENTS:` line | **Requirements** — then route by the rows above |

The session-start hook already computed this and put it in your context — use it instead of stat-ing the folder again. If no `<cervantes>` block arrived (no bash on the machine), check by hand.

## Requirements — check the computer, install what's missing

The folder runs on Claude Code plus one thing from the machine: **bash**, which the session-start check needs (and with it `curl`, which the `importer` uses to read posts word for word). macOS and Linux always have both. Windows has them only once **Git for Windows** is installed, and a non-developer usually hasn't installed it.

**When to run it:** no `<cervantes>` block arrived this session, or the block carries a `REQUIREMENTS:` line. A block without that line means the machine is fine: say nothing and skip this section.

1. **Check, don't guess.** On Windows, look for `C:\Program Files\Git\bin\bash.exe`, `C:\Program Files (x86)\Git\bin\bash.exe`, or `bash` on the PATH. Everywhere, check for `curl`. If everything is there and the hook still didn't run, say so in one line ("the start-up check didn't run this time; I checked by hand") and continue.
2. **Install it without asking.** Something missing is a fact to fix, not a preference to collect: no `AskUserQuestion`, no "shall I?". Say in one plain line, in the author's language, what you're installing and why — never the word "bash" on its own. For example: "Your computer is missing a small free program called Git, which I use to check your newsletter every time you open the folder. I'm installing it now; if Windows shows a permission window, accept it." Then run the installer yourself; the author never types a command. Claude Code may ask permission before the step; tell the author to choose Yes. On Windows: `winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements`. If a missing `curl` is the only gap, the same Git install brings it.
3. **Check again** and confirm in one line only once it is really there.
4. **Ask only when you can't do it yourself.** If `winget` is missing, the install fails, or the permission window was declined, that's the one moment the author has to act: don't troubleshoot in the terminal with them. Give them the download page (`https://git-scm.com/download/win`) and the plain steps (download, open the file, click Next on every screen until Finish), then check again. If they'd rather leave it, carry on: Cervantes works without it, because `CLAUDE.md`'s manual check stands in for the hook. Bring it up at most once per session and never block their work on it.
5. **Once it's installed,** tell them in one line that the change takes effect the next time they open the folder: they should close Claude Code and reopen it when this conversation ends. Never send them away mid-setup; finish onboarding first.

Nothing else is a requirement. Image generation for covers is optional: without a tool, `cover` hands over a ready-to-paste prompt. Never install anything to get it.

## Rule 1 — preferences are gathered with the wizard, NOT chat

Every preference choice with a small set of options — audience, reader address, length tier, cadence, emoji/caps, loanwords, polish intensity, cover-style direction — **MUST be asked by calling the `AskUserQuestion` tool**, never typed as questions in message text. This is what makes onboarding feel guided instead of like an interrogation. Rules:

- Batch into `AskUserQuestion` calls of up to 4 questions each; each question offers 2–4 concrete options with the value inferred from the sample listed **first and marked "(Recommended)"**.
- Skip any dimension the sample/archive already answers clearly — don't ask what you already know.
- Only two things happen as plain chat: the initial free-text request for the URL/sample, and the voice-analysis recap. Everything else that has options goes through the wizard.
- If (and only if) the `AskUserQuestion` tool is genuinely unavailable in the session, fall back to ONE compact chat message listing the choices with defaults — never a long multi-question form.

## Onboard

**Always open with a 2–3 line greeting** — who Cervantes is and what's about to happen — before reading, fetching, or analyzing anything. Detect the author's language from their messages for the conversation; the newsletter's language comes later, from their content. When the hook triggered this (the author never typed anything), the greeting *is* the first message of the session: don't ask whether they'd like to start, just start.

**Already under way?** If this conversation already shows the setup checklist (the session was resumed or compacted mid-setup), continue from the current step — never greet again and never restart.

**One line in that greeting covers the returning author:** an author who downloaded a newer Cervantes lands here too, because a new folder has no `voice/` either. So offer the branch once, plainly — "if you already have a Cervantes folder with your newsletter in it, tell me where it is and I'll bring everything over; otherwise we start from scratch right now" — and then carry on with step 1 without waiting for an answer. If they name a folder, switch to **Move house**.

Print this checklist first (labels translated to the author's language) and reprint it as you go — never end a turn without either a question for the author or the final hand-off:

```
Setup progress:
- [ ] 1. Newsletter URL or writing sample
- [ ] 2. Import the published archive
- [ ] 3. Voice fingerprint (shown to you for corrections)
- [ ] 4. Preferences wizard
- [ ] 5. Cover style
- [ ] 6. Seed the memory
- [ ] 7. Recap and first issue
```

**The format is fixed. Do not improve it as onboarding advances** — the natural pull is to compress it to save space, and a checklist that changes shape every turn stops being readable exactly when the author most needs to see where they are:

- **Reprint all seven lines, every time**, inside the fenced block, each with its full label. Never collapse it to one line, never replace the labels with bare numbers, never drop the lines that are already done.
- **Two states only:** `- [x]` done, `- [ ]` not done. Never introduce other markers — no `✓`, no `→`, no `[→]`, no `[~]`, no strikethrough, no mixing several conventions in one block.
- To show where you are, append ` ←` to the current line and nothing else. That's the only decoration allowed.
- **Translate the labels once**, at the first print, then reuse those exact strings verbatim for the rest of onboarding. Re-translating each turn makes the same step read differently every time it appears.
- Reprint it when you complete a step or ask the author something — not inside every message. Twice in one turn is noise.

If this session calls for **Requirements** (above), run it right after the greeting, before step 1: the archive import needs `curl`. It doesn't get its own line in the checklist.

**1. The sample.** Ask for the newsletter URL (archive/homepage) — the preferred sample. No newsletter yet → ask for a paste of 3–6 raw paragraphs of their writing or a link to any post. In the same message, ask for an optional **cover reference image** (file path, paste, or URL). Never write in their name from a blank profile.

**2. Import the archive** (if a URL was given) — **delegate it to the `importer` agent, don't scrape inline.** Fetching a dozen posts in this session would bury the fingerprint work under page markup. Announce before spawning, then pass the newsletter URL, target dir `voice/archive/`, and a limit of 15. It discovers posts (RSS → `/archive` → sitemap; if all fail it returns a `Needs` note — then ask the author for 3–5 links), writes clean `YYYY-MM-DD-slug.md` files with frontmatter, and returns a compact report. Relay its count + titles to the author, and take the **language it detected** as the newsletter language — confirm it explicitly (it can differ from the chat).

**3. Voice fingerprint.** Read the archive/sample and fill the fingerprint dimensions listed in `.cervantes/templates/profile.md` — only from what's observed, each dimension with a short quoted example. Also derive the hook-formula shortlist (per `.cervantes/engine/HOOK-FORMULAS.md` § Narrowing) and any anti-slop exceptions genuinely present in their published text. **Print the full analysis as visible message text** — never inside a question dialog or a file they haven't seen — then ask in plain conversation what to correct. Their corrections beat the analysis.

**4. Preferences wizard.** The moment the fingerprint is settled, **call the `AskUserQuestion` tool now** (per Rule 1 — this is a tool call, never chat questions). One call covering only what the sample didn't already answer — candidates: audience, reader address, length tier (`short` ~600–900 / `standard` ~1000–1500 / `deep` ~1800–2500+ words), cadence, emoji/caps, loanwords, polish intensity — inferred value first, marked "(Recommended)". A second call only if more than 4 gaps remain. Do NOT ask about drafting workflow — both entry points (Cervantes drafts / author writes raw) are always available per issue.

**5. Cover style.** Build the fixed style block by priority: (a) the reference image from step 1 — describe what it actually shows (palette, treatment, mood, composition, medium) and record it as the style anchor; (b) the newsletter site's look; (c) one wizard question on style direction (illustration / photo / flat minimal / hand-drawn), stressing the choice stays FIXED across issues. Sensible default if they don't care.

**6. Seed the memory** (write everything yourself; the author never hand-edits during setup):

1. Instantiate `voice/profile.md`, `voice/journal.md`, `voice/cover-style.md` from `.cervantes/templates/`, filling every placeholder with what you gathered. Record the **newsletter name and the author's language** in the profile — `CLAUDE.md` reads them from there. Set `Voice version: v0.1`. That line stays exactly `Voice version: vX.Y`, in English, even if you translate the other labels — the session-start check reads it.
   If the newsletter's language is neither Spanish nor English, also fill the profile's `## Anti-slop forms in {language}` once: that language's own equivalents of the patterns in `.cervantes/engine/ANTI-SLOP.md`, so the sweep has something to match in the text it actually checks.
2. Create `issues/` and `published/` (and `voice/archive/` if the import didn't).
3. **Statusline** (branding touch): merge a `statusLine` into **`.claude/settings.local.json`** (create it if absent, preserve any existing keys). It goes in the `.local` file on purpose: `settings.json` ships with the folder and registers the hook, so the author's branding has to live somewhere a newer copy of Cervantes won't overwrite. Keep the command **static and shell-portable** — no `jq`/`node`, just `echo` of a fixed string with the newsletter name baked in, so it works on any OS/shell:
   ```json
   { "statusLine": { "type": "command", "command": "echo \"✎ Cervantes · {NEWSLETTER_NAME}\"", "padding": 1 } }
   ```
   Don't put the voice version in it (it changes; a static echo would go stale). Mention the author can ask for a richer statusline later.
4. **Touch nothing else.** No engine copy, no skill copy, no `CLAUDE.md` regeneration — those ship with the folder and are already in place. If you find yourself writing outside `voice/`, `issues/`, `published/` and `settings.local.json`, stop. (The one exception is **GitHub backup** below, and only if the author says yes.)

Then run **GitHub backup** (below), before the hand-off. Like Requirements, it doesn't get its own line in the checklist.

**7. Hand over.** Recap in 4–5 lines: what was created, where their voice lives ("edit it whenever"), and how to work from now on — **just talk naturally**, with example phrases in THEIR language ("write a draft about X, here are my notes", "polish what I wrote", "titles?", "make the cover"). There is no command to remember and no restart to do: the skills were registered before this session started. The one exception: if **Requirements** installed something this session, repeat in one line that they should close and reopen Claude Code once. If **GitHub backup** created a repository, give its link in one line. Invite them to begin their first issue.

## GitHub backup (optional, offered once at setup)

A private copy of the newsletter on the author's own GitHub account, kept current each time an issue ships — so a lost laptop costs them at most the work since their last published issue. It's an offer, never a requirement: only make it when the computer is already ready for it, and never install or log into anything to get there.

**1. Detect, silently.** All three must hold, or skip this section without a word:

- `gh` (the GitHub CLI) is on the machine and `gh auth status` reports a logged-in account.
- `git` is on the machine (on Windows it arrives with Git for Windows, which **Requirements** already handles).
- The folder isn't already a repository with a remote: no `.git/`, or a `.git/` where `git remote` comes back empty.

Don't mention GitHub to an author whose machine fails any of these. They may not know what it is, and a feature they can't use is noise. If they bring it up later themselves, tell them plainly that it needs the GitHub app for the terminal and a login through the browser, which is outside what Cervantes sets up.

**2. Ask, with the wizard.** One `AskUserQuestion` question, in the author's language, naming the account `gh` is logged into: "Do you want me to keep a private copy of this newsletter on your GitHub (`<login>`)?" Options: **yes, private (Recommended)** — only they can see it; **not now**. There is no public option: paywalled posts and unpublished drafts live in this folder. Creating a repository on their account is an outward action, so it never happens without this answer. "Not now" is final for the session: don't offer again.

**3. Create it yourself.** The author types nothing. Claude Code may ask permission before each step; tell the author to choose Yes. From the folder's root:

1. Write a `.gitignore` with `.DS_Store`, `Thumbs.db` (system junk) and `.claude/settings.local.json` (Claude Code keeps the author's permission rules there).
2. `git init -b main` if there's no `.git/` yet.
3. If `git config user.email` is empty, set it **for this folder only** from their GitHub account: `user.name` = their login, `user.email` = `<id>+<login>@users.noreply.github.com` (both from `gh api user`). Never touch their global git config.
4. `git add -A` and commit with a plain message in the author's language ("Initial setup of <newsletter name>").
5. `gh repo create <slug> --private --source . --remote origin --push`. The slug is the newsletter name in lowercase with hyphens. If the name is taken on their account, add `-newsletter` and try once more; if that fails too, ask them for a name in plain chat.

**4. Confirm** only once the push really went through: `gh repo view --json url` gives the link for the hand-off. If anything fails, say in one line that the copy couldn't be created, keep the local `.git/` (it's harmless), and carry on with the hand-off. Never troubleshoot git with the author.

The whole folder goes up, the kit included, except `settings.local.json`: that makes the repository a full working copy they can download and open anywhere. `ship` commits and pushes after every published issue, so the copy stays current without the author doing anything.

## Repair

Fix exactly what the hook reported, without re-checking the filesystem, and without ceremony:

- A missing journal or cover-style file → recreate it from its `.cervantes/templates/` skeleton. **Never overwrite or blank an existing memory file.**
- **Re-seed** — the profile is missing or at `v0.0` but the newsletter has work (`STATE: half-built`). This author is not new: never greet them as one, and never recreate the profile empty at `v0.0`. Rebuild it from what's already here: skip the import if `voice/archive/` holds posts (run step 2 of Onboard only if it's empty), skip the cover style if `voice/cover-style.md` exists, then run Onboard steps 3, 4 and 6 — print the fingerprint for corrections, run the wizard for what the archive doesn't answer, seed the profile. Never touch the journal, the archive, `issues/` or `published/`. Say in one line what you're rebuilding and why.
- Profile present but its section headers drifted from `.cervantes/engine/MEMORY-SCHEMA.md` (a newer engine added or renamed a section) → don't migrate silently: name what's new and offer to add the missing headers, **preserving every existing line**. This is how a memory schema catches up — no version numbers involved.
- One case needs the author's word: if the profile's **Typical length** field holds no tier (`short` / `standard` / `deep`) — it reads ambiguous, like "medium-ish" or "depends" — ask once with `AskUserQuestion` and write the answer. A wrong tier silently changes the length of every future issue.
- `issues/`, `published/`, `voice/archive/` missing → create them.
- Anything under `.cervantes/` or `.claude/` missing or corrupt → **never improvise engine files, skills, or agents from recall**; an invented engine file produces a corrupt newsletter that looks like it works. Say plainly that this copy of Cervantes is damaged and run **Move house** below: they download a fresh Cervantes, unzip it, and you copy their work across. Their work is not at risk — it's all in `voice/`, `issues/` and `published/`, none of which is damaged.
- If you repaired something, report it in one line. If everything is healthy, **stand down**: say nothing about setup and proceed to whatever the author came for.

## Migrate (engine v3.x → this layout)

A v3.x workspace kept memory in `cervantes/` with a duplicated engine inside it. Convert it in place, then continue with the author's actual request:

1. `voice/` ← move `cervantes/profile.md`, `cervantes/journal.md`, `cervantes/cover-style.md` and `cervantes/archive/` **verbatim**. Their content is sacred; only the path changes.
2. Delete `cervantes/engine/` — it was a copy of what now lives at `.cervantes/engine/`. Then remove `cervantes/` if empty. If it holds anything else the author put there, leave the folder and say what you left.
3. The old root-level `engine/`, `templates/`, `workspace-payload/`, `hooks/` and `VERSION` are leftovers from the old layout; list any that are still on disk and offer to delete them. Deleting them is safe — this kit reads none of them.
4. The old `CLAUDE.md` carried a `<!-- cervantes: engine vX.Y -->` marker plus the author's name and language baked in. This folder already ships the new `CLAUDE.md`, so if the old one is still in place, make sure the name and language are recorded in `voice/profile.md` (where they live now) and then replace it with this folder's version. Never merge the two.
5. `issues/` and `published/` don't move. **Never touch them.**
6. Report it in one line ("Migrated your memory to `voice/`; the engine now lives in `.cervantes/engine/`"), then do what the author asked.

## Move house — copy the work into a newer Cervantes (how an author updates or recovers)

There is no updater and no repo to pull from: **a newer Cervantes is a new folder.** So updating never means overwriting files inside this one — it means the author's work is copied into the new copy, and you do the copying. Copy, never move: the old folder stays a complete working backup.

Tell them exactly this, in their language, and nothing more technical:

> Download the new Cervantes and unzip it wherever you like. Then open **the new folder** in Claude Code and say "bring my work from the old folder" — I'll ask you where it is and copy everything across. Your old folder stays exactly as it is.

**Which folder is the newer one?** There is no version marker to compare — decide by context, never by file dates. The new copy is the one the author just downloaded and unzipped, and a fresh copy has no `voice/`; the old one holds their work. If both folders hold work, or the author seems to be sitting in the old folder asking to update, confirm in one line ("this folder is the one you just downloaded, right?") before copying anything — and never copy in both directions.

From the new folder, given the path to the old one:

1. Copy `voice/` (profile, journal, cover-style, **and `archive/`**), `issues/` and `published/` from the old folder into this one, **verbatim**. Those three are the entire newsletter; everything else in the old folder is a Cervantes you're replacing.
2. Also copy `.claude/settings.local.json` if it exists — it holds their statusline and permission choices. If the old folder has a `.git/` with a GitHub remote (from **GitHub backup**), copy `.git/` and `.gitignore` too, then commit and push once from the new folder ("Copied to a newer Cervantes", in the author's language) so the repository keeps its history and now holds the new kit. If the push fails, say so in one line; the copy itself is done.
3. **Verify before going on:** count the files in `voice/`, `issues/` and `published/` in both folders. If the counts differ, copy what's missing and count again; never report a copy that doesn't match.
4. If the old folder used the v3.x layout (memory in `cervantes/`), run **Migrate** on what you copied.
5. Then run **Repair** once: the new engine may define memory sections the old profile lacks. Offer the missing headers; never rewrite a line they wrote.
6. **Leave the old folder untouched.** It's their backup until they're sure. Say so — never delete it, never suggest deleting it in the same breath as the copy.
7. Report what was copied in one or two lines (counts: N archived posts, N issues, N published), then get back to work.

Never ask them to find, copy, or drag a folder whose name starts with a dot — `.cervantes/` and `.claude/` are invisible in Finder and in Windows Explorer, so an instruction to copy them is an instruction they cannot follow. Only `voice/`, `issues/` and `published/` are ever named to the author, and even those you copy for them.

## Anti-goals

- Never ask the author to evaluate something they haven't seen — print it first.
- Never hand the author a command to run — no `git`, no terminal, no "copy this path over that one". They downloaded a ZIP; they are not a developer. If something has to move, you move it; if something has to be installed, you run the installer.
- Never invent voice attributes the sample doesn't support.
- Never end a turn mid-onboarding without a question or the hand-off.
- Never write outside `voice/`, `issues/`, `published/` and `.claude/settings.local.json` — plus `.git/` and `.gitignore`, only when the author said yes to **GitHub backup**. Installing Git for Windows under **Requirements** and creating the repository the author asked for are the only changes Cervantes makes outside the folder.
- Onboarding is conversation, not a tax form — the wizard handles preferences; chat handles the sample and the recap.
