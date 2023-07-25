// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application/services/bulldozer.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_application/services/tractor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppBar(
          centerTitle: true, title: Text(AppLocalizations.of(context)!.work)),
      body: Center(
        child: Stack(
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            tractor(), // Replace NextPage with your desired page/widget
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
                                        'assets/images/tractor.png',
                                        width: 70,
                                        height: 100,
                                      ),
                                      Text(
                                          AppLocalizations.of(context)!.tractor)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            bulldozer(), // Replace NextPage with your desired page/widget
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
                                        'assets/images/bulldozer.png',
                                        width: 80,
                                        height: 100,
                                      ),
                                      Text(AppLocalizations.of(context)!
                                          .bulldozer)
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
