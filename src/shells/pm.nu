
# Completions for {{name}}

#

def "nu-complete {{name}} projects" [] {
  ^project-jump --list
  | lines
  | each { |l|
      let parts = ($l | split row ": ")
      { value: ($parts | first), description: ($parts | last) }
  }
}

# def "nu-complete {{name}} first-arg" [] {
#   let flags = [
#     { value: "--new",    description: "Add current directory as a new project" },
#     { value: "--remove", description: "Remove a project" },
#   ]
#   $flags | append (nu-complete {{name}} projects)
# }

# =============================================================================
# Command for {{name}}.
#

def --env {{name}} [
  project?: string@"nu-complete {{name}} projects" # switch to project
  --new: string # add current dir to projects
  --remove: string@"nu-complete {{name}} projects" # remove project
] {

  if $project != null {
    cd (project-jump --project $project)
  } else if $new != null {
    project-jump --new $new
  } else if $remove != null {
    project-jump --remove $remove
  } else {
      let selected = (
        ^project-jump --list
        | ^fzf --prompt="Project: "
        | split row ": "
	| first 
      )
      if $selected != "" {
        cd (^project-jump --project $selected )
      }
  }
}
