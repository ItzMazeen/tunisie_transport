// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class depanneuse extends StatefulWidget {
  depanneuse({Key? key}) : super(key: key);

  @override
  State<depanneuse> createState() => _depanneuseState();
}

class _depanneuseState extends State<depanneuse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Dépanneuse Page')),
      body: Center(
        child: Text('Dépanneuse'),
      ),
    );
  }
}
