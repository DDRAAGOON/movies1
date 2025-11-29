import 'package:flutter/material.dart';
import 'package:movies1/Utls/routes.dart';
import 'package:movies1/core/app_colors.dart';
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
        startOpacityColor: AppColors.start,
        endOpacityColor: AppColors.start,
        theRoute: AppRoutes.login,
        showBackButton: true,
        cardHeight: 240,
      ),
    );
  }
}