---
name: aligning-requirements
description: Use before the first Edit/Write on any non-trivial request. Converts the user's prompt plus gathered context into a short alignment block (Understanding, Scope, Open questions, Proposed approach, Ready to proceed?) and waits for confirmation before editing. No-op while plan mode is active.
---

# Aligning Requirements

## Purpose

Convert the user's prompt plus gathered context into a user-visible alignment artifact before editing. Catches misunderstandings while they're cheap — a 30-second read beats a 20-minute rework.

## When To Use

Before the first Edit/Write/non-trivial Bash on any non-trivial request. A task is non-trivial if any of:

- Multi-file change
- Behavior-changing (features, bug fixes beyond typos)
- UI/UX work
- Touches external systems (APIs, DB, payments, auth)
- You had to read ≥2 files to understand scope

Skip for:

- Typos, single-line renames, obvious one-liners you were pointed at directly.
- **Plan mode is active.** Plan mode is harness-enforced: it already requires writing a plan file (which collects goal, scope, approach, open questions) and getting ExitPlanMode approval before any edit. That is the alignment round-trip. Do not additionally post the alignment block in chat — the plan file is the artifact. This skill is a no-op while plan mode is active; follow plan mode's own workflow unchanged.

## The Alignment Block

Post this in chat and stop:

- **Understanding** — 1-3 bullets restating the root goal in your words.
- **Scope** — files/surfaces you plan to touch.
- **Open questions** — anything ambiguous that would change direction. Omit if none.
- **Proposed approach** — one paragraph, at the shape-of-solution level, not line-by-line.
- **Ready to proceed?** — explicit pause.

Then wait. Do not Edit/Write until the user responds (explicit yes, a correction, or answers to open questions). A thumbs-up emoji counts; silence does not.

## Rules

- Post the block before any Edit/Write, not after.
- One block per request. Don't re-post if you've already aligned and scope hasn't shifted.
- If the user's response adds scope, post a short addendum — do not silently expand.
- If the user says "just do it" or similar skip-signal, proceed and note you're proceeding without alignment.

## Red Flags

- Posting the block *after* starting edits ("I've begun; here's my understanding...")
- Including line-by-line implementation detail — that's for the plan/TDD step, not alignment.
- Skipping because "it seems obvious" — obviousness bias is exactly what this skill catches.

## Handoff

Once aligned, proceed under `engineering-defaults`. If the work is behavior-heavy or multi-step, chain into `tdd` or `design-alternatives` as appropriate.
