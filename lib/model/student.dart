import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String nome;
  num pontuacao;
  String documentID;

  Aluno(this.nome, this.pontuacao, this.documentID);

  Aluno.fromDocument(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot.data['nome'];
    this.pontuacao = documentSnapshot.data['pontuacao'];
    this.documentID = documentSnapshot.documentID;
  }
}
