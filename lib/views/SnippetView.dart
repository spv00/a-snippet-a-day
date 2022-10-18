import 'package:a_snippet_a_day/misc/Util.dart';
import 'package:a_snippet_a_day/models/Snippets.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
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
      language: langs.allLanguages[
          Util.patch_lang_name(widget.snippet.lang.name.toLowerCase())]!,
      theme: monokaiSublimeTheme,
      params: const EditorParams(tabSpaces: 4),
      webSpaceFix: true,
    );

    // Code view in case of the lang not being markdown
    Widget code_view = HighlightView(
      widget.snippet.code,
      language: Util.patch_lang_name(widget.snippet.lang.name.toLowerCase()),
      theme: monokaiSublimeTheme,
      tabSize: 4,
      padding: EdgeInsets.all(6),
      textStyle: const TextStyle(
        fontFamily: 'Source Code',
        fontSize: 18,
      ),
    );

    Widget md_view = Container(padding: EdgeInsets.all(5), decoration: BoxDecoration(color: Color(0x23241f), borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Theme.of(context).dividerColor, width: 1)), child: MarkdownBody(
      data: widget.snippet.code,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
    ),);

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
                child: Text(widget.snippet.title,
                    style: Theme.of(context).textTheme.headline5),
              ),
              TextButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.snippet.code));
                  },
                  child: Icon(Icons.copy,
                      color: Theme.of(context).colorScheme.onPrimary)),
              Tooltip(
                message: widget.snippet.lang.name,
                child: Icon(Util.get_lang_icon(widget.snippet.lang)),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      // Markdown view of code view based on language provided
                      child: widget.snippet.lang == Language.Markdown
                          ? md_view
                          : code_view)),
            ],
          )
        ],
      ),
    );
  }
}
