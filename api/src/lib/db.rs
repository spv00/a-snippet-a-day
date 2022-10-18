#![allow(clippy::unwrap_used, clippy::expect_used)]

use super::models::*;
use mongodb::{options::InsertOneOptions, Client, Collection, Database};

pub async fn test() {
    let client = Client::with_uri_str("mongodb://127.0.0.1:27017")
        .await
        .unwrap();
    let database = client.database("a_snippet_a_day");
    let coll = database.collection::<SnippetGroup>("snippets");

    coll.insert_one(
        &SnippetGroup::new(
            "Test group".to_string(),
            "First test".to_string(),
            vec![
                "This is 'Hello World!'".to_string(),
                "In Rust, C and Python".to_string(),
            ],
            vec![Snippet::new(
                "Hello World in py".to_string(),
                Language::Python,
                "print(\"Hello World!\")".to_string(),
            )],
        ),
        InsertOneOptions::default(),
    )
    .await
    .unwrap();
}
