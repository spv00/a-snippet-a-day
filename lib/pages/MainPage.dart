import 'dart:convert';

import 'package:a_snippet_a_day/models/Snippets.dart';
import 'package:a_snippet_a_day/views/SnippetGroupView.dart';
import 'package:flutter/material.dart';
import 'package:a_snippet_a_day/api/Api.dart' as api;
import 'package:a_snippet_a_day/misc/Util.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  List<SnippetGroup>? views;
  Language selected_lang = Language.All;
  int? selected_id;

  Widget select_lang_dropdown() {
    return Container(padding: EdgeInsets.all(5), margin: EdgeInsets.all(5),
      child: DropdownButtonHideUnderline(child: DropdownButton<Language>(
        value: selected_lang,
        onChanged: (Language? newValue) {
          setState(() {
            selected_lang = newValue!;
            update_snips();
          });
        },
        items: Language.values.map((Language lang) {
          return DropdownMenuItem<Language>(
              value: lang,
              child: Container(child: Row(children: [
                Expanded(child: Text(lang.name),),
                Icon(Util.get_lang_icon(lang)),
              ],), width: 200,));
        }).toList(), hint: Text("Select Language"),
      )),);
  }

  void update_snips() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      api.get_snippets(
          selected_id,
          selected_lang,
              (p0) => {
            setState(() {
              views = List<SnippetGroup>.from(jsonDecode(p0.body)
                  .map((model) => SnippetGroup.fromJson(model)));
            }),
          });
    });
  }

  @override
  void initState() {
    update_snips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("A Snippet A Day"),
          actions: [
            // Dropdown button to select langs
            select_lang_dropdown(),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, "/create");
            }, child: Text("Create New")),
          ],
        ),
        // Some weird shit magic
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var view in views ?? []) SnippetGroupView(sg: view),
            ],
          ),
        ));
  }
}
