 import 'package:cloud_firestore/cloud_firestore.dart';

class Dinheiro {
  String imagem;
  num valor;

  Dinheiro.from(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data;
    this.imagem = map['imagem'];
    this.valor = map['valor'];
  }

}
