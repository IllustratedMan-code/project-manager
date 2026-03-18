pm() {
  # pm --new <n>
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

  # pm <n>  →  cd into named project
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
# Autocomplete (zsh)
# ---------------------------------------------------------------------------
_pm_completions() {
  local -a projects flags

  flags=(
    '--new:add current directory as a new project'
    '--remove:remove a project'
  )

  # Load project names lazily
  projects=( ${(f)"$(project-manager --list 2>/dev/null | cut -d: -f1)"} )

  local state
  _arguments \
    '1: :->first' \
    '2: :->second' && return

  case "$state" in
    first)
      # offer flags or project names
      _describe 'flags' flags
      _describe 'projects' projects
      ;;
    second)
      case "${words[2]}" in
        --remove|--project)
          _describe 'projects' projects ;;
        --new)
          # free-form; no completions
          ;;
      esac
      ;;
  esac
}

compdef _pm_completions pm
