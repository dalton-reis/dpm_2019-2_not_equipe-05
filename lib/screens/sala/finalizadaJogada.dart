import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/model/aluno.dart';

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
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Final de Jogo ' +
                                this.aluno.nome +
                                '! ' +
                                this.texto,
                            style: TextStyle(
                              fontSize: 30,
                            ))
                      ]))
            ]),
          ),
        ));
  }
}
