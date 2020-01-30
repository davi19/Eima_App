import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eima_app/Rest/Extrato.dart' as rest;

class Extrato extends StatefulWidget {
  @override
  DadosExtrato createState() {
    return DadosExtrato();
  }
}

String _usuario = "";
String _token = "";

class DadosExtrato extends State<Extrato> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _usuario = prefs.getString("usuario");
      _token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      FutureBuilder<Map<String, dynamic>>(
          future: rest.extrato(_usuario, _token),
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
    var corCancelado = informacoes["cancelado"].toString().contains("NÃO CANCELADO")?  Colors.black45:Colors.red ;
    var corResgate = informacoes["tipo"].toString().contains("RESGATE")? Colors.lightGreen: Colors.black ;
    debugPrint(informacoes.toString());
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        title: Text("Operação: "+informacoes["tipo"],
            style: TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 16,color:corResgate)),
        subtitle: Text("Data da Operação: " + informacoes["data"],
            style: TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      ListTile(
        title: Text("Pontos Gerados: "+informacoes["pontos"],
            style: TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("Cancelado : " + informacoes["cancelado"],
            style: TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 14,color:corCancelado)),
      ),
      ListTile(
        title: Text("Valor : "+informacoes["valor"],
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("Valor Devolvido : " + informacoes["devolucao"],
            style: TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    ]);
  }
}
