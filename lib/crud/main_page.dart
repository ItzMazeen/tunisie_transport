// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/auth_page.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/crud/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            SharedPreferences.getInstance().then((prefs) {
              bool? isFirstTime = prefs.getBool('isFirstTime');

              if (isFirstTime == null) {
                // Set the flag to false to indicate subsequent logins
                prefs.setBool('isFirstTime', false);

                // User is registering for the first time, redirect to Service widget
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => Service()),
                );
              } else {
                // User is already registered, redirect to Home widget
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              }
            });
          } else {
            return AuthPage();
          }

          return CircularProgressIndicator(); // Placeholder widget while the flag is retrieved
        },
      ),
    );
  }
}
