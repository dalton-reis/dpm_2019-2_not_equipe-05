import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String imagem = '';
  String nome = '';
  num valor = 0;
  bool inteiro;
  String documentId;

  Produto();

  Produto.from(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data;
    this.imagem = map['imagem'];
    this.nome = map['nome'];
    this.valor = map['valor'];
    this.inteiro = map['inteiro'];
    this.documentId = map['documentID'] != null
        ? map['documentID']
        : documentSnapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    return {
      'imagem': this.imagem,
      'nome': this.nome,
      'valor': this.valor,
      'inteiro': this.inteiro,
      'documentID': this.documentId
    };
  }
}
