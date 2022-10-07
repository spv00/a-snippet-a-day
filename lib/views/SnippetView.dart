import 'package:a_snippet_a_day/misc/Util.dart';
import 'package:a_snippet_a_day/models/Snippets.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/all.dart' as langs;
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class SnippetView extends StatefulWidget {
  final Snippet snippet;

  const SnippetView({Key? key, required this.snippet}) : super(key: key);

  @override
  _CodeSnippetView createState() => _CodeSnippetView();
}

class _CodeSnippetView extends State<SnippetView> {
  @override
  Widget build(BuildContext context) {
    CodeController controller = CodeController(
      text: widget.snippet.code,
      language: langs.allLanguages[Util.patch_lang_name(widget.snippet.lang.name.toLowerCase())]!,
      theme: monokaiSublimeTheme,
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upper column with title and language icon
          Row(
            children: [
              Expanded(
                child: Text(widget.snippet.title, style: Theme.of(context).textTheme.headline5),
              ),
              Tooltip(child: Icon(Util.get_lang_icon(widget.snippet.lang)), message: widget.snippet.lang.name,)
            ],
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      child: CodeField(controller: controller,),
                      constraints: BoxConstraints(
                          minWidth: 200, minHeight: 50, maxWidth: 500))),
            ],
          )
        ],
      ),
    );
  }
}
