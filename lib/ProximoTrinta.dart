import 'package:flutter/material.dart';

String _teste;

class ProximoTrinta extends StatefulWidget {
  
  final String teste;
   ProximoTrinta(this.teste){
     _teste = teste;
   }

  @override
  _ProximoTrintaState createState() => _ProximoTrintaState();
}

class _ProximoTrintaState extends State<ProximoTrinta> {
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