import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'dart:developer' as developer;

class JogadaState extends StatefulWidget {
  @override
  _JogadaState createState() => _JogadaState();
}

class _JogadaState extends State<JogadaState> {
  final db = Firestore.instance;
  final TextEditingController _controllerTeacher = TextEditingController();

  //final TextEditingController _controllerDificulty = TextEditingController();
  Dificulty valueDificulty = Dificulty.FACIL;
  final TextEditingController _controllerTime = TextEditingController();
  final TextEditingController _controllerPlayersAmount =
      TextEditingController();
  List _dificuldade = ['Básico', 'Fácil', 'Normal', 'Difícil', 'Avançado'];
  List<DropdownMenuItem<String>> dificuldade = new List();
  int _quantidadeJogadas = 1;
  List<Produto> produtos;
  List<Produto> produtosUtilizados = [];
  Future<List<Dinheiro>> dinheiros;
  List<Dinheiro> dinheirosSelecionados = [];

  num totalSelecionado = 0;
  Produto produtoAtual;

  Future<List<Produto>> buscarProdutos() async {
    var produtosEncontrados = await db
        .collection("produtos")
        .where("imagem", isGreaterThan: "")
        .getDocuments();
    return produtosEncontrados.documents
        .map((document) => new Produto.from(document))
        .toList();
  }

  Future<List<Dinheiro>> buscarDinheiro() async {
    var dinheiros = await db
        .collection("dinheiros")
        .where("imagem", isGreaterThan: "")
        .getDocuments();
    return dinheiros.documents
        .map((document) => new Dinheiro.from(document))
        .toList();
  }

  int generateRandom() {
    var _random = Random();
    int min = 0, max = 99999;
    return min + _random.nextInt(max - min);
  }

  @override
  void initState() {
    iniciar();
    super.initState();
  }

  void iniciar() async {
    buscarProdutos().then((produtos) {
      this.produtos = produtos;
      setState(() => produtoAtual = this.produtos.elementAt(0));
    });
    this.dinheiros = buscarDinheiro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sala XPTO'),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Container(
                child: SingleChildScrollView(
                    child: Column(
              children: <Widget>[
                Row(children: [
                  Center(
                      child: Text(
                          'Jogada ' + _quantidadeJogadas.toString() + '/10'))
                ]),
                Row(children: [
                  produtoAtual != null
                      ? Column(children: [
                          Image.network(
                            produtoAtual.imagem,
                            height: 100,
                            width: 100,
                          ),
                          Text('Valor: ' +
                              produtoAtual.valor.toStringAsPrecision(2))
                        ])
                      : Center(child: CircularProgressIndicator())
                ]),
                Row(
                  children: <Widget>[
                    FutureBuilder(
                      future: this.dinheiros,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Dinheiro>> snapshot) {
                        if (snapshot.hasData) {
                          return Column(children: [
                            for (Dinheiro dinheiro in snapshot.data)
                              GestureDetector(
                                child: Image.network(dinheiro.imagem,
                                    height: 100, width: 100),
                                onTap: () {
                                  selecionarDinheiro(context, dinheiro);
                                },
                              )
                          ]);
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Total selecionado: " +
                        this.totalSelecionado.toStringAsPrecision(2))
                  ],
                ),
                Row(
                  children: <Widget>[Center(child: getIconeComparacao())],
                )
              ],
            )))));
  }

  Widget getIconeComparacao() {
    if (this.produtoAtual != null) {
      if (this.totalSelecionado < this.produtoAtual.valor) {
        return Icon(Icons.keyboard_arrow_left, size: 24, color: Colors.red);
      } else if (this.totalSelecionado > this.produtoAtual.valor) {
        return Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.red);
      }
    }
    return Container();
  }

  selecionarDinheiro(BuildContext context, Dinheiro dinheiro) {
    num totalFinal = this.totalSelecionado + dinheiro.valor;
    setState(() {
      this.totalSelecionado = totalFinal;
    });
    this.dinheirosSelecionados.add(dinheiro);
    if (this.produtoAtual != null &&
        this.produtoAtual.valor == totalFinal) {
      final snackBar = SnackBar(
          content: Text('Acertou mizeravi!'),
          elevation: 40,
          duration: Duration(seconds: 5));
      Scaffold.of(context).showSnackBar(snackBar);

      new Timer(Duration(seconds: 3), () {
        this.realizarNovaJogada();
      });
    }
  }

  void realizarNovaJogada() {
    this.produtosUtilizados.add(produtoAtual);
    this.produtos.remove(produtoAtual);
    if (produtos.length > 0) {
      Random random = new Random();
      num index =
          produtos.length == 1 ? 0 : random.nextInt(this.produtos.length - 1);
      setState(() {
        produtoAtual = this.produtos.elementAt(index);
        totalSelecionado = 0;
        _quantidadeJogadas += 1;
      });
    }
  }
}
