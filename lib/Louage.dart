// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class Louage extends StatefulWidget {
  Louage({Key? key}) : super(key: key);

  @override
  State<Louage> createState() => _LouageState();
}

class _LouageState extends State<Louage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Louages Page')),
      body: Center(
        child: Text('Louages'),
      ),
    );
  }
}
