import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class Produto {
  String imagem = '';
  Uint8List imageA;
  String nome = '';
  num valor = 0;
  bool inteiro;
  String documentId;

  set imagemA(Uint8List imagemA) {
    this.imageA = imagemA;
  }

  Produto();

  Produto.fromDocument(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data;
    this.imagem = map['imagem'];
    this.nome = map['nome'];
    this.valor = map['valor'];
    this.inteiro = map['inteiro'] != null ? map['inteiro'] : true;
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

class ProdutoAluno extends Produto {
  ProdutoAluno();

  num segundosDemorados = 0;
  bool acertou = true;

  ProdutoAluno.fromDocument(DocumentSnapshot documentSnapshot)
      : this.segundosDemorados =
            documentSnapshot.data['segundosDemorados'] != null
                ? documentSnapshot.data['segundosDemorados']
                : 0,
        this.acertou = documentSnapshot.data['acertou'],
        super.fromDocument(documentSnapshot);
}
