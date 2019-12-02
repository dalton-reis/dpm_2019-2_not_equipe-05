import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as prefix0;
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/model/aluno.dart';

import '../login.dart';

class FinalizadaJogadaState extends StatefulWidget {
  @override
  _FinalizadaJogadaState createState() =>
      _FinalizadaJogadaState(this.aluno, this.sala, this.texto);

  Aluno aluno;
  Classroom sala;
  String texto;

  FinalizadaJogadaState(this.aluno, this.sala, this.texto);
}

class _FinalizadaJogadaState extends State<FinalizadaJogadaState> {
  final db = Firestore.instance;

  Aluno aluno;
  Classroom sala;
  String texto;

  _FinalizadaJogadaState(this.aluno, this.sala, this.texto);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext contextBuild) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Final de jogo!",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Center(
        child: Container(
          height: screenHeight,
          //width: screenWidth,
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Final de Jogo ' + this.aluno.nome + '! ' + this.texto,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    "Voltar para o início",
                    style: TextStyle(fontSize: 20),
                  ),
                  padding: EdgeInsets.all(12),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                      return LoginComPin();
                    }), (r) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
