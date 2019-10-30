import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String nome;
  num pontuacao;

  Aluno(this.nome, this.pontuacao);

  Aluno.fromDocument(DocumentSnapshot documentSnapshot) {
    Aluno(documentSnapshot.data['nome'], documentSnapshot.data['pontuacao']);
  }


}