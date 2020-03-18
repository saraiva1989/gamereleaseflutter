import 'package:flutter/material.dart';
import 'Favoritos.dart';
import 'ProximoTrinta.dart';
import 'Todos.dart';

bool _retornoDetalhe = false;

class Home extends StatefulWidget {
  final retornoDetalhe;
  Home(this.retornoDetalhe){
    _retornoDetalhe = retornoDetalhe;
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

//tab bar click
  Widget onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        return Todos(_retornoDetalhe);
        break;
      case 1:
        return ProximoTrinta("teste proximo trinta");
        break;
      case 2:
        return Favoritos("teste favoritos");
        break;
      default:
        Todos(_retornoDetalhe);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      body: onTabTapped(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),

        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.games),
            title: new Text('Jogos'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text('Próximo 30 dias'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text('Favorito'))
        ],
      ),
    );
  }
}
