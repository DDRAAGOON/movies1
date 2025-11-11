import 'package:flutter/material.dart';
import 'package:movies1/screens/auth/forget_password_screen.dart';
import 'package:movies1/screens/auth/login_screen.dart';
import 'package:movies1/screens/auth/register_screen.dart';
import 'package:movies1/screens/home/home_screen.dart';
import 'package:movies1/screens/movie_details/movie_details_screen.dart';
import 'package:movies1/screens/onboarding/onboarding_screen.dart';
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
    onboarding: (context) => OnboardingScreen(),
    login: (context) => Loginscreen(),
    register: (context) => RegisterScreen(),
    forgetPassword: (context) => ForgetPasswordScreen(),
    home: (context) => HomeScreen(),
    movieDetails: (context) => MovieDetailsScreen(),
    updateProfile: (context) => UpdateProfileScreen(),
  };
}
