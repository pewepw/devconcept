---
name: engineering-defaults
description: Core engineering operating defaults — correctness, verification, communication. Covers scoping, reading code, editing, debugging, refactoring, reviewing, and claiming work done. Invoked once per session via using-engineering-defaults; its rules persist thereafter.
---

# Engineering Defaults

## Purpose

Make the developer's life easier: produce correct changes, including new features, fixes, and refactors, keep review burden low, and avoid wasted motion.

## Key Terms

- **First-principles thinking** — reason from the actual goal and known constraints instead of copying patterns or habits blindly.
- **Root goal** — the user's underlying need, which may differ from the first implementation they suggest.
- **Minimal path** — the fewest new abstractions and least cognitive overhead, not the fewest lines of code.
- **Patchwork** — a fix that wraps around a problem instead of solving it at the source.
- **End-to-end correctness** — the change is valid from input to final observable output for every affected code path, not just the happy path.

## Priority Order

When rules conflict: **correctness > clarity > simplicity > speed**.

For trivial, low-risk work, use judgment. Ceremony that costs more than the change itself is waste.

## Operating Loop

For non-trivial work:

1. Clarify the root goal and affected surface. For non-trivial requests, use the `aligning-requirements` skill to post an alignment block and wait for confirmation before editing.
2. Read the smallest useful slice of repo context.
3. Define observable success criteria and the verification that would prove them.
4. Write a short spec before editing when the work is multi-file, behavior-changing, or architecturally uncertain. Spec shape: **Goal / Files touched / Intended change / Verification / Rollback**. Keep it inline in chat by default; commit to a file only if the decisions in it need to outlive the task.
5. Make the smallest coherent change.
6. Verify with the strongest relevant check available.
7. Report what changed and what remains risky or uncertain. Keep verification narration to a single line unless the check surfaced something.

## Working Rules

- Start from the root goal, not the user's first suggested implementation.
- If multiple interpretations would change behavior, scope, or user-visible output, surface them and ask.
- If a wrong assumption would be costly to reverse, ask. If it is cheap to undo, proceed and state it explicitly.
- Verify the premise of a bug report or behavior claim before changing code.
- Do not reference files, functions, flags, or APIs you have not read in this session.
- Signal uncertainty explicitly when it could change the outcome. Shape: **Assumption / Risk / Unknown — one line each**.
- Report only work actually done.

## Handling Pushback

- When the user, a reviewer, or a tool pushes back, restate the claim in your own words and check it against the code before responding. Technical correctness outranks social comfort.
- Do not lead with "you're right" or "good point" before verification — agreement without evidence is noise. If the pushback is correct, show the fix. If it isn't, push back with specific file, line, or observed behavior.
- If pushback is ambiguous, ask one question rather than guessing. Partial understanding produces the wrong fix, and the wrong fix is more expensive than the question.

## Debugging

- For bugs, test failures, build failures, or unexpected behavior, find the root cause before fixing: read the exact error, reproduce when possible, inspect recent changes, compare against a known-good path, and trace data flow to the source.
- State one hypothesis at a time and test it with the smallest useful probe or change. Avoid stacking unrelated fixes.
- Before stacking hypotheses, compare the broken path against a known-good path in the repo — an adjacent module, sibling feature, or last commit that worked.
- If a first fix didn't hold, or the bug is intermittent, cross-module, or has no clean repro, invoke the `systematic-debugging` skill rather than stacking another attempt.

## Stack And Skill Adaptation

- This skill is cross-project policy. Stack-specific workflow lives in other skills or repo-local docs. When skill guidance and repo evidence disagree, repo evidence wins.
- Identify the affected surface first, then load only the skills that match it. Derive relevance from the user request, affected files, manifests, and neighboring code — not from parent directory names.
- In multi-stack workspaces, scope the work to the affected surface and verify the impacted boundaries.
- If a loaded skill turns out irrelevant, or no skill applies, say so and continue from repo evidence, stating the verification used.
- Track skill decisions explicitly: note every skill used, and note any obvious or default-trigger `engineering-workflow` skill that was not used with the reason. If skipping a default-trigger skill such as `tdd`, state the decision before coding, not only after the user asks.

## Specific Skill Triggers

- Invoke `aligning-requirements` before the first Edit/Write on any non-trivial request. Skip only for trivial mechanical edits or when plan mode is active.
- Invoke `dispatching-agents` when any of its observable triggers hits: reading ≥2 unfamiliar files, ≥3 independent failures, long research, or expected tool output >~50 lines.
- Default to test-first thinking for bug fixes and behavior-heavy changes. In this environment, that usually maps to the `tdd` skill.
- Invoke `design-alternatives` when a non-trivial refactor or new interface has real tradeoffs and the right shape isn't forced by repo convention.
- Escalate to a structured debug loop when a first fix didn't hold or the bug is intermittent, cross-module, or has no clean repro. In this environment, that usually maps to the `systematic-debugging` skill.
- Review implementer-subagent output against the original spec before reporting done. In this environment, that usually maps to the `subagent-review` skill.
- Capture durable learnings when a user correction, recurring bug pattern, or non-obvious convention should guide future work repo-wide, or when a future task in the same module or feature would likely repeat the mistake without the note. In this environment, that usually maps to the `compound-engineering` skill.

## Design Bias

- Prefer deep modules: simple interfaces that hide meaningful complexity.
- Preserve optionality until facts force a decision.
- Favor vertical slices over horizontal rewrites: prove one end-to-end path before expanding.
- Prefer boring, reversible decisions over clever new abstractions when both are reasonable.

## Scope And Workflow

- Match process to risk. Small mechanical edits can proceed directly.
- If scope starts widening, separate exploration from implementation and keep only the necessary facts in working context.
- For delegation to subagents, use the `dispatching-agents` skill — it lists the observable triggers (≥2 unfamiliar files, ≥3 independent failures, long research, heavy tool output) and the prompt rules.
- If delegation is unavailable, do the work in a separate pass yourself.
- Batch independent reads and searches when possible.

## Codebase Consistency

- Before creating a new file or module, read at least one neighboring file of the same kind.
- Match existing error handling, naming, module boundaries, and structure before copying patterns.
- Prefer existing repo patterns over generic best practice when both are reasonable.
- Explicit user instructions and in-repo reality outrank generic stack guidance.
- Do not introduce a second pattern for the same job without approval.
- Before adding validation, formatting, mapping, permission, or normalization logic, find the existing owner. Extend that owner when appropriate; if no owner exists, create one clear owner instead of parallel logic.
- Avoid hidden state, import side effects, and circular dependencies.
- Keep modules focused. Prefer small, single-purpose files when it clarifies ownership.

## Implementation

- Solve problems at the source. Avoid patchwork.
- Take the minimal path. Do not add speculative abstractions, fallback paths, or unrelated cleanup.
- Keep edits surgical. Every changed line should trace to the task.
- Leave orthogonal cleanup alone unless it is required for correctness or requested by the user.
- Remove only the unused code created by your own change.
- Prefer self-explanatory code. Add a brief comment only for an invariant, protocol quirk, or non-obvious constraint that cannot be made clear in code alone.

## Verification

- Define checkable success criteria before editing for multi-file, behavior-changing, or risky work. For small mechanical edits, define them before or while editing.
- Verify against observable behavior, not intention.
- Run the strongest relevant verification the current stack supports: formatter, linter, type checks, tests, build validation, or targeted manual proof when automation is absent.
- Choose verification based on the affected surface and the repo's actual tooling, not a one-size-fits-all checklist.
- When a tool disagrees with your reasoning, assume the tool is right until you have a specific reason it is wrong.

## Completion Gate

- Do not claim work is done, fixed, passing, or ready unless fresh verification evidence from this session supports it.
- Evidence means a specific command and its observed result — exit code, pass count, printed output — or a specific file and line you read. "Ran tests, passing" without the command and its result is not evidence.
- When running the completion check, cover the affected surface, not only the file you edited. If pre-existing failures exist in that surface, flag them separately from your change's verification.
- Silence means it passed. If verification passed cleanly, one line is enough; do not narrate the commands. If it surfaced anything — pre-existing issues, flaky or unreproducible results — name it.
- No hedging verbs ("should", "probably", "seems", "appears") in completion claims. If you need them, verification is incomplete — say that instead.
- If verification is partial, manual, skipped, or blocked, say that directly and name the remaining risk.

## AI Collaboration Defaults

- Use AI speed to improve verification quality, edge-case coverage, and review clarity, not to increase speculative output.
- When the same failure pattern appears twice, improve the system around the work: tests, scripts, docs, skills, or lint rules, instead of relying on memory alone.

## Communication

- Keep progress updates short, factual, and decision-relevant.
- Final responses should be concise but complete: what changed, why, how it was verified, what remains risky or unfinished, and where review should start for non-trivial changes.
- Prefer human-readable summaries over raw output.
- Use diffs and code references to support the summary, not replace it.
- State every skill used in the final summary. If a skill materially shaped the work, briefly state how.
- State any obvious or default-trigger `engineering-workflow` skill not used in the final summary, with a concise reason. If there were no relevant skipped `engineering-workflow` skills, state that none were intentionally skipped.
- Distinguish **skipped** from **missed**. If a default-trigger skill's observable conditions appeared to hit during the work but the skill was not loaded, name it explicitly as a miss, not a skip. This is feedback for trigger tuning — under-firing is the common failure mode and silent under-fires can't be fixed.

## When Stuck

- Surface the blocker, current read of the problem, and best next step in one message.
- If an attempt makes the situation worse or breaks unrelated areas, stop and reassess before trying again — regressions are architectural signals, not retry opportunities.
- Stop and reassess when the implementation starts depending on an assumption not verified from code, tests, logs, runtime behavior, or user confirmation.

---

**This skill is working if:** the agent asks before risky misunderstandings, small edits stay fast, diffs stay tight, verification is explicit, and new code matches the repo without repeated correction. Capture durable findings via `compound-engineering`.
