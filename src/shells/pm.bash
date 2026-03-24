{{name}}() {
  # {{name}} --new <name>
  if [[ "$1" == "--new" ]]; then
    if [[ -z "$2" ]]; then
      echo "Usage: pm --new <project_name>" >&2
      return 1
    fi
    project-jump --new "$2"
    return

  # {{name}} --remove [name]
  elif [[ "$1" == "--remove" ]]; then
    if [[ -n "$2" ]]; then
      project-jump --remove "$2"
    else
      local selected
      selected=$(project-jump --list | fzf --prompt="Remove project: " | cut -d: -f1)
      [[ -n "$selected" ]] && project-jump --remove "$selected"
    fi
    return

  # {{name}} <name>  →  cd into named project
  elif [[ -n "$1" ]]; then
    local target
    target=$(project-jump --project "$1") || return 1
    cd "$target" || return 1
    return
  fi

  # {{name}}  →  fzf picker, cd into selection
  local selected
  selected=$(project-jump --list | fzf --prompt="Project: " | cut -d: -f1)
  if [[ -n "$selected" ]]; then
    local target
    target=$(project-jump --project "$selected") || return 1
    cd "$target" || return 1
  fi
}

# ---------------------------------------------------------------------------
# Autocomplete
# ---------------------------------------------------------------------------
_{{name}}_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Flags always available at position 1
  local flags="--new --remove"

  case "$prev" in
    pm)
      # offer flags + project names
      local projects
      projects=$(project-jump --list 2>/dev/null | cut -d: -f1)
      COMPREPLY=( $(compgen -W "$flags $projects" -- "$cur") )
      ;;
    --remove|--project)
      # complete with project names
      local projects
      projects=$(project-jump --list 2>/dev/null | cut -d: -f1)
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

complete -F _{{name}}_completions {{name}}
