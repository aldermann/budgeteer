import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/meta/meta.dart';
import 'package:budgeteer/routes/routes.dart';
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

import 'routes/home/home.dart';
import 'models/currency/currency.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Budget.registerAdapters();
  Currency.registerAdapters();
  await Metadata.init();
  await Budget.openBox();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgeteer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(color: Colors.red.shade700),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: "/home",
    );
  }
}
