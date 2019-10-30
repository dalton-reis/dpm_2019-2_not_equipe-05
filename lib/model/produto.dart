 import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String imagem = '';
  String nome = '';
  num valor = 0;

  Produto();

  Produto.from(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data;
    this.imagem = map['imagem'];
    this.nome = map['nome'];
    this.valor = map['valor'];
  }

}
