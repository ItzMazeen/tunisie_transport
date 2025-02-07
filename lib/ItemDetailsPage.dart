// ignore_for_file: prefer_const_constructors, deprecated_member_use, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/edit_Page.dart';
import 'package:flutter_application/crud/signal_page.dart';
import 'package:flutter_application/services/taxi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class ItemDetailsPage extends StatelessWidget {
  final String docId;
  final String user;
  final String name;
  final String region;
  final String modele;
  final String serie;
  final String phone;
  final String about;
  final String service;

  ItemDetailsPage({
    required this.docId,
    required this.user,
    required this.name,
    required this.region,
    required this.modele,
    required this.serie,
    required this.phone,
    required this.about,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name,
            style: TextStyle(
              color: Colors.black,
            )),
        iconTheme: IconThemeData(
          color: Colors
              .black, // Change this color to the desired color for the back button
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(255, 168, 39, 1),
                    radius: 60,
                    child: Icon(Icons.person, color: Colors.black, size: 80),
                  ),
                ),
                if (user == currentUser?.uid ||
                    currentUser?.email == "admin@gmail.com")
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
                              AppLocalizations.of(context)!.confirmDelete,
                            ),
                            content: Text(
                                AppLocalizations.of(context)!.tconfirmDelete),
                            actions: <Widget>[
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context)!.delete),
                                onPressed: () {
                                  // Delete the document
                                  FirebaseFirestore.instance
                                      .collection("Taxi")
                                      .doc(docId)
                                      .delete()
                                      .then((_) {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    // Show a success dialog or navigate to a different page
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .deleteSucc),
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .tdeleteSucc),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Taxi(), // Replace NextPage with your desired page/widget
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
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .error),
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .tedelete),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
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
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .location_on, // Replace with the icon you want to display
                      size: 20,
                      color: Colors.grey[500],
                    ),
                    SizedBox(
                        width: 8), // Add some spacing between the icon and text
                    Text(
                      region,
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text("${AppLocalizations.of(context)!.modele}: $modele"),
              subtitle: Text("${AppLocalizations.of(context)!.serie}: $serie"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("${AppLocalizations.of(context)!.phone}: $phone"),
            ),
            Divider(height: 30, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context)!.aboutService,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(about),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _makePhoneCall(phone),
        child: Icon(Icons.phone),
        backgroundColor: Color.fromRGBO(255, 168, 39, 1),
      ),
    );
  }
}
