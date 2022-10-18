use futures::stream::TryStreamExt;
use mongodb::{Client, Collection, Database};
use serde::{Deserialize, Serialize};
use std::ops::DerefMut;

use crate::db;

/// A group of Snippets that make up a working bit of code like client.js and server.c or something
/// ```rust
/// SnippetGroup::new(
/// "Test group".to_string(),
/// "First test".to_string(),
/// vec![
///     "This is 'Hello World!'".to_string(),
///     "In Rust, C and Python".to_string(),
/// ],
/// vec![
///     Snippet::new(
///         "Hello World in py".to_string(),
///         Language::Python,
///         r#"
///         print("Hello World!")
///         "#
///         .to_string(),
///     ),
///     Snippet::new(
///         "Hello World in C".to_string(),
///         Language::C,
///         r#"
///         #include <stdio.h>
///
///         int main() {
///             printf("Hello World!");
///             return 0;
///         }
///         "#
///         .to_string(),
///     ),
///     Snippet::new(
///         "Rust snippet".to_string(),
///         Language::Rust,
///         r#"
///         fn main() {
///             println!("Hello World!");
///         }
///         "#
///         .to_string(),
///     ),
/// ],
/// )
/// ```
#[derive(Debug, Serialize, Deserialize, Default, Clone)]
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

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Clone, strum::EnumString)]
pub enum Language {
    All,
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
    Markdown,
}

impl Default for Language {
    fn default() -> Self {
        Language::All
    }
}

/// A snippet. a single file of code
/// ```rust
/// Snippet::new(
///     "Hello World in py".to_string(),
///     Language::Python,
///     "print(\"Hello World!\")".to_string(),
/// )
/// ```
#[derive(Debug, Serialize, Deserialize, Default, Clone)]
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

/// A collection of SnippetGroups queried directly from the database for ease of use and consistency.
/// ```rust
/// let db = SnippetCollection::init().await;
/// db.filter(None, Some(Language::Python));
/// ```

#[derive(Debug, Clone)]
pub struct SnippetCollection {
    pub coll: Collection<SnippetGroup>,
    pub snippet_groups: Vec<SnippetGroup>,
}

/// Collection of snippets from the database
/// ```rust
/// let snippet_collection = SnippetCollection::init().await;
/// println!("{}", snippet_collection.snippet_groups.len());
/// snippet_collection.update().await;
/// ```
impl SnippetCollection {
    /// Get the database.
    pub async fn get_db() -> mongodb::error::Result<Database> {
        let client = Client::with_uri_str("mongodb://127.0.0.1:27017").await?;
        Ok(client.database("a_snippet_a_day"))
    }

    /// Initialize the collection
    pub async fn init() -> mongodb::error::Result<Self> {
        let coll = Self::get_db().await?.collection::<SnippetGroup>("snippets");
        let sgs = coll.find(None, None).await?;
        let out = sgs.try_collect().await?;

        Ok(Self {
            coll,
            snippet_groups: out,
        })
    }

    /// Update the collection of a SnippetCollection Object.
    /// ```rust
    /// let snippet_collection = SnippetCollection::init().await;
    /// // This syncs the collection of snippet_collection with the database.
    /// snippet_collection.update().await.unwrap();
    /// ```
    pub async fn update(mut self) -> mongodb::error::Result<Self> {
        self.coll = Self::get_db().await?.collection::<SnippetGroup>("snippets");
        let sgs = self.coll.find(None, None).await?;
        self.snippet_groups = sgs.try_collect().await?;

        Ok(self)
    }

    /// Insert a SnippetCollection Element into the Database.
    /// ```rust
    /// let snippet_collection = SnippetCollection::init().await;
    /// let snippet_group = SnippetGroup::default();
    /// snippet_collection.insert(snippet_group).await;
    pub async fn insert(&self, snippet_group: SnippetGroup) -> mongodb::error::Result<()> {
        self.coll.insert_one(snippet_group, None).await?;
        Ok(())
    }

    /// Filter the collection by id or lang (Both as option in first and second argument)
    /// ```rust
    /// let coll = SnippetCollection::init().await;
    /// // This will return all snippets with id=1 **OR** lang=Python
    /// coll.filter(Some(1), Some(Language::Python));
    /// // This will return all snippets
    /// coll.filter(None, None);
    /// ```
    pub fn filter(&self, id: Option<i64>, lang: Option<Vec<Language>>) -> Vec<SnippetGroup> {
        if id.is_none() && lang.is_none() {
            return self.snippet_groups.clone();
        }
        let mut out: Vec<SnippetGroup> = Vec::new();
        for sg in self.snippet_groups.iter() {
            if let Some(id) = id {
                if sg.id == id {
                    out.push(sg.clone());
                }
            }
            if let Some(langs) = lang.clone() {
                for snippet in sg.snippets.iter() {
                    for l in langs.iter() {
                        if snippet.lang == l.clone() {
                            out.push(sg.clone());
                        }
                    }
                }
            }
        }

        out
    }
}
