---
name: repurpose
description: Turns a finished or published newsletter issue into platform-native social posts — LinkedIn, X/Twitter, Substack Notes, threads — in the author's voice and language, reusing the workspace's hook formulas and anti-slop rules. Triggers when the author asks to repurpose, atomize, or adapt an issue into posts, social, Notes, a thread, or "the LinkedIn version".
---

# Cervantes: Repurpose

One issue is a week of social. Repurposing is **not** pasting the intro into a post box — it's finding the 2–4 self-contained ideas already inside the issue and rebuilding each as a native post for its platform, in the author's voice. Same voice, same anti-slop bar; different shape and length per surface.

## Preconditions

- The issue exists as `issues/NNN-slug/draft.md` or `published/NNN-slug/` (published is better — it's the final text). Ask which issue only if ambiguous.
- Read `voice/profile.md` (voice, shortlist, taboos, **language**, emoji/caps, loanwords), the issue text, `.cervantes/engine/HOOK-FORMULAS.md` (shortlist first — the same tension-first method makes the opening line), and `.cervantes/engine/ANTI-SLOP.md` (it bites hardest on short social copy).
- All output in the profile's **Language**. Match the author's real social habits if the archive/profile show them (emoji use, hashtag use, sign-off).

## The golden rule (unchanged)

Everything comes from the issue and the author's material — **no new facts, numbers, quotes, or claims** invented to make a post punchier. A social post can only say what the issue earned. Inline links point where the issue already pointed. If a post needs a fact the issue doesn't have → drop the angle, don't fabricate.

## Method

**1. Find the atoms.** Pull the 2–4 ideas in the issue that stand on their own — a single insight, a story beat, a contrarian take, a concrete number or result, one useful step. Each atom must make sense to someone who never read the issue. List them to the author in one line each before writing, so they can steer.

**2. Pick platforms.** Default to what the author actually uses (profile/archive); otherwise ask once with a short list (LinkedIn · X/Twitter · Substack Notes · thread). Adapt per surface:
- **Substack Notes / X (single):** one atom, ≤ ~55-char first line that stops the scroll (`HOOK-FORMULAS.md` method), pays off in 2–5 short lines, one soft nudge to the full issue. No hashtag spam.
- **LinkedIn:** hook line → white space → a short story or argument in scannable lines → one takeaway → one CTA (reply or read). Professional register but still the author's voice, not corporate.
- **X/Twitter thread:** first tweet is the hook and must work alone; each subsequent tweet is one beat and earns the next; last tweet lands the point + link. Number only if the author's style does.

**3. Write each post fully** — finished, postable, no `[FILL IN]`. Run every opening and every line through `ANTI-SLOP.md`: the tics that are "fine once" in a long issue are instant tells in a three-line post — zero antithesis scaffolds, zero "What if I told you", zero empty tricolons, no manufactured-community "we". A weak human line beats a slick generic one.

**4. Vary the hooks across posts.** If you're making five posts from one issue, five different formulas/tensions — don't open all of them the same way. Reuse the issue's strongest line at most once.

**4b. Verdict on the set (recommended).** Short copy is where tics are fatal, and you just wrote every
one of these lines. Spawn the `editor` agent (Agent tool, `subagent_type: "editor"`) with the drafted set
and `voice/profile.md`, no brief, asking for the **tic census and voice-fidelity checks only** —
structure and length don't apply here. Fix its Must-fix items before saving. Skip only for a single short
post.

**5. Save.** Write the set to `issues/NNN-slug/social.md` (or `published/NNN-slug/social.md` if that's where the issue lives), grouped by platform, each post in its own block ready to copy-paste, with a one-line note of which atom it draws from. Never touch `draft.md`, the snapshot, or memory files.

**6. Hand off.** Tell the author where the set is, which atoms became which posts, and that they can ask for more variations of any one. Note the strongest post to lead the week with.

## Learn (light)

Repurposing surfaces which ideas *feel* most postable — a useful signal. If the author reacts strongly to an atom ("this is the real point"), note it in `voice/journal.md` as a resonance/carry-forward hint. Don't bump the voice version for this; it's a soft signal, not an edit to their hand.

## Anti-goals

- Never invent facts, numbers, or quotes to make a post land — social honesty is checked exactly like the draft.
- Never let a post over-promise what the issue delivers — the click has to be paid off.
- Never flood with hashtags, emoji, or "engagement bait" the author's real voice doesn't use.
- Don't just excerpt the intro — rebuild each atom as a native post for its surface.
- Never post or schedule anything — this skill writes copy for the author to publish.
