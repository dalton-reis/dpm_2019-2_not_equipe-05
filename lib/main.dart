import 'package:flutter/material.dart';
import 'package:quantocusta/screens/login.dart';

void main() => runApp(QuantoCusta());

class QuantoCusta extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          canvasColor: Colors.green,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.accent,
          )),
      home: LoginComPin(),

    );
  }
}