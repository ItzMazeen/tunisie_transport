// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late BuildContext _context; // Define a context variable

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? savedPassword = '';

  final user = FirebaseAuth.instance.currentUser!;
  final _passwordController =
      TextEditingController(); // Declare the password controller here

  void getPasswordFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPassword = prefs.getString('password');
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    selectedType = prefs2.getString('service');

    _passwordController.text =
        savedPassword ?? ''; // Update the password controller value
  }

  Future<void> saveNotificationValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification', value);
  }

  Future<bool> getNotificationValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification') ?? true;
  }

  bool switchValue = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    _context = context; // Assign the context in the initState method
    getPasswordFromSharedPreferences();
    getStatisticsForCurrentUser(); // Call the method once in initState
    getNotificationValue().then((value) {
      setState(() {
        switchValue = value; // Set switchValue based on the stored value
      });
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      switchValue = value;
      if (switchValue) {
        _firebaseMessaging.subscribeToTopic('service');
        Fluttertoast.showToast(
          msg: 'Notifications ON',
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
        );
      } else {
        _firebaseMessaging.unsubscribeFromTopic('service');
        Fluttertoast.showToast(
          msg: 'Notifications OFF',
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
        );
      }
      saveNotificationValue(switchValue); // Save the updated switch value
    });
  }

  int? currentValue = 0;
  String? selectedType;
  Future<void> getStatisticsForCurrentUser() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('statistique')
        .where('User', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document that matches the current user's ID
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      setState(() {
        currentValue = documentSnapshot.get('i') as int;
      });

      print('Statistics for current user - Current Value: $currentValue');
    } else {
      print('No statistics found for current user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(centerTitle: true, title: Text('Settings Page')),
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
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Allow notifications :',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                        Switch(
                                          value: switchValue,
                                          onChanged: toggleSwitch,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Nombres de vue de votre service ${selectedType ?? 'N/A'} : ${currentValue ?? 'N/A'} ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _fnameController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          label: Text("First Name :"),
                                          prefixIcon: Icon(
                                            Icons.person,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _lnameController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          label: Text("Last Name :"),
                                          prefixIcon: Icon(
                                            Icons.person_2_outlined,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          label: Text("Email :"),
                                          prefixIcon: Icon(
                                            Icons.email,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          label: Text("Password :"),
                                          prefixIcon: Icon(
                                            Icons.password,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: Icon(_obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Retrieve the saved password
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? savedPassword =
                                    prefs.getString('password');
                                String firstName = _fnameController.text;
                                String lastName = _lnameController.text;
                                String email = _emailController.text;
                                String newPassword = _passwordController.text;

                                bool emailValid = RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                                ).hasMatch(email);

                                if (firstName.isEmpty ||
                                    lastName.isEmpty ||
                                    email.isEmpty ||
                                    newPassword.isEmpty) {
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
                                          Text('Please enter a valid email'),
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
                                } else if (newPassword.length < 6) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("Error updating"),
                                      content: Text(
                                          'Password should be at least 6 characters'),
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
                                    context:
                                        _context, // Use the assigned context
                                    builder: (context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  // Re-authenticate the user
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                    email: user.email!,
                                    password: savedPassword!,
                                  );

                                  user
                                      .reauthenticateWithCredential(credential)
                                      .then((authResult) {
                                    // User successfully re-authenticated
                                    // Proceed with updating the email
                                    user.updateEmail(email).then((_) {
                                      // Email updated successfully
                                      // Update the password
                                      user
                                          .updatePassword(newPassword)
                                          .then((_) async {
                                        // Password updated successfully
                                        // Save the password in SharedPreferences
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'password', newPassword);
                                        // Update profile information
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .where("email",
                                                isEqualTo: user.email!)
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach(
                                              (DocumentSnapshot document) {
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
                                              Navigator.of(_context).pop();

                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title:
                                                      Text("Update successful"),
                                                  content: Text(
                                                      'Profile information updated'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  HomePage()),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).catchError((error) {
                                              Navigator.of(_context).pop();

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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                          });
                                        });
                                      }).catchError((error) {
                                        Navigator.of(_context).pop();

                                        // An error occurred while updating the password
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title:
                                                Text("Error updating password"),
                                            content: Text(
                                                'An error occurred while updating the password.'),
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
                                    }).catchError((error) {
                                      Navigator.of(_context).pop();

                                      // An error occurred while updating the email
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Error updating email"),
                                          content: Text(
                                              'An error occurred while updating the email.'),
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
        ),
      ),
    );
  }
}
