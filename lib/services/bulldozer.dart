// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, avoid_function_literals_in_foreach_calls, deprecated_member_use, avoid_print, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application/ItemDetailsPage.dart';

import 'package:flutter_application/navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class bulldozer extends StatefulWidget {
  bulldozer({Key? key}) : super(key: key);

  @override
  State<bulldozer> createState() => _bulldozerState();
}

class _bulldozerState extends State<bulldozer> {
  String selectedRegion =
      'Toute les regions'; // Step 1: Create a variable to hold the selected value.

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
    'Toute les regions',
  ];
  final CollectionReference statistiqueCollection =
      FirebaseFirestore.instance.collection('statistique');

  Future<void> searchDocumentByUserId(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('statistique')
        .where('User', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document that matches the user ID
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      String documentId = documentSnapshot.id;

      // Update the document with the desired values and increment 'i'
      int currentValue = documentSnapshot.get('i') as int;
      updateStatistiqueWithDocumentId(documentId, userId, currentValue);
    } else {
      // No document found with the provided user ID
      // Create a new document with the user ID and 'i' value set to 1
      createNewStatistiqueDocument(userId);
    }
  }

  void createNewStatistiqueDocument(String userId) {
    statistiqueCollection.add({
      'User': userId,
      'i': 1,
    }).then((DocumentReference document) {
      print('New document created with ID: ${document.id}');
    }).catchError((error) {
      print('Failed to create a new document: $error');
    });
  }

  void updateStatistiqueWithDocumentId(
      String documentId, String userId, int currentValue) {
    statistiqueCollection.doc(documentId).update({
      'User': userId,
      'i': currentValue + 1,
    }).then((_) {
      print('Statistique updated successfully!');
    }).catchError((error) {
      print('Failed to update statistique: $error');
    });
  }

  void _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      String url = 'tel:$phoneNumber';
      if (await launch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  var collection = FirebaseFirestore.instance.collection("Bulldozer");
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String name = "";
  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  int counter = 0;

  _incrementCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();
    var length = data.size;

    data.docs.forEach((element) {
      var itemData = element.data();
      itemData["id"] = element.id; // Include the document ID in the data map
      tempList.add(itemData);
    });
    setState(() {
      counter = length; // Assign the collection size to the 'counter' variable

      items = tempList;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String service = "Bulldozer";

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavBar(),
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.bulldozer,
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(
            color: Colors
                .black, // Change this color to the desired color for the back button
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.search,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
              ),
              value: selectedRegion, // Step 2: Set the value of the dropdown.
              items: _regionList.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  name = val!;
                  selectedRegion = val; // Remove 'val!' and use 'val'
                });
              },
            ),
          ),
          if (name.isEmpty || name == "Toute les regions")
            Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!
                  .counter(counter, AppLocalizations.of(context)!.bulldozer)),
            ),
          Column(
            children: [
              isLoaded
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: isLoaded ? items.length : 0,
                      itemBuilder: (context, index) {
                        final currentItem = items[index];
                        final serviceName =
                            currentItem["Service name"] ?? "Not given";
                        final modeleVehicule =
                            currentItem["Modele Vehicule"] ?? "Not given";
                        final region = currentItem["Region"] ?? "Not given";

                        if (name.isEmpty ||
                            region.toLowerCase().contains(name.toLowerCase()) ||
                            name == "Toute les regions") {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailsPage(
                                    docId: currentItem["id"] ?? "Not given",
                                    user: currentItem["User"] ?? "Not given",
                                    name: serviceName,
                                    region: region,
                                    modele: modeleVehicule,
                                    serie: currentItem["serie"] ?? "Not given",
                                    phone: currentItem["Phone"].toString(),
                                    about: currentItem["about"] ?? "Not given",
                                    service: service,
                                  ),
                                ),
                              );
                              String userId =
                                  currentItem["User"] ?? "Not given";
                              searchDocumentByUserId(userId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation:
                                    5, // Adjust the value to control the shadow intensity
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  tileColor: Colors
                                      .white, // Replace 'Colors.blue' with the color you want for the ListTile

                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(255, 168, 39, 1),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        serviceName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(" | "),
                                      Text(
                                        modeleVehicule,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(region),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      String phoneNumber =
                                          currentItem["Phone"].toString();
                                      _makePhoneCall(phoneNumber);
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox
                              .shrink(); // Return an empty SizedBox to display nothing for this item.
                        }
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ]),
      ),
    );
  }
}
