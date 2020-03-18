import 'package:flutter/material.dart';
import 'package:game_release/home.dart';

import 'Todos.dart';
import 'model/GamesModel.dart';

Retorno _jogo;

class JogoDetalhe extends StatefulWidget {
    final Retorno jogo;
  JogoDetalhe(this.jogo) {
    _jogo = jogo;
  }

  @override
  _JogoDetalheState createState() => _JogoDetalheState();
}

class _JogoDetalheState extends State<JogoDetalhe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
        child: FlatButton(onPressed: () => voltar(), child: Text(_jogo.nome)),
      ),
    );
  }

  voltar() {
    Navigator.pop(
            context);
  }
}
