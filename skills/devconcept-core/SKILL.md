---
name: devconcept-core
description: Core DevConcept operating skill for Claude Code and Codex. Routes work through Lean, Standard, or Full mode; aligns requirements when needed; plans risky edits; dispatches agents when useful; verifies and hands off honestly.
---

# DevConcept Core

DevConcept is a lightweight senior-engineering workflow for Claude Code and Codex. It routes each task through the minimum process needed to understand, implement, verify, and hand off the work correctly.

## DevConcept Mode Router

Before acting, classify the task internally as Lean, Standard, or Full. Use the minimum mode that can complete the work correctly.

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
- finish with changed / verified / risk / review-first summary

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
- dispatch agents only for separable work
- review subagent-written code before accepting it
- verify integrated behavior before handoff

## Mode Escalation Rules

Start Lean only when the task is exact and low-risk.

Escalate Lean -> Standard when:
- behavior changes
- tests may need updates
- requirements are underspecified
- more than one implementation path is plausible
- a wrong assumption would cause rework

Escalate Standard -> Full when:
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
- Dispatching agents: use when context-budget rules justify read-only exploration, plan review, review, debugging, or bounded worker slices. In Claude Code prefer the named DevConcept agents directly; in Codex invoke them by name in plain English (for example, "Have `devconcept-explorer` map <area> read-only").
- Subagent review: use before accepting code written by an implementer subagent.
- Finishing work: use before final handoff after code changes, generated artifacts, subagent work, or completion claims.

## Plan Review Rules

Use `devconcept-plan-reviewer`:
- always in Full Mode before implementation
- in Standard Mode when the change affects architecture, security, billing, auth, permissions, data integrity, or public API contracts
- never in Lean Mode

### Plan Review Checklist

Check:
- Does the plan directly satisfy the user request?
- Are assumptions explicit?
- Are product decisions identified instead of invented?
- Are affected files or areas identified?
- Are dependencies ordered correctly?
- Is verification concrete?
- Is scope reduced silently?
- Is any step too broad for one agent/context?

Return:
- `pass` only if implementation can start safely
- `needs revision` if blockers exist

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
Review first:
- ...
Skills / agents used:
- ...
Relevant skipped or missed workflow:
- ...
```
