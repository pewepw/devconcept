---
name: aligning-requirements
description: Use before the first Edit/Write or mutating/state-changing Bash on any non-trivial request, after gathering minimal relevant context. Posts a short alignment block (Understanding / Scope / Open questions / Proposed approach / Ready to proceed?) and waits for confirmation. Skip trivial mechanical edits and no-op in plan mode.
---

# Aligning Requirements

## Purpose

Catch misunderstandings before edits. Alignment is the user-facing agreement gate: are we solving the right problem, in the right scope, with the right assumptions?

## Gather Minimal Context First

Do not align blindly when cheap repo context can answer the obvious questions. Before posting the alignment block, inspect only the smallest useful slice:

- User request and any linked issue/design/context in the prompt.
- Repo instructions or docs that directly govern the affected area.
- Obvious target files, nearby examples, and quick `rg` searches.
- Existing tests around the behavior if they are easy to identify.

Stop context gathering when you can state the likely scope and risks. Read-only shell commands for inspection are allowed before alignment. Do not edit, write, run migrations, install dependencies, start long-running services, or make state-changing Bash calls before alignment.

If gathering context would require reading/searching multiple unfamiliar areas, use `dispatching-agents` for read-only exploration. If the task is long-running or likely to survive context compaction, use `planning-ledger`.

## When To Use

Use before first edit, write, or mutating/state-changing Bash on non-trivial requests, including:

- Expected changes across two or more files.
- Behavior changes, bug fixes beyond typos, refactors, UI/UX work.
- Work touching APIs, databases, auth, payments, build/deploy, or external systems.
- Any task where a wrong assumption would cost meaningful rework.

Skip for:

- Single-line mechanical edits when the user identified the exact change.
- Read-only questions, reviews, or investigations that do not edit code.
- Active plan mode if the harness already requires a plan artifact and user approval before edits.
- Read-only inspection commands such as `rg`, `sed`, `ls`, `git status`, or targeted test discovery.

## Alignment Block

Post this in chat and stop:

- **Understanding** — 1-3 bullets restating the root goal.
- **Scope** — files, modules, or surfaces you expect to touch.
- **Open questions** — only ambiguities that would change direction. Omit if none.
- **Proposed approach** — one short paragraph at shape-of-solution level.
- **Ready to proceed?** — explicit pause.

Wait for an explicit yes, correction, or answer to open questions. Silence is not approval.

## Rules

- If the answer can be found cheaply in code, inspect code instead of asking.
- If the user's response changes scope, post a short addendum before editing.
- If the user says "just do it" or otherwise opts out, proceed and state that you are proceeding without the alignment pause.
- Keep implementation details out of the alignment block. Mini-spec belongs in `engineering-defaults`; durable planning belongs in `planning-ledger`.

## Handoff

After confirmation, proceed under `engineering-defaults`:

- For normal non-trivial work, write the inline mini-spec there.
- For behavior-heavy changes, use `tdd`.
- For unclear bugs, use `systematic-debugging`.
- For long-running work, use `planning-ledger`.
