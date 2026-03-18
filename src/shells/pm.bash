pm() {
  # pm --new <name>
  if [[ "$1" == "--new" ]]; then
    if [[ -z "$2" ]]; then
      echo "Usage: pm --new <project_name>" >&2
      return 1
    fi
    project-manager --new "$2"
    return

  # pm --remove [name]
  elif [[ "$1" == "--remove" ]]; then
    if [[ -n "$2" ]]; then
      project-manager --remove "$2"
    else
      local selected
      selected=$(project-manager --list | fzf --prompt="Remove project: " | cut -d: -f1)
      [[ -n "$selected" ]] && project-manager --remove "$selected"
    fi
    return

  # pm <name>  →  cd into named project
  elif [[ -n "$1" ]]; then
    local target
    target=$(project-manager --project "$1") || return 1
    cd "$target" || return 1
    return
  fi

  # pm  →  fzf picker, cd into selection
  local selected
  selected=$(project-manager --list | fzf --prompt="Project: " | cut -d: -f1)
  if [[ -n "$selected" ]]; then
    local target
    target=$(project-manager --project "$selected") || return 1
    cd "$target" || return 1
  fi
}

# ---------------------------------------------------------------------------
# Autocomplete
# ---------------------------------------------------------------------------
_pm_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Flags always available at position 1
  local flags="--new --remove"

  case "$prev" in
    pm)
      # offer flags + project names
      local projects
      projects=$(project-manager --list 2>/dev/null | cut -d: -f1)
      COMPREPLY=( $(compgen -W "$flags $projects" -- "$cur") )
      ;;
    --remove|--project)
      # complete with project names
      local projects
      projects=$(project-manager --list 2>/dev/null | cut -d: -f1)
      COMPREPLY=( $(compgen -W "$projects" -- "$cur") )
      ;;
    --new)
      # free-form name — no completions
      COMPREPLY=()
      ;;
    *)
      COMPREPLY=()
      ;;
  esac
}

complete -F _pm_completions pm
