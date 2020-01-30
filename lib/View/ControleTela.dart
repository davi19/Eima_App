import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:eima_app/Menu/collapsing_navigation_drawer_widget.dart';
import 'package:eima_app/Controllers/ControleTela.dart';
import 'package:eima_app/View/Extrato/Extrato.dart';
import 'package:eima_app/View/Principal/Pontuacao.dart';
import 'package:flutter/material.dart';


class Principal extends StatefulWidget {
  @override
  TelaPrincipal createState() {
    return TelaPrincipal();
  }
}

class TelaPrincipal extends State<Principal> {
  Widget build(BuildContext context) {
    final ControleTela bloc = BlocProvider.getBloc<ControleTela>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF006EB6),
        title:
        Image.asset('Imagens/EIMA_LOGO branco.png', fit: BoxFit.fitWidth, height: 45.0),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: StreamBuilder(
                  initialData: 0,
                  stream: bloc.saida,
                  // ignore: missing_return
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch(snapshot.data){
                      case 0:
                        return Pontuacao();
                        break;
                      case 1:
                        return Extrato();
                        break;
                    }
                  })
          ),
          CollapsingNavigationDrawer()
        ],
      ),
    );
  }
}