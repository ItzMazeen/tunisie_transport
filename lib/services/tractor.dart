// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_constructors_in_immutables, deprecated_member_use, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/edit_Page.dart';
import 'package:flutter_application/crud/signal_page.dart';
import 'package:flutter_application/navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class tractor extends StatefulWidget {
  tractor({Key? key}) : super(key: key);

  @override
  State<tractor> createState() => _tractorState();
}

class _tractorState extends State<tractor> {
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

  int counter = 0;

  var collection = FirebaseFirestore.instance.collection("Tractor");
  late List<Map<String, dynamic>> items;
  bool isLoaded = false;
  String name = "";
  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

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
    String service = "Tractor";
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.tractor)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: AppLocalizations.of(context)!.search,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
          ),
          if (name.isEmpty)
            Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!
                  .counter(counter, AppLocalizations.of(context)!.tractor)),
            ),
          isLoaded
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final currentItem = items[index];
                    final serviceName =
                        currentItem["Service name"] ?? "Not given";
                    final modeleVehicule =
                        currentItem["Modele Vehicule"] ?? "Not given";
                    final region = currentItem["Region"] ?? "Not given";

                    if (name.isEmpty ||
                        region.toLowerCase().contains(name.toLowerCase())) {
                      return InkWell(
                        onTap: () {
                          showDialogFunc(
                            context,
                            currentItem["id"] ?? "Not given",
                            currentItem["User"] ?? "Not given",
                            serviceName,
                            region,
                            modeleVehicule,
                            currentItem["serie"] ?? "Not given",
                            currentItem["Phone"].toString(),
                            currentItem["about"] ?? "Not given",
                            service,
                          );
                          String userId = currentItem["User"] ?? "Not given";
                          searchDocumentByUserId(userId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xff6ae792),
                              child: Icon(Icons.person),
                            ),
                            title: Row(
                              children: [
                                Text(serviceName),
                                Text(" | "),
                                Text(modeleVehicule),
                              ],
                            ),
                            subtitle: Text(region),
                            trailing: GestureDetector(
                              onTap: () {
                                String phoneNumber =
                                    currentItem["Phone"].toString();
                                _makePhoneCall(phoneNumber);
                              },
                              child: Icon(Icons.phone),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}

showDialogFunc(
    context, docId, user, name, region, modele, serie, phone, about, service) {
  User? currentUser = FirebaseAuth.instance.currentUser;

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal,
                            ),
                            child: Stack(
                              children: [
                                if (user == currentUser?.uid ||
                                    currentUser?.email ==
                                        "admin@gmail.com") // Conditionally show the button if user is logged in
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditPage(
                                              docId: docId,
                                              name: name,
                                              region: region,
                                              modele: modele,
                                              serie: serie,
                                              phone: phone,
                                              about: about,
                                              service: service,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (user == currentUser?.uid ||
                                    currentUser?.email ==
                                        "admin@gmail.com") // Conditionally show the button if user is logged in
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .confirmDelete,
                                            ),
                                            content: Text(
                                              AppLocalizations.of(context)!
                                                  .tconfirmDelete,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete,
                                                ),
                                                onPressed: () {
                                                  // Delete the document
                                                  FirebaseFirestore.instance
                                                      .collection("Tractor")
                                                      .doc(docId)
                                                      .delete()
                                                      .then((_) {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    // Show a success dialog or navigate to a different page
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .deleteSucc),
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .tdeleteSucc),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Ok'),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          tractor(), // Replace NextPage with your desired page/widget
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).catchError((error) {
                                                    // Show an error dialog if deletion fails
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .error),
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .tedelete),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Ok'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (user != currentUser?.uid &&
                              currentUser?.email != "admin@gmail.com")
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingalPage(
                                        docId: docId,
                                        name: name,
                                        region: region,
                                        modele: modele,
                                        serie: serie,
                                        phone: phone,
                                        about: about,
                                        service: service,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.report_gmailerrorred),
                              ),
                            ),
                          Positioned(
                              top: 50.0,
                              left: 94.0,
                              child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0,
                                  ),
                                  color: const Color(
                                      0xff6ae792), // Set the background color directly
                                ),
                                child: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              ))
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                name,
                              ),
                            ),
                            Text(
                              ' | ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                region,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                modele,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                serie,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.phone,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              about,
                            ),
                          )),
                    ],
                  ),
                )));
      });
}
