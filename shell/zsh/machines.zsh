mini() {
  emulate -L zsh
  setopt pipefail

  local mode="${1:-shell}"
  local color="${MINI_WORKSPACE_COLOR:-#3ABF7A}"
  local shell_title="${MINI_SHELL_TITLE:-Mac Mini}"
  local lan_shell_title="${MINI_LAN_SHELL_TITLE:-Mac Mini LAN}"
  local monitor_title="${MINI_MONITOR_TITLE:-Mac Mini Monitor}"
  local lan_monitor_title="${MINI_LAN_MONITOR_TITLE:-Mac Mini Monitor LAN}"
  local host_alias="${MINI_HOST_ALIAS:-macmini}"
  local lan_host_alias="${MINI_LAN_HOST_ALIAS:-macmini-lan}"
  local monitor_bin="${MINI_MONITOR_BIN:-/opt/homebrew/bin/btop}"
  local host
  local workspace

  host="$(ssh -G "$host_alias" 2>/dev/null | awk '$1 == "hostname" { print $2; exit }')"
  if [[ -z "$host" ]]; then
    printf '%s\n' \
      "The '$host_alias' host alias is missing from ~/.ssh/config." \
      "Run the dotfiles installer again or add the Host entry manually."
    return 1
  fi

  case "$mode" in
    shell)
      cmux ssh "$host_alias" --name "$shell_title"
      ;;
    lan)
      cmux ssh "$lan_host_alias" --name "$lan_shell_title"
      ;;
    monitor)
      cmux ssh "$host_alias" --name "$monitor_title" --ssh-option RequestTTY=force -- "$monitor_bin"
      ;;
    monitor-lan)
      cmux ssh "$lan_host_alias" --name "$lan_monitor_title" --ssh-option RequestTTY=force -- "$monitor_bin"
      ;;
    ssh|raw)
      ssh "$host_alias"
      return
      ;;
    ssh-lan|raw-lan)
      ssh "$lan_host_alias"
      return
      ;;
    *)
      printf '%s\n' "Usage: mini [shell|lan|monitor|monitor-lan|ssh|ssh-lan]"
      return 2
      ;;
  esac

  workspace="$(cmux current-workspace 2>/dev/null | awk 'NR == 1 { print $1; exit }')"
  if [[ -n "$workspace" ]]; then
    cmux workspace-action --workspace "$workspace" --action pin >/dev/null 2>&1 || true
    cmux workspace-action --workspace "$workspace" --action set-color --color "$color" >/dev/null 2>&1 || true
  fi
}
