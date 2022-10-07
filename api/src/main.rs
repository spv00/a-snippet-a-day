use actix_cors::*;
use actix_web::{web::Json, *};

mod lib;
use lib::{models::*, *};

#[get("/snippet")]
async fn snippet() -> HttpResponse {
    match serde_json::to_string(&SnippetCollection::init().await.snippet_groups) {
        Ok(s) => HttpResponse::Ok().content_type("application/json").body(s),
        Err(e) => HttpResponse::InternalServerError().body(e.to_string()),
    }
}

// dont deploy this ;)
#[post("/insert")]
async fn insert(sg: Json<SnippetGroup>) -> HttpResponse {
    let sgdb = models::SnippetCollection::init().await;
    match sgdb.insert(sg.into_inner()).await {
        Ok(_) => HttpResponse::Ok().body("Success"),
        Err(e) => HttpResponse::InternalServerError().body(format!("{:?}", e)),
    }
}

#[get("/length")]
async fn length() -> HttpResponse {
    HttpResponse::Ok().body(
        SnippetCollection::init()
            .await
            .coll
            .count_documents(None, None)
            .await
            .unwrap()
            .to_string(),
    )
}

#[get("/test")]
async fn test() -> HttpResponse {
    HttpResponse::Ok().body("eeee")
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
            .service(test)
            .service(length)
    })
    .bind(("127.0.0.1", 8000))?
    .run()
    .await
}
