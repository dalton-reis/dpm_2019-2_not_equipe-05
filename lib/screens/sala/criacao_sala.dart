import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto_service.dart';
import 'package:quantocusta/screens/sala/edicao.dart';
import 'package:quantocusta/screens/sala/jogo.dart';

class SalaCriacao extends StatefulWidget {
  @override
  _SalaCriacaoState createState() => _SalaCriacaoState();
}

class _SalaCriacaoState extends State<SalaCriacao> {
  final db = Firestore.instance;
  final produtoService = new ProdutoService();
  final TextEditingController _controllerTeacher = TextEditingController();

  Dificulty valueDificulty = Dificulty.FACIL;
  final TextEditingController _controllerProductQuantity =
      TextEditingController();
  List _dificuldade = ['Básico', 'Fácil', 'Normal', 'Difícil', 'Avançado'];
  List<DropdownMenuItem<String>> dificuldade = new List();

  /*Future <void> addSala() async {
    await db.collection("salas").add({
      'dificuldade': _controllerDificuldade,
      'professor': 'Jailson',
      'tempo': int.tryParse(_controllerDuracao.value.toString()),
      'limiteJogadores': int.tryParse(_controllerQntJogadores.value.toString()),
    }).then((docu))
  }*/

  int generateRandom() {
    var _random = Random();
    int min = 0, max = 99999;
    return min + _random.nextInt(max - min);
  }

  String showDificulty(Dificulty dificulty) {
    switch (dificulty) {
      case Dificulty.DIFICIL:
        return 'Difícil';
      case Dificulty.FACIL:
        return 'Fácil';
      default:
        return 'Médio';
    }
  }

  IconData showIconDificulty(Dificulty dificulty) {
    switch (dificulty) {
      case Dificulty.DIFICIL:
        return Icons.looks_3;
      case Dificulty.FACIL:
        return Icons.looks_one;
      default:
        return Icons.looks_two;
    }
  }

  Future<Classroom> createClassroom(BuildContext context) async {
    int quantidadeDecimal;
    int quantidadeInteiro;

    int quantidadeProdutos =
        int.tryParse(_controllerProductQuantity.value.text.toString());

    switch (valueDificulty) {
      case Dificulty.DIFICIL:
        quantidadeDecimal = (quantidadeProdutos * 0.7).floor();
        break;
      case Dificulty.MEDIO:
        quantidadeDecimal = (quantidadeProdutos * 0.5).floor();
        break;
      case Dificulty.FACIL:
        quantidadeDecimal = (quantidadeProdutos * 0.3).floor();
        break;
    }
    quantidadeInteiro = quantidadeProdutos - quantidadeDecimal;

    return produtoService
        .buscarProdutosNovaSala(quantidadeInteiro, quantidadeDecimal)
        .then((produtos) {
      return db.collection("salas").add({
        'idSala': generateRandom(),
        'dificuldade': valueDificulty.toString(),
        'quantidadeProdutos': quantidadeProdutos,
        'quantidadeInteiro': quantidadeInteiro,
        'quantidadeDecimal': quantidadeDecimal,
        'nomeProfessor': _controllerTeacher.value.text.toString(),
        'status': Status.AGUARDANDO.toString(),
      }).then((documentAdded) {
        produtos.forEach((produto) => db
            .collection("salas")
            .document(documentAdded.documentID)
            .collection("produtos")
            .add(produto.toJson()));
        return documentAdded.get().then((documentSnap) {
          Classroom c = new Classroom.fromDocument(documentSnap);
          c.produtos = produtos;
          return c;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Criar sala",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        body: Container(
            color: Colors.green,
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: TextField(
                        controller: _controllerTeacher,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.person),
                          hintText: "Insira seu nome",
                          hintStyle:
                              TextStyle(fontSize: 18.0, color: Colors.white),
                          labelText: "Professor",
                          errorStyle: TextStyle(fontSize: 18),
                          labelStyle:
                              TextStyle(fontSize: 22.0, color: Colors.white),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _controllerTeacher.text.isEmpty
                                  ? Colors.white60
                                  : Colors.lightGreenAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightGreenAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: TextField(
                        controller: _controllerProductQuantity,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.person),
                          hintText: "Insira a quantidade de produtos",
                          hintStyle:
                              TextStyle(fontSize: 18.0, color: Colors.white),
                          labelText: "Quantidade de produtos",
                          errorStyle: TextStyle(fontSize: 18),
                          labelStyle:
                              TextStyle(fontSize: 22.0, color: Colors.white),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _controllerTeacher.text.isEmpty
                                  ? Colors.white60
                                  : Colors.lightGreenAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightGreenAccent,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: DropdownButton<Dificulty>(
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                      value: valueDificulty,
                      isExpanded: true,
                      onChanged: (Dificulty newValue) {
                        setState(() {
                          valueDificulty = newValue;
                        });
                      },
                      items: Dificulty.values.map((Dificulty dificulty) {
                        return DropdownMenuItem<Dificulty>(
                          value: dificulty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                showIconDificulty(dificulty),
                                color: Colors.black,
                              ),
                              Text(
                                showDificulty(dificulty),
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Criar sala",
                        style: TextStyle(fontSize: 20),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        createClassroom(context).then((classroom) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SalaEdicaoProfessor(classroom);
                          }));
                        });
                      },
                    ),
                  ),
                ])))));
  }
}
