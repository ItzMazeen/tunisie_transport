// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class Toktok extends StatefulWidget {
  Toktok({Key? key}) : super(key: key);

  @override
  State<Toktok> createState() => _ToktokState();
}

class _ToktokState extends State<Toktok> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Toktoks Page')),
      body: Center(
        child: Text('Toktoks'),
      ),
    );
  }
}
