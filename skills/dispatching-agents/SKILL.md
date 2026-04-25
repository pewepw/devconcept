---
name: dispatching-agents
description: Use when observable dispatch triggers hit — ≥2 unread files, ≥3 independent failures, long research, or expected output >~50 lines not quoted verbatim. Sends work to subagents instead of inline reads.
---

# Dispatching Agents

## Purpose

Protect the main context window. Every inline Read/Grep of files you don't need verbatim is context debt — it crowds out later reasoning. Subagents return summaries, not raw content.

## When To Use

Dispatch a subagent when any of these observable triggers hits:

- **Exploration** — reading/searching ≥2 files you haven't read in this session → dispatch an Explore agent.
- **Independent failures** — ≥3 independent test/build/lint failures across unrelated files → parallel dispatch, one agent per failure.
- **Long research** — fetching external docs, scanning large directories, multi-file reads where you won't quote verbatim → dispatch with a "report in ≤200 words" instruction.
- **Heavy tool output** — expected output >~50 lines that won't be referenced verbatim → dispatch.
- **Design exploration** — non-trivial interface with real tradeoffs → use `design-alternatives` (which dispatches three parallel design agents).

Skip dispatch for: known file paths, single-file edits, output you'll quote verbatim, any task where dispatch overhead exceeds the context savings.

**In plan mode:** dispatch still applies and is actively encouraged. Plan mode's own workflow recommends parallel Explore agents during research.

## Rules

- **Self-contained prompt.** Include file paths, error text, and the explicit deliverable. Vague scopes ("fix the tests") produce vague results.
- **No shared root cause.** Never parallel-dispatch failures that might share a root cause — you'll fix the symptom three times and miss the cause. Sequential investigation is correct here.
- **Isolated context.** Subagents get no session history. Construct exactly what they need in the prompt.
- **Size the return.** Cap report length in the prompt ("under 200 words", "punch list only") so the agent's response doesn't itself become context debt.
- **One domain per agent.** If two tasks share state or sequencing, don't parallelize them.
- **Parallel means one assistant message.** Send all `Agent({...})` tool calls in the **same** message. Three sequential turns is not parallel — it's just slow serial dispatch with extra cache misses.

## Parallel dispatch shape

When the trigger is parallelizable (≥3 independent failures, multiple independent research questions), the tool calls go in a single message:

```
// All three in one assistant message — they execute concurrently
Agent({ description: "Fix abort-test failures",     subagent_type: "general-purpose", prompt: "..." })
Agent({ description: "Fix batch-completion tests",  subagent_type: "general-purpose", prompt: "..." })
Agent({ description: "Fix tool-approval race test", subagent_type: "general-purpose", prompt: "..." })
```

Three back-to-back assistant turns each containing one `Agent(...)` is **not** parallel.

## Agent prompt template

```
Goal: <one sentence — what success looks like>

Context:
- File(s): <absolute paths>
- Error / behavior: <paste exact error text or observed behavior>
- Constraints: <e.g. "do not change production code", "tests only">

Steps:
1. <first probe>
2. <second probe / fix>
3. <verification command>

Return: <punch list | summary under 200 words | diff only>
```

Vague prompts produce vague work. The constraint line and the explicit `Return:` cap do the most work — the rest is just framing.

## Worked example

**Scenario.** After a refactor, six unrelated test failures across three files:
- `agent-tool-abort.test.ts` — 3 timing failures
- `batch-completion.test.ts` — 2 event-shape failures
- `tool-approval-race.test.ts` — 1 execution-count failure

**Decision.** Three independent domains (abort logic, batch shape, race timing). No shared root cause expected because the refactor touched all three areas separately. Parallel dispatch is correct.

**Dispatch (single assistant message).**

```
Agent({ description: "Fix abort-test failures",
        prompt: "Goal: green agent-tool-abort.test.ts (3 failing)...
                 Files: src/agents/agent-tool-abort.test.ts
                 Errors: <pasted>
                 Constraints: tests only, no prod changes
                 Return: under 200 words: root cause + diff summary" })
Agent({ description: "Fix batch-completion tests",  prompt: "..." })
Agent({ description: "Fix tool-approval race test", prompt: "..." })
```

**Integration.** Each returns a ≤200-word summary. Run `subagent-review` on each diff (Stage 1 spec compliance → Stage 2 code quality). Then run the full suite once to confirm no cross-fix conflicts.

**Why not sequential.** Three runs at ~3 minutes each = 9 minutes. Three parallel = ~3 minutes. The savings only materialize if all three calls are in **one message**.

## After dispatch

Before reporting "done" based on subagent work, run `subagent-review` (spec compliance → code quality, separate passes). Subagent summaries describe intent, not actual diff.

## Common mistakes

| ❌ | ✅ |
|---|---|
| Reading 5+ files inline to map a feature | Dispatch one Explore agent: "Map files involved in payment-retry flow. Return ≤150 words: file paths + role." |
| Three Agent calls in three back-to-back turns | Three Agent calls in one assistant message |
| Parallel-dispatching three test fixes that may share a refactor regression | Investigate one sequentially first; parallelize only after confirming domains are independent |
| "Fix the failing tests" (no paths, no errors) | "Fix `src/foo.test.ts:42-58`. Errors: `<pasted>`. Constraints: tests only. Return: diff + 1-line root cause." |
| Accepting a subagent's "done" summary and reporting back to the user | Read the diff, run `subagent-review`, then report |
| Subagent prompt with no `Return:` cap | Prompt ends with explicit return shape and word budget |
