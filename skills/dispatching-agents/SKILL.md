---
name: dispatching-agents
description: "Use when DevConcept is active and dispatch triggers hit: multiple unfamiliar files, independent failures, long research, heavy tool output, or parallelizable implementation slices. Defines standing permission, runtime recipes, context-budget rules, and mandatory review."
---

# Dispatching Agents

## Purpose

Protect the main context window and shorten wall-clock time. Dispatch is a tool, not a ceremony: use it when a subagent can do bounded work in parallel while the main agent keeps the critical path moving.

## Standing Policy

When DevConcept is active, the user has granted standing permission to consider subagents under these rules:

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

## Runtime Dispatch Recipes

### Claude Code

When dispatch triggers hit, prefer named DevConcept agents:
- `devconcept-explorer` for read-only codebase mapping
- `devconcept-plan-reviewer` for requirement or plan review
- `devconcept-worker` for bounded, disjoint implementation slices
- `devconcept-code-reviewer` for independent review of diffs
- `devconcept-debugger` for failure diagnosis before fixes

If DevConcept agents are unavailable, use the closest built-in agent or inline the same prompt contract.

### Codex

Codex does not spawn subagents unless explicitly asked in the conversation. Codex custom agents live in `~/.codex/agents/` as TOML files. When dispatch triggers hit and subagents are allowed, ask for them by name in plain English so Codex routes to the matching DevConcept TOML.

Prefer named-agent phrasing first:

- "Have `devconcept-explorer` map <area> read-only and return Findings, Relevant files, Risks / unknowns, Recommended next step."
- "Have `devconcept-plan-reviewer` review the plan above against the Plan Review Checklist."
- "Have `devconcept-code-reviewer` review the diff for correctness, scope drift, and verification gaps."
- "Have `devconcept-debugger` investigate <symptom> before any fix; reproduce first, then identify root cause."
- "Have `devconcept-worker` implement <bounded slice>; follow the approved plan and the deviation protocol."

When several read-only areas need to run in parallel, use the literal spawn phrasing so Codex starts a batch:

```md
Spawn one `devconcept-explorer` subagent per area, wait for all of them, and return a consolidated summary. Use read-only exploration only.

Areas:
1. <area A>
2. <area B>
3. <area C>

Each subagent must return: Findings, Relevant files, Risks / unknowns, Recommended next step.
```

If the named DevConcept agents are not synced into Codex, ask the user to run `scripts/sync-codex-agents.sh --user`, or fall back to the closest built-in agent and inline the same contract.

If the current Codex session does not allow subagents at all, continue inline using the same contracts and report that dispatch was skipped because subagents were unavailable.

## Context-Budget Dispatch Rules

Dispatch read-only explorers when:
- multiple unfamiliar subsystems must be understood
- implementation and investigation are separable
- likely more than five files need inspection
- independent areas can be mapped without conflicting edits
- the main context would be polluted by broad search results

Dispatch workers only when:
- the plan is approved or clearly bounded
- each worker owns a disjoint slice
- file ownership is clear
- integration can be reviewed by the main agent

Do not dispatch code-writing workers when:
- failures likely share one root cause
- the architecture decision is unresolved
- two workers may edit the same files
- the task is small enough for the main agent to do safely

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

## Expected Output

```md
Dispatch decision: dispatch | do not dispatch
Reason:
Agents / slices:
- agent: purpose, ownership, read/write permission
Local critical-path work:
Integration plan:
```
