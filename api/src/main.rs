#![warn(missing_docs)]

//! Main rust backend for my a-snippet-a-day project. This is the api for parsing, processing and database integration.

use actix_cors::*;
use actix_web::{web::Json, *};
use std::str::FromStr;

mod lib;
use lib::{models::*, *};
use rand::Rng;

/// Get snippet. returns a list of snippets that match a set of rules. You can filter these by querying "id" and "lang".
/// This will return a list of snippets that EITHER parameter of the query.
/// `/snippet?id=5&lang=python` will return every snippet that EITHER has the id 5 OR the language python.
/// This is only the backend. This will only return valid json or an internal server error.
#[get("/snippet")]
async fn snippet(query: web::Query<std::collections::HashMap<String, String>>) -> HttpResponse {
    let mut langs: Vec<Language> = vec![];
    if let Some(ls) = query.get("lang") {
        let ls = ls
            .split(' ')
            .map(|x| x.to_string())
            .collect::<Vec<String>>();

        for l in ls {
            #[allow(clippy::unwrap_used)]
            // Weird magic shit to uppercase the first char cuz strum only accepts the correctly cased version of a string :)
            let l = l.chars().next().unwrap().to_uppercase().to_string() + &l[1..].to_lowercase();
            if let Ok(l) = Language::from_str(&l) {
                langs.push(l);
            }
        }
    }

    match serde_json::to_string(&SnippetCollection::init().await.unwrap().filter(
        query.get("id").and_then(|x| x.parse::<i64>().ok()),
        if langs.is_empty() { None } else { Some(langs) },
    )) {
        Ok(s) => HttpResponse::Ok().content_type("application/json").body(s),
        Err(e) => HttpResponse::InternalServerError().body(e.to_string()),
    }
}

/// Post request (json) to insert any valid snippet group object into the database.
/// No auth whatsoever cuz this is production and only localhost is allowed to insert.
#[post("/insert")]
async fn insert(mut sg: Json<SnippetGroup>, req: HttpRequest) -> HttpResponse {
    match req.peer_addr() {
        None => {
            return HttpResponse::Unauthorized()
                .body("Only localhost is allowed to insert data for now :)");
        }
        Some(addr) => {
            if !addr.ip().is_loopback() {
                return HttpResponse::Unauthorized()
                    .body("Only localhost is allowed to insert data for now :)");
            }
        }
    }
    let sgdb = models::SnippetCollection::init().await.unwrap();
    sg.id = rand::thread_rng().gen::<i64>();
    for mut snip in sg.snippets.iter_mut() {
        snip.id = rand::thread_rng().gen::<i64>();
    }
    match sgdb.insert(sg.into_inner()).await {
        Ok(_) => HttpResponse::Created().body("Success"),
        Err(e) => HttpResponse::InternalServerError().body(format!("{:?}", e)),
    }
}

/// Get the amount of snippets in the database (we start from 0 so a db of 5 snippets will return 4)
#[get("/length")]
async fn length() -> HttpResponse {
    HttpResponse::Ok().body(
        SnippetCollection::init()
            .await
            .unwrap()
            .coll
            .count_documents(None, None)
            .await
            .unwrap_or(0)
            .to_string(),
    )
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(move || {
        let logger = middleware::Logger::default();
        App::new()
            .wrap(Cors::permissive())
            .wrap(logger)
            .service(snippet)
            .service(insert)
            .service(length)
    })
    .bind(("127.0.0.1", 8000))?
    .run()
    .await
}
