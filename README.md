# Project-Jump

![](assets/demo.gif)

Project-jump is a CLI tool for saving commonly visited directories
and provides a fuzzy menu for selecting a project directory to visit.

## Usage

```shell
pj --help
pj --new PROJECT_NAME # adds current directory to project list as PROJECT_NAME
pj --remove PROJECT_NAME # removes a directory from the project list
pj PROJECT_NAME # changes current directory to that of PROJECT_NAME
```

## Installation

First, you'll need to install the `project-jump` binary:

<details>
<summary>With Cargo</summary>

```shell
cargo install project-jump
```

</details>

<details>
<summary>Nix flake</summary>
Add this flake to your inputs:

```nix
inputs = {
	project-jump.url = "github:IllustratedMan-code/project-jump"
}
```

Then add the default package to your system packages somewhere:

```nix
{inputs, ...}:
{
 environment.systemPackages = [inputs.project-jump.packages.x86_64-linux.default];
}
```

</details>

Then, you'll need to initialize the `pj` function in your shell:

<details>
<summary>Bash</summary>

Add to the end of your `~/.bashrc`

```shell
eval "$(project-jump --init bash)"
```

</details>

<details>
<summary>Zsh</summary>

Add to the end of your ~/.zshrc

```shell
eval "$(project-jump --init zsh)"
```

</details>

<details>
<summary>Nushell</summary>

Add to the end of your env file (`$nu.env-path`)

```shell
project-jump --init nushell | save -f ~/.config/nushell/pj.nu
```

Then add this to the end of your config file (`$nu.config-path`)

```shell
source ~/.config/nushell/pj.nu
```

</details>

You should be good to go! Open a new shell and type `pj` to get started.
