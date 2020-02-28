import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eima_app/Rest/Rest.dart' as rest;

class Principal extends StatefulWidget {
  @override
  TelaPrincipal createState() {
    return TelaPrincipal();
  }
}

String _usuario = "";
String _token = "";
dynamic viewTab;
var _indice = 0;

class TelaPrincipal extends State<Principal> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _usuario = prefs.getString("usuario");
      _token = prefs.getString("token");
    });
  }

  Widget build(BuildContext context) {
    if (_indice == 0) {
      viewTab = RetornaPontos();
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF006EB6),
          title: Image.asset('Imagens/EIMA_LOGO branco.png',
              fit: BoxFit.fitWidth, height: 150.0),
          centerTitle: true,
        ),
        body: Container(
          child: viewTab,
        ),
        bottomNavigationBar: CurvedNavigationBar(
            color: Color(0xFF006EB6),
            backgroundColor: Colors.white,
            items: <Widget>[
              Icon(Icons.account_balance_wallet, size: 30, color: Colors.white),
              Icon(Icons.insert_chart, size: 30, color: Colors.white),
              Icon(Icons.exit_to_app, size: 30, color: Colors.white)
            ],
            onTap: (indice) async {
              switch (indice) {
                case 0:
                  setState(() {
                    _indice = indice;
                    viewTab = RetornaPontos();
                  });
                  break;
                case 1:
                  setState(() {
                    debugPrint(_token);
                    _indice = indice;
                    viewTab = RetornaExtrato();
                  });
                  break;
                case 2:
                  setState(() async {
                    Navigator.of(context).pushReplacementNamed("/login");
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('usuario', '');
                  });
                  break;
              }
            }));
  }

  Widget RetornaPontos() {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FutureBuilder<Map<String, dynamic>>(
          future: rest.ponto(_usuario, _token),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Padding(
                  padding: EdgeInsets.fromLTRB(180, 50,50, 0),
                  child: CircularProgressIndicator());
            else {
              debugPrint(snapshot.data.toString());
              return Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                                )),
                            Container(
                                child: ListTile(
                              title: Text(
                                  "Sua pontuação é de: " +
                                      snapshot.data["pontos"].toString() +
                                      " pontos",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )),
                              subtitle: Text(
                                  "Procure uma loja Eima e troque seus pontos 😉",
                                  style: TextStyle(fontSize: 9.0)),
                            )),
                          ])));
            }
            return null;
          })
    ]));
  }

  Widget RetornaExtrato() {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FutureBuilder<Map<String, dynamic>>(
          future: rest.extrato(_usuario, _token),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Padding(
                  padding: EdgeInsets.fromLTRB(180, 50,50, 0),
                  child: CircularProgressIndicator());
            else {
              return Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                                  title: Text("Extrato",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.white)),
                                )),
                            ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                      color: Color(0xFF2CBBB5),
                                    ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data["pontos"].length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return InformacoesExtrato(
                                      snapshot.data["pontos"][index]);
                                })
                          ])));
            }
            return null;
          })
    ]));
  }

  Widget InformacoesExtrato(informacoes) {
    var corCancelado =
        informacoes["cancelado"].toString().contains("NÃO CANCELADO")
            ? Colors.black45
            : Colors.red;
    var corResgate = informacoes["tipo"].toString().contains("RESGATE")
        ? Colors.lightGreen
        : Colors.black;
    debugPrint(informacoes.toString());
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        title: Text("Operação: " + informacoes["tipo"],
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: corResgate)),
        subtitle: Text("Data da Operação: " + informacoes["data"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      ListTile(
        title: Text("Pontos Gerados: " + informacoes["pontos"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("Cancelado : " + informacoes["cancelado"],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: corCancelado)),
      ),
      ListTile(
        title: Text("Valor : " + informacoes["valor"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("Valor Devolvido : " + informacoes["devolucao"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    ]);
  }
}
