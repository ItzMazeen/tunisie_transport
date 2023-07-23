import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  FirebaseMessaging token = FirebaseMessaging.instance;
  var serverToken =
      "AAAAkRiCMP8:APA91bEwHyocXl9CeeOrjx6XVj13OG2gT8sKn6Y7ZFKK0hBvsWJCpq1wpR1kpwPs0vVoyI4-fHHJLrGSCCXcHeBXlatT9a3J4X1pwPHXPJAMvP4--7C6PO02qzuQmw5nmoINQ1sIDBOX";

  pen(String t, String b) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': b.toString(),
              'title': t.toString()
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'to': "/topic/weather"
            },
            'to': "/topics/weather"
          },
        ));
  }

  getMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      print("======================================================");
      print(event.notification!.title);
      print(event.notification!.body);
      print("${event.notification!.body}");
    });
  }

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () async {
                      await pen("montadhar", "Reataj");
                    },
                    child: Text("notfiy")),
                TextButton(
                    onPressed: () async {
                      await FirebaseMessaging.instance
                          .subscribeToTopic('service');
                    },
                    child: Text("subscribe")),
                TextButton(
                    onPressed: () async {
                      await FirebaseMessaging.instance
                          .unsubscribeFromTopic('service');
                    },
                    child: Text("unsubscribe")),
              ],
            ),
          ),
        ));
  }
}
