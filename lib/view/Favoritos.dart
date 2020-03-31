import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_release/helper/DB/FavoritosDB.dart';
import 'package:game_release/model/GamesModel.dart';
import 'package:game_release/widget/cardGame.dart';

String _teste;

class Favoritos extends StatefulWidget {
  final String teste;
  Favoritos(this.teste) {
    _teste = teste;
  }

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Retorno> _listaJogos = new List<Retorno>();
  String mensagem = "wait, loading!";

  @override
  void deactivate() {
    super.deactivate();
    _listaJogos.clear();
    carregarFavoritos();
  }

  void initState() {
    super.initState();
    _listaJogos.clear();
    carregarFavoritos();
  }

  void carregarFavoritos() {
    FavoritosDB favoritosDB = new FavoritosDB();
    favoritosDB.consultar().then((retorno) {
      if (retorno.length > 0) {
        retorno.forEach((item) {
          Map userMap = jsonDecode(item['conteudoJson']);
          var jogo = Retorno.fromJson(userMap);
          _listaJogos.add(jogo);
        });
        setState(() {
          _listaJogos;
        });
      } else {
        setState(() {
          mensagem = "There are no saved items.";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
        //valida se mosta o progressbar ou monta a coluna
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _header(context),
            Container(
              height: MediaQuery.of(context).size.height - 156,
              child: _listaJogos.length == 0
                  ? Text(
                      mensagem,
                      style: TextStyle(fontSize: 26),
                    )
                  : ListView.builder(
                      itemCount: _listaJogos.length,
                      itemBuilder: (context, index) {
                        return cardGame(context, index, _listaJogos);
                      },
                    ),
            ),
          ],
        ));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
          height: 100,
          child: Text(
            "Favorite Games!",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
