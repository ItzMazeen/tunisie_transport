// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unused_element, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrePage extends StatefulWidget {
  final VoidCallback showLoginPage;

  RegistrePage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  late BuildContext _context; // Define a context variable

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('service');

    _context = context; // Assign the context in the initState method
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmpasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  bool _obscureText2 = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _obscureText2 = !_obscureText2;
    });
  }

  Future signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmpasswordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    showDialog(
      context: _context, // Use the assigned context
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      Navigator.of(_context).pop();

      showDialog(
        context: _context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.fill),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
          ],
        ),
      );
    } else if (!passwordEqual()) {
      Navigator.of(_context).pop();

      showDialog(
        context: _context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.wrong),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        addUserDetails(
          firstName,
          lastName,
          email,
        );
        // Save the password in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('password', password);
        Navigator.of(_context).pop();
      } on FirebaseAuthException catch (e) {
        Navigator.of(_context).pop();

        switch (e.code) {
          case "invalid-email":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(
                  AppLocalizations.of(context)!.invalidEmail,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(_context).pop();
                    },
                  ),
                ],
              ),
            );
            break;
          case "email-already-in-use":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(
                  AppLocalizations.of(context)!.use,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(_context).pop();
                    },
                  ),
                ],
              ),
            );
            break;
          case "weak-password":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(
                  AppLocalizations.of(context)!.weak,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(_context).pop();
                    },
                  ),
                ],
              ),
            );
            break;
        }
      }
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }

  bool passwordEqual() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
                'assets/images/logo.png',
                width: 200,
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.registerB,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),

              // Email textField
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
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.firstName),
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
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.person_2_outlined), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.lastName),
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
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email), // Add the icon here
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.email),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Password textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password), // Add the icon here
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.password,
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
              SizedBox(height: 10),
              // confirm Password textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _confirmpasswordController,
                    obscureText: _obscureText2,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password), // Add the icon here

                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.cpassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        child: Icon(_obscureText2
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                  ),
                ),
              ),

              // Sign in button
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromRGBO(255, 168, 39, 1),
                    ),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.registre,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
              ),
              // not a membre
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.memberI,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(AppLocalizations.of(context)!.loginN,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
