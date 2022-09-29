import 'package:a_snippet_a_day/pages/MainPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ASnippetADay());
}

class ASnippetADay extends StatelessWidget {
  const ASnippetADay({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
      },
    );
  }
}