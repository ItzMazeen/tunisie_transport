// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/setting.dart';
import 'package:flutter_application/services/livraison.dart';
import 'package:flutter_application/services/sos.dart';
import 'package:flutter_application/crud/main_page.dart';
import 'package:flutter_application/services/taxi.dart';
import 'package:flutter_application/services/trucks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'services/louage.dart';
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
            //LOGO settings
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                alignment: Alignment.center,
                width: 200,
              ),
            ),
            const SizedBox(height: 10),
            //Dashboard Menu Item
            buildMenuItem(
                text: AppLocalizations.of(context)!.home,
                icon: Icons.dashboard_outlined,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            //Dashboard Menu Item
            buildMenuItem(
                text: AppLocalizations.of(context)!.taxi,
                icon: Icons.local_taxi_outlined,
                onClicked: () => selectedItem(context, 1)),
            //Sellers Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
                text: AppLocalizations.of(context)!.louage,
                icon: Icons.directions_bus_filled_outlined,
                onClicked: () => selectedItem(context, 2)),
            //Sales statistics Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
                text: AppLocalizations.of(context)!.delivery,
                icon: Icons.fire_truck_outlined,
                onClicked: () => selectedItem(context, 3)),

            const SizedBox(height: 10),
            buildMenuItem(
                text: AppLocalizations.of(context)!.work,
                icon: Icons.local_shipping_outlined,
                onClicked: () => selectedItem(context, 4)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: AppLocalizations.of(context)!.sos,
                icon: Icons.car_repair_outlined,
                onClicked: () => selectedItem(context, 5)),
            //Divider
            const SizedBox(height: 10),
            Divider(
              color: Colors.white70,
            ),

            //Settings Menu Item

            const SizedBox(height: 10),
            if (FirebaseAuth.instance.currentUser != null)
              buildMenuItem(
                text: AppLocalizations.of(context)!.settings,
                icon: Icons.settings_outlined,
                onClicked: () => selectedItem(context, 6),
              ),
            const SizedBox(height: 10),
            buildMenuItem(
              text: AppLocalizations.of(context)!.logout,
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
        builder: (context) => Taxi(),
      ));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Louage(),
      ));
      break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => livraison(),
      ));
      break;

    case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => trucks(),
      ));
      break;
    case 5:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => sos(),
      ));
      break;
    case 6:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Setting(),
      ));
      break;
  }
}
