import 'package:flutter/material.dart';
import 'package:movies1/Utls/routes.dart' as app_routes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: app_routes.AppRoutes.onboarding,
      routes: app_routes.AppRoutes.routes,
    );
  }
}
