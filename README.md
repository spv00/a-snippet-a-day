# a_snippet_a_day

A project where you basically get code snippets.

Snippets are stored in a mongodb database, and are served to the user via a REST API.
the "snippets" collection of the database is structured into Snippet Groups which hold info about the group and the snippets in it.

For example
```
SnippetGroup::new(
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
        )
```