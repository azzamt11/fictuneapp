import './pages/AuthPage.dart';
import './pages/InitialPage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: const InitialPage(),
  ));
}


