import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/screens/sala/espera.dart';
import 'package:quantocusta/screens/sala/espera_aluno.dart';
class SalaCriacaoAluno extends StatefulWidget {
  @override
  _SalaCriacaoAlunoState createState() => _SalaCriacaoAlunoState(this.classroom);

  Classroom classroom;
  SalaCriacaoAluno(this.classroom);

}

class _SalaCriacaoAlunoState extends State<SalaCriacaoAluno> {
  final db = Firestore.instance;
  final TextEditingController _nomeAluno = TextEditingController();
  Classroom classroom;

  _SalaCriacaoAlunoState(this.classroom);

  Future<DocumentReference> adicionarAluno(BuildContext context) {
    return db.collection("salas").document(this.classroom.documentId).collection("alunos").add({
      'nome': _nomeAluno.value.text,
      'quantidadeAcertos': 0,
      'quantidadeErros': 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                InputText(
                  icon: Icons.person,
                  hint: 'Insira seu nome',
                  labelText: 'Aluno',
                  controller: _nomeAluno,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(
                      "Iniciar",
                      style: TextStyle(fontSize: 20),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      adicionarAluno(context).then((documentReference) {
                        documentReference.get().then((documentSnapshot) {
                          Aluno aluno = new Aluno.fromDocument(documentSnapshot);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return SalaEsperaAluno(classroom, aluno);
                          }));
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
