// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingalPage extends StatefulWidget {
  final String docId;
  final String name;
  final String region;
  final String modele;
  final String serie;
  final String phone;
  final String about;
  final String service;

  SingalPage({
    required this.docId,
    required this.name,
    required this.region,
    required this.modele,
    required this.serie,
    required this.phone,
    required this.about,
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  State<SingalPage> createState() => _SingalPageState();
}

class _SingalPageState extends State<SingalPage> {
  late TextEditingController _reasonController;
  late String _reason = '';

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitSignal() {
    final String phoneNumber = widget.phone;
    final String modele = widget.modele;
    final String name = widget.name;
    final String serie = widget.serie;
    final String about = widget.about;
    final String service = widget.service;
    final String region = widget.region;
    final String docId = widget.docId;
    final String reason = _reasonController.text;

    // Send the reason and phone number to the "Sibal" collection in Firebase
    FirebaseFirestore.instance.collection("Signal").add({
      "phone": phoneNumber,
      "name": name,
      "about": about,
      "modele": modele,
      "serie": serie,
      "service": service,
      "region": region,
      "reason": reason,
      "docId_service": docId,
    }).then((value) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.sucessSignal),
          content: Text(AppLocalizations.of(context)!.tsucessSignal),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(), // Replace NextPage with your desired page/widget
                  ),
                );
              },
            ),
          ],
        ),
      );
      // Successfully added the document
      // You can show a success dialog or navigate to another page
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error signaling"),
          content: Text('Please try again later'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.signal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.reason,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.treason,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _reason = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reason.isNotEmpty ? _submitSignal : null,
                child: Text(AppLocalizations.of(context)!.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
