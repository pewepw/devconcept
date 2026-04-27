---
name: devconcept-core
description: Core DevConcept operating skill for Claude Code and Codex. Routes work through Lean, Standard, or Full mode; aligns requirements when needed; plans risky edits; dispatches agents when useful; verifies and hands off honestly.
---

# DevConcept Core

DevConcept is a lightweight senior-engineering workflow for Claude Code and Codex. It routes each task through the minimum process needed to understand, implement, verify, and hand off the work correctly.

## Philosophy

Not ceremonial by default, but rigorous when the risk justifies it. The minimum mode that keeps the work correct is the right mode. Add alignment, planning, dispatch, plan review, or TDD only when the task earns them; do not retain that ceremony once the risk has been reduced.

## DevConcept Mode Router

Before acting, classify the task internally as Lean, Standard, or Full. Use the minimum mode that can complete the work correctly.

If a DevConcept skill says to stop, stop. A model's or agent's default tendency to continue executing does not override DevConcept's alignment gate.

### Lean Mode

Use for trivial, exact, mechanical, or read-only work.

Examples:
- typo fix
- exact string rename
- obvious one-line config change
- read-only explanation or file lookup

Behavior:
- inspect the target if needed
- act directly if the request is exact
- do not use an alignment block
- do not create a plan file
- do not dispatch agents
- run the narrowest useful check or explain why not
- finish concisely

### Standard Mode

Use for normal non-trivial code changes.

Examples:
- small bug fix
- behavior change
- small feature
- refactor with limited blast radius
- two to four related files

Behavior:
- gather minimal repo context first
- use requirements alignment before edits
- write a concise mini-plan/spec
- use TDD when practical
- implement surgically
- verify affected behavior
- finish with changed / verified / risk / skills-or-agents-used / dispatch-review / skipped-workflow summary

### Full Mode

Use for risky, ambiguous, cross-surface, long-running, or multi-agent work.

Examples:
- auth, billing, permissions, security, data migrations
- new API or architecture boundary
- multi-module refactor
- unfamiliar code areas across subsystems
- work likely to exceed context budget
- work that benefits from parallel read-only exploration

Behavior:
- gather enough context to avoid blind planning
- align requirements
- write a plan or planning ledger
- run plan review before implementation
- make an explicit dispatch decision; dispatch agents only for separable work and only when the runtime/user allows it
- run an agent or inline review pass before final handoff when Full Mode touches high-risk or broad surfaces
- review subagent-written code before accepting it
- verify integrated behavior before handoff

## Mode Escalation Rules

Start Lean only when the task is exact and low-risk.

## Mandatory Full Mode Escalation Triggers

Classify the task as Full Mode when any of these are true:

- the implementation is expected to touch backend and frontend;
- the implementation is expected to touch more than five files;
- the task changes business-critical rules or trust boundaries, such as account entitlements, quotas or limits, permissions, auth, data model, persistence, privacy, compliance, or security behavior;
- the task spans product UI, API/backend behavior, rules/policies, and tests;
- a wrong assumption would likely cause broad rework or user-visible regression.

Only keep the task in Standard Mode when there is clear evidence the change is narrow, mechanical, and low risk.

Escalate Lean -> Standard when:
- behavior changes
- tests may need updates
- requirements are underspecified
- more than one implementation path is plausible
- a wrong assumption would cause rework

Escalate Standard -> Full when:
- any Mandatory Full Mode escalation trigger applies
- more than one subsystem is involved
- likely more than five files are touched
- security, auth, billing, permissions, or data integrity is involved
- implementation depends on unfamiliar architecture
- work needs durable planning across context compaction
- read-only exploration can be parallelized safely

Do not escalate just because a task is interesting.
Do not keep Full Mode ceremony after the risk has been reduced.

## Playbooks Inside Modes

- Requirements alignment: use before non-trivial edits in Standard and Full modes after gathering minimal context.
- TDD: use for bug fixes and behavior-heavy changes when a practical behavior test surface exists.
- Systematic debugging: use before fixes when symptoms are intermittent, cross-module, unclear, or likely share one root cause.
- Design alternatives: use when a new interface, module, or refactor has real tradeoffs not settled by repo convention.
- Dispatching agents: use when context-budget rules justify read-only exploration, plan review, review, debugging, or bounded worker slices. In Claude Code prefer the named DevConcept agents directly. In Codex, subagents require an explicit user ask; when triggers hit, present a spawn-vs-inline choice unless the user already requested subagents.
- Subagent review: use before accepting code written by an implementer subagent.
- Finishing work: use before final handoff after code changes, generated artifacts, subagent work, or completion claims.

## Pre-Edit Gate

Before any `apply_patch`, Edit/Write tool, file rewrite, installer, migration, formatter that rewrites files, or other mutating Bash command, prove the gate state:

```md
Mode:
Alignment confirmed by:
Mini-plan:
```

Rules:
- For Lean Mode exact edits, `Alignment confirmed by:` and `Mini-plan:` may be `Not required - Lean exact edit`.
- For Standard and Full Mode, if alignment has not been printed and explicitly confirmed after the alignment block, stop and use `aligning-requirements`.
- For Standard and Full Mode, if the mini-plan has not been printed, print it before editing.
- For Full Mode, run plan review after the mini-plan and before editing.
- A user's original task message, silence, or continuing tool calls is not alignment confirmation.

## Plan Review Rules

## Full Mode Plan-Review Gate

Before the first edit in Full Mode, run `devconcept-plan-reviewer`.

If the runtime cannot dispatch `devconcept-plan-reviewer`, run the same plan-review checklist inline and print the verdict before editing.

The plan-review verdict must be one of:

- `PASS` - proceed;
- `PASS WITH WARNINGS` - proceed, but call out risks;
- `BLOCKED` - ask the user or revise the plan before implementation.

`update_plan` is not a substitute for plan review.

Use `devconcept-plan-reviewer`:
- always in Full Mode before implementation
- in Standard Mode when the change affects architecture, security, billing, auth, permissions, data integrity, or public API contracts
- never in Lean Mode

If the runtime cannot dispatch `devconcept-plan-reviewer` (Codex without the agent synced, or any session where subagents are unavailable or refused), run the same Plan Review Checklist inline before implementation and post the verdict in the required Full Mode plan-review shape. Do not skip plan review just because dispatch is not available.

### Plan Review Checklist

Check:
- Does the plan directly satisfy the user request?
- Are assumptions explicit?
- Are product decisions identified instead of invented?
- Are all affected surfaces identified?
- Are data model, API, UI, tests, and migration/rules impacts covered when relevant?
- Are dependencies ordered correctly?
- Is verification concrete?
- Is scope reduced silently?
- Is any blocker present before implementation?

Return:
- `PASS` only if implementation can start safely
- `PASS WITH WARNINGS` when implementation can start, but risks or verification gaps must be called out
- `BLOCKED` if blockers exist

## Full Mode Dispatch and Review Gates

Full Mode does not mean "always spawn agents." It means dispatch must be considered and reported.

Before implementation in Full Mode, state:

```md
Dispatch decision:
- dispatch | inline
Reason:
- ...
```

In Codex, do not spawn subagents unless the user explicitly asks for subagents or chooses a spawn option. If dispatch would help but Codex does not yet have explicit permission, ask with a short spawn-vs-inline choice. Continue inline only when agent dispatch is unavailable or the user chooses inline; do not treat silence as permission.

Before final handoff in Full Mode, run a review pass when any trigger is true:

- backend and frontend both changed
- trust boundaries changed, including auth, permissions, billing, quotas, entitlements, persistence, privacy, compliance, or security
- database or Firestore rules, indexes, migrations, or data model behavior changed
- more than 10 files changed

Use `devconcept-code-reviewer` when the runtime/user allows it. Otherwise run the same review checklist inline and report the path:

```md
Review pass:
- agent | inline | skipped + reason
Findings:
- ...
```

## Implementation Deviation Protocol

Auto-fix without asking when:
- the issue is caused by the current change
- the fix is local and preserves the approved design
- missing validation or error handling is required for correctness
- a test/build failure blocks completion and the fix is within scope
- a small type/lint/test adjustment is needed to satisfy the plan

Stop and ask before changing direction when:
- a new architecture is needed
- a new persistence model is needed
- a new external service or dependency is needed
- a public API or data contract would break
- user-visible product behavior must be chosen
- the fix requires broad unrelated cleanup
- the original plan is no longer valid

Report meaningful deviations in the final handoff.

## Expected Output

For non-trivial work:

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

For mini-plans:

```md
Goal:
- ...
Files touched:
- ...
Intended change:
- ...
Verification:
- ...
Rollback:
- ...
```

For final handoff, follow `finishing-work`:

```md
Changed:
- ...
Verified:
- command/result, file/line proof, or blocked + reason
Risk / not done:
- ...
Skills / agents used:
- ...
Dispatch / review:
- ...
Relevant skipped or missed workflow:
- ...
```
