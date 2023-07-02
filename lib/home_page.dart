// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Home Page')),
      body: Column(
        children: [
          Stack(
            children: [
              Transform.rotate(
                angle: 2.4,
                origin: Offset(30, -60),
                child: Container(
                  margin: EdgeInsets.only(left: 75, top: 40),
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [Color(0xff99D98C), Color(0xFF76C893)])),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                      Container(
                        height: 177,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0x9F1B4332)),
                      ),
                    ],
                  ),
                ]),
              )
            ],
          )
        ],
      ),
    );
  }
}
