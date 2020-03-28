import 'package:flutter/material.dart';

String _teste;

class Favoritos extends StatefulWidget {
  
  final String teste;
   Favoritos(this.teste){
     _teste = teste;
   }

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 26, 1),
      body: Container(
        padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
        child: Text(
          _teste,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}