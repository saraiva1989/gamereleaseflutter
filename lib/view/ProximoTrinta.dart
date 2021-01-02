import 'package:flutter/material.dart';
import 'package:game_release/helper/ValidaConexao.dart';
import 'package:game_release/widget/cardGame.dart';
import 'package:game_release/widget/loading.dart';
import 'package:game_release/widget/semConexao.dart';
//import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/GamesModel.dart';

String _urlBase;
List<Retorno> _listaJogos;
GamesModel _gamesModel;
bool _progressBarActive = true;
bool _moreItem = false;
bool _retornoDetalhe;
//header api
Map<String, String> get headers => {"CHAVE": "XXXVKJFD978FKLJFDIUGLDXXX"};
TextEditingController plataformaController = TextEditingController();

class ProximoTrinta extends StatefulWidget {
  final bool retornoDetalhe;
  ProximoTrinta(this.retornoDetalhe) {
    _retornoDetalhe = retornoDetalhe;
  }
  @override
  _ProximoTrintaState createState() => _ProximoTrintaState();
}

class _ProximoTrintaState extends State<ProximoTrinta> {
  //responsavel por identificar o scroll da pagina;
  ScrollController scrollController = ScrollController();
  bool _statusConexao = true;

  String montarUrl(bool loadMore, bool filter) {
    if (loadMore) {
      if (_gamesModel.next == null) {
        setState(() {
          _moreItem = false;
        });
      }
      var next = _gamesModel.next.replaceAll("&", "%26");
      return _urlBase =
          "https://saraiva89.com/dev/api/gamerelease/listagames.php?next=$next";
    }

    DateTime dateTimeInicio = new DateTime.now();
    DateTime dateTimeFim = new DateTime.now().add(new Duration(days: 31));
    String dataInicio =
        "${dateTimeInicio.year.toString()}-${dateTimeInicio.month.toString().padLeft(2, '0')}-${dateTimeInicio.day.toString().padLeft(2, '0')}";
    String dataFim =
        "${dateTimeFim.year.toString()}-${dateTimeFim.month.toString().padLeft(2, '0')}-${dateTimeFim.day.toString().padLeft(2, '0')}";
    _urlBase =
        "https://saraiva89.com/dev/api/gamerelease/listagames.php?datainicio=$dataInicio&datafim=$dataFim&order=released";
    return _urlBase;
  }

  Future<Null> getGames(bool loadMore, bool filter) async {
    if (!await ValidaConexao.status()) {
      setState(() {
        _progressBarActive = false;
        _statusConexao = false;
      });
      return;
    }
    String url = montarUrl(loadMore, filter);

    http.Response response = await http.get(url, headers: headers);
    Map<String, dynamic> retorno = json.decode(response.body);
    _gamesModel = GamesModel.fromJson(retorno);
    setState(() {
      _progressBarActive = false;
      _moreItem = false;
      if (loadMore) {
        _listaJogos.addAll(_gamesModel.retorno);
        return;
      }
      _listaJogos = _gamesModel.retorno;
    });
  }

  @override
  void initState() {
    super.initState();
    _progressBarActive = true;
    if (_retornoDetalhe) return;
    getGames(false, false);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          _progressBarActive = false;
          _moreItem = true;
        });
        getGames(true, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(26, 26, 26, 1),
        //valida se mosta o progressbar ou monta a coluna
        body: _progressBarActive == true
            ? loading(context)
            : _statusConexao == false
                ? semConexao()
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _header(context),
                      Container(
                        height: _moreItem == true
                            ? MediaQuery.of(context).size.height - 192
                            : MediaQuery.of(context).size.height - 156,
                        child: RefreshIndicator(
                          onRefresh: () => getGames(false, false),
                          child: _listaJogos.length == 0
                              ? Text(
                                  "Game not found!",
                                  style: TextStyle(fontSize: 26),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: _listaJogos.length,
                                  itemBuilder: (context, index) {
                                    return cardGame(
                                        context, index, _listaJogos);
                                  },
                                ),
                        ),
                      ),
                      _moreItem == true
                          ? loading(context)
                          : Text(
                              "",
                              style: TextStyle(fontSize: 0.1),
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
            "Next 30 days!",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
