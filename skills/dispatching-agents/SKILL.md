---
name: dispatching-agents
description: Use when engineering-workflow is active and dispatch triggers hit: multiple unfamiliar files, independent failures, long research, heavy tool output, or parallelizable implementation slices. Defines standing permission, when to use read-only explorers, when to use code-writing workers, and mandatory review.
---

# Dispatching Agents

## Purpose

Protect the main context window and shorten wall-clock time. Dispatch is a tool, not a ceremony: use it when a subagent can do bounded work in parallel while the main agent keeps the critical path moving.

## Standing Policy

When `engineering-workflow` is active, the user has granted standing permission to consider subagents under these rules:

- **Read-only explorer agents:** allowed automatically when dispatch triggers hit.
- **Parallel research agents:** allowed automatically when questions are independent.
- **Code-writing worker agents:** allowed when ownership is clear and write sets are disjoint. Ask first if write scope overlaps, risk is high, or the user's latest instruction implies they want one agent only.

Never dispatch when platform, project, or user instructions forbid it. If the runtime requires explicit permission for subagents despite this policy, ask once and continue inline if unavailable.

## When To Dispatch

Dispatch when any trigger hits and the work can be bounded:

- **Exploration:** reading/searching two or more unfamiliar files or modules to understand scope.
- **Independent failures:** three or more unrelated test/build/lint failures across separate domains.
- **Long research:** external docs, large directories, or multi-file scans where the result should be summarized.
- **Heavy output:** expected output over about 50 lines that you will not quote verbatim.
- **Parallel slices:** independent implementation tasks with disjoint file ownership.
- **Design tradeoffs:** use `design-alternatives` instead; it owns design-space dispatch.

Skip dispatch for known files, single-file edits, output you must inspect verbatim, shared-root-cause debugging, or any task where dispatch overhead exceeds the value.

## Critical Path Rule

Before dispatching, identify the immediate next local task. Do not delegate work that blocks your next action. Dispatch sidecar work that can run while you continue non-overlapping local work.

## Prompt Requirements

Every subagent prompt must be self-contained:

```md
Goal: <one sentence success condition>

Context:
- Files: <absolute paths when known>
- Observed behavior or error: <exact text when available>
- Constraints: <write ownership, no-go areas, test expectations>

Steps:
1. <first probe or implementation step>
2. <verification expected>

Return: <summary under 200 words | punch list | changed paths + verification>
```

For code-writing workers, explicitly say they are not alone in the codebase, must not revert others' edits, and must list changed files.

## Parallel Dispatch

Parallel means one dispatch batch, not sequential single-agent turns. Only parallelize when domains are independent and do not share state.

Examples:

- Good: three unrelated test files failing for unrelated subsystems.
- Bad: three failures after one shared refactor that may have one root cause.

## After Dispatch

- Keep working locally on non-overlapping critical-path work while agents run.
- Wait only when the next local step needs the result.
- Read diffs for any code-writing worker.
- Use `subagent-review` before accepting subagent-produced code or reporting done.
- Run the strongest relevant integrated verification after merging results.
