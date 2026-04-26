---
name: systematic-debugging
description: Use when a first fix didn't hold, when symptoms are intermittent or cross-module, when there's no clean repro, or when you're tempted to change multiple things at once. Forces reproduction, root-cause investigation, and one hypothesis at a time before editing.
---

# Systematic Debugging

## Purpose

Prevent patchwork fixes by grounding every change in a reproducible symptom and a tested hypothesis. Most wasted debugging time comes from fixing symptoms, stacking changes, or editing before the bug is actually understood.

## When To Use

- First fix didn't hold.
- Symptom is intermittent, cross-module, or unfamiliar.
- Bug report is vague ("sometimes the payment fails") or you have no clean repro.
- You're tempted to change multiple things at once.

Skip for mechanical failures with an obvious cause (typo, missing import, clear stack trace pointing at one line).

## The Loop

When a dedicated debugger agent is useful and the runtime allows it, use `devconcept-debugger` for failure diagnosis before fixes. If not, run the same loop inline.

### 1. Reproduce

- State the exact symptom in one sentence, with the input that triggers it.
- Reproduce it locally with a specific command, request, or UI action. Write the steps down.
- If you can't reproduce, stop. You don't have a bug yet, you have a report. Narrow the trigger before editing.

### 2. Compare Against Working Code

- Find a known-good path that does the same job: an adjacent module, a sibling feature, the last green commit.
- List every concrete difference between broken and working. Inputs, dependencies, config, order of operations, recent commits.
- The root cause usually lives in one of those differences.

### 3. Hypothesize And Test

- State one hypothesis in one sentence: "X is failing because Y."
- Design the smallest probe that would confirm or refute it: a targeted log, a unit test, a manual input, a bisect.
- Run the probe. Record the result.
- If refuted, do not stack another change on top. Discard that hypothesis and form a new one.

### 4. Fix At The Source

- Write a failing test (or a deterministic repro) before the fix when the bug is behavior-level.
- Make one change. Run the test. Run the surrounding suite.
- If the fix works but you don't understand why, keep investigating — "it passes now" is not a root cause.

## The Three-Strike Rule

If three fix attempts inside this loop fail, or each fix reveals a new failure somewhere else, stop editing. The problem is not in the current change — it's in the architecture, the abstraction, or an assumption you haven't verified. Surface this and reassess before a fourth attempt.

Count resets when you enter the loop: the failed fix that triggered escalation from `devconcept-core` is not strike one. You get three inside the loop.

## Red Flags

- "One more try, I think I've got it" after two misses.
- Changing multiple files to fix one bug without isolating hypotheses.
- Editing before reproducing.
- "It works on my machine" without identifying the environmental difference.
- Deleting or silencing the failing test.
- Rolling up several speculative fixes into one commit so you can't tell which one worked.

## Handoff

Report the root cause, the evidence that confirmed it, and the minimal fix — not the sequence of attempts. If the fix revealed a reusable repo rule or anti-pattern, route it through `compound-engineering`.

## Expected Output

```md
Symptom:
Reproduction:
Known-good comparison:
Hypothesis:
Probe:
Result:
Root cause:
Fix:
Verification:
```
