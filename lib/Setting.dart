// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/navbar.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Home Page')),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: user.email!)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String firstName = documents[index].get("first name");
                      String lastName = documents[index].get("last name");
                      String email = documents[index].get("email");

                      final _fnameController =
                          TextEditingController(text: firstName);
                      final _lnameController =
                          TextEditingController(text: lastName);

                      final _emailController =
                          TextEditingController(text: email);

                      return Column(
                        children: [
                          Form(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextFormField(
                                    controller: _fnameController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      label: Text("First Name :"),
                                      prefixIcon: Icon(
                                          Icons.person), // Add the icon here
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextFormField(
                                    controller: _lnameController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      label: Text("Last Name :"),
                                      prefixIcon: Icon(Icons
                                          .person_2_outlined), // Add the icon here
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextFormField(
                                    controller: _emailController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      label: Text("Email :"),
                                      prefixIcon: Icon(
                                          Icons.email), // Add the icon here
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          ElevatedButton(
                            onPressed: () {
                              String firstName = _fnameController.text;
                              String lastName = _lnameController.text;
                              String email = _emailController.text;
                              bool emailValid = RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(email);
                              if (firstName.isEmpty ||
                                  lastName.isEmpty ||
                                  email.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Error updating"),
                                    content:
                                        Text('Please fill in all the fields'),
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
                              } else if (emailValid == false) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Error updating"),
                                    content:
                                        Text('Please enter a valid email '),
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
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .where("email", isEqualTo: user.email!)
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs
                                      .forEach((DocumentSnapshot document) {
                                    // Get the document ID
                                    String docId = document.id;

                                    // Update the fields
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(docId)
                                        .update({
                                      "first name": firstName,
                                      "last name": lastName,
                                      "email": email,
                                    }).then((_) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Update successful"),
                                          content: Text(
                                              'Profile information updated'),
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
                                    }).catchError((error) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Error updating"),
                                          content: Text(
                                              'Please check your information'),
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
                                  });
                                });
                              }
                            },
                            child: Text('Update'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator(); // Placeholder while loading data
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
