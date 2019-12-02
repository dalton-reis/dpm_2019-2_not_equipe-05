import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/model/aluno.dart';

import 'finalizadaJogada.dart';

class JogadaState extends StatefulWidget {
  @override
  _JogadaState createState() => _JogadaState(this.aluno, this.sala, this.dinheirosLoaded);

  Aluno aluno;
  Classroom sala;
  List<Dinheiro> dinheirosLoaded;

  JogadaState(this.aluno, this.sala, this.dinheirosLoaded);
}

class _JogadaState extends State<JogadaState> {
  final db = Firestore.instance;

  Aluno aluno;
  Classroom sala;
  List<Dinheiro> dinheirosLoaded;

  _JogadaState(this.aluno, this.sala, this.dinheirosLoaded);

  int _quantidadeJogadas = 1;
  List<Produto> produtos;
  List<Produto> produtosUtilizados = [];
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
    ouvirPausaJogo();
    new Timer(Duration(seconds: 3), () {
      this.lastStart = DateTime.now();
    });
  }


  Widget getIconeComparacao() {
    Color color = Colors.red;
    IconData icone = Icons.arrow_upward;

    if (this.produtoAtual != null) {
      if (this.totalSelecionado < this.produtoAtual.valor) {
        color = Colors.red;
        icone = Icons.arrow_upward;
      } else if (this.totalSelecionado > this.produtoAtual.valor) {
        color = Colors.red;
        icone = Icons.arrow_downward;
      } else if (this.totalSelecionado == this.produtoAtual.valor) {
        color = Colors.green;
        icone = Icons.check;
      }
      return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Icon(icone, size: 35, color: color));
    }
    return Container();
  }

  confirmarJogada(BuildContext context) {
    String mensagem;
    bool acertou;
    if (this.produtoAtual != null &&
        this.produtoAtual.valor.toStringAsFixed(2) ==
            this.totalSelecionado.toStringAsFixed(2)) {
      mensagem = 'Parabéns, mandou bem!';
      this.aluno.quantidadeAcertos = this.aluno.quantidadeAcertos + 1;
      acertou = true;
    } else {
      this.aluno.quantidadeErros = this.aluno.quantidadeErros + 1;
      mensagem = 'Na próxima você consegue!';
      acertou = false;
    }

    Flushbar(
      padding: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
      borderRadius: 8,
      backgroundColor: acertou ? Colors.lightGreen : Colors.redAccent.shade700,
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: acertou ? "Resposta correta" : "Valor incorreto",
      message: mensagem,
    )..show(context);

    // final snackBar = SnackBar(
    //   content: Text(mensagem),
    //   elevation: 40,
    //   duration: Duration(seconds: 5),

    // );
    // Scaffold.of(context).showSnackBar(snackBar);

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
      'segundosDemorados': difference.inSeconds,
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
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FinalizadaJogadaState(this.aluno, this.sala, "Você completou todo o jogo, parabéns!");
      }));
    }
  }

  @override
  Widget build(BuildContext contextBuild) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final Widget jogada = Stack(
      children: <Widget>[
        Text(
            'Jogada ' +
                _quantidadeJogadas.toString() +
                '/' +
                this.sala.quantidadeProdutos.toString(),
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.blue[700],
            )),
        Text(
          'Jogada ' +
              _quantidadeJogadas.toString() +
              '/' +
              this.sala.quantidadeProdutos.toString(),
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ],
    );

    final Widget produto = Container(
      margin: const EdgeInsets.all(0.0),
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ]),
      height: screenHeight * 0.35,
      width: screenWidth * 1,
      child: produtoAtual != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  produtoAtual.imagem,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                //Text('Valor: ' + produtoAtual.valor.toStringAsPrecision(2))
              ],
            )
          : CircularProgressIndicator(),
    );

    final Widget precoProduto = RotationTransition(
      turns: AlwaysStoppedAnimation(-20 / 360),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Color.fromARGB(255, 71, 150, 236),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ]),
        child: Text(
          "R\$ " + produtoAtual.valor.toStringAsFixed(2).replaceAll('.', ','),
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final Widget btnDesfazerUltima = FloatingActionButton(
      heroTag: "btn1",
      child: Icon(
        Icons.close,
      ),
      backgroundColor: Colors.yellow,
      onPressed: () {
        this.desfazerJogada();
      },
      // child: const Text('Desfazer ultima',
      //     style: TextStyle(fontSize: 14)),
    );

    final Widget btnConfirmar = Builder(
      builder: (BuildContext build) {
        return FloatingActionButton(
          heroTag: "btn2",
          child: Icon(Icons.thumb_up),
          backgroundColor: Colors.lightGreenAccent,
          onPressed: () {
            this.confirmarJogada(build);
          },
          // child: const Text('Confirmar',
          //     style: TextStyle(fontSize: 14)),
        );
      },
    );

    final Widget totalSelecionado = Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.cyanAccent,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ]),
      child: Column(
        children: <Widget>[
          Text(
            "Total selecionado:",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.indigo,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "R\$ " +
                    this
                        .totalSelecionado
                        .toStringAsFixed(2)
                        .replaceAll('.', ','),
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              getIconeComparacao(),
            ],
          ),
        ],
      ),
    );

    final carousel = CarouselSlider(
      items: dinheirosLoaded.map((dinheiro) {
        return Builder(builder: (BuildContext context) {
          return Container(
            child: GestureDetector(
              child: Image.network(
                dinheiro.imagem,
                height: 100,
                width: 100,
              ),
              onTap: () {
                selecionarDinheiro(context, dinheiro);
              },
            ),
          );
        });
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.sala.idSala.toString(),
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: Center(
        child: Container(
          height: screenHeight,
          //width: screenWidth,
          color: Colors.green,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 20),
                child: jogada,
              ),
              Center(
                child: Stack(
                  alignment: const Alignment(-0.7, -0.5),
                  children: <Widget>[produto, precoProduto],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    btnDesfazerUltima,
                    totalSelecionado,
                    btnConfirmar
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: screenHeight * 0.17,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                carousel.previousPage(
                                  duration: Duration(milliseconds: 200), curve: Curves.linear,
                                );
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: CircleBorder(),
                              color: Colors.black12,
                            ),
                          ),
                          Container(
                            child: carousel,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                carousel.nextPage(
                                  duration: Duration(milliseconds: 200), curve: Curves.linear,
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: CircleBorder(),
                              color: Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ouvirPausaJogo() {
    this.db.collection("salas").document(this.sala.documentId)
        .snapshots()
        .listen((sala) {
          Status status = Status.values.firstWhere((o) => o.toString() == sala.data['status']);
          if (status == Status.PAUSADO) {
            mostrarDialog();
          } else if (status == Status.EM_ANDAMENTO) {
            Navigator.of(context).pop();
            this.lastStart = DateTime.now();
          } else if (status == Status.FINALIZADO) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FinalizadaJogadaState(this.aluno, this.sala, "O professor(a) finalizou o jogo.");
            }));
          }
    });
  }

  void mostrarDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Jogo pausado, aguarde!'),
          content: SingleChildScrollView(
            child: CircularProgressIndicator()
          ),
        );
      },
    );
  }

}
