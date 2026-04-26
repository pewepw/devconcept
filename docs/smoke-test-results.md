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
