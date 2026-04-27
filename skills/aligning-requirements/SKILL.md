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

Prepare this alignment block:

- **Understanding** — 1-3 bullets restating the root goal.
- **Scope** — files, modules, or surfaces you expect to touch.
- **Open questions** — only ambiguities that would change direction. Omit if none.
- **Proposed approach** — one short paragraph at shape-of-solution level.
- **Ready to proceed?** — explicit pause.

In Codex, if `request_user_input` is exposed in the current mode, use that tool for the `Ready to proceed?` gate instead of relying only on a plain chat question. Do not call it with empty options. Use one question:

```json
{
  "questions": [
    {
      "id": "ready_to_proceed",
      "header": "Proceed",
      "question": "Ready to proceed?",
      "options": [
        {
          "label": "Proceed (Recommended)",
          "description": "Continue with the proposed scope and plan."
        },
        {
          "label": "Revise plan",
          "description": "Pause so the plan can be changed before implementation."
        },
        {
          "label": "Stop",
          "description": "Do not make code changes."
        }
      ]
    }
  ]
}
```

If `request_user_input` is unavailable in the current mode, print the alignment block in chat, end with `Ready to proceed?`, and stop.

Wait for an explicit yes, correction, or answer to open questions. Silence is not approval.

## Hard Stop After Alignment

When an alignment block is printed in chat, the assistant response must end there.

Do not call other tools, update plans, edit files, apply patches, run mutating Bash commands, or continue implementation after the alignment gate in the same turn.

The next action must wait for explicit user confirmation, correction, or opt-out in a later user message or a returned `request_user_input` selection. The original task request, silence, assistant enthusiasm, or an unrelated tool result is not confirmation.

If `request_user_input` returns `Proceed`, that selected option is the confirmation source for the pre-edit gate. If it returns `Revise plan` or `Stop`, do not edit; revise the plan or stop as requested.

Silence is not approval.

## Expected Output

For Standard and Full Mode work before edits:

```md
Understanding:
- ...

Scope:
- ...

Open questions:
- ...

Proposed approach:
- ...

Ready to proceed?
```

Rules:
- Do not print this for Lean Mode exact edits.
- Ask only questions that would change implementation direction.
- If no open questions exist, write `Open questions: None.`

## Rules

- If the answer can be found cheaply in code, inspect code instead of asking.
- If the user's response changes scope, post a short addendum before editing.
- If the user says "just do it" or otherwise opts out, proceed and state that you are proceeding without the alignment pause.
- Keep implementation details out of the alignment block. Mini-spec belongs in `devconcept-core`; durable planning belongs in `planning-ledger`.
- After confirmation or opt-out, satisfy the `devconcept-core` pre-edit gate before editing: mode, alignment confirmation source, and mini-plan.

## Handoff

After confirmation, proceed under `devconcept-core`:

- For normal non-trivial work, write the inline mini-spec there.
- For behavior-heavy changes, use `tdd`.
- For unclear bugs, use `systematic-debugging`.
- For long-running work, use `planning-ledger`.
