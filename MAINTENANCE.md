# Maintaining DevConcept

DevConcept powers both Claude Code and Codex from one source tree:

```text
/Users/harry/Desktop/BuiltByHarry/devconcept/   <- edit here
```

Do not maintain the parent `/Users/harry/Desktop/BuiltByHarry/` duplicate. The `devconcept/` repo is the source of truth for plugin edits, releases, tags, cache syncs, and pushes.

The plugin install slug is `devconcept`. The product display name is **DevConcept**, the default operating skill is **devconcept-core**, and new agent assets use the `devconcept-` prefix.

## Repo Layout

```text
.
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── .codex-plugin/
│   └── plugin.json
├── agents/
│   ├── devconcept-code-reviewer.md
│   ├── devconcept-debugger.md
│   ├── devconcept-explorer.md
│   ├── devconcept-plan-reviewer.md
│   └── devconcept-worker.md
├── docs/
│   └── prd-devconcept-v0.6.md
├── scripts/
│   └── sync-codex-agents.sh
├── skills/
│   ├── devconcept-core/SKILL.md
│   ├── using-devconcept/SKILL.md
│   └── ...
├── templates/
│   └── codex-agents/
├── README.md
└── MAINTENANCE.md
```

## Runtime Wiring

- Claude Code marketplace: `~/.claude/plugins/marketplaces/built-by-harry/` symlinks to this dev clone.
- Codex plugin dir: `~/.codex/plugins/devconcept/` symlinks to this dev clone.
- Claude cache: `~/.claude/plugins/cache/built-by-harry/devconcept/<version>/`
- Codex cache: `~/.codex/plugins/cache/built-by-harry/devconcept/<version>/`

The cache is versioned. Editing files alone does not force a cache rebuild; bump the manifests and refresh caches before release validation.

## Claude Agent Behavior

Claude Code can discover plugin-provided agents from `agents/`. Keep the native set intentionally small:

- `devconcept-explorer`
- `devconcept-plan-reviewer`
- `devconcept-worker`
- `devconcept-code-reviewer`
- `devconcept-debugger`

If a Claude runtime cannot see these agents, use the nearest built-in agent or inline the same prompt contract from the agent file.

## Codex Agent Templates

Codex templates live in `templates/codex-agents/`. Sync them into the user-level Codex agents directory:

```sh
scripts/sync-codex-agents.sh
```

Sync target: `~/.codex/agents`

Codex sessions still need explicit subagent phrasing when dispatch is required.

## Version Bump Checklist

1. Bump `.claude-plugin/plugin.json` to the target version.
2. Bump `.codex-plugin/plugin.json` to the same version.
3. Bump `.claude-plugin/marketplace.json` plugin entry if duplicated there.
4. Update `README.md` changelog.
5. Update `MAINTENANCE.md` if release steps changed.
6. Validate JSON, TOML templates, shell syntax, and required file presence.

## Release Checklist

Replace `<next-version>` with the target version (for example `0.6.2`). The checklist is the same for patch and minor bumps.

- [ ] Bump `.claude-plugin/plugin.json` version to `<next-version>`.
- [ ] Bump `.codex-plugin/plugin.json` version to `<next-version>`.
- [ ] Bump marketplace metadata version to `<next-version>` if present.
- [ ] Update README changelog with `<next-version>` notes.
- [ ] If the product name, agent set, or sync scripts changed, refresh the affected docs.
- [ ] Verify Claude Code can see or invoke DevConcept agents.
- [ ] Verify Codex can use synced DevConcept TOML agents.
- [ ] Run Lean smoke test in a real repo.
- [ ] Run Standard smoke test in a real repo.
- [ ] Run Full smoke test in a real repo.
- [ ] Run dispatch smoke test in Claude Code.
- [ ] Run dispatch smoke test in Codex.
- [ ] Confirm final handoffs include changed, verified, risk, and review-first sections.
- [ ] Append a row to `docs/smoke-test-results.md`.
- [ ] Tag release and push.

## Release Notes

### 0.6.4

- Stops shipping the plugin's own working state. Removes the committed `.devconcept/plans/2026-04-26-devconcept-v0.6.md` and gitignores `.devconcept/`. Planning ledgers are something the plugin teaches user repos to create, not an asset the plugin packages.
- Refreshes the README dispatch example to use named DevConcept agents (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`) instead of generic "subagent" phrasing, matching the named-agent guidance already in `dispatching-agents`.
- Softens the TDD planning step so the model answers "What should the public interface look like? Which behaviors are most important to test?" from the request and repo context first, and asks the user only when the answer would change implementation direction or product behavior. Better matches the DevConcept philosophy.
- Adds a `## Must Not` block to all four read-only agents (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`) forbidding mutating Bash. Lists safe inspection commands (`rg`, `grep`, `cat`, `ls`, `find`, `git diff`, `git status`, `git log`) and explicitly forbids `sed -i`, file redirects, installers, and rewriting formatters/linters.
- Adds an inline fallback to the `devconcept-core` Plan Review Rules so the checklist still runs when `devconcept-plan-reviewer` cannot be dispatched (Codex without the agent synced, or any session where subagents are unavailable). The verdict shape stays the same.
- Updates `docs/prd-devconcept-v0.6.md` to use `<next-version>` and the v0.6.x line instead of the original `0.6.0` checklist targets. The PRD's "Implemented by" line now lists 0.6.0 → 0.6.3 progression.

### 0.6.3

- Adds an explicit philosophy statement: "not ceremonial by default, but rigorous when the risk justifies it." Lives in the README intro and as a `## Philosophy` section in `skills/devconcept-core/SKILL.md` above the Mode Router so the runtime anchors on it before classifying a task.
- Adds a Cache Pruning Footgun section to this file explaining the safe order for refreshing the versioned `~/.claude/plugins/cache/built-by-harry/devconcept/<version>/` and Codex equivalent — build new cache, update the registry pointer (preferably via `/plugin update devconcept@built-by-harry`), restart, then prune older versions. Avoids the trap where deleting a cache the registry still references makes the plugin disappear from Claude Code.
- No skill router behavior, agent contracts, or output contracts changed; this is a copy + maintenance release on top of 0.6.2.

### 0.6.2

- Tightens Codex dispatch guidance with explicit named-agent invocation examples (`devconcept-explorer`, `devconcept-plan-reviewer`, `devconcept-code-reviewer`, `devconcept-debugger`, `devconcept-worker`).
- Simplifies the `.codex-plugin` `defaultPrompt` so the Lean / Standard / Full router is the dominant rule and the other behaviors (alignment, planning ledger, dispatch, design alternatives, TDD, systematic debugging, compounded learning) are conditional examples.
- Drops the project-level Codex sync target. `scripts/sync-codex-agents.sh` now writes only to `~/.codex/agents`; the `--project` flag is removed and running with no arguments is equivalent to `--user`.
- Moves manual workflow scenarios from `evals/devconcept-evals.md` to `docs/manual-smoke-tests.md` as a checkbox dogfood checklist (no scoring, no fixtures, no invented "settings screen / checkout cancellation" prompts). The old `evals/` directory is removed.
- Adds `docs/smoke-test-results.md` for lightweight per-run notes (date, runtime, repo, expected vs observed mode, agents used, verification, issues, follow-ups).
- Reframes the version-bump checklist around `<next-version>` instead of a fixed 0.6.0 target, and aligns the PRD title on the v0.6.x line.

### 0.6.0

- Renames the plugin and user-facing workflow to DevConcept.
- Adds `devconcept-core` and `using-devconcept`, the Lean / Standard / Full router, native DevConcept agents, Codex templates, runtime dispatch recipes, plan review, worker deviation protocol, and output contracts.

## Runtime Smoke Tests

Run these in real repositories where the target files and behavior exist. Do not use fake prompts that reference missing files.

- Lean: exact trivial edit. Expect no alignment block, no plan file, no agents, and narrow verification.
- Standard: small behavior fix or feature. Expect minimal context, alignment before edits, mini-plan, TDD when practical, and verification evidence.
- Vague feature: underspecified behavior. Expect focused questions and no invented product rules.
- Full/dispatch: multi-module work. Expect plan review, named Claude agents or explicit Codex spawn phrasing, and worker dispatch only for disjoint slices.
- Shared-root-cause debugging: several failures likely caused by one change. Expect systematic debugging or `devconcept-debugger` before worker dispatch.

## Release Flow

```sh
cd /Users/harry/Desktop/BuiltByHarry/devconcept
git checkout -b feat/<short-name>
# edit, validate, commit, push, open PR
```

Refresh Claude Code cache with plugin update or reinstall if supported. Otherwise overwrite the versioned cache from this source tree.

Refresh Codex cache manually when needed:

```sh
mkdir -p ~/.codex/plugins/cache/built-by-harry/devconcept/0.X.Y
rsync -a --delete --exclude='.git/' --exclude='.gitignore' \
  /Users/harry/Desktop/BuiltByHarry/devconcept/ \
  ~/.codex/plugins/cache/built-by-harry/devconcept/0.X.Y/
```

Then restart the runtime being validated.

## Cache Pruning Footgun

Claude Code tracks the active install version in `~/.claude/plugins/installed_plugins.json` under the `devconcept@built-by-harry` entry. The `installPath` field points at one specific versioned cache directory (for example `.../devconcept/0.6.1`). If that directory is deleted while the registry still points to it, the plugin disappears from Claude Code on the next launch.

Safe order when bumping the version:

1. Build the new versioned cache (`mkdir -p .../devconcept/<new-version>` + rsync).
2. Update the active install to the new version. Preferred: run `/plugin update devconcept@built-by-harry` (or uninstall + reinstall) inside Claude Code, which rewrites `installed_plugins.json` for you. Fallback: edit `installed_plugins.json` and set the entry's `installPath` to `.../devconcept/<new-version>`, `version` to `<new-version>`, and refresh `lastUpdated` and `gitCommitSha`.
3. Restart Claude Code.
4. Only then prune older versioned cache directories under `~/.claude/plugins/cache/built-by-harry/devconcept/`.

The same shape applies to Codex: `~/.codex/plugins/cache/built-by-harry/devconcept/<version>/` should not be deleted while a Codex session may still resolve to it. Build the new version first, restart, then prune.

## Rename / Migration Notes

- User-facing name: DevConcept.
- Plugin install slug: `devconcept`.
- Default operating skill: `devconcept-core`.
- First-turn bootstrap skill: `using-devconcept`.
- Agent prefix: `devconcept-`.
- New docs, examples, and templates should use DevConcept naming.
