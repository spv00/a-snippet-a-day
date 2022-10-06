import 'package:flutter/material.dart';

import '../models/snippets.dart';
import 'LangIcons.dart';


class Util{
  static IconData get_lang_icon(Language lang){
    switch (lang){
      case Language.Rust:{
        return LangIcons.rust_plain;
      }
      case Language.Python:{
        return LangIcons.python_plain;
      }
      case Language.Javascript:{
        return LangIcons.javascript_plain;
      }
      case Language.Java:{
        return LangIcons.java_plain;
      }
      case Language.Cpp:{
        return LangIcons.cplusplus_plain;
      }
      case Language.C:{
        return LangIcons.c_plain;
      }
      case Language.Csharp:{
        return LangIcons.csharp_plain;
      }
      case Language.Go:{
        return LangIcons.go_plain;
      }
      case Language.Dart:{
        return LangIcons.dart_plain;
      }
      case Language.Kotlin:{
        return LangIcons.kotlin_plain;
      }
      case Language.Swift:{
        return LangIcons.swift_plain;
      }
      case Language.Typescript:{
        return LangIcons.typescript_plain;
      }
      case Language.Ruby:{
        return LangIcons.ruby_plain;
      }
      case Language.Php:{
        return LangIcons.php_plain;
      }
      case Language.Html:{
        return LangIcons.html5_plain;
      }
      case Language.Css:{
        return LangIcons.css3_plain;
      }
      case Language.Scala:{
        return LangIcons.scala_plain;
      }
      case Language.Haskell:{
        return LangIcons.haskell_plain;
      }
    }

    return Icons.question_mark;
  }
}