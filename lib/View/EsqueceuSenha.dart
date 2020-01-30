import 'package:eima_app/View/Login.dart';
import 'package:flutter/material.dart';
import 'package:eima_app/Rest/Login.dart' as rest;
import 'package:flutter_masked_text/flutter_masked_text.dart';

class EsqueceuSenha extends StatefulWidget {
  @override
  FormularioEsqueceuSenha createState() => FormularioEsqueceuSenha();
}

class FormularioEsqueceuSenha extends State<EsqueceuSenha> {
  var _formKey = GlobalKey<FormState>();
  var _usuario =  new MaskedTextController(mask: '00000000000000');
  FocusNode _textFocus = new FocusNode();
  var _senha = TextEditingController();
  var _cofirmaSenha = TextEditingController();

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
                  width: 200,
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
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    labelText: "Senha",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                  controller: _senha,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Favor Preencher com a nova senha';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    labelText: "Confirmação de senha",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                  controller: _cofirmaSenha,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Favor Preencher com a confirmação da nova senha';
                    }
                    if (value != _senha.value.text) {
                      return 'A senha e a confirmação de senha não estão iguais';
                    }
                    return null;
                  },
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: SizedBox(
                  width: double.infinity,
                  child: FlatButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var retorno =
                            await rest.esqueceuSenha(_usuario.value.text,_senha.value.text);
                        debugPrint(retorno["resultado"].toString());
                        if (retorno["resultado"].toString() == "OK") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Sucesso"),
                                  content: new Text(
                                      "Foi enviado um e-mail com um link de confirmação."),
                                  actions: <Widget>[
                                    new FlatButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        icon: Icon(Icons.error),
                                        label: new Text("OK"))
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Erro"),
                                  content: new Text(retorno["mensagem"]),
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
                      'Trocar Senha',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.security,color: Colors.white),
                    color: Color(0xFF006EB6),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: SizedBox(
                  width: double.infinity,
                  child: OutlineButton(
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Lembrei Minha Senha',
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
