import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/student.dart';
import 'package:quantocusta/screens/sala/jogada.dart';

class EsperaState extends StatefulWidget {
  @override
  _EsperaState createState() => _EsperaState(this.aluno, this.sala);

  Aluno aluno;
  Classroom sala;

  EsperaState(this.aluno, this.sala);
}

class _EsperaState extends State<EsperaState> {
  final db = Firestore.instance;

  Aluno aluno;
  Classroom sala;

  _EsperaState(this.aluno, this.sala);

  @override
  void initState() {
    aguardar();
    super.initState();
  }

  void aguardar() async {
    //while (this.sala.status == Status.AGUARDANDO) {
      //Espera...
    //}
    new Timer(Duration(seconds: 5), () {
      iniciar();
    });
  }

  void iniciar() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return JogadaState(aluno, this.sala);
    }));
  }

  @override
  Widget build(BuildContext contextBuild) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.sala.idSala.toString(),
          style: TextStyle(
            fontSize: 24.0
          )
        ),
        centerTitle: true,
        leading: Container()
      ),
      body: Center(
        child: Text(
          'Aguardando o início da partida...',
          style: TextStyle(
            fontSize: 20.0
          )
        ),
      ),
    );
  }
}
