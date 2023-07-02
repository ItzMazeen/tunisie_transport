// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/home_page.dart';

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
  List<String> _typeList = [
    'Louage',
    'Taxi',
    'SOS',
    'TukTuk',
    'Moto',
    'Truck',
    'Tractor',
    'Bulldozer',
  ];

  String? _selectedType;
  Future addService() async {
    String serie =
        _serieVehiculeController.text.trim(); // Get the trimmed serie value
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
          title: Text('Error adding'),
          content: Text(
            'Please Fill all the information',
          ),
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
          title: Text('Error registration'),
          content: Text(
            'Please Enter a valid phone number',
          ),
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
          int.parse(_phoneController.text.trim()));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future addServiceDetails(
      String name, String modele, String serie, String about, int phone) async {
    await FirebaseFirestore.instance.collection('services').add({
      'Service name': name,
      'Modele Vehicule': modele,
      'serie': serie,
      'about': about,
      'matricule': phone,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/wowsoft.png',
                width: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Add service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),

              // serie textField
              SizedBox(height: 20),

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
                        prefixIcon: Icon(Icons.person), // Add the icon here
                        border: InputBorder.none,
                        hintText: 'Service Name'),
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
                            Icon(Icons.person_2_outlined), // Add the icon here
                        border: InputBorder.none,
                        hintText: 'Marque Vehicule'),
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
                    value:
                        _selectedType, // Set the currently selected phone number value
                    onChanged: (String? newValue) {
                      // Update the selected phone number value
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone), // Add the icon here
                      border: InputBorder.none,
                      hintText: 'Phone Number',
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
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _phoneController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone), // Add the icon here
                        border: InputBorder.none,
                        hintText: 'Phone Number'),
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
                        prefixIcon: Icon(Icons.email), // Add the icon here
                        border: InputBorder.none,
                        hintText: 'Serie Vehicule'),
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
                      prefixIcon: Icon(Icons.email), // Add the icon here
                      border: InputBorder.none,
                      hintText: 'About service',
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
                      child: Text('Ajouter',
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
}
