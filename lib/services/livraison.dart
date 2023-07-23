// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application/services/moto.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_application/services/toktok.dart';
import 'package:flutter_application/services/trucks_delivery.dart';

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
      appBar: AppBar(centerTitle: true, title: Text('Delivery Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Toktok(), // Replace NextPage with your desired page/widget
                              ),
                            );
                          },
                          child: Container(
                            height: 177,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0x9F1B4332),
                            ),
                            child: Column(children: [
                              SizedBox(height: 20),
                              Image.asset(
                                'assets/images/ricksaw.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('TukTuk')
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    moto(), // Replace NextPage with your desired page/widget
                              ),
                            );
                          },
                          child: Container(
                            height: 177,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0x9F1B4332)),
                            child: Column(children: [
                              SizedBox(height: 20),
                              Image.asset(
                                'assets/images/moto.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('Moto')
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    trucks_del(), // Replace NextPage with your desired page/widget
                              ),
                            );
                          },
                          child: Container(
                            height: 177,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0x9F1B4332)),
                            child: Column(children: [
                              SizedBox(height: 20),
                              Image.asset(
                                'assets/images/delivery-truck.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('Truck')
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
