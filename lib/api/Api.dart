import 'dart:convert';

import 'package:http/http.dart';

final String baseUrl = "http://127.0.0.1:8000";

Future<void> get_api(String url, Function(Response) callback_response) async {
  Response response = await get(Uri.parse(baseUrl + url));
  callback_response(response);
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


Future<void> post_api_json(String url, Map<String, String> data, Function(Response) callback_response) async {
  Response response = await post(Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  callback_response(response);
}