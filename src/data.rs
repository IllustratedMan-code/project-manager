use std::collections::HashMap;
use serde_json;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct Project{
    pub path: std::path::PathBuf,
}

impl Project{
    pub fn new(path: std::path::PathBuf) -> Self{
        Self{
            path
        }
    } 
}


pub fn parse_data(path: &std::path::PathBuf) -> std::io::Result<HashMap<String, Project>>{
    let file = std::fs::read_to_string(path)?;

    let data: HashMap<String, Project> = serde_json::from_str(&file)?;
    
    Ok(data)
}


pub fn write_data(path: &std::path::PathBuf, data: HashMap<String, Project>) -> std::io::Result<()>{
    
    let data = serde_json::to_string(&data)?;
    std::fs::write(path, data)?;
    Ok(())
}
