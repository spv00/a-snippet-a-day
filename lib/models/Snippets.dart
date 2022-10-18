enum Language {
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

class SnippetGroup {
  int id;
  String title;
  String explanation;
  List<String> comments;
  List<Snippet> snippets;

  SnippetGroup(
      this.id, this.title, this.explanation, this.comments, this.snippets);

  factory SnippetGroup.fromJson(dynamic json) {
    return SnippetGroup(
        json['id'] as int,
        json['title'] as String,
        json['explanation'] as String,
        (json['comments'] as List<dynamic>).cast<String>(),
        List<Snippet>.from(
            json['snippets'].map((model) => Snippet.fromJson(model))));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'explanation': explanation,
        'comments': comments,
        'snippets': snippets,
      };
}

class Snippet {
  int id;
  String title;
  Language lang;
  String code;

  Snippet(this.id, this.title, this.lang, this.code);

  factory Snippet.fromJson(dynamic json) {
    return Snippet(json["id"] as int, json["title"] as String,
        Language.values.byName(json['lang']), json["code"] as String);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'lang': lang.toString().split(".").last,
        'code': code,
      };
}
