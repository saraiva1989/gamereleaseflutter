import 'package:flutter/material.dart';
//import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Filtro.dart';
import 'JogoDetalhe.dart';
import 'model/GamesModel.dart';

String _urlBase;
List<Retorno> _listaJogos;
GamesModel _gamesModel;
bool _progressBarActive = true;
bool _moreItem = false;
bool _retornoDetalhe;
var _filter;
//header api
Map<String, String> get headers => {"CHAVE": "576DJKH09KL2342VCXBZ09B"};
TextEditingController plataformaController = TextEditingController();

class Todos extends StatefulWidget {
  final bool retornoDetalhe;
  Todos(this.retornoDetalhe) {
    _retornoDetalhe = retornoDetalhe;
  }
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  //responsavel por identificar o scroll da pagina;
  ScrollController scrollController = ScrollController();

  void telaFiltro() async {
    //recupera dados do pop da tela de filtro
    _filter = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Filtro()));
    setState(() {
      _progressBarActive = true;
    });
    getGames(false, true);
  }

  String montarUrl(bool loadMore, bool filter) {
    if (loadMore) {
      if (_gamesModel.next == null) {
        setState(() {
          _moreItem = false;
        });
      }
      var next = _gamesModel.next.replaceAll("&", "%26");
      return _urlBase =
          "http://arcadaweb.com.br/api/gamerelease/listagames.php?next=$next";
    }
    if (filter && _filter != null && _filter != "") {
      return "http://arcadaweb.com.br/api/gamerelease/listagames.php?$_filter";
    } else {
      DateTime dateTimeInicio =
          new DateTime.now().add(new Duration(days: -365));
      DateTime dateTimeFim = new DateTime.now();
      String dataInicio =
          "${dateTimeInicio.year.toString()}-${dateTimeInicio.month.toString().padLeft(2, '0')}-${dateTimeInicio.day.toString().padLeft(2, '0')}";
      String dataFim =
          "${dateTimeFim.year.toString()}-${dateTimeFim.month.toString().padLeft(2, '0')}-${dateTimeFim.day.toString().padLeft(2, '0')}";
      _urlBase =
          "http://arcadaweb.com.br/api/gamerelease/listagames.php?datainicio=$dataInicio&datafim=$dataFim&order=-released";
      return _urlBase;
    }
  }

  Future<Null> getGames(bool loadMore, bool filter) async {
    //biblioteca terceiro - http: ^0.12.0+4
    String url = montarUrl(loadMore, filter);

    http.Response response = await http.get(url, headers: headers);
    Map<String, dynamic> retorno = json.decode(response.body);
    //deserializando o json para minha model
    _gamesModel = GamesModel.fromJson(retorno);
    setState(() {
      _progressBarActive = false;
      _moreItem = false;
      if (loadMore) {
        //adicionando novos itens a lista
        _listaJogos.addAll(_gamesModel.retorno);
        return;
      }
      _listaJogos = _gamesModel.retorno;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_retornoDetalhe) return;
    getGames(false, false);
    //responsavel para identificar se chegou ao fim do scroll da lista
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
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
            ? _loading(context)
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _header(context),
                  Container(
                    //seta o tamanho da tela de acordo com o componente usado.
                    height: _moreItem == true
                        ? MediaQuery.of(context).size.height - 192
                        : MediaQuery.of(context).size.height - 156,
                    //atualiza a pagina quando puxar a lista para cima
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
                                return _jogoCard(context, index);
                              },
                            ),
                    ),
                  ),
                  _moreItem == true
                      ? _loading(context)
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
          //alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
          height: 100,
          child: Text(
            "Todos os Jogos!",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        InkWell(
          onTap: () => telaFiltro(),
          child: Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width - 280, 40, 0, 0),
            child: Icon(
              Icons.filter_list,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
        alignment: Alignment.center, child: CircularProgressIndicator());
  }

  Widget _jogoCard(BuildContext context, int index) {
    String nome = _listaJogos.elementAt(index).nome;
    String data = _listaJogos.elementAt(index).data;
    String background = _listaJogos.elementAt(index).background ??
        "https://arcadaweb.com.br/img/cardnotfound.jpg";
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
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
                                backgroundColor:
                                    Color.fromRGBO(0, 0, 0, 0.4))))),
              ],
            ),
          ),
        ));
  }
}

//dialog quando quiser usar
// Widget _showFilter(BuildContext context) {
//   //configura o button
//   Widget okButton = FlatButton(
//     child: Text("OK"),
//     onPressed: () {
//       setState(() {
//         _gamesModel = null;
//         _progressBarActive = true;
//       });
//       getGames(false, true);
//       Navigator.pop(context);
//     },
//   );
//   // configura o  AlertDialog
//   AlertDialog alerta = AlertDialog(
//     title: Text("Pesquisar"),
//     content: Container(
//       height: 300,
//       child: Column(
//         children: <Widget>[
//           _mydropdown(context),
//         ],
//       ),
//     ),
//     actions: [
//       okButton,
//     ],
//   );
//   // exibe o dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alerta;
//     },
//   );
//   //flutter defined function
// }
