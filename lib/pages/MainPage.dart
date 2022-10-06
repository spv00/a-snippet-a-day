import 'dart:convert';

import 'package:a_snippet_a_day/models/snippets.dart';
import 'package:a_snippet_a_day/views/SnippetGroupView.dart';
import 'package:a_snippet_a_day/views/SnippetView.dart';
import 'package:flutter/material.dart';
import 'package:a_snippet_a_day/api/Api.dart' as api;

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  List<SnippetGroup> views = List.empty(growable: true);

  @override
  void initState() {
    api.get_api(
      "/snippet",
          (callback_response) {
        setState(() {
          views.add(SnippetGroup.fromJson(jsonDecode(callback_response.body)));
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A Snippet A Day"),
      ),
      body: Column(children: [
        for(var sg in views) SnippetGroupView(sg: sg),
      ],),
    );
  }
}
