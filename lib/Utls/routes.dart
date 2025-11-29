import 'package:flutter/material.dart';
import 'package:movies1/screens/auth/forget_password_screen.dart';
import 'package:movies1/screens/auth/login_screen.dart';
import 'package:movies1/screens/auth/register_screen.dart';
import 'package:movies1/screens/home/home_screen.dart';
import 'package:movies1/screens/movie_details/movie_details_screen.dart';
import 'package:movies1/screens/onboarding/first_onboardin.dart';
import 'package:movies1/screens/onboarding/onBording_page_three.dart';
import 'package:movies1/screens/onboarding/onBording_page_four.dart';
import 'package:movies1/screens/onboarding/onBording_page_five.dart';
import 'package:movies1/screens/onboarding/onBording_page_six.dart';
import 'package:movies1/screens/onboarding/second_screen.dart';
import 'package:movies1/screens/profile/update_profile_screen.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String home = '/home';
  static const String movieDetails = '/movie-details';
  static const String updateProfile = '/update-profile';

  static const String firstOnboarding = '/first';
  static const String secondOnboarding = '/second';
  static const String thirdOnboarding = '/third';
  static const String fourthOnboarding = '/four';
  static const String fifthOnboarding = '/five';
  static const String sixthOnboarding = '/six';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const FirstOnboarding(),

    firstOnboarding: (context) => const FirstOnboarding(),
    secondOnboarding: (context) => const SecondScreen(),
    thirdOnboarding: (context) => const OnbordingPageThree(),
    fourthOnboarding: (context) => const OnbordingPageFour(),
    fifthOnboarding: (context) => const OnbordingPageFive(),
    sixthOnboarding: (context) => const OnbordingPageSix(),

    login: (context) => const Loginscreen(),
    register: (context) => const RegisterScreen(),
    forgetPassword: (context) => const ForgetPasswordPage(),

    home: (context) => const HomeScreen(),
    // movieDetails requires movieId parameter, so it should be navigated directly
    // using Navigator.push with MaterialPageRoute instead of routes

  };
}
