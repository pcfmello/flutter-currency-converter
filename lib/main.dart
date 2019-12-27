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
          )
        ),
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
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar dados :(",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                          TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Reais",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "R\$ ",
                                  prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0)
                              ),
                              style: TextStyle(color: Colors.amber, fontSize: 25.0)
                          ),
                          Divider(),
                          TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Dolares",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "US\$ ",
                                  prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0)
                              ),
                              style: TextStyle(color: Colors.amber, fontSize: 25.0)
                          ),
                          Divider(),
                          TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Euros",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder(),
                                  prefixText: "E\$ ",
                                  prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0)
                              ),
                              style: TextStyle(color: Colors.amber, fontSize: 25.0)
                          )
                        ],
                      ),
                    )
                  );
                }
            }
          }),
    );
  }
}
