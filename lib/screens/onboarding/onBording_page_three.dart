import 'package:flutter/material.dart';

import 'custem_screen.dart';
import 'onBording_page_four.dart';

class OnbordingPageThree extends StatelessWidget {
  static String routeName = "/third";
  const OnbordingPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustemScreen(
        startOpacityColor: Color(0xff85210E),
        endOpacityColor: Color(0xff85210E),
        image: "assets/images/godfather.png",
        textForElevatedButton: "Next",

        title: "Explore All Genres",
        descriprion:
            "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
             theRoute: OnbordingPageFour.routeName ,
      ),
    );
  }
}
