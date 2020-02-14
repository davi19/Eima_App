import 'package:eima_app/View/ControleTela.dart';
import 'package:eima_app/View/Login.dart';
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

var _login;
recuperaLogin() async {
  final prefs = await SharedPreferences.getInstance();
  _login = prefs.getString('usuario') ?? '';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
   recuperaLogin().then((resultado){
     var home;
     if (_login == '') {
       home = Login();
     } else {
       debugPrint(_login.toString());
       home = Principal();
     }
     runApp(new MaterialApp(
       title: "Eima Pontos",
       theme: ThemeData(
           primaryColor:Color(0xFF006EB6),
           accentColor: Colors.cyan),
       routes: <String, WidgetBuilder>{
         '/login': (BuildContext context) => new Login(),
         '/Principal': (BuildContext context) => new Principal(),
       },
       home:  home,
     ));
  });

}