import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/dinheiro.dart';
import 'package:quantocusta/model/enums.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf/pdf.dart' as tex;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

class FinalizadaJogadaProfessorState extends StatefulWidget {
  @override
  _FinalizadaJogadaProfessorState createState() =>
      _FinalizadaJogadaProfessorState(this.sala);

  Classroom sala;

  FinalizadaJogadaProfessorState(this.sala);
}

class _FinalizadaJogadaProfessorState
    extends State<FinalizadaJogadaProfessorState> {
  final db = Firestore.instance;

  Classroom sala;

  _FinalizadaJogadaProfessorState(this.sala);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext contextBuild) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Parabéns!",
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
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text(
                              "Enviar PDF",
                              style: TextStyle(fontSize: 20),
                            ),
                            padding: EdgeInsets.all(12),
                            onPressed: () {
                              carregarImagens().then((imagens) {
                                gerarPdf().then((fileCreated) {
                                  print("saved on " + fileCreated.path);

                                  final MailOptions mailOptions = MailOptions(
                                      body:'Segue em anexo o resultado da sala ' + this.sala.idSala.toString(),
                                      subject: 'Quantocu\$ta - Resultado da sala ' + this.sala.idSala.toString(),
                                      recipients: ['nicolasjcviana@gmail.com'],
                                      isHTML: true,
                                      attachments: [fileCreated.path]);

                                  return FlutterMailer.send(mailOptions);
                                }).then((emailSended) {
                                  print('feito');
                                });
                              });
                            },
                          )
                        ])
                      ]))
            ]),
          ),
        ));
  }

  Future<dynamic> gerarPdf() async {
    QuerySnapshot alunosQuery = await this
        .db
        .collection("salas")
        .document(this.sala.documentId)
        .collection("alunos")
        .getDocuments();
    List<Aluno> alunos = [];
    for (DocumentSnapshot aluno in alunosQuery.documents) {
      QuerySnapshot produtosAluno =
          await aluno.reference.collection("produtos").getDocuments();
      List<ProdutoAluno> produtos = produtosAluno.documents
          .map((doc) => new ProdutoAluno.fromDocument(doc))
          .toList();
      produtos.sort((a, b) => a.nome.compareTo(b.nome));
      alunos.add(new Aluno.fromDocumentAndProdutos(aluno, produtos));
    }

    final pdfLib.Document pdf = await createPdf(alunos);

    final String dir = (await getExternalStorageDirectory()).path;
    final String path = '$dir/sala_' + this.sala.idSala.toString() + '.pdf';
    final File file = File(path);
    return file.writeAsBytes(pdf.save());
  }

  pdfLib.Table createTable(
      pdfLib.Context context, List<Aluno> alunos, pdfLib.Document pdf) {
    final List<pdfLib.TableRow> rows = <pdfLib.TableRow>[];
    final List<pdfLib.Widget> tableRow = <pdfLib.Widget>[];

    if (alunos.isNotEmpty) {
      tableRow.add(pdfLib.Container(
          alignment: pdfLib.Alignment.center,
          margin: pdfLib.EdgeInsets.all(5),
          child: pdfLib.Text("")));

      var produtosSala = this.sala.produtos;
      produtosSala.sort((a, b) => a.nome.compareTo(b.nome));

      for (Produto produto in produtosSala) {
        tableRow.add(pdfLib.Container(
            alignment: pdfLib.Alignment.center,
            width: 50,
            height: 35,
            child: pdfLib.Column(children: [
//                  pdfLib.Image(tex.PdfImage(pdf.document, image: produto.imageA, width: 50, height: 50)),
              pdfLib.Text(produto.nome),
              pdfLib.Text("R\$ " +
                  produto.valor.toStringAsFixed(2).replaceAll(".", ","))
            ])));
      }

      rows.add(pdfLib.TableRow(children: tableRow));

      for (Aluno aluno in alunos) {
        final List<pdfLib.Widget> tableRow = <pdfLib.Widget>[];
        tableRow.add(pdfLib.Container(
            margin: const pdfLib.EdgeInsets.all(5),
            height: 15,
            width: 100,
            child: pdfLib.Text(aluno.nome)));

        for (Produto produto in produtosSala) {
          ProdutoAluno produtoAluno = aluno.produtos.firstWhere(
              (prodAluno) => prodAluno.documentId == produto.documentId,
              orElse: () => null);

          if (produtoAluno == null) {
            tableRow.add(pdfLib.Container(
                alignment: pdfLib.Alignment.center,
                height: 25,
                width: 15,
                color: tex.PdfColor(1, 0.53, 0)));
          } else {
            if (produtoAluno.acertou) {
              // o mais estourado do tempo é 2 minutos = 120s
              // o maior vermelho é 94
              // o maior verde é 144
              // 94 = 120
              // x =  55

              num segundos = produtoAluno.segundosDemorados < 120
                  ? produtoAluno.segundosDemorados
                  : 120;

              num r = ((segundos * 26) / 120) / 100;
              num g = ((segundos * 255) / 120) / 100;
              num b = 0.0;
              tableRow.add(pdfLib.Container(
                  alignment: pdfLib.Alignment.center,
                  height: 25,
                  width: 15,
                  color: tex.PdfColor(r, g, b)));
            } else {
              tableRow.add(pdfLib.Container(
                  alignment: pdfLib.Alignment.center,
                  height: 25,
                  width: 15,
                  color: tex.PdfColor(1, 0.92, 0))); // amarelo
            }
          }
        }

        rows.add(
            pdfLib.TableRow(children: tableRow, repeat: aluno == alunos.first));
      }
    }

    return pdfLib.Table(
        border: const pdfLib.TableBorder(),
        tableWidth: pdfLib.TableWidth.max,
        children: rows);
  }

  pdfLib.Document createPdf(List<Aluno> alunos) {
    pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
          build: (context) => buildPdf(pdf, context, alunos),
          orientation: pdfLib.PageOrientation.landscape),
    );

    return pdf;
  }

  List<pdfLib.Widget> buildPdf(
          pdfLib.Document pdf, pdfLib.Context context, List<Aluno> alunos) =>
      [
        pdfLib.Container(
            alignment: pdfLib.Alignment.center,
            height: 20,
            width: 200,
            child: pdfLib.Text("Resultado sala " + this.sala.idSala.toString(),
                textAlign: pdfLib.TextAlign.center,
                style: pdfLib.TextStyle(
                    fontWeight: pdfLib.FontWeight.bold, fontSize: 16))),
        createTable(context, alunos, pdf)
      ];

  Future<bool> carregarImagens() async {
//    for(Produto p in this.sala.produtos) {
//      p.imagemA = await networkImageToByte(p.imagem);
//    }
    return true;
  }
}
