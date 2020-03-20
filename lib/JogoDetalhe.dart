import 'package:carousel_pro/carousel_pro.dart';
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
  List<NetworkImage> _listaFotos = List<NetworkImage>();
  void initState() {
    super.initState();
    if(_jogo.fotos.length == 0)
    _listaFotos.add(NetworkImage("https://arcadaweb.com.br/img/cardnotfound.jpg"));
    for (var item in _jogo.fotos){
      _listaFotos.add(NetworkImage(item.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: <Widget>[
                _sliderImage(context),
                Text(
                  "Doom is a first-person shooter video game developed by id Software and published by Bethesda Softworks. It was released worldwide on Windows, PlayStation 4, and Xbox One in May 2016 and is powered by id Tech 6. A port for Nintendo Switch was co-developed with Panic Button and released in November 2017.",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
      ],
    ));
  }

  Widget _sliderImage(BuildContext context) {
    return Container(
        child: SizedBox(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.fill,
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1500),
        dotSize: 6.0,
        dotIncreasedColor: Color(0xFFFF335C),
        dotBgColor: Colors.transparent,
        dotPosition: DotPosition.bottomCenter,
        dotVerticalPadding: 10.0,
        showIndicator: true,
        indicatorBgPadding: 7.0,
        images: _listaFotos,
      ),
    ));
  }

  voltar() {
    Navigator.pop(context);
  }
}
