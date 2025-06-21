import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/employer_dash_screen.dart';

void main() {
  runApp(const TimeGenApp());
}

class TimeGenApp extends StatelessWidget {
  const TimeGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Gen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF111111),
      ),
      home: const EmployerDashScreen(),
    );
  }
}