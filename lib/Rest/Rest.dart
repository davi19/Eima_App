import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String urlBase ="http://eima.medina-ddns.com:9090/EIma/";

Future<Map<String, dynamic>> ponto(String usuario, String token) async {

  final http.Response resposta = await http.get(
      urlBase+"RetornaPontos/$usuario",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      });
  if(resposta.statusCode==401){
    return  json.decode('{"resultado":"erro"}');
  }
  if(resposta.statusCode==500){
    return  json.decode('{"resultado":"OK","pontos":"0"}');
  }
  return json.decode(utf8.decode(resposta.bodyBytes));
}


Future<Map<String, dynamic>> extrato(String usuario, String token) async {
  final http.Response resposta = await http.get(
      urlBase+"RetornaExtrato/$usuario",
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      });
  debugPrint(resposta.body.toString());
  if(resposta.statusCode==401){
    return  json.decode('{"resultado":"erro"}');
  }
  if(resposta.statusCode==500){
    return  json.decode('{"resultado":"OK","pontos":[]}');
  }

  return json.decode(utf8.decode(resposta.bodyBytes));
}