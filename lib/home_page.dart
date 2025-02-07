// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_application/crud/ad_mob_service.dart';
import 'package:flutter_application/crud/service.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_application/services/bulldozer.dart';
import 'package:flutter_application/services/louage.dart';
import 'package:flutter_application/services/moto.dart';
import 'package:flutter_application/services/sos.dart';
import 'package:flutter_application/services/taxi.dart';
import 'package:flutter_application/services/toktok.dart';
import 'package:flutter_application/services/tractor.dart';
import 'package:flutter_application/services/trucks_delivery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  // ignore: non_constant_identifier_names
  String? Vip = "0";
  String? vipStatus;
  Future<void> getVipForCurrentUser() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document that matches the current user's ID
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        Vip = documentSnapshot.get('vip');
      });

      print('vip is $Vip');
    } else {
      print('No statistics found for current user.');
    }
  }

  BannerAd? _banner;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result; // Add this line to return the mapped list.
  }

  String? service;
  List<CarouselModel> carousels = []; // Declaration added here
  // Function to load the 'service' variable from SharedPreferences
  _loadServiceFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      service = prefs
          .getString('service'); // Set the value to the variable, if available
    });
  }

  @override
  void initState() {
    super.initState();
    _loadServiceFromSharedPreferences();
    getVipForCurrentUser();
    _createBannerAd();
    fetchDataFromFirebase();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      var carouselsData =
          await firebase_storage.FirebaseStorage.instance.ref().listAll();

      var items = carouselsData.items;

      List<CarouselModel> fetchedCarousels = [];
      for (var item in items) {
        String downloadURL = await item.getDownloadURL();
        fetchedCarousels.add(CarouselModel(downloadURL));
      }

      setState(() {
        carousels = fetchedCarousels;
      });
    } catch (e) {
      // Handle errors if any
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if ((Vip == "true" || service == null) && user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Service()),
            );
            print("1");
            print(Vip);
            print(service);
          } else if (user == null) {
            print("2");
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.connect),
                content: Text(AppLocalizations.of(context)!.tconnect),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.buy),
                content: Text(AppLocalizations.of(context)!.tbuy),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      drawer: NavBar(),
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.home,
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(
            color: Colors
                .black, // Change this color to the desired color for the back button
          )),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    child: Swiper(
                      onIndexChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      autoplay: true,
                      layout: SwiperLayout.DEFAULT,
                      itemCount: carousels.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(
                                  carousels[index].image,
                                ),
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: map<Widget>(carousels, (index, image) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 6,
                            width: 6,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _current == index ? Colors.blue : Colors.grey,
                            ),
                          );
                        }),
                      ),
                      // Text(
                      //   AppLocalizations.of(context)!.edit,
                      //   style: TextStyle(
                      //       color: Colors.blue, fontWeight: FontWeight.w700),
                      // )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(AppLocalizations.of(context)!.navigate),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/taxi.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.taxi,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/van.png",
                                fit: BoxFit.contain,
                                width: 45,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.louage,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/tractor.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.tractor,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/bulldozer.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.bulldozer,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/ricksaw.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.tuktuk,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/moto.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.moto,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/delivery-truck.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.truck,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
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
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(children: <Widget>[
                              Image.asset(
                                "assets/images/tow-truck.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.sos,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(AppLocalizations.of(context)!.show,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _banner!),
            ),
    );
  }
}

class CarouselModel {
  String image;

  CarouselModel(this.image);

  factory CarouselModel.fromFirebase(Map<String, dynamic> data) {
    return CarouselModel(data['image']);
  }
}
