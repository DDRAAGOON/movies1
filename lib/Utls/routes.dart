import 'package:flutter/material.dart';
import 'package:movies1/screens/auth/forget_password_screen.dart';
import 'package:movies1/screens/auth/login_screen.dart';
import 'package:movies1/screens/auth/register_screen.dart';
import 'package:movies1/screens/profile/update_profile_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';
  static const String movieDetails = '/movie-details';
  static const String updateProfile = '/update-profile';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => Loginscreen(),
    register: (context) => RegisterScreen(),
    forgetPassword: (context) => ForgetPasswordApp(),
    updateProfile: (context) => UpdateProfilePage(),
  };
}
