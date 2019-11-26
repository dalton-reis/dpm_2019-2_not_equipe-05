import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/screens/sala/jogo.dart';

class SalaEdicaoProfessor extends StatefulWidget {
  @override
  _SalaEdicaoProfessorState createState() => _SalaEdicaoProfessorState(this._classroom);

  final Classroom _classroom;

  SalaEdicaoProfessor(this._classroom);
}

class _SalaEdicaoProfessorState extends State<SalaEdicaoProfessor> {
  final db = Firestore.instance;
  final TextEditingController _nomeAluno = TextEditingController();

  Classroom classroom;

  _SalaEdicaoProfessorState(this.classroom);

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
                    child: ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document['nome'],
                                  style: TextStyle(fontSize: 18)),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alterar o nome do aluno'),
                              content: InputText(
                                icon: Icons.person,
                                labelText: 'Aluno',
                                controller: _nomeAluno
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text(
                                    'Alterar',
                                    style: TextStyle(fontSize: 20)
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                            },
                        );
                      },
                    );
                  }).toList()
                ));
              },
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text(
                'Iniciar',
                style: TextStyle(fontSize: 20)
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SalaJogoProfessor(this.classroom);
                }));
              }
            )
          ]
        ),
      ),
    );
  }
}
