import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String _console = "";
TextEditingController _dataInicio = TextEditingController();
TextEditingController _dataFim = TextEditingController();
TextEditingController _nome = TextEditingController();

class Filtro extends StatefulWidget {
  @override
  _FiltroState createState() => _FiltroState();
}

class _FiltroState extends State<Filtro> {
  @override
  void initState() {
    super.initState();
    if (_dataInicio.text == "") {
      _dataInicio.text = gerarData(0);
    }
    if (_dataFim.text == "") {
      _dataFim.text = gerarData(31);
    }
  }

  String gerarData(int dias) {
    DateTime data = new DateTime.now().add(new Duration(days: dias));
    return "${data.year.toString()}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
  }

  formatarData(data) {
    if (data == null) return;
    return "${data.year.toString()}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
  }

  voltar() {
    String filtro;
    if (_nome.text != null && _nome.text != "") {
      filtro = "nome=${_nome.text}";
    } else {
      filtro =
          "order=released&datainicio=${_dataInicio.text ?? ""}&datafim=${_dataFim.text ?? ""}&plataforma=$_console";
    }
    Navigator.pop(context, filtro);
    //Navigator.pushReplacementNamed(context, "home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 100,
            child: Text(
              "Filter!",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Container(child: _mydropdown(context)),
          Container(child: _campoData(context, _dataInicio, "Start date")),
          Container(child: _campoData(context, _dataFim, "End date")),
          Container(
            child: _pesquisaNome(context),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              height: 60,
              child: FlatButton(
                onPressed: () => voltar(),
                child: Text("Search"),
                color: Color.fromRGBO(30, 30, 30, 1),
              )),
        ],
      ),
    ));
  }

  Widget _pesquisaNome(BuildContext context) {
    return TextFormField(
      controller: _nome,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Optional: Input game name",
      ),
    );
  }

  Widget _campoData(
      BuildContext context, TextEditingController data, String label) {
    return TextFormField(
      controller: data,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: label,
      ),
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));

        data.text = formatarData(date);
      },
    );
  }

  Widget _mydropdown(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select Item'),
      value: _console,
      items: [
        DropdownMenuItem<String>(
          child: Text('All'),
          value: '',
        ),
        DropdownMenuItem<String>(
          child: Text('PS5'),
          value: '187',
        ),
        DropdownMenuItem<String>(
          child: Text('Xbox|X/S'),
          value: '186',
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
