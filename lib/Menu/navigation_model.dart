import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Pontuação", icon: Icons.account_balance_wallet),
  NavigationModel(title: "Extrato", icon: Icons.insert_chart),
  NavigationModel(title: "Sair", icon: Icons.exit_to_app),

];