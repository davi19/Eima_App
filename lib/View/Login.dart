import 'package:eima_app/View/EsqueceuSenha.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eima_app/Rest/Login.dart' as rest;
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Login extends StatefulWidget {
  @override
  FormularioLogin createState() {
    return FormularioLogin();
  }
}

class FormularioLogin extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  var _senha = TextEditingController();
  var _usuario =  new MaskedTextController(mask: '00000000000000');
  FocusNode _textFocus = new FocusNode();

  // ignore: must_call_super
  void initState() {
    _textFocus.addListener(onChange);}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 100, 20, 60),
                        child: Image.asset(
                          'Imagens/EIMA_LOGO.png',

                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextFormField(
                          focusNode: _textFocus,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "Usuário",
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                          controller: _usuario,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Favor Preencher com o seu usuário';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextFormField(
                          controller: _senha,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Favor Preencher com a sua senha';
                            }
                            return null;
                          },
                          obscureText: true,
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: SizedBox(
                          width: double.infinity,
                          child: FlatButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var retorno = await rest.login(
                                    _usuario.value.text, _senha.value.text);
                                debugPrint(retorno["resultado"].toString());
                                if (retorno["resultado"].toString() != "erro") {
                                  final prefs = await SharedPreferences.getInstance();

                                  prefs.setString('token',retorno["resultado"].toString());
                                  prefs.setString('usuario',_usuario.value.text);
                                  Navigator.of(context)
                                      .pushReplacementNamed("/Principal");
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: new Text("Erro"),
                                          content: new Text("Usuário ou senha incorreto."),
                                          actions: <Widget>[
                                            new FlatButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.error),
                                                label: new Text("OK"))
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                            label: Text(
                              'Entrar',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(Icons.account_circle,color: Colors.white),
                            color:Color(0xFF006EB6),
                          )),
                    ),      Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EsqueceuSenha()));

                            },
                            child: Text(
                              'Esqueceu sua senha ?',
                              style: TextStyle(color: Color(0xFF006EB6)),
                            ),
                            highlightColor: Color(0xFF006EB6),
                          )),
                    ),
                  ],
                )),
          )),
    );
  }
  void onChange() {
    bool hasFocus = _textFocus.hasFocus;
    if (!hasFocus) {
      if (_usuario.value.text.length <= 11 && _usuario.value.text.length != 0) {
        _usuario.updateMask('000.000.000-00');
      } else if (_usuario.value.text.length == 0) {
        _usuario.updateMask('00000000000000');
      } else {
        _usuario.updateMask('00.000.000/0000-00');
      }
    } else {
      _usuario.updateMask('00000000000000');
    }
  }
}