import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quantocusta/components/input_text.dart';
import 'package:quantocusta/model/enums.dart';

class SalaCriacao extends StatefulWidget {
  @override
  _SalaCriacaoState createState() => _SalaCriacaoState();
}

class _SalaCriacaoState extends State<SalaCriacao> {
  final db = Firestore.instance;
  final TextEditingController _controllerTeacher = TextEditingController();
  //final TextEditingController _controllerDificulty = TextEditingController();
  Dificulty valueDificulty = Dificulty.FACIL;
  final TextEditingController _controllerTime = TextEditingController();
  final TextEditingController _controllerPlayersAmount =
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

  int generateRandom(){
    var _random = Random();
    int min = 0, max = 99999;
    return min + _random.nextInt(max - min);
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
                /*InputText(
                  icon: Icons.swap_vert,
                  hint: 'Insira o nível de dificuldade',
                  labelText: 'Dificuldade',
                  controller: _controllerDificulty,
                ),*/

                InputText(
                  icon: Icons.people,
                  hint: 'Insira a quantidade máxima de jogadores',
                  labelText: 'Qnt. Jogadores',
                  controller: _controllerPlayersAmount,
                  keyboardType: TextInputType.number,
                ),
                InputText(
                  icon: Icons.alarm,
                  hint: 'Insira o tempo de duração (min)',
                  labelText: 'Duração',
                  controller: _controllerTime,
                  keyboardType: TextInputType.number,
                ),
                /*TextField(
                  controller: _controllerDificuldade,
                  decoration: InputDecoration(
                    labelText: 'Dificuldade',
                    hintText: 'Fácil, Médio, Difícil',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _controllerDuracao,
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
                  controller: _controllerQntJogadores,
                  decoration: InputDecoration(
                    labelText: 'Quantidade de jogadores',
                    hintText: 'Até 100 jogadores',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                ),*/
                DropdownButton<Dificulty>(
                  value: valueDificulty,
                  onChanged: (Dificulty newValue) {
                    setState(() {
                      valueDificulty = newValue;
                    });
                  },
                  items: Dificulty.values.map((Dificulty dificulty) {
                    return DropdownMenuItem<Dificulty>(
                        value: dificulty,
                        child: Text(dificulty.toString()));
                  }).toList(),
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
                      db.collection("salas").document().setData(
                        {
                          'idSala': generateRandom(),
                          'dificuldade': valueDificulty.toString(),
                          'duracao': int.tryParse(_controllerTime.value.text.toString()),
                          'nomeProfessor': _controllerTeacher.value.text.toString(),
                          'status': Status.AGUARDANDO.toString(),
                          'qntJogadores': int.tryParse(_controllerPlayersAmount.value.text.toString()),
                        },
                      );
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
