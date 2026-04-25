# engineering-workflow

Personal Claude Code plugin: operating defaults, TDD, systematic debugging, design alternatives, subagent review, and compounded learnings.

## Install

```
/plugin install pewepw/engineering-workflow
```

## Skills

- **engineering-defaults** — Core operating rules: correctness priority, verification gate, working rules, completion claims. Bootstrapped once per session.
- **using-engineering-defaults** — First-turn bootstrap that invokes `engineering-defaults` so its rules persist through the session.
- **tdd** — Test-driven development via tracer bullets and vertical slices. Default for bug fixes and behavior-heavy changes.
- **systematic-debugging** — Four-phase debug loop (reproduce, compare, hypothesize, fix at source) for intermittent or cross-module bugs.
- **design-alternatives** — Dispatches three parallel subagents with different design constraints to surface tradeoffs for non-trivial interfaces.
- **subagent-review** — Two-stage review (spec compliance → code quality) of subagent-produced code before accepting as done.
- **compound-engineering** — Extracts session learnings and appends them to the project's AGENTS.md / CLAUDE.md.

## Versioning

- `0.4.0` — reverts skill content to the 0.2.0 set: removes `aligning-requirements` and `dispatching-agents`, rolls back the related `engineering-defaults` and `using-engineering-defaults` changes, and drops the skipped-vs-missed Communication rule. Keeps the dual-tool wiring (`.codex-plugin/`, `.claude-plugin/marketplace.json`) and `MAINTENANCE.md` introduced during 0.3.x.
- `0.3.1` — sharpens `dispatching-agents` (worked example, literal parallel-dispatch snippet, agent-prompt template, ❌/✅ pairs, "files unread in this session" trigger) and `aligning-requirements` (observable triggers, worked example, ❌/✅ pairs); adds skipped-vs-missed distinction to the engineering-defaults Communication rule. Trimmed both skills' description fields. **Reverted in 0.4.0.**
- `0.3.0` — adds `aligning-requirements` and `dispatching-agents`; slims delegation guidance out of `engineering-defaults` into the dedicated dispatch skill. **Reverted in 0.4.0.**
- `0.2.0` — initial public baseline.
