import 'package:a_snippet_a_day/models/snippets.dart';
import 'package:a_snippet_a_day/views/SnippetView.dart';
import 'package:flutter/material.dart';

class SnippetGroupView extends StatefulWidget{
  final SnippetGroup sg;
  const SnippetGroupView({Key? key, required this.sg}) : super(key: key);

  @override
  _CodeSnippetView createState() => _CodeSnippetView();
}

class _CodeSnippetView extends State<SnippetGroupView>{

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.black54),
      child: Column(children: [
      Text(widget.sg.title, style: Theme.of(context).textTheme.headline4,),
      Row(children: [
        Expanded(flex: 2,
          child: Column(children: [
            for(var snippet in widget.sg.snippets)
                Container(child: SnippetView(snippet: snippet), padding: EdgeInsets.all(15),),

        ], crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly,),),
        Container(child: Column(children: [
          Text(widget.sg.explanation, style: Theme.of(context).textTheme.subtitle1,),
          Divider(color: Theme.of(context).dividerColor,),
          for(var comment in widget.sg.comments)
            Text(comment, style: Theme.of(context).textTheme.caption,),
        ]), constraints: BoxConstraints(maxWidth: 200),)
      ], mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,)
    ],),);
  }
}