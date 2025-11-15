import 'package:flutter/material.dart';

import 'custem_screen.dart';
import 'onBording_page_six.dart';

class OnbordingPageFive extends StatelessWidget {
  static String routeName = "/five";
  const OnbordingPageFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustemScreen(
        image: "assets/images/five.png",
        title: "Rate, Review, and Learn",
        descriprion:
            "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
        startOpacityColor: Color(0xff601321),
        endOpacityColor: Color(0xff601321),
        theRoute: OnbordingPageSix.routeName ,
      ),
    );
  }
}
