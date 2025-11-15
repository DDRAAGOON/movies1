import 'package:flutter/material.dart';

import 'custem_screen.dart';
import 'onBording_page_three.dart';

class SecondScreen extends StatelessWidget {
  static String routeName = "/second";
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustemScreen(
        image: "assets/images/second.png",
        title: "Discover Movies",
        descriprion:
            "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
        startOpacityColor: Color(0xff121312),
        endOpacityColor: Color(0xff084250),
        theRoute: OnbordingPageThree.routeName,
      ),
    );
  }
}
