import 'package:flutter/material.dart';
import 'pages/QrReader.dart';
import 'pages/LoginPage.dart';
import 'pages/MealSelectionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qcode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[800],
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/mealSelect': (context) => MealSelectionPage(),
        '/qrreader': (context) => QrReader(),
      },
    );
  }
}
