# Maintaining engineering-workflow

This plugin powers **both Claude Code and Codex CLI** from a single source tree:

```
~/Desktop/BuiltByHarry/engineering-workflow/   ← edit here (the dev clone)
```

Both tools point at this directory via symlinks. GitHub (`pewepw/engineering-workflow`) is used for backup/sharing, not runtime sourcing.

Do not maintain a second copy from `~/Desktop/BuiltByHarry/` itself. That parent directory may contain this dev clone as a nested folder, but the nested `engineering-workflow/` repository is the only source of truth for plugin edits, releases, tags, cache syncs, and pushes.

## Repo layout

```
.
├── .claude-plugin/
│   ├── plugin.json         # Claude Code plugin manifest
│   └── marketplace.json    # Claude Code marketplace (single-plugin wrapper)
├── .codex-plugin/
│   └── plugin.json         # Codex CLI plugin manifest (richer schema)
├── skills/
│   ├── aligning-requirements/SKILL.md
│   ├── compound-engineering/SKILL.md
│   ├── design-alternatives/SKILL.md
│   ├── dispatching-agents/SKILL.md
│   ├── engineering-defaults/SKILL.md
│   ├── finishing-work/SKILL.md
│   ├── planning-ledger/SKILL.md
│   ├── subagent-review/SKILL.md
│   ├── systematic-debugging/SKILL.md
│   ├── tdd/SKILL.md
│   └── using-engineering-defaults/SKILL.md
├── evals/
│   └── engineering-workflow-evals.md
├── README.md
├── MAINTENANCE.md          # this file
└── .gitignore
```

Skills are shared — same `SKILL.md` file powers both Claude Code and Codex. Only the top-level manifests differ.

## How the wiring works

- **Claude Code:** marketplace at `~/.claude/plugins/marketplaces/built-by-harry/` is a symlink → this dev clone. Registered in `~/.claude/plugins/known_marketplaces.json` as `source_type: directory`.
- **Codex CLI:** plugin dir at `~/.codex/plugins/engineering-workflow/` is a symlink → this dev clone. Registered in `~/.codex/config.toml` under `[marketplaces.built-by-harry]` (source `/Users/harry/.codex`), with a marketplace manifest at `~/.codex/.agents/plugins/marketplace.json` pointing at `./plugins/engineering-workflow`.
  - **Caveat:** Codex's marketplace manifest lives *outside* this repo (at `~/.codex/.agents/plugins/marketplace.json`). If you rebuild Codex from scratch, you'll need to recreate that file and the `[marketplaces.built-by-harry]` block in `~/.codex/config.toml`. The exact contents as of 0.3.0 are in the "One-time setup" section below.

Both tools copy from the source into a versioned cache:
- Claude Code: `~/.claude/plugins/cache/built-by-harry/engineering-workflow/<version>/`
- Codex CLI: `~/.codex/plugins/cache/built-by-harry/engineering-workflow/<version>/`

**The cache is versioned.** Editing a skill file alone does NOT force a cache rebuild — you must bump the version number in both `plugin.json` files first.

## Updating the plugin (standard flow)

1. **Edit** only inside `~/Desktop/BuiltByHarry/engineering-workflow/`. Do not mirror edits into the parent `~/Desktop/BuiltByHarry/` repo.

2. **Bump version** in both manifests (keep them in sync):
   - `.claude-plugin/plugin.json` → `"version": "0.X.Y"`
   - `.codex-plugin/plugin.json` → `"version": "0.X.Y"`
   - Also bump `version` inside `.claude-plugin/marketplace.json`'s plugin entry if it's duplicated there.

3. **Update the README changelog** (optional but recommended).

4. **Commit + push to GitHub** (backup):
   ```sh
   cd ~/Desktop/BuiltByHarry/engineering-workflow
   git checkout -b feat/<short-name>
   git add .
   git commit -m "feat: <summary>"
   git push -u origin feat/<short-name>
   gh pr create --fill && gh pr merge --rebase --delete-branch
   git checkout master && git pull --ff-only
   git tag -a v0.X.Y -m "v0.X.Y: <summary>" && git push origin v0.X.Y
   ```

5. **Refresh Claude Code cache** — one of:
   - `/plugin update engineering-workflow@built-by-harry` (preferred if supported for directory sources)
   - or `/plugin uninstall engineering-workflow@built-by-harry` then `/plugin install engineering-workflow@built-by-harry`
   - Restart Claude Code after.

6. **Refresh Codex cache:**
   - As of `codex-cli 0.120.0`, there is no `codex plugin` subcommand — Codex does not automatically populate a new version cache on restart. Seed the versioned cache folder manually:
     ```sh
     mkdir -p ~/.codex/plugins/cache/built-by-harry/engineering-workflow/0.X.Y
     rsync -a --delete --exclude='.git/' --exclude='.gitignore' --exclude='README.md' --exclude='MAINTENANCE.md' \
       ~/Desktop/BuiltByHarry/engineering-workflow/ \
       ~/.codex/plugins/cache/built-by-harry/engineering-workflow/0.X.Y/
     ```
   - Restart Codex after.
   - If a future Codex CLI adds `codex plugin install/uninstall`, prefer those over rsync.

7. **Verify:**
   ```sh
   cat ~/.claude/plugins/cache/built-by-harry/engineering-workflow/0.X.Y/.claude-plugin/plugin.json
   cat ~/.codex/plugins/cache/built-by-harry/engineering-workflow/0.X.Y/.codex-plugin/plugin.json
   ```
   Both should show the new version. Skill list should include any new skills.

## Quick edit (no version bump)

For tiny fixes (typos, wording tweaks) where you don't want to cut a release:

1. Edit in `~/Desktop/BuiltByHarry/engineering-workflow/skills/...`
2. Force-refresh the cache manually — delete the versioned cache folder and reinstall, or overwrite in place:
   ```sh
   # Claude Code
   rsync -av --delete --exclude='.git/' --exclude='.gitignore' --exclude='README.md' --exclude='MAINTENANCE.md' \
     ~/Desktop/BuiltByHarry/engineering-workflow/ \
     ~/.claude/plugins/cache/built-by-harry/engineering-workflow/0.X.Y/

   # Codex
   rsync -av --delete --exclude='.git/' --exclude='.gitignore' --exclude='README.md' --exclude='MAINTENANCE.md' \
     ~/Desktop/BuiltByHarry/engineering-workflow/ \
     ~/.codex/plugins/cache/built-by-harry/engineering-workflow/0.X.Y/
   ```
3. Restart both tools.

This is a last resort — prefer the versioned release flow.

## One-time setup (already done, documented for reproducibility)

If this machine is ever re-set up from scratch:

```sh
# 1. Clone dev repo
mkdir -p ~/Desktop/BuiltByHarry
cd ~/Desktop/BuiltByHarry
git clone https://github.com/pewepw/engineering-workflow.git

# 2. Claude Code marketplace symlink
rm -rf ~/.claude/plugins/marketplaces/built-by-harry
ln -s ~/Desktop/BuiltByHarry/engineering-workflow ~/.claude/plugins/marketplaces/built-by-harry

# 3. Codex plugin symlink
rm -rf ~/.codex/plugins/engineering-workflow
ln -s ~/Desktop/BuiltByHarry/engineering-workflow ~/.codex/plugins/engineering-workflow

# 4. Codex marketplace manifest (external to repo — recreate if missing)
mkdir -p ~/.codex/.agents/plugins
cat > ~/.codex/.agents/plugins/marketplace.json <<'EOF'
{
  "name": "built-by-harry",
  "interface": {
    "displayName": "Built by Harry"
  },
  "plugins": [
    {
      "name": "engineering-workflow",
      "source": {
        "source": "local",
        "path": "./plugins/engineering-workflow"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
EOF

# 5. Codex config block (in ~/.codex/config.toml)
#    Add if not present:
#    [marketplaces.built-by-harry]
#    source_type = "local"
#    source = "/Users/harry/.codex"
#
#    [plugins."engineering-workflow@built-by-harry"]
#    enabled = true

# 6. Install in both tools
#    Claude Code:
/plugin install engineering-workflow@built-by-harry
#    Codex CLI:
codex plugin install engineering-workflow@built-by-harry
```

## Why not github-sourced marketplaces?

Claude Code supports `source_type: github` for marketplaces — tempting, because it gives a "push → auto-pull" flow. But **Codex's marketplace system doesn't support github sources** (as of this writing, all `~/.codex/config.toml` marketplaces use `source_type = "local"`). Making Claude github-sourced while Codex stays local creates two different update procedures — you end up remembering "Claude pulls, Codex doesn't" every single time.

Symmetric local symlinks give one mental model. GitHub is demoted to backup/sharing only. The small cost is one extra `rsync`-to-cache step instead of a `/plugin update` — but you were going to restart the tool anyway, so it's a wash.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with frontmatter:
   ```
   ---
   name: <skill-name>
   description: Use when ... <trigger conditions>
   ---

   # <Title>
   ...
   ```
2. Follow the update flow above (bump version, commit, refresh caches).
3. Update `README.md`'s skill list.

## Removing a skill

1. Delete `skills/<skill-name>/` from the dev clone.
2. Remove any cross-references in `engineering-defaults/SKILL.md` and `README.md`.
3. Follow the update flow above.
4. After refreshing caches, verify the skill is gone from both tools' skill lists.
