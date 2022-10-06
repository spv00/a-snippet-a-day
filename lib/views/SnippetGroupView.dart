import 'package:a_snippet_a_day/models/snippets.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';

class CodeSnippetView extends StatefulWidget{
  final SnippetGroup sg;
  const CodeSnippetView({Key? key, required this.sg}) : super(key: key);

  @override
  _CodeSnippetView createState() => _CodeSnippetView();
}

class _CodeSnippetView extends State<CodeSnippetView>{

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.sg.title),
      Row(children: [
        Expanded(flex: 2,
          child: Column(children: [
            for(var snippet in widget.sg.snippets)
              Container(color: Colors.black12, width: double.infinity, child: Column(children: [
                Text(snippet.title),
                Text(snippet.lang.toString().split(".").last),
                Text(snippet.code),
              ],),),
        ], crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,),),
        Container(child: Column(children: [
          Text(widget.sg.explanation),
          for(var comment in widget.sg.comments)
            Text(comment),
        ]), constraints: BoxConstraints(maxWidth: 200),)
      ], mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,)
    ],);
  }
}