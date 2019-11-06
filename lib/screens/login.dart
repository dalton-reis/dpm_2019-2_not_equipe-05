import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/screens/sala/criacao.dart';
import 'package:quantocusta/screens/sala/criacao_aluno.dart';

class LoginComPin extends StatefulWidget {
  @override
  _LoginComPinState createState() => _LoginComPinState();
}

class _LoginComPinState extends State<LoginComPin> {
  TextEditingController controller = TextEditingController();
  int numeroSala;
  int pinLength = 5;

  bool hasError = false;
  String errorMessage;

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Pin Code Text Field Example"),
//      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              PinCodeTextField(
                autofocus: true,
                controller: controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: pinLength,
                hasError: hasError,
                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                  });
                },
                onDone: (text) {
                  print("DONE $text");
                  debugPrint(controller.text);
                },
                pinCodeTextFieldLayoutType:
                    PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                wrapAlignment: WrapAlignment.start,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
              ),
              Visibility(
                child: Text(
                  "Sala não encontrada!",
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
                visible: hasError,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 20),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        setState(() {
                          numeroSala = int.tryParse(controller.text);
                          db
                              .collection("salas")
                              .limit(1)
                              .where("idSala", isEqualTo: numeroSala)
                              .getDocuments()
                              .then((documents) {
                            if (documents == null ||
                                documents.documents == null ||
                                documents.documents.isEmpty) {
                              controller.text = null;
                              hasError = true;
                            } else {
                              DocumentSnapshot document =
                                  documents.documents.elementAt(0);
                              Classroom classroom =
                                  new Classroom.fromDocument(document);

                              db
                                  .collection("salas")
                                  .document(classroom.documentId)
                                  .collection("produtos")
                                  .getDocuments()
                                  .then((produtos) {
                                List<Produto> produtosMapped = produtos
                                    .documents
                                    .map((document) =>
                                        new Produto.from(document))
                                    .toList();
                                classroom.produtos = produtosMapped;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SalaCriacaoAluno(classroom);
                                }));
                              });
                            }
                          });
                        });
                      },
                    ),
                    FlatButton(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Criar uma sala',
                          style:
                              TextStyle(color: Colors.black45, fontSize: 18)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SalaCriacao();
                        }));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
