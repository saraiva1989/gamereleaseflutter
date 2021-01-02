import 'package:flutter/material.dart';
import 'package:game_release/model/GamesModel.dart';
import 'package:game_release/view/JogoDetalhe.dart';

Widget cardGame(BuildContext context, int index, List<Retorno> _listaJogos) {
  String nome = _listaJogos.elementAt(index).nome;
  String background = _listaJogos.elementAt(index).background ??
      "https://thumbs.dreamstime.com/t/error-page-not-found-pixel-art-bit-objects-retro-game-assets-set-icons-vintage-computer-video-arcades-vector-illustration-136642892.jpg";
  //var valor = _listaJogos.values.elementAt(index)["buy"];

  return Container(
      height: 200,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    JogoDetalhe(_listaJogos.elementAt(index)))),
        child: Card(
          color: Color.fromRGBO(26, 40, 65, 1),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 15,
          child: Stack(
            children: <Widget>[
              Image.network(
                background,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                      //break line
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text("$nome",
                          style: TextStyle(
                              fontSize: 30,
                              backgroundColor: Color.fromRGBO(0, 0, 0, 0.4))))),
            ],
          ),
        ),
      ));
}
