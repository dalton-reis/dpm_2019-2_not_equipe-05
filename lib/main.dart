import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

void main() => runApp(QuantoCusta());

class QuantoCusta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.accent,
          )),
      home: LoginComPin(),
    );
  }
}

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
                          if (numeroSala == 11111) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Sala();
                            }));
                          } else {
                            controller.text = null;
                            hasError = true;
                          }
                        });
                      },
                    ),
                    FlatButton(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Criar uma sala',
                          style:
                              TextStyle(color: Colors.black45, fontSize: 18)),
                      onPressed: () {},
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

class Sala extends StatefulWidget {
  @override
  _SalaState createState() => _SalaState();
}

class _SalaState extends State<Sala> {
  List _dificuldade = ['Básico', 'Fácil', 'Normal', 'Difícil', 'Avançado'];
  List<DropdownMenuItem<String>> dificuldade = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sala'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Dificuldade',
                  hintText: 'Fácil, normal, díficil..',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duração',
                  hintText: '(min)',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade de jogadores',
                  hintText: 'Até 100 jogadores',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                ),
              ),
              RaisedButton(
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginSemPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final numeroSala = TextField(
      keyboardType: TextInputType.number,
      autofocus: true,
      maxLength: 5,
      decoration: InputDecoration(
        hintText: 'Sala',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );

    final entrarBotao = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
//        color: Colors.lightBlueAccent,
        child: Text(
          'Entrar',
//          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    final criarSala = FlatButton(
      child: Text(
        'Criar sala',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            SizedBox(height: 48),
            numeroSala,
            SizedBox(height: 8),
            entrarBotao,
            criarSala
          ],
        ),
      ),
    );
  }
}
