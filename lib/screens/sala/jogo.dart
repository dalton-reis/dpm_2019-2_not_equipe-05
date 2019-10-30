
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';

class SalaJogoProfessor extends StatefulWidget {
  @override
  _SalaJogoProfessorState createState() => _SalaJogoProfessorState();

  final Classroom _docRef;

  SalaJogoProfessor(this._docRef);

}

class _SalaJogoProfessorState extends State<SalaJogoProfessor> {

  String fieldDocument(DocumentReference documentReference, String field) {
    var data;
//    documentReference.get().then((datasnapshot){
//      if(datasnapshot.exists){
//        data = datasnapshot.data['dificuldade'];
//      }
//    });

    documentReference.get().then((retorno) {
      data = retorno.data['idSala'];
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sala'
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              fieldDocument(null, 'dificuldade').toString()
            ),
            Text(
              fieldDocument(null, 'professor').toString()
            ),

          ],
        ),
      ),
    );
  }
}
