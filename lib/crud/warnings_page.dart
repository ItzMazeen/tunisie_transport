// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarningsPage extends StatefulWidget {
  WarningsPage({Key? key}) : super(key: key);

  @override
  State<WarningsPage> createState() => _WarningsPageState();
}

class _WarningsPageState extends State<WarningsPage> {
  var collection = FirebaseFirestore.instance.collection("Signal");
  late List<Map<String, dynamic>> items;
  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  bool isLoaded = false;

  _incrementCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();
    data.docs.forEach((element) {
      var itemData = element.data();
      itemData["id"] = element.id; // Include the document ID in the data map
      tempList.add(itemData);
    });

    setState(() {
      items = tempList;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.warnigns,
          )),
      body: ListView(
        children: [
          isLoaded
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final currentItem = items[index];
                    final serviceName = currentItem["name"] ?? "Not given";
                    final modeleVehicule = currentItem["modele"] ?? "Not given";
                    final region = currentItem["region"] ?? "Not given";
                    final reason = currentItem["reason"] ?? "Not given";
                    final service = currentItem["service"] ?? "Not given";

                    return InkWell(
                      onTap: () {
                        showDialogFunc(
                            context,
                            currentItem["id"] ?? "Not given",
                            currentItem["User"] ?? "Not given",
                            serviceName,
                            region,
                            modeleVehicule,
                            currentItem["serie"] ?? "Not given",
                            currentItem["phone"].toString(),
                            currentItem["about"] ?? "Not given",
                            currentItem["reason"] ?? "Not given",
                            currentItem["service"] ?? "Not given",
                            currentItem["docId_service"] ?? "Not given");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xff6ae792),
                            child: Icon(Icons.person),
                          ),
                          title: Row(
                            children: [
                              Text(service),
                              Text(" | "),
                              Text(reason),
                            ],
                          ),
                          subtitle: Text(region),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}

showDialogFunc(context, docId, user, name, region, modele, serie, phone, about,
    reason, service, docId_service) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          Container(
                            height: 100.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .confirmDelete,
                                          ),
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .confirmWarnigns),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete),
                                              onPressed: () {
                                                // Delete the document
                                                FirebaseFirestore.instance
                                                    .collection("Signal")
                                                    .doc(docId)
                                                    .delete()
                                                    .then((_) {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  // Show a success dialog or navigate to a different page
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .deleteSucc),
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .tdeleteSucc),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WarningsPage(), // Replace NextPage with your desired page/widget
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).catchError((error) {
                                                  // Show an error dialog if deletion fails
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .error),
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .tedelete),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .confirmDelete,
                                          ),
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .tconfirmDelete),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete),
                                              onPressed: () {
                                                // Delete the document
                                                FirebaseFirestore.instance
                                                    .collection(service)
                                                    .doc(docId_service)
                                                    .delete()
                                                    .then((_) {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  // Show a success dialog or navigate to a different page
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .deleteSucc),
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .tdeleteSucc),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WarningsPage(), // Replace NextPage with your desired page/widget
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).catchError((error) {
                                                  // Show an error dialog if deletion fails
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .error),
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .tedelete),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete_sweep_rounded),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 50.0,
                              left: 94.0,
                              child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0,
                                  ),
                                  color: const Color(
                                      0xff6ae792), // Set the background color directly
                                ),
                                child: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              ))
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              reason,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Center(
                            child: Text("-----------------------------------"),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                name,
                              ),
                            ),
                            Text(
                              ' | ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                region,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                modele,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                serie,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.phone,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Center(
                            child: Text(
                              about,
                            ),
                          )),
                    ],
                  ),
                )));
      });
}
