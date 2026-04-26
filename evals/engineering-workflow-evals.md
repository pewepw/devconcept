# Engineering Workflow Evals

Use these evals to test whether `engineering-workflow` improves real coding sessions without adding pointless ceremony. They are not runtime instructions. Run them manually, with an evaluator agent, or against saved transcripts after plugin changes.

## Scoring

Score each case from 0-4:

- **4: Correct** — right skills, right amount of ceremony, clear verification.
- **3: Usable** — minor over/under-trigger, no major workflow harm.
- **2: Risky** — missed an important gate or added heavy ceremony that slows work.
- **1: Bad** — wrong workflow choice likely causes rework or confusion.
- **0: Fail** — ignores task, edits unsafely, claims completion without evidence.

Also record:

- **Triggered skills** — actual skills used.
- **Expected skills missed** — should have triggered but did not.
- **Forbidden skills used** — over-triggered or harmful skills.
- **Notes** — one sentence on why the score was assigned.

Passing target: average score >= 3.25 with no 0 or 1.

For any transcript-level score, a 4 requires:

- `using-engineering-defaults`/`engineering-defaults` was loaded before the assistant's first repo inspection, task analysis, or clarifying question.
- Any bug fix or behavior-heavy implementation that claims `tdd` has observable RED evidence before production edits, or explicitly says before coding why a practical behavior test is unavailable.
- Skipped default-trigger skills are named before coding when the skip is knowable from the current scope.

If those are missed but the session is otherwise well-scoped and verified, cap the score at 3.

## Eval 1: Trivial Mechanical Edit

**Prompt**

```text
In the settings screen, rename the button label from "Save" to "Apply".
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Inspect likely file if path is not provided.
- No alignment block unless scope becomes ambiguous.
- No `planning-ledger`.
- No subagents.
- Verify with the narrowest relevant check or explain why not run.

**Expected skills**

- `engineering-defaults`
- `finishing-work` if code is changed

**Forbidden skills**

- `planning-ledger`
- `dispatching-agents`
- `design-alternatives`

## Eval 2: Non-Trivial Bug Fix

**Prompt**

```text
Checkout cancellation is not refunding merchandise that was already paid for in the same order. Fix it.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Gather minimal context first: cancellation flow, refund path, nearby tests.
- Use `aligning-requirements` before editing.
- Ask only questions that code cannot answer cheaply.
- Use `tdd` if there is a practical behavior test surface, with at least one observed RED before production edits.
- Use `finishing-work` before handoff.

**Expected skills**

- `engineering-defaults`
- `aligning-requirements`
- `tdd` unless tests are impractical and that is stated
- `finishing-work`

**Forbidden skills**

- `planning-ledger` unless the flow spans many subsystems
- `design-alternatives`

## Eval 3: Vague Feature Request

**Prompt**

```text
Add team invites.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Inspect repo structure and existing auth/team/user concepts.
- Post an alignment block with scope and open questions before edits.
- Do not invent product details silently.
- Do not create a durable plan unless the user confirms a broad feature.

**Expected skills**

- `engineering-defaults`
- `aligning-requirements`

**Forbidden skills**

- `tdd` before requirements are clear
- `planning-ledger` before scope is known

## Eval 4: Complex Multi-Phase Feature

**Prompt**

```text
Add usage-based billing with Stripe webhooks, an admin usage dashboard, and tests.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Use read-only exploration, possibly via explorer subagents.
- Use `aligning-requirements`.
- Use `planning-ledger` because the work is multi-phase and cross-system.
- Identify vertical slices and verification per slice.
- Use `dispatching-agents` only for independent exploration or disjoint work.
- For behavior slices using `tdd`, show one RED before each production implementation slice unless impractical.

**Expected skills**

- `engineering-defaults`
- `aligning-requirements`
- `planning-ledger`
- `dispatching-agents` if subagent-capable and independent domains exist
- `tdd` for behavior slices
- `finishing-work`

**Forbidden skills**

- Parallel worker agents without disjoint ownership
- `compound-engineering` unless a durable repo rule emerges

## Eval 5: Independent Failures

**Prompt**

```text
These unrelated test files are failing: auth-token-refresh.test.ts, csv-export.test.ts, and billing-retry.test.ts. Fix them.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Confirm the failures are likely independent before parallelizing.
- Use `dispatching-agents` for parallel workers if write ownership is disjoint.
- Use `subagent-review` for any code-writing worker output.
- Run integrated verification after fixes.

**Expected skills**

- `engineering-defaults`
- `dispatching-agents`
- `subagent-review` if workers write code
- `finishing-work`

**Forbidden skills**

- `systematic-debugging` as a single shared-root-cause loop unless evidence shows shared cause
- `planning-ledger` unless the work expands

## Eval 6: Shared-Root-Cause Failures

**Prompt**

```text
After refactoring auth middleware, five auth tests fail across different files. Fix them.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Do not parallelize the fixes initially.
- Reproduce/read exact failures.
- Treat as one likely shared-root-cause debugging task.
- Use `systematic-debugging` if the cause is not obvious.
- Add/adjust tests through public behavior when practical, with observed RED before implementation when using `tdd`.

**Expected skills**

- `engineering-defaults`
- `systematic-debugging` unless a clear one-line root cause exists
- `tdd` if behavior-level regression test is practical
- `finishing-work`

**Forbidden skills**

- Parallel code-writing workers before shared-root-cause is ruled out
- `design-alternatives`

## Eval 7: Interface Design

**Prompt**

```text
Design the API for a plugin installation manager. It needs to support local directory plugins, marketplace plugins, install/update/remove, and future integrity checks.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Gather hard constraints and callers.
- Use `design-alternatives`.
- Use subagents if available; otherwise run three inline design passes.
- Compare tradeoffs and recommend one with accepted downside.
- Do not implement unless the user asks.

**Expected skills**

- `engineering-defaults`
- `design-alternatives`

**Forbidden skills**

- `tdd`
- `finishing-work` unless code or durable docs are changed

## Eval 8: Final Handoff After Code Change

**Prompt**

```text
The implementation is done. Summarize what changed and whether it is ready.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files or diffs.
- Re-read request/plan if available.
- Check diff or changed files.
- Verify with relevant command(s), or state why verification is blocked.
- Use concise human-friendly summary with residual risk.
- Do not claim done without evidence.

**Expected skills**

- `engineering-defaults`
- `finishing-work`

**Forbidden skills**

- `aligning-requirements`
- `planning-ledger` unless already active

## Eval 9: Durable Learning

**Prompt**

```text
We discovered every tenant data mutation must go through backend APIs, never direct Firestore writes from the client. Capture that for future agents.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- Use `compound-engineering`.
- Update the canonical instruction file only if the learning is not already present.
- Keep the entry short, repo-wide, and categorized.

**Expected skills**

- `compound-engineering`

**Forbidden skills**

- `planning-ledger`
- `dispatching-agents`

## Eval 10: Read-Only Code Map

**Prompt**

```text
I do not know the billing module. Map the relevant files, callers, and data flow. Do not change code.
```

**Expected behavior**

- Load `engineering-defaults` before inspecting files.
- No alignment block because it is read-only.
- Use read-only exploration; use explorer subagents if many files are involved.
- Return concise map with file paths and uncertainty.
- Do not run mutating commands.

**Expected skills**

- `engineering-defaults`
- `dispatching-agents` if the map requires multiple unfamiliar files

**Forbidden skills**

- `aligning-requirements`
- `tdd`
- `finishing-work`
