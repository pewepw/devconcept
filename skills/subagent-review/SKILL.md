---
name: subagent-review
description: Use when an implementer subagent has produced code you're about to accept, merge, or report as done. Requires two review passes (spec compliance, then code quality) before treating subagent output as finished work.
---

# Subagent Review

## Purpose

A subagent's summary describes what it intended to do, not what it did. Accepting subagent output unreviewed is the most common way defects and scope drift enter a session.

## When To Use

- After dispatching an Agent call that wrote, edited, or deleted code.
- Before reporting "done" to the user based on subagent work.
- Before merging subagent output into the main change in this session.

Skip for read-only subagents (research, exploration, summaries) and trivial mechanical dispatches where you've already read the full diff.

## Two Stages, Separate Passes

Do not collapse the two stages. Each catches different failures, and running them together lets scope-drift hide behind plausible-looking code.

### Stage 1: Spec Compliance

Question: **Did the subagent do what was asked — no more, no less?**

- Read the diff, not the subagent's summary.
- Map each requirement in the original prompt to a concrete change in the diff.
- Flag anything added that wasn't requested: new files, refactors, helper abstractions, tests for things not asked for, unrelated cleanup.
- Flag anything missing that the subagent skipped, deferred, or silently descoped.

If the diff doesn't match the spec, send it back to a subagent with the specific gap. Do not fix it yourself — silent repair hides the pattern and lets the same drift recur.

### Stage 2: Code Quality

Only run after Stage 1 passes.

Question: **Would this pass review from a careful teammate on this repo?**

- Matches existing naming, error handling, module boundaries.
- No speculative abstractions, no dead code, no commented-out blocks, no TODOs introduced.
- Verification actually ran — exit code, test output — not just "tests look right."
- Edge cases the spec implied but didn't spell out: null, empty, concurrent access, failure paths, permissions.

## Reviewer Identity

- The reviewer is not the implementer. Do the review yourself after the subagent returns, or dispatch a separate reviewer subagent with the diff and the original spec.
- Never let the implementer self-review in the same call — it will rationalize its own choices.
- A reviewer subagent should receive the diff and the original prompt, not the implementer's summary.

## Red Flags

- Accepting based on the subagent's "done" summary without reading the diff.
- Skipping Stage 1 because the code "looks good" — scope drift hides in plausible-looking code.
- Letting the subagent iterate on its own output more than twice without external review.
- Batching multiple subagent outputs and reviewing at the end — review between tasks, not after all of them.

## Handoff

Report what the subagent changed and what the review caught (or didn't). If you accepted scope drift, say so explicitly and why.
