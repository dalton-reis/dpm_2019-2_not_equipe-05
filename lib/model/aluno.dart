import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno {
  String _nome;

  String get nome => _nome;

  set nome(String nome) {
    _nome = nome;
  }
  num _quantidadeAcertos = 0;

  num get quantidadeAcertos => _quantidadeAcertos;

  set quantidadeAcertos(num quantidadeAcertos) {
    _quantidadeAcertos = quantidadeAcertos;
  }
  num _quantidadeErros = 0;

  num get quantidadeErros => _quantidadeErros;

  set quantidadeErros(num quantidadeErros) {
    _quantidadeErros = quantidadeErros;
  }
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
