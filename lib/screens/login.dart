import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:quantocusta/model/aluno.dart';
import 'package:quantocusta/model/classroom.dart';
import 'package:quantocusta/model/produto.dart';
import 'package:quantocusta/screens/sala/criacao_sala.dart';
import 'package:quantocusta/screens/sala/criacao_aluno.dart';
import 'package:quantocusta/screens/sala/espera_aluno.dart';
import 'package:quantocusta/screens/sala/jogada.dart';

class LoginComPin extends StatefulWidget {
  @override
  _LoginComPinState createState() => _LoginComPinState();
}

class _LoginComPinState extends State<LoginComPin> {

  Classroom classroom;
  Aluno aluno;

  TextEditingController pinController = TextEditingController();
  TextEditingController alunoController = TextEditingController();

  int numeroSala;
  int pinLength = 5;

  bool errorSala = false;
  bool errorAluno = false;
  String errorMessage = "";

  final db = Firestore.instance;

  Future<DocumentReference> adicionarAluno(BuildContext context) {
    return db.collection("salas").document(this.classroom.documentId).collection("alunos").add({
      'nome': alunoController.value.text,
      'quantidadeAcertos': 0,
      'quantidadeErros': 0
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Image(
                //   image: AssetImage('assets/logo1.png'),
                // ),
                PinCodeTextField(
                  autofocus: true,
                  controller: pinController,
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: Colors.lightBlueAccent,
                  defaultBorderColor: Colors.white60,
                  hasTextBorderColor: Colors.lightGreenAccent,
                  maxLength: pinLength,
                  hasError: errorSala,
                  onTextChanged: (text) {
                    setState(() {
                      errorSala = false;
                    });
                  },
                  onDone: (text) {
                    print("DONE $text");
                    debugPrint(pinController.text);
                  },
                  pinCodeTextFieldLayoutType:
                      PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  pinTextStyle: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
                ),
                Visibility(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 20.0,),
                  ),
                  visible: errorSala,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: alunoController,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.person),
                      hintText: "Insira seu nome",
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                      labelText: "Aluno",
                      errorText: errorAluno ? "Informe seu nome!" : null,
                      errorStyle: TextStyle(fontSize: 18),
                      labelStyle:
                          TextStyle(fontSize: 22.0, color: Colors.white),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: alunoController.text.isEmpty ? Colors.white60 : Colors.lightGreenAccent,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightGreenAccent,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ),
                Column(
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
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        setState(
                          () {
                            numeroSala = int.tryParse(pinController.text);
                            if (pinController.text.length < 5) {
                              errorSala = true;
                              errorMessage =
                                  "O identificador da sala exige 5 números!";
                            } else if(alunoController.text.isEmpty) {
                              errorAluno = true;
                            } else {
                              errorSala = false;
                              errorAluno = false;
                              db
                                  .collection("salas")
                                  .limit(1)
                                  .where("idSala", isEqualTo: numeroSala)
                                  .getDocuments()
                                  .then(
                                (documents) {
                                  if (documents == null ||
                                      documents.documents == null ||
                                      documents.documents.isEmpty) {
                                    pinController.text = null;
                                    errorSala = true;
                                    errorMessage = "Sala não encontrada!";
                                  } else {
                                    DocumentSnapshot document =
                                        documents.documents.elementAt(0);
                                    this.classroom =
                                       Classroom.fromDocument(document);
                                    db
                                        .collection("salas")
                                        .document(classroom.documentId)
                                        .collection("produtos")
                                        .getDocuments()
                                        .then(
                                      (produtos) {
                                        List<Produto> produtosMapped = produtos
                                            .documents
                                            .map((document) =>
                                                new Produto.from(document))
                                            .toList();
                                        classroom.produtos = produtosMapped;
                                      },
                                    );
                                    adicionarAluno(context).then((documentReference) {
                                      documentReference.get().then((documentSnapshot) {
                                        Aluno aluno = new Aluno.fromDocument(documentSnapshot);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return SalaEsperaAluno(classroom,aluno);
                                        }));
                                      });
                                    });
                                  }
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                    FlatButton(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Criar uma sala',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SalaCriacao();
                        }));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
