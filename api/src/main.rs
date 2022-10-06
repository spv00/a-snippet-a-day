use actix_cors::*;
use actix_web::{web::Json, *};
use docker_api::{
    self,
    opts::{ContainerListOpts, ImageListOpts},
};
use http::header::ContentType;
use rand::seq::SliceRandom;
use serde::{Deserialize, Serialize};

mod lib;
use lib::{models::*, *};

#[get("/snippet")]
async fn snippet() -> HttpResponse {
    match serde_json::to_string(
        db::get_snippet_groups(&db::get_db().await.collection("snippets"))
            .await
            .choose(&mut rand::thread_rng())
            .unwrap(),
    ) {
        Ok(s) => HttpResponse::Ok().content_type("application/json").body(s),
        Err(e) => HttpResponse::InternalServerError().body(e.to_string()),
    }
}

// dont deploy this ;)
#[post("/insert")]
async fn insert(sg: Json<SnippetGroup>) -> HttpResponse {
    match db::insert_snippet_group(sg.0).await {
        Ok(_) => HttpResponse::Ok().body("Success"),
        Err(e) => HttpResponse::InternalServerError().body(format!("{:?}", e)),
    }
}

#[get("/test")]
async fn test() -> HttpResponse {
    db::test().await;
    HttpResponse::Ok().body("Test")
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
    })
    .bind(("127.0.0.1", 8000))?
    .run()
    .await
}
