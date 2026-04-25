---
name: finishing-work
description: Use before final handoff after code changes, refactors, bug fixes, subagent work, or multi-step tasks. Verifies completion claims, summarizes changes, names residual risk, and offers merge/PR next steps only when relevant.
---

# Finishing Work

## Purpose

Make completion honest and easy to review. This is the final gate before saying work is done, fixed, passing, ready, or complete.

## When To Use

Use before final handoff for:

- Code changes, refactors, bug fixes, or generated artifacts.
- Any work involving subagents.
- Any task that used `planning-ledger`.
- Any task where you are about to claim tests, build, lint, or behavior passed.

Skip for pure read-only answers and tiny terminal-command responses.

## Completion Gate

Before final response:

1. Re-read the user request and any alignment/plan artifact.
2. Check the diff or changed files.
3. Run the strongest relevant verification available for the affected surface.
4. If verification is blocked, skipped, partial, or has pre-existing failures, say that directly.
5. Do not claim success beyond the evidence.

Evidence means a command and observed result, or a concrete file/line/manual check from this session.

## Final Summary Shape

Keep the final response human-friendly:

- What changed.
- How it was verified.
- Remaining risk or anything not done.
- Where to review first for non-trivial changes.

If subagents wrote code, mention that their output was reviewed through `subagent-review`.

## Git / PR Options

Only offer merge, commit, push, or PR next steps when the user asked for git workflow or the task naturally ends at integration. Never discard, reset, or force-push without explicit confirmation.

## Red Flags

- "Should pass" or "looks good" without fresh evidence.
- Trusting a subagent summary without reading the diff.
- Running only a narrow test when the affected surface is broader.
- Hiding pre-existing failures as if the current change caused them or fixed them.
