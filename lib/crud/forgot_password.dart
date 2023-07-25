// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    String email = _emailController.text.trim(); // Get the trimmed email value

    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (email.isEmpty) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.errEmail,
          ),
          content: Text(
            AppLocalizations.of(context)!.invalidEmail,
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
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.sent),
            content: Text(
              AppLocalizations.of(context)!.tsent,
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
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();

        switch (e.code) {
          case "user-not-found":
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.errEmail),
                content: Text(
                  AppLocalizations.of(context)!.terrEmail,
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
            break;
          case "invalid-email":
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.errEmail,
                ),
                content: Text(
                  AppLocalizations.of(context)!.invalidEmail,
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

            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.send,
            textAlign: TextAlign.center,
          ),
          // Email textField
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _emailController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.email,
                  prefixIcon: Icon(Icons.email), // Add the icon here
                ),
              ),
            ),
          ),
          // Reset button
          SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            child: Text(AppLocalizations.of(context)!.reset),
            color: Colors.deepPurple[200],
          )
        ],
      ),
    );
  }
}
