import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:quantocusta/screens/login.dart';
import 'package:quantocusta/screens/sala/criacao.dart';

void main() => runApp(QuantoCusta());

class QuantoCusta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.accent,
          )),
      home: SalaCriacao(),
    );
  }
}




/*
class LoginSemPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final numeroSala = TextField(
      keyboardType: TextInputType.number,
      autofocus: true,
      maxLength: 5,
      decoration: InputDecoration(
        hintText: 'Sala',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );

    final entrarBotao = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
//        color: Colors.lightBlueAccent,
        child: Text(
          'Entrar',
//          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    final criarSala = FlatButton(
      child: Text(
        'Criar sala',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            SizedBox(height: 48),
            numeroSala,
            SizedBox(height: 8),
            entrarBotao,
            criarSala
          ],
        ),
      ),
    );
  }
}*/
