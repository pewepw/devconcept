#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/sync-codex-agents.sh [--user]

Copies DevConcept Codex agent templates into ~/.codex/agents.

The user-level target is the only supported destination. The flag exists
for clarity; running with no arguments has the same effect.
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/.." && pwd)"
source_dir="$repo_dir/templates/codex-agents"

if [[ ! -d "$source_dir" ]]; then
  echo "Missing template directory: $source_dir" >&2
  exit 1
fi

case "${1:-}" in
  ""|--user)
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

mkdir -p "$target_dir"
cp "$source_dir"/devconcept-*.toml "$target_dir"/

echo "Synced DevConcept Codex agents to $target_dir"
