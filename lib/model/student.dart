import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String nome;
  num pontuacao;
  String documentID;

  Aluno(this.nome, this.pontuacao, this.documentID);

  Aluno.fromDocument(DocumentSnapshot documentSnapshot) {
    Aluno(documentSnapshot.data['nome'], documentSnapshot.data['pontuacao'], documentSnapshot.documentID);
  }


}