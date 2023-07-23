// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/service.dart';
import 'package:flutter_application/services/livraison.dart';
import 'package:flutter_application/services/louage.dart';
import 'package:flutter_application/crud/setting.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_application/services/sos.dart';
import 'package:flutter_application/services/taxi.dart';
import 'package:flutter_application/services/trucks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Service()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Home Page')),
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
                                    Taxi(), // Replace NextPage with your desired page/widget
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
                                'assets/images/taxi.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('Taxi')
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Louage(), // Replace NextPage with your desired page/widget
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
                                'assets/images/van.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('Louage')
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
                                    livraison(), // Replace NextPage with your desired page/widget
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
                              Text('Delivery')
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    trucks(), // Replace NextPage with your desired page/widget
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
                                'assets/images/winter.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('Work Trucks')
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
                                    sos(), // Replace NextPage with your desired page/widget
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
                                'assets/images/tow-truck.png',
                                width: 80,
                                height: 100,
                              ),
                              Text('SOS')
                            ]),
                          ),
                        ),
                        if (currentUser !=
                            null) // Conditionally show the button if user is logged in
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Setting(), // Replace Setting() with your desired page/widget
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
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Image.asset(
                                    'assets/images/gear.png',
                                    width: 60,
                                    height: 100,
                                  ),
                                  Text('Settings'),
                                ],
                              ),
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
