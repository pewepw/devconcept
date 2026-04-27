# DevConcept v0.6.x PRD and Implementation Plan

Date: 2026-04-26  
Current assessed version: 0.5.3  
Target version: v0.6.x line
Release checklist version: `<next-version>`
Implemented by: 0.6.3 (rolled up from the 0.6.0 scope; 0.6.1 was unreleased; 0.6.2 shipped the workflow changes; 0.6.3 added the philosophy statement and cache-pruning footgun docs)
Target rating after this work: 91-93 / 100  
Decision: remove the executable eval scope, adopt the GSD-inspired essentials only, and rename the user-facing plugin concept to **DevConcept**.

---

## 1. Executive Summary

DevConcept is a lightweight workflow for Claude Code and Codex. The goal is not to create a heavy command framework. The goal is to make Claude Code and Codex behave like a strong senior developer: understand the requirement, ask when uncertainty matters, write a concise plan before risky edits, use agents when they reduce risk or context load, verify the result, and finish with a useful handoff.

The previous PRD over-scoped evaluation. A real executable eval harness would require fixture repositories for every case. A trivial UI rename, a multi-file feature, a shared-root-cause bug, and an agent-dispatch scenario all need known files, known failures, known tests, and known expected end states. Building that now would turn the release into an eval-platform project. This PRD removes that scope entirely.

The path to 91-93/100 is now focused on five practical upgrades:

1. Use **DevConcept** as the user-facing workflow name.
2. Replace vague workflow selection with a compact **three-mode router**: Lean, Standard, Full.
3. Add a small native agent set for Claude Code and Codex-compatible templates.
4. Add GSD-inspired plan review, context-budget dispatch, and implementation deviation rules.
5. Add output contracts and maintenance docs so behavior is predictable across runtimes.

Three modes are enough. More modes would make the router harder to predict. Debugging, design alternatives, plan review, TDD, and agent dispatch should be cross-cutting playbooks inside the three modes, not separate top-level modes.

---

## 2. Confirmed Decisions

### Decision 1: Remove executable eval scope

Remove the following from this release:

- `scripts/run-workflow-evals.py`
- `evals/cases.yaml`
- `evals/fixtures/*`
- live Claude/Codex eval runner
- fixture validation
- saved-run scoring
- pass/fail eval metrics as release blockers

Keep only manual dogfood scenarios in the release checklist. Existing manual eval notes may remain as reference material, but this release does not add an eval harness.

### Decision 2: Steal only the useful GSD concepts

GSD is conceptually similar: it is a structured AI coding workflow that emphasizes requirements, planning, agents, context management, execution, and verification. Its philosophy is more lifecycle-heavy than this plugin should be.

What DevConcept should steal:

- Quick/Full style routing, simplified into Lean / Standard / Full.
- A smart router that decides the minimum necessary ceremony.
- A small native agent set.
- Pre-execution plan review for risky work.
- A deviation protocol for implementation workers.
- Context-budget-based dispatch.

What DevConcept should not steal:

- A large `.planning/` lifecycle as the default.
- A broad command surface.
- A huge agent library.
- Permission-skipping posture.
- Mandatory commits or branch workflow.
- Full project/phase machinery for normal coding tasks.

### Decision 3: Rename direction

Use **DevConcept** as the product/workflow name.

Recommended naming:

```text
Product / plugin display name: DevConcept
Default operating skill: devconcept-core
First-turn bootstrap skill: using-devconcept
Agent prefix: devconcept-
```

Required agent names:

```text
devconcept-explorer
devconcept-plan-reviewer
devconcept-worker
devconcept-code-reviewer
devconcept-debugger
```

Migration rule:

- User-facing docs should move to DevConcept naming.
- Generic paths should be removed or renamed during DevConcept setup.
- New examples, docs, agents, and templates should use DevConcept names.

---

## 3. Is Three Modes Enough?

Yes. Three modes are enough if they are top-level operating modes and not forced to encode every engineering situation.

The plugin needs a small decision surface:

| Mode | Purpose | Default ceremony |
|---|---|---|
| Lean | Fast handling of trivial, exact, or read-only tasks | inspect, act, narrow verification, concise summary |
| Standard | Normal code changes where correctness matters | align requirements, mini-plan, implement, verify, summarize |
| Full | Risky, ambiguous, cross-surface, long-running, or multi-agent work | plan, plan review, dispatch, integrate, review, verify, handoff |

Other workflows should be triggered inside these modes:

| Situation | Playbook inside mode |
|---|---|
| Vague product behavior | requirements alignment / focused questions |
| New API or architecture | design alternatives before implementation |
| Bug with unknown cause | systematic debugging |
| Behavior change with test surface | TDD when practical |
| Multi-area exploration | read-only explorer agents |
| Risky plan | plan reviewer before implementation |
| Subagent-written code | spec review then code-quality review |

Why not more than three modes:

- More modes increase routing mistakes.
- Most users think in simple levels: quick task, normal task, serious task.
- Debugging and design are not levels of ceremony; they are specialized methods.
- Agent dispatch should be based on context budget and separability, not a separate mode.

The router should classify internally. It should not print a mode banner for every task. It should expose the mode only when that helps the user understand why the agent is asking questions, writing a plan, or dispatching agents.

---

## 4. Product Requirements Document

## 4.1 Product Name

**DevConcept v0.6.x** (shipping as 0.6.2)

Working description:

> DevConcept is a lightweight senior-engineering workflow for Claude Code and Codex. It routes each task through the minimum process needed to understand, implement, verify, and hand off the work correctly.

## 4.2 Problem Statement

Software developers using coding agents need reliable behavior across small edits, normal feature work, bug fixes, and multi-step changes. The agent should not rush into edits when requirements are unclear, but it also should not force heavy ceremony for trivial work.

The current plugin has many good skills, but the behavior still depends too much on the model choosing the right skill at the right moment. The next release must make the workflow more predictable by adding a clear mode router, native agents, runtime-specific dispatch recipes, plan review, deviation rules, and output contracts.

## 4.3 Target Users

Primary user:

- A software developer using Claude Code and Codex daily for code changes, bug fixes, feature work, refactors, code review, and repo exploration.

Secondary user:

- A maintainer of the plugin who needs clear rules for editing skills, agents, and docs without adding unnecessary workflow weight.

## 4.4 Product Goals

1. Increase the plugin quality rating from 86/100 to 91-93/100.
2. Make the agent reliably choose Lean, Standard, or Full workflow behavior.
3. Make the agent ask questions before risky or ambiguous edits.
4. Make subagent dispatch concrete across Claude Code and Codex.
5. Make Full Mode safer through plan review and implementation deviation rules.
6. Preserve speed for trivial and low-risk tasks.
7. Improve final handoffs with consistent verification and residual-risk reporting.

## 4.5 Non-Goals

This release does not include:

- Executable eval harnesses.
- Fixture repositories.
- Live Claude/Codex eval runners.
- Full GSD-style project lifecycle management.
- Full Superpowers-style mandatory brainstorming for all creative work.
- planning-with-files as the default workflow.
- A large agent library.
- Git automation, forced commits, or branch management.
- Permission-skipping guidance.
- Broad skill shopping from other providers.

## 4.6 Success Criteria

The release succeeds when:

- Trivial exact edits stay Lean: no alignment block, no plan file, no agents.
- Normal behavior changes use Standard Mode: minimal context, requirements alignment, concise plan, implementation, verification, final summary.
- Vague feature requests produce focused questions instead of invented product behavior.
- Risky or cross-surface work enters Full Mode: plan, plan review, dispatch if useful, review, integrated verification.
- Codex dispatch instructions explicitly ask for subagents when needed.
- Claude Code dispatch instructions prefer named DevConcept agents when available.
- Implementation workers know when to auto-fix local issues and when to stop for user approval.
- Final summaries consistently state what changed, what was verified, what risk remains, and where review should start.

---

## 5. Required Scope

## P0 Requirement 1: Rename user-facing workflow to DevConcept

### Why this is required

DevConcept gives the plugin a product identity without sounding like a heavyweight methodology.

### Required changes

Update user-facing naming across docs and new assets:

```text
Plugin display name: DevConcept
Default operating skill: devconcept-core
First-turn bootstrap skill: using-devconcept
Agent prefix: devconcept-
```

Required documentation changes:

- README title and introduction use DevConcept.
- Changelog describes the release as DevConcept v0.6.x.
- New agents and templates use `devconcept-*` names.
- Default workflow docs refer to `devconcept-core` and first-turn bootstrap docs refer to `using-devconcept`.
- Generic skill paths are removed.

### Acceptance criteria

- New users see DevConcept as the product name.
- The default skill no longer presents itself as generic engineering defaults.
- Agent names, examples, and dispatch recipes use the DevConcept prefix.
- Existing users are not left with broken references after the rename.

---

## P0 Requirement 2: Implement the DevConcept Mode Router

### Why this is required

The plugin needs predictable ceremony control. The model should not improvise whether to ask questions, plan, dispatch agents, or edit directly. It should classify the task first and use the minimum workflow that protects correctness.

### Required content for `devconcept-core`

Add this near the top of the default operating skill:

```md
## DevConcept Mode Router

Before acting, classify the task internally as Lean, Standard, or Full. Use the minimum mode that can complete the work correctly.

### Lean Mode
Use for trivial, exact, mechanical, or read-only work.

Examples:
- typo fix
- exact string rename
- obvious one-line config change
- read-only explanation or file lookup

Behavior:
- inspect the target if needed
- act directly if the request is exact
- do not use an alignment block
- do not create a plan file
- do not dispatch agents
- run the narrowest useful check or explain why not
- finish concisely

### Standard Mode
Use for normal non-trivial code changes.

Examples:
- small bug fix
- behavior change
- small feature
- refactor with limited blast radius
- 2-4 related files

Behavior:
- gather minimal repo context first
- use requirements alignment before edits
- write a concise mini-plan/spec
- use TDD when practical
- implement surgically
- verify affected behavior
- finish with changed / verified / risk / skills-or-agents-used / skipped-workflow summary

### Full Mode
Use for risky, ambiguous, cross-surface, long-running, or multi-agent work.

Examples:
- auth, billing, permissions, security, data migrations
- new API or architecture boundary
- multi-module refactor
- unfamiliar code areas across subsystems
- work likely to exceed context budget
- work that benefits from parallel read-only exploration

Behavior:
- gather enough context to avoid blind planning
- align requirements
- write a plan or planning ledger
- run plan review before implementation
- dispatch agents only for separable work
- review subagent-written code before accepting it
- verify integrated behavior before handoff
```

### Escalation rules

Add:

```md
## Mode Escalation Rules

Start Lean only when the task is exact and low-risk.

Escalate Lean -> Standard when:
- behavior changes
- tests may need updates
- requirements are underspecified
- more than one implementation path is plausible
- a wrong assumption would cause rework

Escalate Standard -> Full when:
- more than one subsystem is involved
- likely more than five files are touched
- security, auth, billing, permissions, or data integrity is involved
- implementation depends on unfamiliar architecture
- work needs durable planning across context compaction
- read-only exploration can be parallelized safely

Do not escalate just because a task is interesting.
Do not keep Full Mode ceremony after the risk has been reduced.
```

### Acceptance criteria

- Lean Mode remains fast and non-ceremonial.
- Standard Mode becomes the default for normal code changes.
- Full Mode is reserved for meaningful risk, ambiguity, or context size.
- Design, debugging, TDD, and dispatch are playbooks inside the modes, not extra modes.

---

## P0 Requirement 3: Add native DevConcept agents

### Why this is required

The plugin currently describes when to use agents, but it needs actual named agent assets and runtime-specific templates so Claude Code and Codex can use them predictably.

The agent set should be small. Five agents are enough for this release.

### Required files

```text
agents/
  devconcept-explorer.md
  devconcept-plan-reviewer.md
  devconcept-worker.md
  devconcept-code-reviewer.md
  devconcept-debugger.md

templates/codex-agents/
  devconcept-explorer.toml
  devconcept-plan-reviewer.toml
  devconcept-worker.toml
  devconcept-code-reviewer.toml
  devconcept-debugger.toml

scripts/
  sync-codex-agents.sh
```

### Agent contracts

#### `devconcept-explorer`

Purpose:

- Read-only codebase exploration.
- Map files, callers, data flow, tests, risks, and likely implementation surfaces.

Must not:

- Edit files.
- Run mutating commands.
- Propose broad rewrites unless directly relevant.

Expected output:

```md
Findings:
- ...
Relevant files:
- path: reason
Likely change surface:
- ...
Risks / unknowns:
- ...
Recommended next step:
- ...
```

#### `devconcept-plan-reviewer`

Purpose:

- Review a requirement, alignment block, mini-spec, or implementation plan before coding.
- Find missing requirements, hidden assumptions, dependency mistakes, unsafe sequencing, and verification gaps.

Expected output:

```md
Plan verdict: pass | needs revision
Blockers:
- ...
Warnings:
- ...
Requirement coverage:
- ...
Verification gaps:
- ...
Recommended revision:
- ...
```

#### `devconcept-worker`

Purpose:

- Implement one bounded, disjoint slice of work when ownership is clear.

Must:

- Follow the approved plan/spec exactly.
- Avoid unrelated cleanup.
- Avoid overwriting other agents' changes.
- Report changed files and verification.
- Follow the implementation deviation protocol.

Expected output:

```md
Completed slice:
- ...
Changed files:
- ...
Verification:
- command/result or not run + reason
Deviation notes:
- ...
Notes for integrator:
- ...
```

#### `devconcept-code-reviewer`

Purpose:

- Review a diff for correctness, maintainability, repo consistency, tests, edge cases, and scope drift.

Expected output:

```md
Review verdict: pass | changes requested
Critical:
- ...
Important:
- ...
Nit:
- ...
Verification gaps:
- ...
```

#### `devconcept-debugger`

Purpose:

- Diagnose failing behavior before fixes, especially when failures may share one root cause.

Must:

- Reproduce or inspect failure evidence first.
- Identify likely root cause before recommending edits.
- Avoid parallel code-writing when failures likely share a cause.

Expected output:

```md
Symptom:
Reproduction / evidence:
Likely root cause:
Rejected hypotheses:
Minimal fix direction:
Verification plan:
```

### Acceptance criteria

- Claude Code has an `agents/` directory with the five DevConcept agents.
- Codex users can sync matching TOML templates into project or user agent locations.
- Dispatch docs use these named agents.
- Read-only agents are constrained as read-only where the runtime supports it.
- The plugin does not add a large agent library beyond these five agents.

---

## P0 Requirement 4: Add runtime-specific dispatch recipes and context-budget rules

### Why this is required

Claude Code and Codex do not dispatch agents in the same way. Codex needs explicit subagent instructions. Claude Code can use named agents more directly. The workflow must tell each runtime what to do.

### Required changes

Update the dispatch skill with:

```md
## Runtime Dispatch Recipes

### Claude Code
When dispatch triggers hit, prefer named DevConcept agents:
- devconcept-explorer for read-only codebase mapping
- devconcept-plan-reviewer for requirement or plan review
- devconcept-worker for bounded, disjoint implementation slices
- devconcept-code-reviewer for independent review of diffs
- devconcept-debugger for failure diagnosis before fixes

If DevConcept agents are unavailable, use the closest built-in agent or inline the same prompt contract.

### Codex
Codex does not spawn subagents unless explicitly asked. When dispatch triggers hit, ask the user to choose between spawning agents and continuing inline unless the user already requested subagents or parallel agent work. If the user chooses spawn, say the dispatch request literally.

Examples:

Have `devconcept-plan-reviewer` review the plan before implementation.

Have `devconcept-code-reviewer` review the diff for correctness and verification gaps.

Have `devconcept-debugger` investigate the failing test before any fix.

For parallel read-only exploration:

Spawn one `devconcept-explorer` subagent per area, wait for all of them, and return a consolidated summary. Use read-only exploration only.

Areas:
1. <area A>
2. <area B>
3. <area C>

Each subagent must return: Findings, Relevant files, Risks / unknowns, Recommended next step.
```

### Context-budget dispatch rules

Add:

```md
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
```

### Acceptance criteria

- Dispatch behavior differs correctly between Claude and Codex.
- Codex examples include literal spawn phrasing.
- Claude examples use DevConcept agent names.
- Context-budget rules prevent both under-dispatch and over-dispatch.
- Shared-root-cause bugs route through debugging before parallel implementation.

---

## P0 Requirement 5: Add plan review and implementation deviation protocol

### Why this is required

The most valuable GSD concept for DevConcept is not the full planning lifecycle; it is the idea that risky plans should be challenged before implementation. The second valuable concept is that implementation workers need clear rules for what they may fix and when they must ask.

### Plan review requirement

Use `devconcept-plan-reviewer`:

- Always in Full Mode before implementation.
- In Standard Mode when the change affects architecture, security, billing, auth, permissions, data integrity, or public API contracts.
- Not in Lean Mode.

Required plan-review checklist:

```md
## Plan Review Checklist

Check:
- Does the plan directly satisfy the user request?
- Are assumptions explicit?
- Are product decisions identified instead of invented?
- Are affected files or areas identified?
- Are dependencies ordered correctly?
- Is verification concrete?
- Is scope reduced silently?
- Is any step too broad for one agent/context?

Return:
- pass only if implementation can start safely
- needs revision if blockers exist
```

### Implementation deviation protocol

Add this to `devconcept-worker` and the main workflow skill:

```md
## Implementation Deviation Protocol

Auto-fix without asking when:
- the issue is caused by the current change
- the fix is local and preserves the approved design
- missing validation or error handling is required for correctness
- a test/build failure blocks completion and the fix is within scope
- a small type/lint/test adjustment is needed to satisfy the plan

Stop and ask before changing direction when:
- a new architecture is needed
- a new persistence model is needed
- a new external service or dependency is needed
- a public API or data contract would break
- user-visible product behavior must be chosen
- the fix requires broad unrelated cleanup
- the original plan is no longer valid
```

### Acceptance criteria

- Full Mode plans are reviewed before coding.
- Risky Standard Mode plans are reviewed before coding.
- Workers do not silently make architectural decisions.
- Workers can still fix local correctness issues without unnecessary user interruption.
- Final handoff reports any deviations from the approved plan.

---

## P0 Requirement 6: Add output contracts to core skills

### Why this is required

Predictable output shapes make the workflow easier to review and harder for models to drift away from. The output contracts should stay concise; they are not meant to make every answer verbose.

### Required output contracts

#### `devconcept-core` / default workflow

```md
For non-trivial work:
Understanding:
- ...
Scope:
- ...
Open questions:
- ...
Proposed approach:
- ...
Ready to proceed?
```

Rules:

- Do not print this for Lean Mode exact edits.
- Ask only questions that would change implementation direction.
- If no open questions exist, write `Open questions: None.`

#### Planning / plan ledger

```md
Plan:
- Goal:
- Steps:
- Files / areas:
- Verification:
- Risks:
```

For durable planning:

```md
Created/updated plan: .devconcept/plans/<file>.md
Current phase:
Next action:
Open risks:
```

#### Dispatch

```md
Dispatch decision: dispatch | do not dispatch
Reason:
Agents / slices:
- agent: purpose, ownership, read/write permission
Local critical-path work:
Integration plan:
```

#### Design alternatives

```md
Frame:
- Goal:
- Hard constraints:
- Negotiable choices:

Design A:
Design B:
Design C:

Comparison:
Recommendation: <X> because <Y>, accepting <Z>.
Decision needed from user:
```

#### Subagent review

```md
Stage 1 - Spec compliance: pass | fail
Evidence:
- requirement -> diff/file evidence
Scope drift:
- ...

Stage 2 - Code quality: pass | fail
Issues:
- ...

Decision:
- accept | revise locally | send back to subagent
```

#### TDD

```md
Behavior under test:
RED:
- test/command/result
GREEN:
- change made
- test/command/result
Refactor:
- done | skipped + reason
```

#### Systematic debugging

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

#### Finishing work

```md
Changed:
- ...

Verified:
- command/result, file/line proof, or blocked + reason

Risk / not done:
- ...

Skills / agents used:
- ...

Relevant skipped or missed workflow:
- ...
```

### Acceptance criteria

- Every core skill has an `Expected Output` section.
- Lean Mode remains concise despite output contracts.
- Final summaries consistently include changed, verified, residual risk, skills/agents used, and skipped-workflow information.

---

## P0 Requirement 7: Update maintenance, packaging, and release docs

### Why this is required

DevConcept will have a renamed identity, native agents, Codex templates, and runtime-specific dispatch recipes. Maintenance docs must explain how to install, sync, smoke-test, and release the plugin without relying on chat history.

### Required documentation updates

Update `README.md`:

- Introduce DevConcept.
- Explain Lean / Standard / Full modes.
- List the five DevConcept agents.
- Explain Claude and Codex dispatch differences.
- Show concise examples of when the plugin asks questions, plans, or dispatches agents.

Update `MAINTENANCE.md`:

- Version bump checklist.
- Claude plugin agent directory behavior.
- Codex agent template sync.
- Runtime smoke-test checklist.
- Setup notes for the DevConcept plugin slug and runtime wiring.

Update plugin manifests:

- `.claude-plugin/plugin.json`
- `.codex-plugin/plugin.json`
- `.claude-plugin/marketplace.json` if present

### Required release checklist

```md
## Release Checklist

- [ ] Bump `.claude-plugin/plugin.json` version to `<next-version>`.
- [ ] Bump `.codex-plugin/plugin.json` version to `<next-version>`.
- [ ] Bump marketplace metadata version to `<next-version>` if present.
- [ ] Update product display name to DevConcept.
- [ ] Update README introduction and changelog.
- [ ] Add DevConcept agents under `agents/`.
- [ ] Add Codex agent templates under `templates/codex-agents/`.
- [ ] Add `scripts/sync-codex-agents.sh`.
- [ ] Verify Claude Code can see or invoke DevConcept agents.
- [ ] Verify Codex can use synced DevConcept TOML agents.
- [ ] Run Lean smoke test in a real repo.
- [ ] Run Standard smoke test in a real repo.
- [ ] Run Full smoke test in a real repo.
- [ ] Run dispatch smoke test in Claude Code.
- [ ] Run dispatch smoke test in Codex.
- [ ] Confirm final handoffs include changed, verified, risk, skills/agents used, and skipped-workflow sections.
- [ ] Tag release and push.
```

### Acceptance criteria

- Maintainers can release without relying on memory.
- Codex agent setup is documented.
- Claude agent behavior is documented.
- Smoke tests are manual and repo-backed, not fake fixture-based evals.

---

## 6. Implementation Plan

## Phase 1: Rename and scope lock

Branch:

```sh
git checkout -b feat/devconcept-v0.6-workflow-agents
```

Tasks:

1. Add this PRD as `docs/prd-devconcept-v0.6.md`.
2. Confirm target version is the v0.6.x line (this PRD shipped through 0.6.2 / 0.6.3).
3. Confirm current assessed version is `0.5.3`.
4. Confirm no executable eval harness is part of this release.
5. Keep `devconcept-core` as the default operating skill and `using-devconcept` as the first-turn bootstrap.

Deliverable:

- PRD checked in or attached to the implementation issue.

Acceptance:

- Scope contains only P0 requirements in this file.

---

## Phase 2: Build `devconcept-core` mode router

Tasks:

1. Update the default operating skill with the DevConcept Mode Router.
2. Add Lean / Standard / Full behavior.
3. Add escalation rules.
4. Map existing skills into playbooks inside the modes:
   - requirements alignment
   - TDD
   - systematic debugging
   - design alternatives
   - dispatching agents
   - subagent review
   - finishing work
5. Ensure Lean Mode explicitly skips alignment, plan files, and agents.

Deliverable:

- Default workflow skill can reliably choose the minimum useful process.

Acceptance:

- Trivial exact tasks stay Lean.
- Normal code changes use Standard.
- Risky or cross-surface work escalates to Full.

---

## Phase 3: Add native agents and Codex templates

Tasks:

1. Create `agents/devconcept-explorer.md`.
2. Create `agents/devconcept-plan-reviewer.md`.
3. Create `agents/devconcept-worker.md`.
4. Create `agents/devconcept-code-reviewer.md`.
5. Create `agents/devconcept-debugger.md`.
6. Create matching TOML templates under `templates/codex-agents/`.
7. Create `scripts/sync-codex-agents.sh` with project and user targets.

Example Claude agent frontmatter:

```md
---
name: devconcept-explorer
description: Read-only codebase exploration for unfamiliar files, modules, callers, data flow, tests, and risks before implementation.
model: sonnet
effort: medium
maxTurns: 20
disallowedTools: Write, Edit
---
```

Example Codex TOML:

```toml
name = "devconcept-explorer"
description = "Read-only codebase exploration for unfamiliar files, modules, callers, data flow, tests, and risks before implementation."
developer_instructions = """
You are a read-only DevConcept explorer. Map relevant files, callers, tests, data flow, risks, and recommended next step. Do not edit files or run mutating commands.
"""
sandbox_mode = "read-only"
```

Deliverable:

- Five native Claude agents and five Codex templates exist.

Acceptance:

- Agents match the contracts in P0 Requirement 3.
- Codex templates validate as TOML.
- Sync script can copy templates to project or user agent directory.

---

## Phase 4: Update dispatch, review, and debugging skills

Tasks:

1. Update dispatch skill with Claude and Codex recipes.
2. Add context-budget dispatch rules.
3. Update design alternatives to use named agents or inline fallback passes.
4. Update subagent review to require spec/plan compliance before code-quality review.
5. Update systematic debugging to use `devconcept-debugger` when useful.
6. Preserve the shared-root-cause rule: diagnose first, do not parallelize code-writing workers prematurely.

Deliverable:

- Agent usage becomes concrete and runtime-aware.

Acceptance:

- Claude path references DevConcept agents by name.
- Codex path includes literal spawn phrasing.
- Workers are used only for bounded, disjoint implementation slices.

---

## Phase 5: Add plan review and deviation protocol

Tasks:

1. Add plan-review rules to Full Mode.
2. Add plan-review rules for risky Standard Mode tasks.
3. Add the plan-review checklist to `devconcept-plan-reviewer`.
4. Add the implementation deviation protocol to `devconcept-worker`.
5. Add the same deviation protocol summary to the main workflow skill.
6. Ensure final handoff reports meaningful deviations.

Deliverable:

- Risky plans are challenged before implementation.
- Workers can continue through local blockers but cannot silently change architecture.

Acceptance:

- Full Mode implementation does not start before plan review.
- Risky Standard Mode changes get plan review when needed.
- Worker deviations are handled according to the protocol.

---

## Phase 6: Add output contracts

Tasks:

1. Add `Expected Output` to the default workflow skill.
2. Add or update output contracts for planning, dispatch, design alternatives, subagent review, TDD, systematic debugging, and finishing work.
3. Keep Lean Mode concise.
4. Ensure final summaries are human-friendly and evidence-backed.

Deliverable:

- Core skills produce predictable output shapes.

Acceptance:

- Non-trivial work shows understanding/scope/questions/approach before edits.
- Final summaries include changed, verified, risk/not done, skills/agents used, and skipped-workflow disclosure.
- Output contracts do not create heavy ceremony for exact edits.

---

## Phase 7: Update docs, manifests, and release checklist

Tasks:

1. Update README to introduce DevConcept.
2. Update README with the mode model.
3. Update README with agent list and dispatch explanation.
4. Update `MAINTENANCE.md` with agent sync and smoke tests.
5. Update plugin manifests to `<next-version>` on the v0.6.x line.
6. Update changelog.
7. Remove references to executable eval work from the release scope.

Deliverable:

- Docs and manifests match the new workflow.

Acceptance:

- A new user understands DevConcept in under two minutes.
- A maintainer can release any v0.6.x version using the checklist.
- There is no `run-workflow-evals.py` requirement in the docs.

---

## Phase 8: Manual repo-backed smoke tests

Run smoke tests in real repositories where the required files and behavior actually exist. Do not use fake prompts that reference missing files.

### Smoke 1: Lean Mode

Use a real trivial edit, such as an exact label rename in an existing file.

Expected:

- No alignment block.
- No plan file.
- No agents.
- Narrow verification or clear reason verification was not run.

### Smoke 2: Standard Mode

Use a real small bug fix or behavior change.

Expected:

- Minimal context first.
- Requirements alignment before edits.
- Concise mini-plan.
- TDD when practical.
- Verification evidence in final summary.

### Smoke 3: Vague feature request

Use a real repo and ask for a feature whose product behavior is underspecified.

Expected:

- The agent asks focused questions.
- The agent does not invent product rules.
- The agent proposes a concise approach only after enough context.

### Smoke 4: Full Mode / dispatch

Use a real repo with multiple independent modules to map or change.

Expected:

- Claude: named DevConcept agents if available.
- Codex: explicit spawn phrasing when subagents are needed.
- Read-only exploration before implementation.
- Worker dispatch only for disjoint slices.

### Smoke 5: Shared-root-cause debugging

Use a real failure where several tests may share one cause.

Expected:

- No premature parallel code-writing workers.
- Systematic debugging or `devconcept-debugger` first.
- Root cause identified before broad fixes.

Deliverable:

- Smoke-test notes in the release PR.

Acceptance:

- All five smoke categories pass in at least one real repo.

---

## 7. Proposed v0.6.x File Tree

```text
devconcept/
  .claude-plugin/
    plugin.json
    marketplace.json
  .codex-plugin/
    plugin.json
  agents/
    devconcept-explorer.md
    devconcept-plan-reviewer.md
    devconcept-worker.md
    devconcept-code-reviewer.md
    devconcept-debugger.md
  assets/
  docs/
    prd-devconcept-v0.6.md
  scripts/
    sync-codex-agents.sh
  skills/
    devconcept-core/SKILL.md
    using-devconcept/SKILL.md
    aligning-requirements/SKILL.md
    compound-engineering/SKILL.md
    design-alternatives/SKILL.md
    dispatching-agents/SKILL.md
    finishing-work/SKILL.md
    planning-ledger/SKILL.md
    subagent-review/SKILL.md
    systematic-debugging/SKILL.md
    tdd/SKILL.md
  templates/
    codex-agents/
      devconcept-explorer.toml
      devconcept-plan-reviewer.toml
      devconcept-worker.toml
      devconcept-code-reviewer.toml
      devconcept-debugger.toml
  MAINTENANCE.md
  README.md
```

`devconcept-core` is the default operating skill. `using-devconcept` is the first-turn bootstrap skill.

---

## 8. Release Acceptance Checklist

### Naming and packaging

- [ ] Product display name is DevConcept.
- [ ] Target version is on the v0.6.x line (use `<next-version>` when bumping).
- [ ] Current assessed version references are `0.5.3` (the baseline this PRD started from).
- [ ] README and changelog use DevConcept naming.
- [ ] Plugin slug, display name, and docs use DevConcept naming.

### Mode router

- [ ] Default workflow skill includes Lean / Standard / Full modes.
- [ ] Escalation rules are explicit.
- [ ] Lean Mode skips alignment, plan files, and agents.
- [ ] Standard Mode aligns requirements before non-trivial edits.
- [ ] Full Mode uses plan review and dispatch when warranted.

### Agent infrastructure

- [ ] `agents/devconcept-explorer.md` exists.
- [ ] `agents/devconcept-plan-reviewer.md` exists.
- [ ] `agents/devconcept-worker.md` exists.
- [ ] `agents/devconcept-code-reviewer.md` exists.
- [ ] `agents/devconcept-debugger.md` exists.
- [ ] Matching Codex TOML templates exist.
- [ ] `scripts/sync-codex-agents.sh` supports project and user sync.

### Runtime dispatch

- [ ] Claude dispatch docs reference named DevConcept agents.
- [ ] Codex dispatch docs include literal spawn phrasing.
- [ ] Context-budget dispatch rules are present.
- [ ] Shared-root-cause failures avoid premature parallel code-writing workers.

### Plan review and worker behavior

- [ ] Full Mode requires plan review before implementation.
- [ ] Risky Standard Mode can require plan review.
- [ ] `devconcept-worker` includes the deviation protocol.
- [ ] Final handoff reports meaningful deviations.

### Output contracts

- [ ] Requirements alignment output is defined.
- [ ] Planning output is defined.
- [ ] Dispatch output is defined.
- [ ] Design alternatives output is defined.
- [ ] Subagent review output is defined.
- [ ] TDD output is defined.
- [ ] Systematic debugging output is defined.
- [ ] Finishing output is defined.

### Manual smoke tests

- [ ] Lean smoke test passes in a real repo.
- [ ] Standard smoke test passes in a real repo.
- [ ] Vague feature smoke test passes in a real repo.
- [ ] Full/dispatch smoke test passes in a real repo.
- [ ] Shared-root-cause debugging smoke test passes in a real repo.

---

## 9. Expected Rating After Implementation

If all P0 requirements ship cleanly, DevConcept should reach **91-93/100**.

Why:

- The plugin keeps the lightweight developer experience.
- The mode router makes ceremony predictable.
- Native agents make dispatch concrete instead of aspirational.
- Plan review catches bad plans before expensive implementation.
- The deviation protocol prevents agents from silently changing direction.
- Output contracts make handoffs consistent across Claude Code and Codex.
- Removing the eval harness keeps this release focused on workflow quality rather than infrastructure.

The remaining gap above 93 would require a separate release with real-world transcript analysis and carefully built fixture-backed evals. That is not part of this release.

---

## 10. References

- Claude Code plugin reference, including plugin-provided agents: https://code.claude.com/docs/en/plugins-reference
- Claude Code skills documentation: https://code.claude.com/docs/en/skills
- Codex subagents documentation: https://developers.openai.com/codex/subagents
- Codex custom agent documentation: https://developers.openai.com/codex/subagents
- Codex plugin documentation: https://developers.openai.com/codex/plugins
- GSD repository: https://github.com/gsd-build/get-shit-done
- GSD command router concept: https://raw.githubusercontent.com/gsd-build/get-shit-done/main/commands/gsd/do.md
- GSD plan checker agent: https://raw.githubusercontent.com/gsd-build/get-shit-done/main/agents/gsd-plan-checker.md
- GSD executor agent: https://raw.githubusercontent.com/gsd-build/get-shit-done/main/agents/gsd-executor.md
- GSD planner agent: https://raw.githubusercontent.com/gsd-build/get-shit-done/main/agents/gsd-planner.md
