import 'package:flutter/material.dart';
import 'package:movies1/Utls/routes.dart';

import 'custem_screen.dart';

class OnbordingPageSix extends StatelessWidget {
  static String routeName = "/six";
  const OnbordingPageSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustemScreen(
        image: "assets/images/end.png",
        title: "Start Watching Now",
        textForElevatedButton: "Finish",
        startOpacityColor: const Color(0xff2A2C30),
        endOpacityColor: const Color(0xff2A2C30),
        // After finishing onboarding, go to the login screen
        theRoute: AppRoutes.login,
      ),
    );
  }
}
