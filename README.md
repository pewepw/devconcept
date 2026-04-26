# engineering-workflow

Personal Claude Code and Codex plugin: first-action operating defaults, requirements alignment, lightweight planning, agent dispatch, observable TDD, systematic debugging, design alternatives, subagent review, finishing, and compounded learnings.

## Install

```
/plugin install pewepw/engineering-workflow
```

## Skills

- **engineering-defaults** — Core operating rules: correctness priority, first-action bootstrap expectation, verification gate, working rules, completion claims.
- **using-engineering-defaults** — First-turn bootstrap that invokes `engineering-defaults` before repo inspection so its rules persist through the session.
- **aligning-requirements** — Gather minimal context, post Understanding / Scope / Open questions / Proposed approach, and wait before non-trivial edits.
- **planning-ledger** — Lightweight durable markdown planning for long-running, multi-phase, research-heavy, or multi-agent tasks.
- **dispatching-agents** — Standing-policy subagent dispatch for read-only exploration, parallel research, independent failures, and disjoint worker slices.
- **tdd** — Test-driven development via observable red-green tracer bullets and vertical slices. Default for bug fixes and behavior-heavy changes.
- **systematic-debugging** — Four-phase debug loop (reproduce, compare, hypothesize, fix at source) for intermittent or cross-module bugs.
- **design-alternatives** — Dispatches three parallel subagents with different design constraints to surface tradeoffs for non-trivial interfaces.
- **subagent-review** — Two-stage review (spec compliance → code quality) of subagent-produced code before accepting as done.
- **finishing-work** — Final completion gate: verify, summarize, name residual risk, and report review starting points.
- **compound-engineering** — Extracts session learnings and appends them to the project's AGENTS.md / CLAUDE.md.

## Evals

Workflow evals live in [`evals/engineering-workflow-evals.md`](evals/engineering-workflow-evals.md). Use them after skill changes to check whether the plugin triggers the right skills, avoids unnecessary ceremony, and preserves verification discipline.

## Versioning

- `0.5.3` — tightens eval and skill rules for first-action defaults bootstrap, observable RED evidence before behavior-heavy implementation, and pre-coding skipped-skill reporting.
- `0.5.2` — adds a lightweight eval harness for trigger accuracy, ceremony control, dispatch behavior, and completion quality.
- `0.5.1` — fixes workflow review issues: platform-neutral defaults bootstrap, inline fallback for design alternatives, direct design trigger routing, clearer pre-alignment Bash rules, and practical local repair allowance during subagent review.
- `0.5.0` — restores and updates requirements alignment and agent dispatch; adds lightweight planning ledger and finishing-work completion gate; wires the full risk-tiered workflow through `engineering-defaults`; updates TDD triggering and makes compounding less eager.
- `0.4.0` — reverts skill content to the 0.2.0 set: removes `aligning-requirements` and `dispatching-agents`, rolls back the related `engineering-defaults` and `using-engineering-defaults` changes, and drops the skipped-vs-missed Communication rule. Keeps the dual-tool wiring (`.codex-plugin/`, `.claude-plugin/marketplace.json`) and `MAINTENANCE.md` introduced during 0.3.x.
- `0.3.1` — sharpens `dispatching-agents` (worked example, literal parallel-dispatch snippet, agent-prompt template, ❌/✅ pairs, "files unread in this session" trigger) and `aligning-requirements` (observable triggers, worked example, ❌/✅ pairs); adds skipped-vs-missed distinction to the engineering-defaults Communication rule. Trimmed both skills' description fields. **Reverted in 0.4.0.**
- `0.3.0` — adds `aligning-requirements` and `dispatching-agents`; slims delegation guidance out of `engineering-defaults` into the dedicated dispatch skill. **Reverted in 0.4.0.**
- `0.2.0` — initial public baseline.
