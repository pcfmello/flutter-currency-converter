import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const url = "https://api.hgbrasil.com/finance?format=jsonkey=f3728c6f";

void main() async {
  print(await getData());

  runApp(MaterialApp(home: Home()));
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
                return Center(
                  child: Text("Carregando dados...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar dados :(",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0
                        ),
                        textAlign: TextAlign.center),
                  );
                } else {
                  return Center(
                    child: Text("Dados carregados com sucesso :)",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0
                        ),
                        textAlign: TextAlign.center),
                  );
                }
            }
          }),
    );
  }
}
