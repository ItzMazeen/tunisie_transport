// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Service extends StatefulWidget {
  Service({Key? key}) : super(key: key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  final _serieVehiculeController = TextEditingController();
  final _serviceNameController = TextEditingController();
  final _modeleVehiculeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutServiceController = TextEditingController();

  List<String> _regionList = [
    'Ariana',
    'Béja',
    'Ben Arous',
    'Bizerte',
    'Gabès',
    'Gafsa',
    'Jendouba',
    'Kairouan',
    'Kébili',
    'Kasserine',
    'Kef',
    'Mahdia',
    'Manouba',
    'Médenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan',
    'Toute la tunisie',
  ];

  String? _selectedType;
  String? _selectedRegion;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _serieVehiculeController.dispose();
    _serviceNameController.dispose();
    _modeleVehiculeController.dispose();
    _phoneController.dispose();
    _aboutServiceController.dispose();
    super.dispose();
  }

  FirebaseMessaging token = FirebaseMessaging.instance;
  var serverToken =
      "AAAAkRiCMP8:APA91bEwHyocXl9CeeOrjx6XVj13OG2gT8sKn6Y7ZFKK0hBvsWJCpq1wpR1kpwPs0vVoyI4-fHHJLrGSCCXcHeBXlatT9a3J4X1pwPHXPJAMvP4--7C6PO02qzuQmw5nmoINQ1sIDBOX";

  sendNotif(String t, String b) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': b.toString(),
              'title': t.toString()
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'to': "/topic/service"
            },
            'to': "/topics/service"
          },
        ));
  }

  Future<void> addService() async {
    String serie = _serieVehiculeController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String name = _serviceNameController.text.trim();
    String modele = _modeleVehiculeController.text.trim();
    String about = _aboutServiceController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (serie.isEmpty ||
        name.isEmpty ||
        modele.isEmpty ||
        phoneNumber.isEmpty ||
        about.isEmpty) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.fill),
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
    } else if (phoneNumber.isEmpty ||
        phoneNumber.length != 8 ||
        !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.validP),
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
      addServiceDetails(
        _serviceNameController.text.trim(),
        _modeleVehiculeController.text.trim(),
        _serieVehiculeController.text.trim(),
        _aboutServiceController.text.trim(),
        int.parse(_phoneController.text.trim()),
        _selectedRegion!,
        user.uid,
      );
      // Save the service in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('service', _selectedType!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      // Display notification
      String notificationTitle =
          AppLocalizations.of(context)!.notifications(_selectedType!);
      String notificationBody = AppLocalizations.of(context)!
          .tnotifications(_selectedType!, _selectedRegion!);
      await sendNotif(notificationTitle, notificationBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _typeList = [
      AppLocalizations.of(context)!.louage,
      AppLocalizations.of(context)!.taxi,
      AppLocalizations.of(context)!.sos,
      AppLocalizations.of(context)!.tuktuk,
      AppLocalizations.of(context)!.moto,
      AppLocalizations.of(context)!.truck,
      AppLocalizations.of(context)!.tractor,
      AppLocalizations.of(context)!.bulldozer,
    ];
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),

              Text(
                AppLocalizations.of(context)!.addService,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _serviceNameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.home_repair_service), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.serviceName),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _modeleVehiculeController,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.directions_car), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.modele),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      // Update the selected phone number value
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.design_services), // Add the icon here
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.serviceType,
                    ),
                    items:
                        _typeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRegion,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.place), // Add the icon here
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.region,
                    ),
                    items: _regionList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _phoneController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.phone),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _serieVehiculeController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.minor_crash_rounded), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.serie),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 238, 238),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    controller: _aboutServiceController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description), // Add the icon here
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.aboutService,
                    ),
                  ),
                ),
              ),
              // Sign in button
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: addService,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.ajouter,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(), // Replace HomePage with your desired home page widget
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future addServiceDetails(
    String name,
    String modele,
    String serie,
    String about,
    int phone,
    String _selectedRegion,
    String userId,
  ) async {
    if (_selectedType == AppLocalizations.of(context)!.taxi) {
      await FirebaseFirestore.instance.collection('Taxi').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.sos) {
      await FirebaseFirestore.instance.collection('SOS').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.tuktuk) {
      await FirebaseFirestore.instance.collection('TukTuk').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.moto) {
      await FirebaseFirestore.instance.collection('Moto').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.truck) {
      await FirebaseFirestore.instance.collection('Truck').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.tractor) {
      await FirebaseFirestore.instance.collection('Tractor').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.bulldozer) {
      await FirebaseFirestore.instance.collection('Bulldozer').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    } else if (_selectedType == AppLocalizations.of(context)!.louage) {
      await FirebaseFirestore.instance.collection('Louage').add({
        'Service name': name,
        'Modele Vehicule': modele,
        'serie': serie,
        'about': about,
        'Phone': phone,
        'Region': _selectedRegion,
        'User': userId,
      });
    }
  }
}
