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
        title: Text('Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                InputText(
                  icon: Icons.person,
                  hint: 'Insira seu nome',
                  labelText: 'Professor',
                  controller: _controllerTeacher,
                ),
                InputText(
                  icon: Icons.devices_other,
                  hint: 'Insira a quantidade de produtos para a sala',
                  labelText: 'Qnt. Produtos',
                  controller: _controllerProductQuantity,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<Dificulty>(
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
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Text(
                              showDificulty(dificulty),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
