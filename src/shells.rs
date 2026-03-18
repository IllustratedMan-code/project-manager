
#[derive(clap::ValueEnum, Debug, Clone)]
pub enum Shell{
    Bash,
    Fish,
    Zsh,
    Posix
}


impl Shell{
    pub fn init(self){
        match self{
            Self::Bash => println!("{}",include_str!("shells/pm.bash")),
            Self::Zsh => println!("{}",include_str!("shells/pm.zsh")),
            _ => println!("uninmplemented")
            
        }
    }
}
