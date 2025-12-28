import 'package:flutter/material.dart';
import 'package:stitch/bookingconfirmation.dart';
import 'package:stitch/bookingmanagement.dart';
import 'package:stitch/booktable.dart';
import 'package:stitch/login.dart';
import 'package:stitch/profile.dart';
import 'package:stitch/tablemanagement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E60F7)),
        useMaterial3: true,
        fontFamily:
            'Inter', // Try to use Inter if available, or it will fallback
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
