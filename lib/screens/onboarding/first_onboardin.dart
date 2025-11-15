import 'package:flutter/material.dart';
import 'package:movies1/screens/onboarding/second_screen.dart';
import 'custom_elevated_button.dart';

class FirstOnboarding extends StatelessWidget {
  static String routeName = "/first";
  const FirstOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/first_onborading.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Find Your Next Favorite Movie Here",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 36,
                  fontFamily: "Inter",
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Get access to a huge library of movies to suit all tastes. You will surely like it.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondScreen(),
                        ),
                      );
                    },
                    child: Text("Go To Second Screen"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
