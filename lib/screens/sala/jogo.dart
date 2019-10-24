
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';

class SalaJogoProfessor extends StatefulWidget {
  @override
  _SalaJogoProfessorState createState() => _SalaJogoProfessorState();

  final DocumentReference _docRef;

  SalaJogoProfessor(this._docRef);

}

class _SalaJogoProfessorState extends State<SalaJogoProfessor> {
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
              widget._docRef.toString(),
            )
          ],
        ),
      ),
    );
  }
}
