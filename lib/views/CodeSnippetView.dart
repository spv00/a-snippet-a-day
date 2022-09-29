import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';

class CodeSnippetView extends StatefulWidget{
  final String code;
  final String title;
  final String explanation;
  const CodeSnippetView({Key? key, required this.title, required this.code, required this.explanation}) : super(key: key);

  @override
  _CodeSnippetView createState() => _CodeSnippetView();
}

class _CodeSnippetView extends State<CodeSnippetView>{

  @override
  Widget build(BuildContext context) {
    CodeController codeController = CodeController(theme: monokaiSublimeTheme, text: widget.code, language: python);
    return CodeField(controller: codeController);
  }
}