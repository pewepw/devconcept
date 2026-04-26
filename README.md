# DevConcept

DevConcept is a lightweight senior-engineering workflow for Claude Code and Codex. It helps an agent choose the minimum process needed to understand, implement, verify, and hand off code changes correctly.

**Philosophy: not ceremonial by default, but rigorous when the risk justifies it.** Lean Mode stays out of the way; Standard adds alignment and verification; Full adds plan review and dispatch — and only when the work warrants it.

The plugin install slug is `devconcept`. The user-facing workflow name is **DevConcept**, and the default operating skill is **devconcept-core**.

## Install

```sh
/plugin install devconcept@built-by-harry
```

## Modes

DevConcept routes each task internally as Lean, Standard, or Full.

| Mode | Use for | Behavior |
| --- | --- | --- |
| Lean | Trivial, exact, mechanical, or read-only work | Inspect if needed, act directly, no alignment block, no plan file, no agents, narrow verification. |
| Standard | Normal code changes where correctness matters | Gather minimal context, align requirements, write a concise mini-plan, use TDD when practical, implement, verify, summarize. |
| Full | Risky, ambiguous, cross-surface, long-running, or multi-agent work | Plan, review the plan, dispatch only separable work, review subagent output, verify integrated behavior, hand off with residual risk. |

Debugging, design alternatives, TDD, dispatch, and subagent review are playbooks inside these three modes rather than separate top-level modes.

## Skills

- **devconcept-core** - Default DevConcept operating skill: mode router, correctness policy, plan review, deviation protocol, verification, and handoff contracts.
- **using-devconcept** - First-turn bootstrap that invokes `devconcept-core` before repo inspection so its rules persist through the session.
- **aligning-requirements** - Standard/Full Mode alignment block before non-trivial edits.
- **planning-ledger** - Lightweight durable planning for long-running, multi-phase, research-heavy, or context-compaction-prone work.
- **dispatching-agents** - Runtime-aware dispatch rules for Claude Code and Codex.
- **tdd** - Observable red-green-refactor workflow when practical behavior tests exist.
- **systematic-debugging** - Root-cause debugging loop for intermittent, cross-module, unclear, or shared-cause failures.
- **design-alternatives** - Three-option design exploration for interfaces, modules, and refactors with real tradeoffs.
- **subagent-review** - Two-stage review of implementer subagent output: spec compliance, then code quality.
- **finishing-work** - Final completion gate with changed, verified, risk, and review-first handoff.
- **compound-engineering** - Captures durable repo-wide learnings into project instruction files.

## DevConcept Agents

Claude Code can use the native agents in `agents/`:

- `devconcept-explorer` - read-only codebase mapping
- `devconcept-plan-reviewer` - requirement or plan review before risky implementation
- `devconcept-worker` - bounded, disjoint implementation slices
- `devconcept-code-reviewer` - independent diff review
- `devconcept-debugger` - failure diagnosis before fixes

Codex users can sync matching templates from `templates/codex-agents/` into `~/.codex/agents`:

```sh
scripts/sync-codex-agents.sh
```

## Dispatch Differences

Claude Code should prefer named DevConcept agents when dispatch triggers hit. If the agents are unavailable, use the closest built-in agent or inline the same contract.

Codex requires explicit subagent phrasing. When dispatch is appropriate and allowed, name the DevConcept agent rather than the generic word "subagent":

- Have `devconcept-explorer` map `<area>` read-only and return Findings, Relevant files, Risks / unknowns, Recommended next step.
- Have `devconcept-plan-reviewer` review the plan above against the Plan Review Checklist before implementation.
- Have `devconcept-code-reviewer` review the diff for correctness, scope drift, and verification gaps.
- Have `devconcept-debugger` investigate the failing test before any fix; reproduce first, then identify root cause.

For parallel read-only exploration, spawn a batch by name:

```md
Spawn one `devconcept-explorer` subagent per area, wait for all of them, and return a consolidated summary. Use read-only exploration only.

Areas:
1. <area A>
2. <area B>

Each subagent must return: Findings, Relevant files, Risks / unknowns, Recommended next step.
```

If the named DevConcept agents are not synced into Codex, run `scripts/sync-codex-agents.sh` (writes to `~/.codex/agents`) and try again, or fall back to inline read-only exploration with the same return contract.

Do not dispatch workers when failures likely share one root cause, architecture is unresolved, write ownership overlaps, or the main agent can do the work safely.

## Examples

- Exact typo or label rename: Lean Mode, no alignment block, narrow verification.
- Small behavior fix: Standard Mode, minimal context, alignment, mini-plan, TDD when practical, verification evidence.
- Vague feature request: Standard or Full Mode, focused questions before product behavior is invented.
- Cross-module billing/auth/data change: Full Mode, plan review before implementation and dispatch only for separable exploration or disjoint worker slices.
- Multiple auth failures after one refactor: systematic debugging or `devconcept-debugger` first, no premature parallel workers.

## Manual Smoke Tests

Manual workflow checks live in [`docs/manual-smoke-tests.md`](docs/manual-smoke-tests.md) as a checkbox dogfood checklist. Per-run notes go in [`docs/smoke-test-results.md`](docs/smoke-test-results.md). There is no executable eval harness or fixture repo.

## Versioning

- `0.6.5` - Releases the review cleanup: removes plugin-owned `.devconcept/` working state from the package, refreshes PRD and README dispatch wording around named DevConcept agents and `<next-version>`, softens TDD questioning, adds inline plan-review fallback, and tightens read-only Bash safety rules across native agents and Codex templates.
- `0.6.4` - Removes the committed `.devconcept/` working state from the plugin package and gitignores it (planning ledgers belong in user repos, not the plugin); refreshes the README dispatch example to use named DevConcept agents (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`); softens the TDD planning step so the model answers from request and repo context first and only asks the user when the answer would change implementation direction or product behavior; adds a `## Must Not` block to all four read-only agents (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`) forbidding mutating Bash and listing safe inspection commands; adds an inline fallback to the `devconcept-core` Plan Review Rules so the checklist still runs when `devconcept-plan-reviewer` cannot be dispatched; updates `docs/prd-devconcept-v0.6.md` to use `<next-version>` and the v0.6.x line instead of the original `0.6.0` checklist targets.
- `0.6.3` - States the DevConcept philosophy ("not ceremonial by default, but rigorous when the risk justifies it") in the README intro and as a `## Philosophy` section in [`skills/devconcept-core/SKILL.md`](skills/devconcept-core/SKILL.md) above the Mode Router so the model anchors on it before classifying. Adds a Cache Pruning Footgun section to [`MAINTENANCE.md`](MAINTENANCE.md) explaining the safe order for refreshing versioned caches without losing visibility in Claude Code or Codex.
- `0.6.2` - Tightens Codex dispatch with explicit named-agent invocation examples (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`, `devconcept-worker`); simplifies the `.codex-plugin` `defaultPrompt` so Lean / Standard / Full routing dominates and other behaviors are conditional; drops the project-level Codex sync target so `scripts/sync-codex-agents.sh` only writes to `~/.codex/agents`; reframes manual workflow scenarios as [`docs/manual-smoke-tests.md`](docs/manual-smoke-tests.md) (checkbox checklist, no scoring or invented prompts) and removes the old `evals/` folder; adds [`docs/smoke-test-results.md`](docs/smoke-test-results.md) for per-run notes; reframes the version-bump checklist around `<next-version>`; aligns PRD title and release notes on the v0.6.x line.
- `0.6.0` - Renames the plugin and user-facing workflow to DevConcept; adds `devconcept-core` and `using-devconcept`; adds Lean / Standard / Full routing; adds native DevConcept agents and Codex templates; adds runtime dispatch recipes, plan review, worker deviation protocol, output contracts, maintenance docs, and manual smoke-test guidance.
- `0.5.3` - Tightens eval and skill rules for first-action defaults bootstrap, observable RED evidence before behavior-heavy implementation, and pre-coding skipped-skill reporting.
- `0.5.2` - Adds a lightweight eval harness for trigger accuracy, ceremony control, dispatch behavior, and completion quality.
- `0.5.1` - Fixes workflow review issues: platform-neutral defaults bootstrap, inline fallback for design alternatives, direct design trigger routing, clearer pre-alignment Bash rules, and practical local repair allowance during subagent review.
- `0.5.0` - Restores and updates requirements alignment and agent dispatch; adds lightweight planning ledger and finishing-work completion gate; wires the full risk-tiered workflow through the default operating skill; updates TDD triggering and makes compounding less eager.
- `0.4.0` - Reverts skill content to the 0.2.0 set: removes `aligning-requirements` and `dispatching-agents`, rolls back the related default-bootstrap changes, and drops the skipped-vs-missed Communication rule. Keeps the dual-tool wiring (`.codex-plugin/`, `.claude-plugin/marketplace.json`) and `MAINTENANCE.md` introduced during 0.3.x.
- `0.3.1` - Sharpens `dispatching-agents`, `aligning-requirements`, and skipped-vs-missed reporting. Reverted in 0.4.0.
- `0.3.0` - Adds `aligning-requirements` and `dispatching-agents`; slims delegation guidance out of the default operating skill. Reverted in 0.4.0.
- `0.2.0` - Initial public baseline.
