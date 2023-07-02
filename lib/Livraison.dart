// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class livraison extends StatefulWidget {
  livraison({Key? key}) : super(key: key);

  @override
  State<livraison> createState() => _livraisonState();
}

class _livraisonState extends State<livraison> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Livraison Page')),
      body: Center(
        child: Text('Livraison'),
      ),
    );
  }
}
