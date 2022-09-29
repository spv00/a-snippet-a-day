import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:a_snippet_a_day/api/Api.dart' as api;


class MainPage extends StatefulWidget{
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage>{
  String output = "";
  TextEditingController ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("A Snippet A Day"),),
      body: Column(children: [
        TextField(controller: ctrl,),
        Text(output),
        ElevatedButton(child: Text("Press bruh"), onPressed: (){
        api.post_api_plain("/cmd", ctrl.text, (response) {
          setState(() {
            output = response.body.trim();
          });
        });
      },)],),
    );
  }

}