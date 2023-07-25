// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPage extends StatefulWidget {
  final String docId;

  final String name;
  final String region;
  final String modele;
  final String serie;
  final String phone;
  final String about;
  final String service;

  EditPage({
    required this.docId,
    required this.name,
    required this.region,
    required this.modele,
    required this.serie,
    required this.phone,
    required this.about,
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
    'Mahdia',
    'Manouba',
    'Médenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Kef',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan',
    'Toute la tunisie',
  ];
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.region;
  }

  @override
  Widget build(BuildContext context) {
    final _serviceController = TextEditingController(text: widget.name);
    final _modeleController = TextEditingController(text: widget.modele);
    final _serieController = TextEditingController(text: widget.serie);
    final _phoneController = TextEditingController(text: widget.phone);
    final _aboutController = TextEditingController(text: widget.about);

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
          centerTitle: true, title: Text(AppLocalizations.of(context)!.edit)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: TextFormField(
                      controller: _serviceController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.serviceName),
                        prefixIcon: Icon(
                            Icons.home_repair_service), // Add the icon here
                        border: InputBorder.none,
                      ),
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
                          _selectedRegion = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.place), // Add the icon here
                        border: InputBorder.none,
                        label: Text(AppLocalizations.of(context)!.region),
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
                    child: TextFormField(
                      controller: _modeleController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.modele),
                        prefixIcon:
                            Icon(Icons.directions_car), // Add the icon here
                        border: InputBorder.none,
                      ),
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
                    child: TextFormField(
                      controller: _serieController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.serie),
                        prefixIcon: Icon(
                            Icons.minor_crash_rounded), // Add the icon here
                        border: InputBorder.none,
                      ),
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
                    child: TextFormField(
                      controller: _phoneController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.phone),
                        prefixIcon: Icon(Icons.phone), // Add the icon here
                        border: InputBorder.none,
                      ),
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
                    child: TextFormField(
                      maxLines: 3,
                      controller: _aboutController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.aboutService),
                        prefixIcon:
                            Icon(Icons.description), // Add the icon here
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ]),
              ElevatedButton(
                onPressed: () {
                  String name = _serviceController.text;

                  String modele = _modeleController.text;
                  String serie = _serieController.text;
                  String phone = _phoneController.text.trim();

                  String about = _aboutController.text;

                  if (name.isEmpty ||
                      modele.isEmpty ||
                      serie.isEmpty ||
                      phone.isEmpty ||
                      about.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Error updating"),
                        content: Text('Please fill in all the fields'),
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
                  } else if (phone.length != 8 ||
                      !RegExp(r'^\d+$').hasMatch(phone)) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Error updating"),
                        content: Text('Please enter a valid phone number'),
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
                    // Update the fields
                    FirebaseFirestore.instance
                        .collection(widget.service)
                        .doc(widget.docId)
                        .update({
                      'Service name': name,
                      'Modele Vehicule': modele,
                      'serie': serie,
                      'about': about,
                      'Phone': phone,
                      'Region': _selectedRegion,
                    }).then((_) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.updateSucc),
                          content:
                              Text(AppLocalizations.of(context)!.tupdateSucc),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(), // Replace NextPage with your desired page/widget
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Error updating"),
                          content: Text('Please check your information'),
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
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.update),
              )
            ],
          ),
        ),
      ),
    );
  }
}
