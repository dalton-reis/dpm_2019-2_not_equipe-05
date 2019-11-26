import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/screens/sala/jogo.dart';

class SalaEsperaAluno extends StatefulWidget {
  @override
  _SalaEsperaAlunoState createState() => _SalaEsperaAlunoState();

  Classroom classroom;

  SalaEsperaAluno(this.classroom);
}


class _SalaEsperaAlunoState extends State<SalaEsperaAluno> {

  final db = Firestore.instance;
  Future<List<Aluno>> alunos;

  @override
  void initState() {
    super.initState();
    alunos = buscarAlunos();
  }

  Future<List<Aluno>> buscarAlunos() async {
    var alunos = await db
    .collection('salas')
    .document(widget.classroom.documentId)
    .collection('alunos')
    .getDocuments();

    return alunos.documents.map((aluno) {
      Aluno.fromDocument(aluno);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.classroom.idSala.toString(),
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Aguardando partida iniciar...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              //CircularProgressIndicator(),
              Text(widget.classroom.idSala.toString()),
              Text(widget.classroom.qntJogadores.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
