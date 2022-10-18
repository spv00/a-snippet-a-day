import 'dart:convert';

import 'package:a_snippet_a_day/api/Api.dart';
import 'package:a_snippet_a_day/views/SnippetGroupView.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highlight/languages/all.dart' as langs;
import 'package:flutter/material.dart';

import '../misc/Util.dart';
import '../models/Snippets.dart';

class CreateNewSnippet extends StatefulWidget {
  TextEditingController id = TextEditingController();
  TextEditingController title = TextEditingController();
  Language selected_lang = Language.All;
  CodeController code = CodeController(language: langs.allLanguages['c'], webSpaceFix: false);

  @override
  _CreateNewSnippet createState() => _CreateNewSnippet();
}

class _CreateNewSnippet extends State<CreateNewSnippet> {
  @override
  Widget build(BuildContext context) {
    Container select_lang_dropdown = Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<Language>(
        value: widget.selected_lang,
        onChanged: (Language? newValue) {
          setState(() {
            widget.selected_lang = newValue!;
          });
        },
        items: Language.values.map((Language lang) {
          return DropdownMenuItem<Language>(
              value: lang,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(lang.name),
                    ),
                    Icon(Util.get_lang_icon(lang)),
                  ],
                ),
                width: 200,
              ));
        }).toList(),
        hint: Text("Select Language"),
      )),
    );

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(controller: widget.title, decoration: InputDecoration(hintText: "Title")),
              ),
              select_lang_dropdown,
            ],
            mainAxisSize: MainAxisSize.max,
          ),
          Expanded(child: SingleChildScrollView(child: CodeField(controller: widget.code),)),
        ],
      ), decoration: BoxDecoration(border: Border.all(color: Colors.white10, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
    );
  }
}

class CreateNewPage extends StatefulWidget {
  List<TextEditingController> comments = List.empty(growable: true);
  List<CreateNewSnippet> snippets = List.empty(growable: true);
  TextEditingController title = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController explanation = TextEditingController();

  @override
  _CreateNewPage createState() => _CreateNewPage();
}

class _CreateNewPage extends State<CreateNewPage> {
  Widget comment_box(MapEntry<int, TextEditingController> snip) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: snip.value,
            decoration: InputDecoration(hintText: "Comment ${snip.key + 1}"),
          )),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.comments.removeAt(snip.key);
                });
              },
              child: Icon(Icons.remove))
        ],
      ),
      constraints: BoxConstraints(maxHeight: 200),
    );
  }
  Widget snippet_box(MapEntry<int, CreateNewSnippet> cmt) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: cmt.value),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.snippets.removeAt(cmt.key);
                });
              },
              child: Icon(Icons.remove))
        ],
      ),
      constraints: BoxConstraints(maxHeight: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create new Snippet")),
      body: LayoutBuilder(builder: (context, c) {
        return Row(children: [
          // Lft side container. General info and comments
          Container(
            height: c.maxHeight,
            width: c.maxWidth * 0.4,
            child: LayoutBuilder(builder: (context, c) {
              return Column(
                children: [
                  Text("Snippet Overview", style: Theme.of(context).textTheme.headline4,),
                  TextField(
                    controller: widget.title,
                      decoration: InputDecoration(hintText: "Title")
                  ),
                  TextField(
                    controller: widget.explanation,
                      decoration: InputDecoration(hintText: "Explanation")
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var cmt in widget.comments.asMap().entries)
                          comment_box(cmt),
                        ElevatedButton(onPressed: (){setState(() {
                          widget.comments.add(TextEditingController());
                        });}, child: Icon(Icons.add))
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
          Container(
            height: c.maxHeight,
            width: c.maxWidth * 0.6,
            child: SingleChildScrollView(child: Column(children: [
              Text("Snippets", style: Theme.of(context).textTheme.headline4,),
              for(var snip in widget.snippets.asMap().entries)
                Container(child: snippet_box(snip), padding: EdgeInsets.all(5),),
              ElevatedButton(onPressed: (){setState(() {
                widget.snippets.add(CreateNewSnippet());
              });}, child: Icon(Icons.add)),
            ],),),
          )
        ]);
      }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        SnippetGroup snipg = SnippetGroup(
            0,
            widget.title.text,
            widget.explanation.text,
            widget.comments.map((e) => e.text).toList(),
            widget.snippets
                .map((e) => Snippet(0, e.title.text,
                    e.selected_lang, e.code.text))
                .toList());
        post_api_json(
            "/insert",
            snipg.toJson(),
            (p0)  {
                  Fluttertoast.showToast(msg: p0.body);
                });
      }, child: Icon(Icons.upload)),
    );
  }
}
