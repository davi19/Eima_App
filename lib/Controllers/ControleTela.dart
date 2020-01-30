import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ControleTela implements BlocBase {

  var view;
  var _controllerDeTela = StreamController<int>();
  Stream<int> get saida => _controllerDeTela.stream;
  Sink<int> get entrada => _controllerDeTela.sink;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _controllerDeTela.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
  void validaTela(int tela){

    entrada.add(tela);


  }
  void sairApp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('usuario','');
  }
}