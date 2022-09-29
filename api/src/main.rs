use actix_cors::*;
use actix_web::{web::Json, *};
use http::header::ContentType;
use serde::{Deserialize, Serialize};

use docker_api::{
    self,
    opts::{ContainerListOpts, ImageListOpts},
};

#[get("/")]
async fn index() -> &'static str {
    "Hello cunt"
}

#[get("/run")]
async fn python() -> &'static str {
    "fart"
}

#[post("/cmd")]
async fn test(echo: String) -> HttpResponse {
    let args: Vec<&str> = echo.split(' ').collect();

    let out = std::process::Command::new(args[0])
        .args(&args[1..])
        .output()
        .unwrap();
    HttpResponse::Ok()
        .content_type(ContentType::plaintext())
        .body(out.stdout)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(move || {
        let logger = middleware::Logger::default();
        App::new()
            .wrap(Cors::permissive())
            .wrap(logger)
            .service(index)
            .service(python)
            .service(test)
    })
    .bind(("127.0.0.1", 8000))?
    .run()
    .await
}
