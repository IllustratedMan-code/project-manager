use clap::{ArgGroup, Parser};
use dirs::data_dir;
use std::path::PathBuf;
mod shells;
use shells::Shell;
mod data;

#[derive(Parser, Debug)]
#[command(version, about)]
#[clap(group(
    ArgGroup::new("args")
    .required(true)
    .args(&["init", "list", "project", "new", "remove"])))]
struct Args {
    #[arg(long)]
    init: Option<Shell>,

    #[arg(long)]
    init_name: Option<String>,

    #[arg(long)]
    project: Option<String>,

    #[arg(long)]
    list: bool,

    #[arg(long)]
    new: Option<String>,

    #[arg(long)]
    remove: Option<String>,
}

fn main() -> std::io::Result<()> {
    let args = Args::parse();

    if let Some(v) = args.init {
        let name;
        if let Some(v) = args.init_name {
            name = v;
        }else{
            name = "pj".to_string()
        }
        v.init(name);
        return Ok(());
    }

    if args.list {
        list_projects()?; 
    }

    if let Some(v) = args.new {
        add_project(v, std::env::current_dir()?)?;
    }

    if let Some(v) = args.project {
        println!("{}", read_project_path(v)?.display()); // may be lossy conversion of paths?
    }

    if let Some(v) = args.remove {
        remove_project(v)?; 
    }

    

    Ok(())
}

fn list_projects() -> std::io::Result<()> {
    let data_path = check_data_dir_exists()?;
    let data = data::parse_data(&data_path)?;

    for (k,v) in data{
        println!("{}: {}", k, v.path.display());
    }
    Ok(())
}

fn add_project(name: String, path: PathBuf) -> std::io::Result<()> {
    let p = data::Project::new(path);
    let data_path = check_data_dir_exists()?;
    let mut data = data::parse_data(&data_path)?;

    data.insert(name, p);

    data::write_data(&data_path, data)?;
    Ok(())
}

fn read_project_path(name: String) -> std::io::Result<PathBuf> {
    let data_path = check_data_dir_exists()?;
    let data = data::parse_data(&data_path)?;

    let p = data.get(&name).ok_or(std::io::Error::new(
        std::io::ErrorKind::NotFound,
        format!(
            "{} is not a valid project! Try adding it with --new first",
            name
        ),
    ))?;
    Ok(p.path.clone())
}

fn remove_project(name: String) -> std::io::Result<()> {
    let data_path = check_data_dir_exists()?;
    let mut data = data::parse_data(&data_path)?;

    data.remove(&name).ok_or(std::io::Error::new(
        std::io::ErrorKind::NotFound,
        format!(
            "{} is not a valid project! Try adding it with --new first",
            name
        ),
    ))?;

    data::write_data(&data_path, data)?;

    Ok(())
}

fn check_data_dir_exists() -> std::io::Result<PathBuf> {
    let mut d = data_dir().ok_or(std::io::Error::new(
        std::io::ErrorKind::NotFound,
        "There is no user-data directory setup!",
    ))?;

    let f_name = "project.json";
    d.push("project-manager");

    if d.is_dir() {
        d.push(f_name);
        if !d.is_file() {
            std::fs::write(&d, "{}")?
        }
    } else {
        std::fs::create_dir_all(&d)?;
        d.push(f_name);
        std::fs::write(&d, "{}")?
    }

    Ok(d)
}
