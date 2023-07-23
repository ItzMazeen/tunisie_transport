// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/crud/auth_service.dart';
import 'package:flutter_application/crud/forgot_password.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_application/square_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegistrePage;

  const LoginPage({Key? key, required this.showRegistrePage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late BuildContext _context; // Define a context variable

  @override
  void initState() {
    super.initState();
    _context = context; // Assign the context in the initState method
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    showDialog(
      context: _context, // Use the assigned context
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (email.isEmpty || password.isEmpty) {
      Navigator.of(_context).pop();

      showDialog(
        context: _context,
        builder: (_) => AlertDialog(
          title: Text('Error registration'),
          content: Text(
            'Please fill in all the information',
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
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Save the password in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('password', password);
        Navigator.of(_context).pop();
      } on FirebaseAuthException catch (e) {
        Navigator.of(_context).pop();

        switch (e.code) {
          case "user-not-found":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text('Error login'),
                content: Text(
                  'User not found with this email',
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
          case "invalid-email":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text('Error login'),
                content: Text(
                  'Please enter a valid email address',
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
          case "wrong-password":
            showDialog(
              context: _context,
              builder: (_) => AlertDialog(
                title: Text('Error login'),
                content: Text(
                  'Wrong password',
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
        }
      }
    }
  }

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
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
              SizedBox(height: 30),
              Text(
                'Hello Again',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),

              // Email textField
              SizedBox(height: 30),
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
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email), // Add the icon here
                    ),
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

              // Forgot password
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        }));
                      },
                      child: Text('Forgot Password ?',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              // Sign in button
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text('Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[800],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[800],
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(context),
                      imagePath: 'assets/images/google.png')
                ],
              ),

              // not a membre
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a membre ?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: widget.showRegistrePage,
                    child: Text(' Register now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              // continue like a visitor
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login as a VISITOR ?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePage(), // Replace HomePage with your desired home page widget
                        ),
                      );
                    },
                    child: Text(' Click here',
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
