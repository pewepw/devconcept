# DevConcept v0.6.0 Plan

## Goal
Implement the DevConcept v0.6.0 PRD in the plugin source tree.

## Alignment
- Understanding: rename the user-facing workflow to DevConcept, add a mode router, native agents, Codex templates, dispatch rules, plan review/deviation rules, output contracts, docs, manifests, and release checklist.
- Scope: `/Users/harry/Desktop/BuiltByHarry/devconcept` only; the parent duplicate is not the source of truth.
- Open questions: none blocking.

## Success Criteria
- [ ] `docs/prd-devconcept-v0.6.md` exists in the nested plugin repo.
- [ ] DevConcept mode router and output contracts are present in the default-facing workflow skill.
- [ ] Five DevConcept agents and five Codex TOML templates exist.
- [ ] Dispatch, plan review, deviation, and final handoff contracts are documented.
- [ ] README, maintenance docs, and manifests describe DevConcept v0.6.0.
- [x] Static validation passes for JSON, TOML, shell syntax, and required file presence.

## Plan
- [x] Phase 1: add durable PRD copy and release ledger.
- [x] Phase 2: add `devconcept-core`, add `using-devconcept`, and update existing workflow skills.
- [x] Phase 3: add agents, Codex templates, and sync script.
- [x] Phase 4: update dispatch/review/debug/TDD/finishing contracts.
- [x] Phase 5: update README, maintenance docs, manifests, and changelog.
- [x] Phase 6: validate and review diff.

## Findings
- `MAINTENANCE.md` identifies the nested `devconcept/` repo as the only source of truth.
- The nested repo was clean on `master...origin/master` before edits.
- The parent `/Users/harry/Desktop/BuiltByHarry` repo contains the PRD as an untracked file.

## Decisions
| Decision | Rationale |
| --- | --- |
| Keep `devconcept-core` plus `using-devconcept` | Preserves first-turn bootstrap behavior with clean DevConcept naming. |
| Use static validation instead of TDD | This release changes plugin instructions, docs, and packaging assets; there is no executable behavior test harness in scope. |

## Verification
- `python3` JSON/TOML/required-file/version check: passed.
- `bash -n scripts/sync-codex-agents.sh`: passed.
- `git diff --check`: passed.
- `scripts/sync-codex-agents.sh --project <tempdir>`: synced five TOML templates.
- Expected Output coverage check across `skills/*/SKILL.md`: passed.
- GitHub repo rename check: `pewepw/devconcept` resolves.
- Old slug search for `engineering-workflow` across docs, manifests, skills, agents, templates, scripts, and evals: no matches.

## Progress
- 2026-04-26: scope aligned; branch created; PRD copied into `docs/`.
- 2026-04-26: added DevConcept core skill, agent templates, sync script, output contracts, docs, manifests, and manual eval updates.
- 2026-04-26: validation completed; no automated runtime smoke tests were run.
- 2026-04-26: renamed plugin slug, GitHub repo, local folder, manual eval path, and planning ledger directory to `devconcept`.
- 2026-04-26: replaced the old first-turn bootstrap with `using-devconcept`, pointing directly at `devconcept-core`.
