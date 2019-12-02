
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';

class Classroom {
  String _documentId;
  int _idSala;
  String _nomeProfessor;
  int _qntJogadores;
  int _quantidadeProdutos;
  int _quantidadeInteiro;
  int _quantidadeDecimal;
  String _nomeSala;

  Dificulty _dificuldade;
  Status _status;
  List<Produto> produtos;


  Classroom(this._documentId, this._idSala, this._nomeProfessor,
      this._qntJogadores, this._dificuldade, this._status,this._nomeSala);

  Classroom.fromDocument(DocumentSnapshot documentSnapshot) {
    Dificulty dif = Dificulty.values.firstWhere((o) => o.toString() == documentSnapshot.data['dificuldade']);
    Status status = Status.values.firstWhere((o) => o.toString() == documentSnapshot.data['status']);
    this._documentId = documentSnapshot.documentID;
    this._idSala = documentSnapshot.data['idSala'];
    this._nomeProfessor = documentSnapshot.data['nomeProfessor'];
    this._qntJogadores = documentSnapshot.data['qntJogadores'];
    this._quantidadeDecimal = documentSnapshot.data['quantidadeDecimal'];
    this._quantidadeInteiro = documentSnapshot.data['quantidadeInteiro'];
    this._quantidadeProdutos = documentSnapshot.data['quantidadeProdutos'];
    this._nomeSala = documentSnapshot.data['nomeSala'];
    this._dificuldade = dif;
    this._status = status;
  }

  Status get status => _status;

  String get documentId => _documentId;

  Dificulty get dificuldade => _dificuldade;

  int get qntJogadores => _qntJogadores;

  String get nomeProfessor => _nomeProfessor;

  int get quantidadeProdutos => _quantidadeProdutos;

  int get quantidadeDecimal => _quantidadeDecimal;

  int get quantidadeInteiro => _quantidadeInteiro;

  int get idSala => _idSala;

  String get nomeSala => _nomeSala;


}