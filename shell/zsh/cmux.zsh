localws() {
  emulate -L zsh
  setopt pipefail

  local target="${1:-$PWD}"
  local title="${2:-${target:t}}"
  local workspace

  workspace="$(cmux new-workspace --cwd "$target" --name "$title" 2>/dev/null | awk 'NR == 1 { print $1; exit }')"
  if [[ -z "$workspace" ]]; then
    cmux "$target"
    workspace="$(cmux current-workspace 2>/dev/null | awk 'NR == 1 { print $1; exit }')"
  fi

  if [[ -n "$workspace" ]]; then
    cmux workspace-action --workspace "$workspace" --action pin >/dev/null 2>&1 || true
    cmux workspace-action --workspace "$workspace" --action set-color --color blue >/dev/null 2>&1 || true
  fi
}

thismac() {
  localws "${1:-$PWD}" "${2:-${LOCAL_WORKSPACE_TITLE:-This Mac}}"
}

cx() {
  localws "${1:-$PWD}"
}

alias mymac="thismac"

