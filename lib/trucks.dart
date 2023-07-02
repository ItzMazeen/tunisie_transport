import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class trucks extends StatefulWidget {
  trucks({Key? key}) : super(key: key);

  @override
  State<trucks> createState() => _trucksState();
}

class _trucksState extends State<trucks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Trucks Page')),
      body: Center(
        child: Text('Trucks'),
      ),
    );
  }
}
