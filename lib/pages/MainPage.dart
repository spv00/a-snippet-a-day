import 'dart:convert';

import 'package:a_snippet_a_day/models/Snippets.dart';
import 'package:a_snippet_a_day/views/SnippetGroupView.dart';
import 'package:flutter/material.dart';
import 'package:a_snippet_a_day/api/Api.dart' as api;

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  List<SnippetGroup>? views;
  List<String> bruh = List.filled(5, "yee");

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      api.get_api("/snippet", (p0) => {
        setState(() {
          views = List<SnippetGroup>.from(jsonDecode(p0.body).map((model)=> SnippetGroup.fromJson(model)));
        }),
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A Snippet A Day"),
      ),
      //body: SnippetGroupView(sg: SnippetGroup(0, "eeee", "aaaa", ["u"], [Snippet(1, "w", Language.Python, "echo fart")])),
      // Some weird shit magic
      body: SingleChildScrollView(child: Column(children: [
        for(var view in views?? [])
          SnippetGroupView(sg: view),
      ],),)
    );
  }
}
