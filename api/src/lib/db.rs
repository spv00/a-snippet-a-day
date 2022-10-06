#![allow(clippy::unwrap_used, clippy::expect_used)]

use super::models::*;
use futures::stream::TryStreamExt;
use mongodb::{options::InsertOneOptions, Client, Collection, Database};

pub async fn get_db() -> Database {
    let client = Client::with_uri_str("mongodb://127.0.0.1:27017")
        .await
        .unwrap();
    client.database("a_snippet_a_day")
}

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
            vec![
                Snippet::new(
                    "Hello World in py".to_string(),
                    Language::Python,
                    r#"
                    print("Hello World!")
                    "#
                    .to_string(),
                ),
                Snippet::new(
                    "Hello World in C".to_string(),
                    Language::C,
                    r#"
                    #include <stdio.h>

                    int main() {
                        printf("Hello World!");
                        return 0;
                    }
                    "#
                    .to_string(),
                ),
                Snippet::new(
                    "Rust snippet".to_string(),
                    Language::Rust,
                    r#"
                    fn main() {
                        println!("Hello World!");
                    }
                    "#
                    .to_string(),
                ),
            ],
        ),
        InsertOneOptions::default(),
    )
    .await
    .unwrap();
}

pub async fn insert_snippet_group(snippet_group: SnippetGroup) -> mongodb::error::Result<()> {
    get_db()
        .await
        .collection("snippets")
        .insert_one(snippet_group, None)
        .await?;
    Ok(())
}

pub async fn get_snippet_groups(coll: &Collection<SnippetGroup>) -> Vec<SnippetGroup> {
    let mut cursor = coll.find(None, None).await.unwrap();
    cursor.try_collect().await.unwrap()
}
