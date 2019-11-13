import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/model/student.dart';

class JogadaState extends StatefulWidget {
  @override
  _JogadaState createState() => _JogadaState(this.aluno, this.sala);

  Aluno aluno;
  Classroom sala;

  JogadaState(this.aluno, this.sala);
}

class _JogadaState extends State<JogadaState> {
  final db = Firestore.instance;

  Aluno aluno;
  Classroom sala;

  _JogadaState(this.aluno, this.sala);

  int _quantidadeJogadas = 1;
  List<Produto> produtos;
  List<Produto> produtosUtilizados = [];
  Future<List<Dinheiro>> dinheiros;
  List<Dinheiro> dinheirosSelecionados = [];
  num totalSelecionado = 0;
  Produto produtoAtual;
  DateTime lastStart;

  Future<List<Dinheiro>> buscarDinheiro() async {
    var dinheiros = await db
        .collection("dinheiros")
        .orderBy("valor", descending: false)
        .getDocuments();
    return dinheiros.documents
        .map((document) => new Dinheiro.from(document))
        .toList();
  }

  @override
  void initState() {
    iniciar();
    super.initState();
  }

  void iniciar() async {
    this.produtos = this.sala.produtos;
    setState(() => produtoAtual = this.produtos.elementAt(0));
    this.dinheiros = buscarDinheiro();
    new Timer(Duration(seconds: 3), () {
      this.lastStart = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext contextBuild) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sala ' + this.sala.idSala.toString()),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Container(
                child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(children: [
                          Center(
                              child: Text('Jogada ' +
                                  _quantidadeJogadas.toString() +
                                  '/' +
                                  this.sala.quantidadeProdutos.toString()))
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
                                produtoAtual.valor.toStringAsFixed(2))
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
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Total selecionado: " +
                                this.totalSelecionado.toStringAsFixed(2))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Center(child: getIconeComparacao())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Builder(
                              builder: (BuildContext build) {
                                return RaisedButton(
                                  onPressed: () {
                                    this.confirmarJogada(build);
                                  },
                                  child: const Text('Confirmar',
                                      style: TextStyle(fontSize: 14)),
                                );
                              },
                            ),

                            RaisedButton(
                              onPressed: () {
                                this.desfazerJogada();
                              },
                              child: const Text('Desfazer última',
                                  style: TextStyle(fontSize: 14)),
                            )
                          ],
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

  confirmarJogada(BuildContext context) {
    String mensagem;
    bool acertou;
    if (this.produtoAtual != null &&
        this.produtoAtual.valor.toStringAsFixed(2) ==
            this.totalSelecionado.toStringAsFixed(2)) {
      mensagem = 'Resposta correta!';
      this.aluno.quantidadeAcertos = this.aluno.quantidadeAcertos + 1;
      acertou = true;
    } else {
      this.aluno.quantidadeErros = this.aluno.quantidadeErros + 1;
      mensagem = 'Valor incorreto!';
      acertou = false;
    }

    final snackBar = SnackBar(
        content: Text(mensagem), elevation: 40, duration: Duration(seconds: 5));
    Scaffold.of(context).showSnackBar(snackBar);

    DocumentReference alunoDocument = db
        .collection("salas")
        .document(this.sala.documentId)
        .collection("alunos")
        .document(aluno.documentID);

    Map<String, dynamic> data = {
      'quantidadeAcertos': this.aluno.quantidadeAcertos,
      'quantidadeErros': this.aluno.quantidadeErros
    };
    alunoDocument.updateData(data);

    DateTime agora = DateTime.now();
    Duration difference = agora.difference(lastStart);
    Map<String, dynamic> produtoJson = this.produtoAtual.toJson();
    produtoJson = {
      ...produtoJson,
      'segundosDemopontuarados': difference.inSeconds,
      'acertou': acertou
    };
    alunoDocument.collection("produtos").add(produtoJson);

    new Timer(Duration(seconds: 3), () {
      this.realizarNovaJogada();
    });
  }

  selecionarDinheiro(BuildContext context, Dinheiro dinheiro) {
    num totalFinal = this.totalSelecionado + dinheiro.valor;
    setState(() {
      this.totalSelecionado = totalFinal;
    });
    this.dinheirosSelecionados.add(dinheiro);
  }

  desfazerJogada() {
    if (this.dinheirosSelecionados.isNotEmpty) {
      Dinheiro removed = this.dinheirosSelecionados.removeLast();
      if (removed != null) {
        num totalFinal = this.totalSelecionado - removed.valor;
        setState(() {
          this.totalSelecionado = totalFinal;
        });
      }
    }
  }

  void realizarNovaJogada() {
    this.produtosUtilizados.add(produtoAtual);
    this.produtos.remove(produtoAtual);
    this.dinheirosSelecionados.clear();
    this.lastStart = DateTime.now();
    if (produtos.length > 0) {
      Random random = new Random();
      num index =
      produtos.length == 1 ? 0 : random.nextInt(this.produtos.length - 1);
      setState(() {
        this.produtoAtual = this.produtos.elementAt(index);
        this.totalSelecionado = 0;
        this._quantidadeJogadas += 1;
      });
    }
  }
}
