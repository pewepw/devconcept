#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/sync-codex-agents.sh [--project DIR | --user]

Copies DevConcept Codex agent templates into a Codex agents directory.

Targets:
  --project DIR   Copy to DIR/.codex/agents
  --user          Copy to ~/.codex/agents

If no target is provided, --project . is used.
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/.." && pwd)"
source_dir="$repo_dir/templates/codex-agents"
target_dir=""

if [[ ! -d "$source_dir" ]]; then
  echo "Missing template directory: $source_dir" >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  target_dir="$PWD/.codex/agents"
else
  case "${1:-}" in
    --project)
      if [[ $# -ne 2 ]]; then
        usage >&2
        exit 1
      fi
      target_dir="$2/.codex/agents"
      ;;
    --user)
      if [[ $# -ne 1 ]]; then
        usage >&2
        exit 1
      fi
      target_dir="$HOME/.codex/agents"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$target_dir"
cp "$source_dir"/devconcept-*.toml "$target_dir"/

echo "Synced DevConcept Codex agents to $target_dir"
