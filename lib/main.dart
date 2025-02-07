// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/crud/main_page.dart';
import 'package:flutter_application/provider/locale_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  // Retrieve the saved locale from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocale = prefs.getString('selectedLocale');
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(savedLocale != null
          ? Locale(savedLocale)
          : null), // Pass the saved locale to the provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize the local notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('test');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen to incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the notification and show it manually
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      showNotification(title, body);
    });
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Access the LocaleProvider instance directly without using Consumer
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'AlloTransport',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(255, 168, 39, 1),
        ),
      ),
      locale: localeProvider.locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: const MainPage(),
    );
  }
}
