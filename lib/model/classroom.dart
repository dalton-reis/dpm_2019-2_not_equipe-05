
import 'package:quantocusta/model/enums.dart';

class Classroom {
  final int _idSala;
  final String _nomeProfessor;
  final int _duracao;
  final int _qntJogadores;
  final Dificulty _dificuldade;
  final Status _status;

  Classroom(this._idSala, this._nomeProfessor, this._duracao,
      this._qntJogadores, this._dificuldade, this._status);

  Status get status => _status;

  Dificulty get dificuldade => _dificuldade;

  int get qntJogadores => _qntJogadores;

  int get duracao => _duracao;

  String get nomeProfessor => _nomeProfessor;

  int get idSala => _idSala;


}