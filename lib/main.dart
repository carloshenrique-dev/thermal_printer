import 'package:flutter/material.dart';

import 'modules/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thermal Printer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ThermalPrinter(),
    );
  }
}
