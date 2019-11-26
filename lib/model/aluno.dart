import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String nome;
  num quantidadeAcertos = 0;
  num quantidadeErros = 0;
  String documentID;

  Aluno.fromDocument(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot.data['nome'];
    this.quantidadeAcertos = documentSnapshot.data['quantidadeAcertos'] != null
        ? documentSnapshot.data['quantidadeAcertos']
        : 0;
    this.quantidadeErros = documentSnapshot.data['quantidadeErros'] != null
        ? documentSnapshot.data['quantidadeErros']
        : 0;
    this.documentID = documentSnapshot.documentID;
  }
}
