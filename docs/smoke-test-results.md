# DevConcept Smoke Test Results

Lightweight per-run notes from [`manual-smoke-tests.md`](manual-smoke-tests.md). Append a new entry per run rather than overwriting earlier ones. This file is not an automated eval harness; it just keeps a paper trail so we can justify rating bumps without inventing fixtures.

## Entry template

Copy this block when adding a new entry.

```md
### YYYY-MM-DD — <runtime> — <short task label>

- Date:
- Runtime: Claude Code | Codex
- Repo:
- Task:
- Expected mode: Lean | Standard | Full
- Observed mode: Lean | Standard | Full
- Agents used:
- Verification:
- Issues found:
- Follow-ups:
```

## Entries

<!-- Append new entries below, newest first. -->

### 2026-04-27 — Codex — 0.6.9 Codex dispatch choice rules

- Date: 2026-04-27
- Runtime: Codex
- Repo: `/Users/harry/Desktop/BuiltByHarry/devconcept`
- Task: Align Full Mode dispatch rules with Codex subagent behavior: Codex must ask before spawning agents unless the user already requested subagents, while broad/high-risk Full Mode still needs an agent or inline review pass.
- Expected mode: Standard
- Observed mode: Standard
- Agents used: None; user asked specifically to change the plugin rules, and the edit scope was tightly coupled documentation/skill text.
- Verification: skill frontmatter parsed with Ruby YAML; plugin JSON manifests parsed; stale dispatch wording searched; `git diff --check` passed.
- Issues found: Runtime host smoke tests and actual Codex subagent prompt flow were not executed in this shell session.
- Follow-ups: Run a Codex Full Mode smoke test where the assistant offers `Spawn reviewer` versus `Inline review`, then verify it does not spawn an agent until the user chooses the spawn option.

### 2026-04-27 — Codex — 0.6.8 workflow gate release

- Date: 2026-04-27
- Runtime: Codex
- Repo: `/Users/harry/Desktop/BuiltByHarry/devconcept`
- Task: Tighten Codex bootstrap anti-batching, Standard/Full pre-edit gate proof, Codex `request_user_input` alignment confirmation, and literal final handoff headings; deploy as `0.6.8`.
- Expected mode: Full
- Observed mode: Full
- Agents used: None; inline plan review used.
- Verification: JSON manifests parsed; shell syntax checked for `scripts/sync-codex-agents.sh`; strict YAML frontmatter parsed for every `skills/*/SKILL.md` through Ruby; `git diff --check` passed; Codex templates synced to `~/.codex/agents`; `0.6.8` Claude and Codex runtime caches built and manifest versions checked.
- Issues found: Runtime-only Claude/Codex host smoke tests were not executed inside this release shell. The `request_user_input` overlay was not exercised because the current Codex session is not in an allowed mode.
- Follow-ups: Restart or update plugin hosts, then run manual Lean / Standard / Full / dispatch smoke tests against `0.6.8`.

### 2026-04-27 — Codex — 0.6.7 workflow gates release

- Date: 2026-04-27
- Runtime: Codex
- Repo: `/Users/harry/Desktop/BuiltByHarry/devconcept`
- Task: Strengthen alignment hard-stop, Full Mode escalation, Full Mode plan review, and final handoff disclosure rules; deploy as `0.6.7`.
- Expected mode: Full
- Observed mode: Full
- Agents used: None; inline plan review used.
- Verification: JSON manifests parsed; TOML templates parsed; shell syntax checked for `scripts/sync-codex-agents.sh`; required files checked; strict YAML frontmatter parsed for every `skills/*/SKILL.md` through Ruby; `git diff --check` passed; Codex templates synced to `~/.codex/agents`; `0.6.7` Claude and Codex runtime caches built and manifest versions checked.
- Issues found: Runtime-only Claude/Codex host smoke tests were not executed inside this release shell.
- Follow-ups: Run manual host smoke tests after installing or restarting against `0.6.7`.

### 2026-04-27 — Codex — 0.6.6 frontmatter release

- Date: 2026-04-27
- Runtime: Codex
- Repo: `/Users/harry/Desktop/BuiltByHarry/devconcept`
- Task: Fix invalid `dispatching-agents` frontmatter and deploy as `0.6.6`.
- Expected mode: Standard
- Observed mode: Standard
- Agents used: None
- Verification: Strict YAML frontmatter parsing for every `skills/*/SKILL.md`; JSON manifest parsing; shell syntax check for `scripts/sync-codex-agents.sh`; `0.6.6` Claude and Codex runtime caches built; Codex agent templates synced to `~/.codex/agents`.
- Issues found: Runtime-only Claude/Codex host smoke tests were not executed inside this release shell.
- Follow-ups: Run manual host smoke tests after installing `0.6.6`.

### 2026-04-27 — Codex — 0.6.5 release checklist

- Date: 2026-04-27
- Runtime: Codex
- Repo: `/Users/harry/Desktop/BuiltByHarry/devconcept`
- Task: Release review cleanup as `0.6.5`.
- Expected mode: Standard
- Observed mode: Standard
- Agents used: None
- Verification: JSON manifests validated; TOML templates parsed; shell syntax checked for `scripts/sync-codex-agents.sh`; required files checked; Codex templates synced to `~/.codex/agents` and compared; `0.6.5` Claude and Codex runtime caches built; stale release-checklist and generic dispatch strings searched; `.devconcept/` confirmed untracked and absent from package contents.
- Issues found: Runtime-only Claude/Codex smoke tests require interactive plugin hosts and were not executed inside this release shell.
- Follow-ups: Run manual host smoke tests after installing `0.6.5` from the pushed tag.

### 2026-04-26 — Codex Desktop — SMS Blast meeting limits

- Date: 2026-04-26
- Runtime: Codex Desktop
- DevConcept: 0.6.5
- Repo: SMS Blast
- Tasks:
  1. Screenshot UI change for templates page.
  2. Read-only recommendation for Meetings package limits.
  3. Multi-file implementation of `maxActiveMeetingLinks`.
- Result:
  - Delivery succeeded.
  - Verification succeeded with targeted tests, typecheck, and lint.
  - Alignment worked partially.
  - Full Mode plan review did not happen.
  - Named-agent dispatch was not exercised.
- Verdict:
  - Lean/Standard delivery: pass with warning.
  - Read-only recommendation: pass.
  - Full Mode workflow: partial fail.
- Follow-up:
  - Strengthen alignment hard-stop rule.
  - Strengthen Full Mode plan-review trigger.
  - Require final skipped-workflow disclosure.
