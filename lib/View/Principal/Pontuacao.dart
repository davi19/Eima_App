import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eima_app/Rest/Ponto.dart' as rest;

class Pontuacao extends StatefulWidget {
  @override
  DadosPontuacao createState() {
    return DadosPontuacao();
  }
}

String _usuario = "";
String _token = "";

class DadosPontuacao extends State<Pontuacao> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs){
    _usuario = prefs.getString("usuario");
    _token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FutureBuilder<Map<String, dynamic>>(
          future: rest.ponto(_usuario, _token),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Aguardando Resultados...');
              case ConnectionState.done:
                return Padding(
                    padding: EdgeInsets.fromLTRB(75, 10, 20, 0),
                    child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                  color: Color(0xFF006EB6),
                                  child: ListTile(
                                    selected: true,
                                    title: Text("Pontuação",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white)),
                                  )),    Container(
                            child: ListTile(
                              title: Text("Sua pontuação é de: "+snapshot.data["pontos"].toString()+" pontos",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      )),
                              subtitle: Text("Procure uma loja Eima e troque seus pontos 😉",
                                  style: TextStyle(
                                  fontSize: 9.0)),
                            )),
                            ])));
            }
            return null;
          })
    ]));
  }
}
