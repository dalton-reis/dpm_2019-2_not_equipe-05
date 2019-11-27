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
  Aluno alunoJogando;

  SalaEsperaAluno(this.classroom, this.alunoJogando);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Olá ${widget.alunoJogando.nome}, seja bem-vindo!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Container(
                padding: EdgeInsets.only(top: 8),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
                ),
                child: Text(
                  'Jogadores na sala.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))
                  ),
                  padding: EdgeInsets.all(0),
                  // color: Colors.white38,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db
                    .collection('salas')
                    .document(widget.classroom.documentId)
                    .collection('alunos')
                    .snapshots(),
                    builder: (BuildContext context, alunosSnapshot) {
                      if(!alunosSnapshot.hasData) return LinearProgressIndicator();

                      final int cardLength = alunosSnapshot.data.documents.length;

                      return ListView.builder(
                        itemCount: cardLength,
                        itemBuilder: (context, index) {
                          final Aluno aluno = Aluno.fromDocument(alunosSnapshot.data.documents[index]);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: ListTile(
                                title: Text(aluno.nome),
                                subtitle: Text('testrr'),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16 ,16, 16),
              child: Text(
                'Aguardando partida iniciar.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
