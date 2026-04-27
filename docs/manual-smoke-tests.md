# DevConcept Manual Smoke Tests

This is a manual dogfood checklist for running DevConcept against real repositories before a release. It is not an executable eval harness, has no fixtures, and produces no numeric score. Run it in a real codebase where the target files and behavior already exist; do not invent prompts that reference missing files.

Record per-run notes in [`smoke-test-results.md`](smoke-test-results.md).

## Bootstrap

- [ ] `using-devconcept` / `devconcept-core` is loaded before the assistant inspects files, analyzes the task, or asks clarifying questions.
- [ ] Mode classification (Lean / Standard / Full) is consistent with the task's actual risk and scope.

## Lean Mode

Run on a real trivial, exact, or read-only edit (typo, mechanical rename, single-line config flip, pure read-only explanation).

- [ ] No alignment block printed.
- [ ] No plan file or planning ledger created.
- [ ] No agents dispatched.
- [ ] Verification is the narrowest useful check, or the assistant explains why no check was run.
- [ ] Final summary stays concise.

## Standard Mode

Run on a real small bug fix or behavior change in code you control.

- [ ] Minimal repo context gathered before edits.
- [ ] Requirements alignment used before edits.
- [ ] Concise mini-plan printed (Goal / Files / Intended change / Verification / Rollback).
- [ ] TDD used when a practical behavior test surface exists; if skipped, the reason is stated before coding.
- [ ] Final handoff includes Changed / Verified / Risk / Review starts at / Skills or agents used / Relevant skipped or missed workflow.

## Vague Feature Request

Run on a real repo with an underspecified feature ask.

- [ ] Focused questions asked instead of invented product behavior.
- [ ] No durable plan created until scope is confirmed.
- [ ] Proposed approach offered only after enough context.

## Full Mode and Dispatch

Run on a real repo with multiple independent modules to map or change.

- [ ] Plan review runs before implementation.
- [ ] Read-only exploration is parallelized only when areas are independent.
- [ ] Claude Code path uses named DevConcept agents (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-worker`, `devconcept-code-reviewer`, `devconcept-debugger`).
- [ ] Codex path uses explicit named-agent phrasing in plain English, or literal spawn phrasing for parallel batches.
- [ ] Worker dispatch is used only for disjoint, bounded slices.
- [ ] Subagent-written code is reviewed before acceptance.

## Shared-Root-Cause Debugging

Run on a real failure where several tests likely share one cause.

- [ ] No premature parallel code-writing workers.
- [ ] Systematic debugging or `devconcept-debugger` runs first.
- [ ] Root cause is identified before broad fixes.

## Final Handoff

- [ ] Final answer includes Changed / Verified / Risk / Review starts at / Skills or agents used / Relevant skipped or missed workflow.
- [ ] Verification evidence is present (command output, file/line proof) or the reason verification is blocked is stated.
- [ ] Skipped default-trigger skills are named, with a reason, when the skip is knowable from the current scope.
- [ ] Meaningful deviations from the approved plan are reported.
