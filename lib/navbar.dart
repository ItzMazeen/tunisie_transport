// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Livraison.dart';
import 'package:flutter_application/Setting.dart';
import 'package:flutter_application/d%C3%A9panneuse.dart';
import 'package:flutter_application/main_page.dart';
import 'package:flutter_application/taxi.dart';
import 'package:flutter_application/toktok.dart';
import 'package:flutter_application/trucks.dart';

import 'Louage.dart';
import 'home_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 60,
    );
    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 64, 145, 108),
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 10),
            //LOGO settings
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Image.asset(
                'assets/images/wowsoft.png',
                alignment: Alignment.center,
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(height: 10),
            //Dashboard Menu Item
            buildMenuItem(
                text: 'Home',
                icon: Icons.dashboard_outlined,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            //Dashboard Menu Item
            buildMenuItem(
                text: 'Louage',
                icon: Icons.directions_bus_filled_outlined,
                onClicked: () => selectedItem(context, 1)),
            //Sellers Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Toktoks',
                icon: Icons.fire_truck_outlined,
                onClicked: () => selectedItem(context, 2)),
            //Sales statistics Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Taxi',
                icon: Icons.local_taxi_outlined,
                onClicked: () => selectedItem(context, 3)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Livraison',
                icon: Icons.motorcycle_outlined,
                onClicked: () => selectedItem(context, 4)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Trucks',
                icon: Icons.local_shipping_outlined,
                onClicked: () => selectedItem(context, 5)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'SOS',
                icon: Icons.car_repair_outlined,
                onClicked: () => selectedItem(context, 6)),
            //Divider
            const SizedBox(height: 10),
            Divider(
              color: Colors.white70,
            ),

            //Settings Menu Item

            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Settings',
                icon: Icons.settings_outlined,
                onClicked: () => selectedItem(context, 7)),
            const SizedBox(height: 10),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_rounded,
              onClicked: () async {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainPage()), // Replace 'LoginPage' with the name of your login page
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Menu Item settings
Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;
  return ListTile(
    leading: Icon(icon, size: 28, color: color),
    title: Text(text, style: TextStyle(color: color, fontSize: 16)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}

//redirect when selected Menu Item
void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
      break;
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Louage(),
      ));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Toktok(),
      ));
      break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Taxi(),
      ));
      break;
    case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => livraison(),
      ));
      break;
    case 5:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => trucks(),
      ));
      break;
    case 6:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => depanneuse(),
      ));
      break;
    case 7:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Setting(),
      ));
      break;
  }
}
