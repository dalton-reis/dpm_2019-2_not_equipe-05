import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:quantocusta/model/enums.dart';

import 'finalizadaJogadaProfessor.dart';

class SalaJogoProfessor extends StatefulWidget {
  @override
  _SalaJogoProfessorState createState() =>
      _SalaJogoProfessorState(this._classroom);

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

  bool isPausado = false;

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
            Text(widget._classroom.idSala.toString() + (this.isPausado ? " - pausado" : " - em andamento")),
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
            Padding(
              padding: EdgeInsets.fromLTRB(12, 2, 12, 12),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(
                  isPausado ? "Retomar" : "Pausar",
                  style: TextStyle(fontSize: 20),
                ),
                padding: EdgeInsets.all(12),
                onPressed: () {
                  Status status;
                  if (this.isPausado) {
                    status = Status.EM_ANDAMENTO;
                  } else {
                    status = Status.PAUSADO;
                  }

                  setState(() {
                    this.isPausado = !this.isPausado;
                  });

                  db.collection('salas').document(this.sala.documentId)
                      .updateData({ 'status': status.toString()}).then((value) {
                    print("atualizou status: " + status.toString());
                  });
                },
              ),
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
                db.collection('salas').document(this.sala.documentId)
                    .updateData({ 'status': Status.FINALIZADO.toString()}).then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FinalizadaJogadaProfessorState(this.sala);
                  }));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
