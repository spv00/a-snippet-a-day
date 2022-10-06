use serde::{Deserialize, Serialize};

// A group of Snippets that make up a working bit of code like client.js and server.c or something
#[derive(Debug, Serialize, Deserialize, Default)]
pub struct SnippetGroup {
    id: i64,
    title: String,
    explanation: String,
    comments: Vec<String>,
    snippets: Vec<Snippet>,
}

impl SnippetGroup {
    pub fn new(
        title: String,
        explanation: String,
        comments: Vec<String>,
        snippets: Vec<Snippet>,
    ) -> Self {
        Self {
            id: 0,
            title: title,
            explanation: explanation,
            comments,
            snippets,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Language {
    Python,
    Rust,
    C,
    Cpp,
    Csharp,
    Go,
    Java,
    Javascript,
    Kotlin,
    Php,
    Swift,
    Typescript,
    Dart,
    Ruby,
    Html,
    Css,
    Scala,
    Haskell,
}

impl Default for Language {
    fn default() -> Self {
        Language::Python
    }
}

// A snippet. a single file of code
#[derive(Debug, Serialize, Deserialize, Default)]
pub struct Snippet {
    id: i64,
    title: String,
    lang: Language,
    code: String,
}

impl Snippet {
    pub fn new(title: String, lang: Language, code: String) -> Self {
        Snippet {
            id: 0,
            title,
            lang,
            code,
        }
    }
}
