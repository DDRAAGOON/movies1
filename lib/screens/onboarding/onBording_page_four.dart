import 'package:flutter/material.dart';

import 'custem_screen.dart';
import 'onBording_page_five.dart';

class OnbordingPageFour extends StatelessWidget {
  static String routeName = "/four";
  const OnbordingPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustemScreen(
        image: "assets/images/badBoys.png",

        title: "Create Watchlists",
        descriprion:
            "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
        startOpacityColor: Color(0xff4C2471),
        endOpacityColor: Color(0xff4C2471),
        theRoute: OnbordingPageFive.routeName,
      ),
    );
  }
}
