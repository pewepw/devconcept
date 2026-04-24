---
name: dispatching-agents
description: Use when observable dispatch triggers hit — ≥2 unfamiliar files to read, ≥3 independent failures, long research, or expected tool output >~50 lines not quoted verbatim. Protects the main context window by sending work to subagents with self-contained prompts instead of reading/grepping inline.
---

# Dispatching Agents

## Purpose

Protect the main context window. Every inline Read/Grep of files you don't need verbatim is context debt — it crowds out later reasoning. Subagents return summaries, not raw content.

## When To Use

Dispatch a subagent instead of doing the work inline when any of these observable triggers hits:

- **Exploration** — reading/searching ≥2 unfamiliar files to understand scope → dispatch an Explore agent.
- **Independent failures** — ≥3 independent test/build/lint failures across unrelated files → parallel dispatch, one agent per failure.
- **Long research** — fetching external docs, scanning large directories, multi-file reads where you won't quote verbatim → dispatch with a "report in ≤200 words" instruction.
- **Heavy tool output** — expected output >~50 lines that won't be referenced verbatim → dispatch.
- **Design exploration** — non-trivial interface with real tradeoffs → use `design-alternatives` (which dispatches three parallel design agents).

Skip dispatch for: known file paths, single-file edits, output you'll quote verbatim, any task where dispatch overhead exceeds the context savings.

**In plan mode:** dispatch still applies and is actively encouraged. Plan mode's own workflow recommends parallel Explore agents during research. Use them.

## Rules

- **Self-contained prompt.** Include file paths, error text, and the explicit deliverable. Vague scopes ("fix the tests") produce vague results.
- **No shared root cause.** Never parallel-dispatch failures that might share a root cause — you'll fix the symptom three times and miss the cause. Sequential investigation is correct here.
- **Isolated context.** Subagents get no session history. Construct exactly what they need in the prompt.
- **Size the return.** Cap report length in the prompt ("under 200 words", "punch list only") so the agent's response doesn't itself become context debt.
- **One domain per agent.** If two tasks share state or sequencing, don't parallelize them.
- **Parallel means one message.** If dispatching in parallel, send all Agent calls in a single message. Sequential dispatch defeats the point.

## After Dispatch

Before reporting "done" based on subagent work, run `subagent-review` (spec compliance → code quality, separate passes). Subagent summaries describe intent, not actual diff.

## Red Flags

- Reading 5+ files inline when an Explore agent would return a 150-word summary.
- Sequential dispatch of three independent probes.
- Parallel-dispatching fixes for failures that might share a root cause.
- Accepting a subagent's "done" summary without reading the diff.
- Omitting file paths or error text from the prompt because "the agent can figure it out."
