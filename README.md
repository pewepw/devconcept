# engineering-workflow

Personal Claude Code plugin: operating defaults, TDD, systematic debugging, design alternatives, subagent review, and compounded learnings.

## Install

```
/plugin install pewepw/engineering-workflow
```

## Skills

- **engineering-defaults** — Core operating rules: correctness priority, verification gate, working rules, completion claims. Bootstrapped once per session.
- **using-engineering-defaults** — First-turn bootstrap that invokes `engineering-defaults` so its rules persist through the session.
- **aligning-requirements** — Post an alignment block (Understanding, Scope, Open questions, Proposed approach) and wait for confirmation before editing on non-trivial requests. No-op in plan mode.
- **dispatching-agents** — Dispatch subagents when observable triggers hit (≥2 unread files, ≥3 independent failures, long research, heavy tool output) to protect the main context window.
- **tdd** — Test-driven development via tracer bullets and vertical slices. Default for bug fixes and behavior-heavy changes.
- **systematic-debugging** — Four-phase debug loop (reproduce, compare, hypothesize, fix at source) for intermittent or cross-module bugs.
- **design-alternatives** — Dispatches three parallel subagents with different design constraints to surface tradeoffs for non-trivial interfaces.
- **subagent-review** — Two-stage review (spec compliance → code quality) of subagent-produced code before accepting as done.
- **compound-engineering** — Extracts session learnings and appends them to the project's AGENTS.md / CLAUDE.md.

## Versioning

- `0.3.1` — sharpens `dispatching-agents` (worked example, literal parallel-dispatch snippet, agent-prompt template, ❌/✅ pairs, "files unread in this session" trigger) and `aligning-requirements` (observable triggers, worked example, ❌/✅ pairs); adds skipped-vs-missed distinction to the engineering-defaults Communication rule. Trimmed both skills' description fields.
- `0.3.0` — adds `aligning-requirements` and `dispatching-agents`; slims delegation guidance out of `engineering-defaults` into the dedicated dispatch skill.
- `0.2.0` — initial public baseline.
