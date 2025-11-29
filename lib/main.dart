import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:movies1/Utls/routes.dart' as app_routes;
import 'package:movies1/api/dio_helper.dart';
import 'package:movies1/firebase_options.dart';
import 'package:movies1/providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle Firebase initialization error
    debugPrint('Firebase initialization error: $e');
    // Continue without Firebase if initialization fails
  }
  
  // Initialize DioHelper
  DioHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: app_routes.AppRoutes.onboarding,
            routes: app_routes.AppRoutes.routes,
          );
        },
      ),
    );
  }
}
