import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';

class SalaEdicaoProfessor extends StatefulWidget {
  @override
  _SalaEdicaoProfessorState createState() => _SalaEdicaoProfessorState();

  final Classroom _classroom;

  SalaEdicaoProfessor(this._classroom);
}

class _SalaEdicaoProfessorState extends State<SalaEdicaoProfessor> {
  final db = Firestore.instance;

  String fieldDocument(DocumentReference documentReference, String field) {
    var data;

    documentReference.get().then((retorno) {
      data = retorno.data['idSala'];
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    db
        .collection("salas")
        .document(widget._classroom.documentId)
        .collection("alunos")
        .snapshots()
        .listen((query) {
      debugPrint(query.documents.toString());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(widget._classroom.idSala.toString()),
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("salas")
                  .document(widget._classroom.documentId)
                  .collection("alunos")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('Loading...');
                return Flexible(
                    child: new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document['nome'],
                                  style: TextStyle(fontSize: 14)),
                      subtitle: Text('Editar nome | Remover da sala')
                    );
                  }).toList(),
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
