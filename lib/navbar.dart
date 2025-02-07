// ignore_for_file: prefer_const_constructors, prefer_const_declarations, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/crud/setting.dart';

import 'package:flutter_application/crud/main_page.dart';
import 'package:flutter_application/crud/warnings_page.dart';
import 'package:flutter_application/home_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    final padding = EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 60,
    );

    return Drawer(
      child: Material(
        color: Colors.black,
        child: ListView(
          padding: padding,
          children: <Widget>[
            //LOGO settings
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Image.asset(
                'assets/images/logoW.png',
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
            if (currentUser?.email == "admin@gmail.com")
              buildMenuItem(
                  text: AppLocalizations.of(context)!.warnigns,
                  icon: Icons.report_gmailerrorred,
                  onClicked: () => selectedItem(context, 1)),
            //Divider
            // Rate App Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
              text: AppLocalizations.of(context)!
                  .rate, // Replace with your desired text
              icon: Icons.star, // Replace with your desired icon
              onClicked: () {
                // Replace 'your_package_name' with your actual package name on the Play Store
                final playStoreUrl =
                    'https://play.google.com/store/apps/details?id=com.alidev.taxirogba';
                _launchURL(playStoreUrl);
              },
            ),
            // Visit Facebook Page Menu Item
            const SizedBox(height: 10),
            buildMenuItem(
              text: AppLocalizations.of(context)!
                  .facebook, // Replace with your desired text
              icon: Icons
                  .facebook, // Replace with your desired icon (if available)
              onClicked: () {
                final facebookPageUrl =
                    'https://www.facebook.com/allotransport.tunisie'; // Replace with your Facebook page URL
                _launchURL(facebookPageUrl);
              },
            ),

            Divider(
              color: Colors.white70,
            ),

            //Settings Menu Item

            const SizedBox(height: 10),
            if (FirebaseAuth.instance.currentUser != null)
              buildMenuItem(
                text: AppLocalizations.of(context)!.settings,
                icon: Icons.settings_outlined,
                onClicked: () => selectedItem(context, 2),
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
        builder: (context) => WarningsPage(),
      ));
      break;
    case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Setting(),
      ));
      break;
  }
}

// Function to launch URLs
void _launchURL(String url) async {
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
