---
name: cervantes
description: Onboards the author of this newsletter folder and keeps their memory healthy. Imports their published archive from a URL, extracts a voice fingerprint, defines a fixed cover style, and seeds voice/. Also repairs a half-built memory, moves an existing newsletter into a newer copy of Cervantes, and migrates a v3.x workspace (cervantes/ → voice/). Triggers when the session-start hook reports the profile is not seeded, when the user types "cervantes" or "/cervantes", greets Cervantes, asks to set up their newsletter, asks to bring their work over from another folder, or asks how to update Cervantes.
---

# Cervantes: setup & repair

This folder is one newsletter. The engine, the workflows and the agents already ship inside it — **there is nothing to install**. The only thing missing in a fresh copy is the author's own memory, and seeding it is this skill's job. Assume the author is not a developer: they downloaded a ZIP and opened the folder. Never hand them a git command, a terminal command, or a file path to fix by hand — if a file has to move, you move it.

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
| No `voice/`, no `cervantes/` | **Onboard** — the whole thing, below |
| No `voice/`, but `cervantes/` exists (engine v3.x) | **Migrate**, then Onboard only what's still missing |
| `voice/` exists but a file is missing, or profile reads `v0.0`, or its headers don't match `MEMORY-SCHEMA.md` | **Repair** |
| `voice/` complete and seeded | Nothing to do. Say nothing about setup; do what the author actually asked |
| The author says they already have a Cervantes folder with their work (or asks how to update) | **Move house** — last section |

The session-start hook already computed this and put it in your context — use it instead of stat-ing the folder again. If no `<cervantes>` block arrived (no bash on the machine), check by hand.

## Rule 1 — preferences are gathered with the wizard, NOT chat

Every preference choice with a small set of options — audience, reader address, length tier (`short` ~600–900 / `standard` ~1000–1500 / `deep` ~1800–2500+ words), cadence, emoji/caps, loanwords, polish intensity, cover-style direction — **MUST be asked by calling the `AskUserQuestion` tool**, never typed as questions in message text. This is what makes onboarding feel guided instead of like an interrogation. Rules:

- Batch into `AskUserQuestion` calls of up to 4 questions each; each question offers 2–4 concrete options with the value inferred from the sample listed **first and marked "(Recommended)"**.
- Skip any dimension the sample/archive already answers clearly — don't ask what you already know.
- Only two things happen as plain chat: the initial free-text request for the URL/sample, and the voice-analysis recap. Everything else that has options goes through the wizard.
- If (and only if) the `AskUserQuestion` tool is genuinely unavailable in the session, fall back to ONE compact chat message listing the choices with defaults — never a long multi-question form.

## Onboard

**Always open with a 2–3 line greeting** — who Cervantes is and what's about to happen — before reading, fetching, or analyzing anything. Detect the author's language from their messages for the conversation; the newsletter's language comes later, from their content. When the hook triggered this (the author never typed anything), the greeting *is* the first message of the session: don't ask whether they'd like to start, just start.

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

**1. The sample.** Ask for the newsletter URL (archive/homepage) — the preferred sample. No newsletter yet → ask for a paste of 3–6 raw paragraphs of their writing or a link to any post. In the same message, ask for an optional **cover reference image** (file path, paste, or URL). Never write in their name from a blank profile.

**2. Import the archive** (if a URL was given) — **delegate it to the `importer` agent, don't scrape inline.** Fetching a dozen posts in this session would bury the fingerprint work under page markup. Announce before spawning, then pass the newsletter URL, target dir `voice/archive/`, and a limit of 15. It discovers posts (RSS → `/archive` → sitemap; if all fail it returns a `Needs` note — then ask the author for 3–5 links), writes clean `YYYY-MM-DD-slug.md` files with frontmatter, and returns a compact report. Relay its count + titles to the author, and take the **language it detected** as the newsletter language — confirm it explicitly (it can differ from the chat).

**3. Voice fingerprint.** Read the archive/sample and fill the fingerprint dimensions listed in `.cervantes/templates/profile.md` — only from what's observed, each dimension with a short quoted example. Also derive the hook-formula shortlist (per `.cervantes/engine/HOOK-FORMULAS.md` § Narrowing) and any anti-slop exceptions genuinely present in their published text. **Print the full analysis as visible message text** — never inside a question dialog or a file they haven't seen — then ask in plain conversation what to correct. Their corrections beat the analysis.

**4. Preferences wizard.** The moment the fingerprint is settled, **call the `AskUserQuestion` tool now** (per Rule 1 — this is a tool call, never chat questions). One call covering only what the sample didn't already answer — candidates: audience, reader address, length tier (`short` ~600–900 / `standard` ~1000–1500 / `deep` ~1800–2500+ words), cadence, emoji/caps, loanwords, polish intensity — inferred value first, marked "(Recommended)". A second call only if more than 4 gaps remain. Do NOT ask about drafting workflow — both entry points (Cervantes drafts / author writes raw) are always available per issue.

**5. Cover style.** Build the fixed style block by priority: (a) the reference image from step 1 — describe what it actually shows (palette, treatment, mood, composition, medium) and record it as the style anchor; (b) the newsletter site's look; (c) one wizard question on style direction (illustration / photo / flat minimal / hand-drawn), stressing the choice stays FIXED across issues. Sensible default if they don't care.

**6. Seed the memory** (write everything yourself; the author never hand-edits during setup):

1. Instantiate `voice/profile.md`, `voice/journal.md`, `voice/cover-style.md` from `.cervantes/templates/`, filling every placeholder with what you gathered. Record the **newsletter name and the author's language** in the profile — `CLAUDE.md` reads them from there. Set `Voice version: v0.1`.
2. Create `issues/` and `published/` (and `voice/archive/` if the import didn't).
3. **Statusline** (branding touch): merge a `statusLine` into **`.claude/settings.local.json`** (create it if absent, preserve any existing keys). It goes in the `.local` file on purpose: `settings.json` ships with the folder and registers the hook, so the author's branding has to live somewhere a newer copy of Cervantes won't overwrite. Keep the command **static and shell-portable** — no `jq`/`node`, just `echo` of a fixed string with the newsletter name baked in, so it works on any OS/shell:
   ```json
   { "statusLine": { "type": "command", "command": "echo \"✎ Cervantes · {NEWSLETTER_NAME}\"", "padding": 1 } }
   ```
   Don't put the voice version in it (it changes; a static echo would go stale). Mention the author can ask for a richer statusline later.
4. **Touch nothing else.** No engine copy, no skill copy, no `CLAUDE.md` regeneration — those ship with the folder and are already in place. If you find yourself writing outside `voice/`, `issues/`, `published/` and `settings.local.json`, stop.

**7. Hand over.** Recap in 4–5 lines: what was created, where their voice lives ("edit it whenever"), and how to work from now on — **just talk naturally**, with example phrases in THEIR language ("write a draft about X, here are my notes", "polish what I wrote", "titles?", "make the cover"). There is no command to remember and no restart to do: the skills were registered before this session started. Invite them to begin their first issue.

## Repair

Fix exactly what the hook reported, without re-checking the filesystem, and without ceremony:

- A missing memory file → recreate it from its `.cervantes/templates/` skeleton, empty, and tell the author it needs re-seeding (profile: `v0.0`). **Never overwrite or blank an existing memory file.**
- Profile present but its section headers drifted from `.cervantes/engine/MEMORY-SCHEMA.md` (a newer engine added or renamed a section) → don't migrate silently: name what's new and offer to add the missing headers, **preserving every existing line**. This is how a memory schema catches up — no version numbers involved.
- One case needs the author's word: if the profile's **Typical length** field holds no tier (`short` / `standard` / `deep`) — it reads ambiguous, like "medium-ish" or "depends" — ask once with `AskUserQuestion` and write the answer. A wrong tier silently changes the length of every future issue.
- `issues/`, `published/`, `voice/archive/` missing → create them.
- Anything under `.cervantes/` or `.claude/` missing or corrupt → **never improvise engine files, skills, or agents from recall**; an invented engine file produces a corrupt newsletter that looks like it works. Say plainly that this copy of Cervantes is damaged and run **Move house** below: they download a fresh Cervantes, unzip it, and you carry their work across. Their work is not at risk — it's all in `voice/`, `issues/` and `published/`, none of which is damaged.
- If you repaired something, report it in one line. If everything is healthy, **stand down**: say nothing about setup and proceed to whatever the author came for.

## Migrate (engine v3.x → this layout)

A v3.x workspace kept memory in `cervantes/` with a duplicated engine inside it. Convert it in place, then continue with the author's actual request:

1. `voice/` ← move `cervantes/profile.md`, `cervantes/journal.md`, `cervantes/cover-style.md` and `cervantes/archive/` **verbatim**. Their content is sacred; only the path changes.
2. Delete `cervantes/engine/` — it was a copy of what now lives at `.cervantes/engine/`. Then remove `cervantes/` if empty. If it holds anything else the author put there, leave the folder and say what you left.
3. The old root-level `engine/`, `templates/`, `workspace-payload/`, `hooks/` and `VERSION` are leftovers from the old layout; list any that are still on disk and offer to delete them. Deleting them is safe — this kit reads none of them.
4. The old `CLAUDE.md` carried a `<!-- cervantes: engine vX.Y -->` marker plus the author's name and language baked in. This folder already ships the new `CLAUDE.md`, so if the old one is still in place, make sure the name and language are recorded in `voice/profile.md` (where they live now) and then replace it with this folder's version. Never merge the two.
5. `issues/` and `published/` don't move. **Never touch them.**
6. Report it in one line ("Migrated your memory to `voice/`; the engine now lives in `.cervantes/engine/`"), then do what the author asked.

## Move house (how an author updates or recovers)

There is no updater and no repo to pull from: **a newer Cervantes is a new folder.** So updating never means overwriting files inside this one — it means the author's work moves into the new copy, and you do the moving.

Tell them exactly this, in their language, and nothing more technical:

> Download the new Cervantes and unzip it wherever you like. Then open **the new folder** in Claude Code and say "bring my work from the old folder" — I'll ask you where it is and move everything across.

**Which folder is the newer one?** There is no version marker to compare — decide by context, never by file dates. The new copy is the one the author just downloaded and unzipped, and a fresh copy has no `voice/`; the old one holds their work. If both folders hold work, or the author seems to be sitting in the old folder asking to update, confirm in one line ("this folder is the one you just downloaded, right?") before moving anything — and never move in both directions.

From the new folder, given the path to the old one:

1. Move `voice/` (profile, journal, cover-style, **and `archive/`**), `issues/` and `published/` from the old folder into this one, **verbatim**. Those three are the entire newsletter; everything else in the old folder is a Cervantes you're replacing.
2. Also carry over `.claude/settings.local.json` if it exists — it holds their statusline.
3. If the old folder used the v3.x layout (memory in `cervantes/`), run **Migrate** on what you moved.
4. Then run **Repair** once: the new engine may define memory sections the old profile lacks. Offer the missing headers; never rewrite a line they wrote.
5. **Leave the old folder untouched.** It's their backup until they're sure. Say so — never delete it, never suggest deleting it in the same breath as the move.
6. Report what moved in one or two lines (counts: N archived posts, N issues, N published), then get back to work.

Never ask them to find, copy, or drag a folder whose name starts with a dot — `.cervantes/` and `.claude/` are invisible in Finder and in Windows Explorer, so an instruction to copy them is an instruction they cannot follow. Only `voice/`, `issues/` and `published/` are ever named to the author, and even those you move for them.

## Anti-goals

- Never ask the author to evaluate something they haven't seen — print it first.
- Never hand the author a command to run — no `git`, no terminal, no "copy this path over that one". They downloaded a ZIP; they are not a developer. If something has to move, you move it.
- Never invent voice attributes the sample doesn't support.
- Never end a turn mid-onboarding without a question or the hand-off.
- Never write outside `voice/`, `issues/`, `published/` and `.claude/settings.local.json`.
- Onboarding is conversation, not a tax form — the wizard handles preferences; chat handles the sample and the recap.
