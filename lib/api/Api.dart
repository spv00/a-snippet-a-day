import 'dart:convert';

import 'package:a_snippet_a_day/models/Snippets.dart';
import 'package:http/http.dart';

final String baseUrl = "http://127.0.0.1:8000";

Future<void> get_api(String url, Function(Response) callback_response) async {
  Response response = await get(Uri.parse(baseUrl + url));
  callback_response(response);
}

Future<void> get_snippets(int? id, Language lang, Function(Response) callback_response) async {
  String url = "/snippet";
  if(id != null){
    url += "?id=$id";
  }
  if(lang != Language.All){
    url += "?lang=${lang.name}";
  }
  get_api(url, callback_response);
}

Future<void> post_api_plain(String url, String data, Function(Response) callback_response) async {
  Response response = await post(Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'text/html; charset=UTF-8',
    },
    body: data,
  );
  callback_response(response);
}


Future<void> post_api_json(String url, Map<String, dynamic> data, Function(Response) callback_response) async {
  Response response = await post(Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  callback_response(response);
}