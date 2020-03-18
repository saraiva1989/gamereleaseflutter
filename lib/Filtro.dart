import 'package:flutter/material.dart';

import 'home.dart';

String _console;

class Filtro extends StatefulWidget {
  @override
  _FiltroState createState() => _FiltroState();
}

class _FiltroState extends State<Filtro> {
  voltar() {
    Navigator.pop(context, _console);
    //Navigator.pushReplacementNamed(context, "home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
            height: 100,
            child: Text(
              "Filtro!",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: _mydropdown(context)),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              height: 60,
              child: FlatButton(
                onPressed: () => voltar(),
                child: Text("Filtrar"),
                color: Color.fromRGBO(30, 30, 30, 1),
              )),
        ],
      ),
    );
  }

  Widget _mydropdown(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select Item'),
      value: _console,
      items: [
        DropdownMenuItem<String>(
          child: Text('Todos'),
          value: '',
        ),
        DropdownMenuItem<String>(
          child: Text('PS4'),
          value: '18',
        ),
        DropdownMenuItem<String>(
          child: Text('Xbox One'),
          value: '1',
        ),
        DropdownMenuItem<String>(
          child: Text('PC'),
          value: '4',
        ),
        DropdownMenuItem<String>(
          child: Text('Switch'),
          value: '7',
        ),
      ],
      onChanged: (String value) {
        setState(() {
          _console = value;
        });
      },
    );
  }
}
