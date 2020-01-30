import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String urlBase ="http://eima.medina-ddns.com:9090/EIma/";
Future login(String usuario, String senha) async {
  var params = {
    "usuario": "$usuario",
    "senha": "$senha",
  };
  final http.Response resposta = await http.post(
      urlBase+"Login/",
      body: utf8.encode(json.encode(params)),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });
  debugPrint(resposta.body.toString());
  if(resposta.statusCode==401){
   return  json.decode('{"resultado":"erro"}');
  }
  return json.decode(utf8.decode(resposta.bodyBytes));
}

Future esqueceuSenha(String usuario,String senha) async{
  var params = {
    "usuario": "$usuario",
    "senha": "$senha",
  };
  final http.Response resposta = await http.post(
      urlBase+"EsqueceuSenha/$senha",
      body: utf8.encode(json.encode(params)),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });
  return json.decode(utf8.decode(resposta.bodyBytes));
}