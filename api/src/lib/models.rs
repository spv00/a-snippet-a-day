use crate::db;
use futures::stream::TryStreamExt;
use mongodb::Collection;
use serde::{Deserialize, Serialize};

// A group of Snippets that make up a working bit of code like client.js and server.c or something
#[derive(Debug, Serialize, Deserialize, Default)]
pub struct SnippetGroup {
    pub id: i64,
    title: String,
    explanation: String,
    comments: Vec<String>,
    pub snippets: Vec<Snippet>,
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

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq)]
pub enum Language {
    Bash,
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
    pub id: i64,
    title: String,
    pub lang: Language,
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

pub struct SnippetCollection {
    pub coll: Collection<SnippetGroup>,
    pub snippet_groups: Vec<SnippetGroup>,
}

impl SnippetCollection {
    pub async fn init() -> Self {
        let coll = db::get_db().await.collection::<SnippetGroup>("snippets");
        let sgs = coll.find(None, None).await.unwrap();
        let out = sgs.try_collect().await.unwrap();

        Self {
            coll,
            snippet_groups: out,
        }
    }

    pub async fn update(mut self) -> Self {
        self.coll = db::get_db().await.collection::<SnippetGroup>("snippets");
        let sgs = self.coll.find(None, None).await.unwrap();
        self.snippet_groups = sgs.try_collect().await.unwrap();

        self
    }

    pub async fn insert(&self, snippet_group: SnippetGroup) -> mongodb::error::Result<()> {
        self.coll.insert_one(snippet_group, None).await?;
        Ok(())
    }

    pub fn filter(
        &self,
        mut sgs: Vec<SnippetGroup>,
        id: Option<i64>,
        lang: Option<Language>,
    ) -> Vec<SnippetGroup> {
        if let Some(id) = id {
            sgs.retain(|sg| sg.id == id);
        }
        if let Some(lang) = lang {
            sgs.retain(|sg| sg.snippets.iter().any(|s| s.lang == lang));
        }

        sgs
    }
}
