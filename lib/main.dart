import 'package:flutter/material.dart';
import 'package:movies1/screens/auth/forget_password_screen.dart';
import 'package:movies1/screens/auth/login_screen.dart';
import 'package:movies1/screens/profile/update_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginscreen(),
    );
  }
}