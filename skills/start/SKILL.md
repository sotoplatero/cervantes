---
name: start
description: Installs, verifies, updates, or repairs a Cervantes newsletter workspace in the current folder. Onboards the author (imports their published archive from a URL, extracts a voice fingerprint, defines a fixed cover style) and scaffolds the workspace (CLAUDE.md, engine, memory). Triggers when the user types "cervantes" or "/cervantes", greets Cervantes, asks to set up/start their newsletter workspace, or when any Cervantes skill finds the workspace missing, incomplete, or outdated.
---

# Cervantes: Start — installer & maintainer

Turns this folder into a self-contained newsletter workspace. After a successful install, the folder's `CLAUDE.md` governs and this skill is only needed again to verify, repair, or update.

## Rule 0 — self-check the payload

This plugin must contain, next to its root:

- `VERSION`
- `engine/` — 6 files: WRITING-CRAFT, HOOK-FORMULAS, ANTI-SLOP, TEMPLATES, QUALITY-CHECKLIST, MEMORY-SCHEMA
- `templates/` — workspace-CLAUDE.md, profile.md, journal.md, cover-style.md
- `workspace-payload/skills/` — draft, polish, headlines, cover, ship, repurpose (each a folder with `SKILL.md`)
- `workspace-payload/agents/` — researcher.md, importer.md

If anything is missing, STOP and tell the user to reinstall the plugin — **never improvise engine files, templates, skills, or agents from recall**: an install from an incomplete payload produces a corrupt workspace.

**Why the payload exists.** This plugin ships exactly one skill — this one — plus a theme and a SessionStart health hook. Everything else is *copied into the workspace* so the newsletter folder is genuinely self-contained and nothing Cervantes-specific loads in the author's other projects. `workspace-payload/skills/` and `workspace-payload/agents/` are inert here; they only become live skills and agents once installed under the workspace's `.claude/`.

## Rule 1 — preferences are gathered with the wizard, NOT chat

Every preference choice with a small set of options — audience, reader address, typical length, cadence, emoji/caps, loanwords, polish intensity, cover-style direction — **MUST be asked by calling the `AskUserQuestion` tool**, never typed as questions in message text. This is what makes onboarding feel guided instead of like an interrogation. Rules:

- Batch into `AskUserQuestion` calls of up to 4 questions each; each question offers 2–4 concrete options with the value inferred from the sample listed **first and marked "(Recommended)"**.
- Skip any dimension the sample/archive already answers clearly — don't ask what you already know.
- Only two things happen as plain chat: the initial free-text request for the URL/sample, and the voice-analysis recap. Everything else that has options goes through the wizard.
- If (and only if) the `AskUserQuestion` tool is genuinely unavailable in the session, fall back to ONE compact chat message listing the choices with defaults — never a long multi-question form.

## Rule 2 — greet, then route by state

**Always open with a 2–3 line greeting** — who Cervantes is and what's about to happen — before reading, fetching, or analyzing anything (a directory listing to detect state is fine; reading file contents is not). Detect the author's language from their messages for the conversation; the workspace language comes later, from their newsletter content.

Read the plugin's `VERSION` (source of truth, `engine vX.Y`) and the first line of `./CLAUDE.md` (marker: `<!-- cervantes: engine vX.Y -->`), then route:

| Folder state | Action |
|---|---|
| No marker, no `cervantes/` content | **Install** (full onboarding) |
| No marker, but `cervantes/` files exist (legacy or half-done workspace) | **Adopt**: report the inventory, confirm found content is theirs ("I found an archive here — N posts, titled '…'. Is this your newsletter?"), preserve confirmed memory, then run only the missing Install steps — including the preferences wizard (step 4) whenever the profile is missing or `Voice version: v0.0` |
| Marker = `VERSION` | **Verify** (repair silently, then stand down) |
| Marker < `VERSION` | **Update** |

Never analyze or reuse found content without the author confirming it's theirs and current.

## Install

Print this checklist first (translated to the author's language) and keep it updated as you go — never end a turn without either a question for the author or the final hand-off:

```
Setup progress:
- [ ] 1. Newsletter URL or writing sample
- [ ] 2. Import the published archive
- [ ] 3. Voice fingerprint (shown to you for corrections)
- [ ] 4. Preferences wizard
- [ ] 5. Cover style
- [ ] 6. Scaffold the workspace
- [ ] 7. Recap and first issue
```

**1. The sample.** Ask for the newsletter URL (archive/homepage) — the preferred sample. No newsletter yet → ask for a paste of 3–6 raw paragraphs of their writing or a link to any post. In the same message, ask for an optional **cover reference image** (file path, paste, or URL). Never write in their name from a blank profile.

**2. Import the archive** (if a URL was given) — **delegate it, don't scrape inline.** Fetching a dozen posts in this session would bury the fingerprint work under page markup, so hand it to the importer: the workspace doesn't exist yet, so spawn a `general-purpose` agent (Agent tool) and instruct it to **first `Read ${CLAUDE_PLUGIN_ROOT}/workspace-payload/agents/importer.md` and follow it exactly**, passing the newsletter URL, target dir `cervantes/archive/`, and a limit of 15. Announce before spawning. It discovers posts (RSS → `/archive` → sitemap; if all fail it returns a `Needs` note — then ask the author for 3–5 links), writes clean `YYYY-MM-DD-slug.md` files with frontmatter, and returns a compact report. Relay its count + titles to the author, and take the **language it detected** as the workspace language — confirm it explicitly (it can differ from the chat). If the Agent tool is genuinely unavailable, fall back to doing the import yourself per the importer spec.

**3. Voice fingerprint.** Read the archive/sample and fill the fingerprint dimensions listed in `${CLAUDE_PLUGIN_ROOT}/templates/profile.md` — only from what's observed, each dimension with a short quoted example. Also derive the hook-formula shortlist (per `engine/HOOK-FORMULAS.md` § Narrowing) and any anti-slop exceptions genuinely present in their published text. **Print the full analysis as visible message text** — never inside a question dialog or a file they haven't seen — then ask in plain conversation what to correct. Their corrections beat the analysis.

**4. Preferences wizard.** The moment the fingerprint is settled, **call the `AskUserQuestion` tool now** (per Rule 1 — this is a tool call, never chat questions). One call covering only what the sample didn't already answer — candidates: audience, reader address, typical length, cadence, emoji/caps, loanwords, polish intensity — inferred value first, marked "(Recommended)". A second call only if more than 4 gaps remain. Do NOT ask about drafting workflow — both entry points (Cervantes drafts / author writes raw) are always available per issue.

**5. Cover style.** Build the fixed style block by priority: (a) the reference image from step 1 — describe what it actually shows (palette, treatment, mood, composition, medium) and record it as the style anchor; (b) the newsletter site's look; (c) one wizard question on style direction (illustration / photo / flat minimal / hand-drawn), stressing the choice stays FIXED across issues. Sensible default if they don't care.

**6. Scaffold** (write everything yourself; the author never hand-edits during setup):
1. Copy `${CLAUDE_PLUGIN_ROOT}/engine/*` → `cervantes/engine/` verbatim.
2. **Install the workspace skills and agent** — copy verbatim, never retype:
   - `${CLAUDE_PLUGIN_ROOT}/workspace-payload/skills/*` → `./.claude/skills/` (so `draft/`, `polish/`, `headlines/`, `cover/`, `ship/`, `repurpose/` each land as their own folder with a `SKILL.md`)
   - `${CLAUDE_PLUGIN_ROOT}/workspace-payload/agents/*` → `./.claude/agents/` (`researcher.md` and `importer.md`)

   These are what make the folder work. Preserve any of the author's own skills/agents already in `.claude/` — add, never wipe the directory.
3. Instantiate `cervantes/profile.md`, `cervantes/journal.md`, `cervantes/cover-style.md` from `${CLAUDE_PLUGIN_ROOT}/templates/`, filling placeholders with everything gathered. Set profile `Voice version: v0.1`.
4. Instantiate `./CLAUDE.md` from `templates/workspace-CLAUDE.md`, replacing `{{ENGINE_VERSION}}` with the plugin's `VERSION` string and the language/name placeholders. If a foreign CLAUDE.md exists, show what you'd merge — never silently overwrite.
5. Create `issues/` and `published/`.
6. **Workspace statusline** (branding touch): merge a `statusLine` into the workspace `./.claude/settings.json` (create the file if absent, preserve any existing keys). Keep the command **static and shell-portable** — no `jq`/`node`, just `echo` of a fixed string with the newsletter name baked in, so it works on any OS/shell:
   ```json
   { "statusLine": { "type": "command", "command": "echo \"✎ Cervantes · {NEWSLETTER_NAME}\"", "padding": 1 } }
   ```
   Don't put the voice version in it (it changes; a static echo would go stale). Mention the author can suggest to Cervantes a richer statusline later.
7. **Suggest the theme** once, in the recap: "For the full look, run `/theme` and pick **Cervantes** (gold-on-ink)." Never switch their theme automatically — it's a global preference.
8. **Mention the restart** in the recap, as a nicety and not a blocker — one line: "Restart Claude Code when convenient so the new skills register; everything works either way." Skills and agents in `.claude/` are discovered at startup, so this session won't have them registered yet. That is not a problem: per the workspace CLAUDE.md, an unregistered skill is read straight from `.claude/skills/<name>/SKILL.md` and followed as written. Never make the author restart before their first issue.

**7. Hand over.** Recap in 4–5 lines: what was created, where their voice lives ("edit it whenever"), and how to work from now on — **just talk naturally**, with example phrases in THEIR language ("write a draft about X, here are my notes", "polish what I wrote", "titles?", "make the cover"). This onboarding was the only command they'll ever need. Invite them to start their first issue.

## Verify (marker = VERSION)

The SessionStart hook already computed what's missing and put it in your context — repair exactly that list, without re-checking the filesystem first. If no hook report arrived (bash unavailable on the machine), do the checks yourself. Repair without ceremony:

- `cervantes/engine/` has all 6 files → restore any missing/corrupt one from `${CLAUDE_PLUGIN_ROOT}/engine/`.
- `.claude/skills/` has draft, polish, headlines, cover, ship, repurpose and `.claude/agents/` has researcher.md and importer.md → restore any missing one from `${CLAUDE_PLUGIN_ROOT}/workspace-payload/`. Never delete skills or agents the author added themselves.
- Memory files (`profile.md`, `journal.md`, `cover-style.md`) exist → recreate ONLY a missing file from its template skeleton (empty, v0.0 for profile — tell the author it needs re-seeding). **Never overwrite or blank an existing memory file.**
- `issues/`, `published/`, `cervantes/archive/` exist → create if missing.
- If anything was repaired, report it in one line. If everything is healthy, **stand down**: say nothing about setup and proceed to whatever the author actually came for.

## Update (marker < VERSION)

1. Re-copy `${CLAUDE_PLUGIN_ROOT}/engine/*` → `cervantes/engine/`, overwriting.
2. Re-copy `${CLAUDE_PLUGIN_ROOT}/workspace-payload/skills/*` → `./.claude/skills/` and `${CLAUDE_PLUGIN_ROOT}/workspace-payload/agents/*` → `./.claude/agents/`, overwriting **only Cervantes' own skills (draft, polish, headlines, cover, ship, repurpose) and agents (researcher.md, importer.md)**. Anything else the author put in `.claude/` is theirs — leave it. An update from an older version that predates `ship`/`repurpose`/`importer` simply adds them here.
3. Regenerate `./CLAUDE.md` from the template, stamping the new version — re-fill placeholders from the existing profile.
4. **Never touch memory files, `issues/`, or `published/`.**
5. If the new engine changed a memory file's STRUCTURE (template gained/renamed a section), don't migrate silently: tell the author what's new and offer to add the missing section headers, preserving every existing line.
6. Report in one line ("Updated engine v1.0 → v1.1: …"), then proceed to their actual request. The refreshed skills register on the next restart; until then read them from `.claude/skills/` as files — say nothing about it unless asked.

**Golden rule:** `engine/`, `.claude/skills/`, `.claude/agents/` and `CLAUDE.md` are regenerable; memory and issues are sacred.

## Anti-goals

- Never ask the author to evaluate something they haven't seen — print it first.
- Never invent voice attributes the sample doesn't support.
- Never end a turn mid-onboarding without a question or the hand-off.
- Onboarding is conversation, not a tax form — the wizard handles preferences; chat handles the sample and the recap.
