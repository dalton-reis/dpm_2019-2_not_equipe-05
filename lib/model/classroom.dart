
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantocusta/model/enums.dart';

class Classroom {
  String _documentId;
  int _idSala;
  String _nomeProfessor;
  int _duracao;
  int _qntJogadores;
  Dificulty _dificuldade;
  Status _status;

  Classroom(this._documentId, this._idSala, this._nomeProfessor, this._duracao,
      this._qntJogadores, this._dificuldade, this._status);

  Classroom.fromDocument(DocumentSnapshot documentSnapshot) {
    Dificulty dif = Dificulty.values.firstWhere((o) => o.toString() == documentSnapshot.data['dificuldade']);
    Status status = Status.values.firstWhere((o) => o.toString() == documentSnapshot.data['status']);
    this._documentId = documentSnapshot.documentID;
    this._idSala = documentSnapshot.data['idSala'];
    this._nomeProfessor = documentSnapshot.data['nomeProfessor'];
    this._duracao = documentSnapshot.data['duracao'];
    this._qntJogadores = documentSnapshot.data['qntJogadores'];
    this._dificuldade = dif;
    this._status = status;
  }

  Status get status => _status;

  String get documentId => _documentId;

  Dificulty get dificuldade => _dificuldade;

  int get qntJogadores => _qntJogadores;

  int get duracao => _duracao;

  String get nomeProfessor => _nomeProfessor;

  int get idSala => _idSala;


}