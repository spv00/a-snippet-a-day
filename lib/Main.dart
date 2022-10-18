import 'dart:convert';

import 'package:a_snippet_a_day/pages/CreateNewPage.dart';
import 'package:a_snippet_a_day/pages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'Themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  runApp(ASnippetADay(theme: ThemeData.dark()));
}

class ASnippetADay extends StatelessWidget {
  final ThemeData theme;
  const ASnippetADay({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        "/create": (context) => CreateNewPage(),
      },
      theme: theme,
    );
  }
}