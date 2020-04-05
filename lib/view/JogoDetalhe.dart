import 'dart:convert';
//import 'dart:html' as html;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:game_release/helper/DB/FavoritosDB.dart';
import 'package:game_release/helper/ValidaConexao.dart';
import 'package:game_release/widget/loading.dart';
import 'package:game_release/widget/semConexao.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Todos.dart';
import '../model/GamesModel.dart';

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
  bool _progressBarActive = true;
  bool _statusConexao = true;
  bool _favoritado = false;
  List<NetworkImage> _listaFotos = List<NetworkImage>();
  voltar() {
    Navigator.pop(context);
  }

  favoritos() async {
    FavoritosDB favoritosDB = new FavoritosDB();
    var consultar = await favoritosDB.consultarId(_jogo.id);
    if (consultar.length > 0) {
      favoritosDB.deletar(_jogo.id);
      setState(() {
        _favoritado = false;
      });
      //favoritosDB.deletarbanco();
      return;
    }
    String json = jsonEncode(_jogo.toJson());
    favoritosDB.inserir(_jogo.id, json);
    setState(() {
        _favoritado = true;
      });
  }

  Future<Null> getGameDetalhe() async {
    if (!await ValidaConexao.status()) {
      setState(() {
        _progressBarActive = false;
        _statusConexao = false;
      });
      return;
    }
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
      _progressBarActive = false;
    });
  }

  @override
  void initState() {
    super.initState();
    FavoritosDB favoritosDB = new FavoritosDB();
    favoritosDB.consultarId(_jogo.id).then((retorno) {
      if (retorno.length > 0) {
        setState(() {
          _favoritado = true;
        });
      }
    });
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
        body: _progressBarActive == true
            ? loading(context)
            : _statusConexao == false
                ? semConexao()
                : Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              _header(context),
                              _jogo.descricao != "" ? _descricao() : Text(""),
                              _cardPlataformaLoja(
                                  "Plataforms: ", _jogo.plataformas),
                              _cardPlataformaLoja("Stores: ", _jogo.lojas),
                              _sliderImage(context),
                              _jogo.videoyoutube ==
                                      "https://www.youtube.com/embed/"
                                  ? Text("")
                                  : _videoYoutube(),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                        child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => voltar()),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 10, 0),
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: _favoritado == false ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
                            onPressed: () => favoritos()),
                      ),
                    ],
                  ));
  }

  Widget _videoYoutube() {
    return Container(
      height: 250,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
      child: WebView(
        initialUrl: Uri.dataFromString(
                '<iframe width="100%" height="100%" src="${_jogo.videoyoutube}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
                mimeType: 'text/html')
            .toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  Widget _cardPlataformaLoja(texto, itens) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            width: 140,
            child: Text(texto, style: TextStyle(fontSize: 20)),
          ),
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 166,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: itens.length,
                itemBuilder: (BuildContext context, int index) {
                  return texto == "Plataforms: "
                      ? _listaPlataforma(context, index)
                      : _listaLoja(context, index);
                },
              )),
        ],
      ),
    );
  }

  Widget _descricao() {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
          child: Text(
            "Description:",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
          child: Text(
            _jogo.descricao ?? "",
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    ));
  }

  Widget _listaPlataforma(BuildContext context, int index) {
    var plataforma = _jogo.plataformas.elementAt(index);
    return Container(
        child: new IconButton(
            iconSize: 30,
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
            iconSize: 30,
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
    String conteudo =
        "${_jogo.publishers ?? _jogo.developer ?? ""} - Genre: ${Genero().retornaString(_jogo.generos) ?? ""} \nDate: ${_jogo.data ?? ""}";
    return Stack(
      children: <Widget>[
        Container(
          height: 500,
          child: Image.network(
            _jogo.background ?? "https://arcadaweb.com.br/img/cardnotfound.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Column(
              children: <Widget>[
                Container(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    //break line
                    width: MediaQuery.of(context).size.width,
                    child: Text("${_jogo.nome}",
                        style: TextStyle(
                          fontSize: 30,
                        ))),
                Container(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  width: MediaQuery.of(context).size.width,
                  child: _notaStar(),
                ),
                Container(
                    //break line
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    width: MediaQuery.of(context).size.width,
                    child: Text(conteudo,
                        style: TextStyle(
                          fontSize: 18,
                        ))),
              ],
            ))
      ],
    );
  }

  Widget _notaStar() {
    if (_jogo.nota >= 0 && _jogo.nota < 0.5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 0.5 && _jogo.nota < 1) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 1 && _jogo.nota < 1.5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 1.5 && _jogo.nota < 2) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 2 && _jogo.nota < 2.5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 2.5 && _jogo.nota < 3) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 3 && _jogo.nota < 3.5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 3.5 && _jogo.nota < 4) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 4 && _jogo.nota < 4.5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border)
      ]);
    }
    if (_jogo.nota >= 4.5 && _jogo.nota < 5) {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half)
      ]);
    } else {
      return Row(children: <Widget>[
        Text("Rating: ",
            style: TextStyle(
              fontSize: 18,
            )),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star)
      ]);
    }
  }

  Widget _sliderImage(BuildContext context) {
    return Container(
        child: SizedBox(
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.fill,
        autoplay: false,
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
