import 'dart:convert';
//import 'dart:html' as html;

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  voltar() {
    Navigator.pop(context);
  }

  Future<Null> getGameDetalhe() async {
    //biblioteca terceiro - http: ^0.12.0+4
    String url =
        "http://arcadaweb.com.br/api/gamerelease/listagames.php?id=${_jogo.id}";

    http.Response response = await http.get(url, headers: headers);
    Map<String, dynamic> retorno = json.decode(response.body);
    //deserializando o json para minha model

    setState(() {
      _jogo.publishers = retorno["publishers"];
      _jogo.descricao = retorno["descricao"];
      _jogo.website = retorno["website"];
      for (var retorno in retorno["lojas"]) {
        for (var loja in _jogo.lojas) {
          if (loja.id == retorno["id"]) {
            loja.url = retorno["url"];
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getGameDetalhe();
    if (_jogo.fotos.length == 0)
      _listaFotos
          .add(NetworkImage("https://arcadaweb.com.br/img/cardnotfound.jpg"));
    for (var item in _jogo.fotos) {
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
                _header(context),
                Text(
                  _jogo.website ?? "",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  _jogo.descricao ?? "",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _jogo.plataformas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listaPlataforma(context, index);
                      },
                    )),
                Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _jogo.lojas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _listaLoja(context, index);
                      },
                    )),
                _sliderImage(context),
              ],
            )),
      ],
    ));
  }

  Widget _listaPlataforma(BuildContext context, int index) {
    var plataforma = _jogo.plataformas.elementAt(index);
    return Container(
        child: new IconButton(
            // Use the MdiIcons class for the IconData
            icon: new Icon(_selecionaIconePlataforma(plataforma.id)),
            onPressed: () {
              print('Using the sword');
            }));
  }

  Widget _listaLoja(BuildContext context, int index) {
    var lojas = _jogo.lojas.elementAt(index);
    return Container(
        child: new IconButton(
            // Use the MdiIcons class for the IconData
            icon: new Icon(_selecionaIconeLoja(lojas.id)),
            onPressed: () {
              _carregaUrlWebView(lojas.url);
            }));
  }

    //necessário ir ao diretorio do ios e instalar o pod
    //cd ios | pod install
  _carregaUrlWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _header(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 500,
          child: Image.network(
            _jogo.background,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
        Positioned(
            bottom: 40,
            left: 10,
            child: Container(
                //break line
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(_jogo.nome,
                    style: TextStyle(
                        fontSize: 30,
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.4))))),
        Positioned(
            bottom: 10,
            left: 10,
            child: Container(
                //break line
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(_jogo.publishers ?? _jogo.developer ?? "",
                    style: TextStyle(
                        fontSize: 18,
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.4))))),
      ],
    );
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

  IconData _selecionaIconePlataforma(int id) {
    switch (id) {
      case 14:
        return MdiIcons.microsoftXbox;
      case 1:
        return MdiIcons.microsoftXbox;
      case 16:
        return MdiIcons.sonyPlaystation;
      case 18:
        return MdiIcons.sonyPlaystation;
      case 7:
        return MdiIcons.nintendoSwitch;
      case 4:
        return MdiIcons.desktopTowerMonitor;
      default:
        return MdiIcons.microsoftXboxController;
    }
  }

  IconData _selecionaIconeLoja(int id) {
    switch (id) {
      case 1:
        return MdiIcons.steam;
      case 2:
        return MdiIcons.microsoftXbox;
      case 3:
        return MdiIcons.sonyPlaystation;
      case 6:
        return MdiIcons.nintendoSwitch;
      case 7:
        return MdiIcons.microsoftXbox;
      default:
        return MdiIcons.gamepadVariantOutline;
    }
  }
}
