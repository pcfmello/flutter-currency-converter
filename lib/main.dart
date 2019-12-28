import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const url = "https://api.hgbrasil.com/finance?format=jsonkey=f3728c6f";

void main() async {
  print(await getData());

  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        )),
      )));
}

Future<Map> getData() async {
  http.Response resp = await http.get(url);
  return json.decode(resp.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar = 0;
  double euro = 0;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final eurController = TextEditingController();

  void _onChangeReal(String text) {
    if (text.isEmpty) {
      _clearFields();
    } else {
      double real = double.parse(text);
      dollarController.text = (real / dollar).toStringAsFixed(2);
      eurController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _onChangeDollar(String text) {
    if (text.isEmpty) {
      _clearFields();
    } else {
      double dollar = double.parse(text);
      realController.text = (dollar * this.dollar).toStringAsFixed(2);
      eurController.text = (dollar * dollar / euro).toStringAsFixed(2);
    }
  }

  void _onChangeEur(String text) {
    if (text.isEmpty) {
      _clearFields();
    } else {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
    }
  }

  void _clearFields() {
    realController.text = "";
    dollarController.text = "";
    eurController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return buildResponseMessage("Carregando dados...");
              default:
                if (snapshot.hasError) {
                  return buildResponseMessage("Erro ao carregar os dados :(");
                }

                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      buildTextField("Reais", "R\$", realController, _onChangeReal),
                      Divider(),
                      buildTextField("Dólares", "US\$", dollarController, _onChangeDollar),
                      Divider(),
                      buildTextField("Euro", "€", eurController, _onChangeEur)
                    ],
                  ),
                ));
            }
          }),
    );
  }
}

Widget buildResponseMessage(String message) {
  return Center(
    child: Text(message,
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center),
  );
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChange) {
  return TextField(
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: " $prefix",
        prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0)),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    controller: controller,
    onChanged: onChange,
  );
}
