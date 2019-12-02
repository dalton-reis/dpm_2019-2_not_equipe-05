import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/screens/sala/jogo.dart';

class SalaEdicaoProfessor extends StatefulWidget {
  @override
  _SalaEdicaoProfessorState createState() =>
      _SalaEdicaoProfessorState(this._classroom);

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
        title: Text(widget._classroom.nomeSala),
        centerTitle: true,
        leading: Container(),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 7.0),
            child: Text(
              'Alunos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('salas')
                .document(widget._classroom.documentId)
                .collection('alunos')
                .orderBy('quantidadeAcertos')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading...');
              return Flexible(
                  child: ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                Aluno alu = Aluno.fromDocument(document);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      title: Text(
                        alu.nome,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      subtitle: Text(
                        'Acertos: ${alu.quantidadeAcertos}    Erros: ${alu.quantidadeErros}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.green[400],
                              title: Text('Alterar o nome do aluno'),
                              content: TextField(
                                controller: _nomeAluno,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(Icons.person),
                                  hintText: "Novo nome aluno",
                                  hintStyle: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                  labelText: "Aluno",
                                  errorStyle: TextStyle(fontSize: 18),
                                  labelStyle: TextStyle(
                                      fontSize: 22.0, color: Colors.white),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _nomeAluno.text.isEmpty
                                          ? Colors.white60
                                          : Colors.lightGreenAccent,
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightGreenAccent,
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text('Alterar',
                                      style: TextStyle(fontSize: 20)),
                                  onPressed: () {
                                    db
                                        .collection('salas')
                                        .document(widget._classroom.documentId)
                                        .collection('alunos')
                                        .document(document.documentID)
                                        .updateData({
                                      'nome': _nomeAluno.value.text.toString()
                                    }).then((document) {
                                      Navigator.of(context).pop();
                                      _nomeAluno.text = '';
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }).toList()));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(
                  "Iniciar",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  DocumentReference salaDocument = db
                      .collection("salas")
                      .document(this.classroom.documentId);
                  Map<String, dynamic> data = {
                    'status': Status.INICIADO.toString()
                  };
                  salaDocument.updateData(data);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SalaJogoProfessor(this.classroom);
                  }));
                }),
          )
        ]),
      ),
    );
  }
}
