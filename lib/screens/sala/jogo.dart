import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/aluno.dart';

import 'finalizadaJogadaProfessor.dart';

class SalaJogoProfessor extends StatefulWidget {
  @override
  _SalaJogoProfessorState createState() => _SalaJogoProfessorState(this._classroom);

  final Classroom _classroom;

  SalaJogoProfessor(this._classroom);
}

class _SalaJogoProfessorState extends State<SalaJogoProfessor> {
  final db = Firestore.instance;

  final Classroom sala;

  _SalaJogoProfessorState(this.sala);

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

  /*Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Aluno.fromDocument(data);

    return Padding(
      key: ValueKey(record.nome),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.nome),
          trailing: Text(record.pontuacao.toString()),
          onTap: () => print(record),
        ),
      ),
    );
  }*/

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

//                return _buildList(context, snapshot.data.documents);
                return Flexible(
                    child: new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document['nome']),
                      subtitle: Text('Acertos: ' +
                          document['quantidadeAcertos'].toString() +
                          ', Erros: ' +
                          document['quantidadeErros'].toString()),
                    );
                  }).toList(),
                ));
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.blue,
              textColor: Colors.white,
              child: Text(
                "Finalizar jogada",
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.all(12),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FinalizadaJogadaProfessorState(this.sala);
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
