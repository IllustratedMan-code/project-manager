#[derive(clap::ValueEnum, Debug, Clone)]
pub enum Shell {
    Bash,
    Fish,
    Zsh,
    Nushell,
    Posix,
}

impl Shell {
    pub fn init(self, name: String) {
        match self {
            Self::Bash => println!("{}", replace(include_str!("shells/pm.bash"), &name)),
            Self::Zsh => println!("{}", replace(include_str!("shells/pm.zsh"), &name)),
            Self::Nushell => println!("{}", replace(include_str!("shells/pm.nu"), &name)),
            _ => println!("uninmplemented"),
        }
    }
}

fn replace(s: &str, name: &str) -> String {
    s.replace("{{name}}", name)
}
