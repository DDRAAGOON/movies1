import 'package:flutter/material.dart';
import '../../Utls/colors.dart';
import 'custom_elevated_button.dart';

class CustemScreen extends StatelessWidget {
  Color startOpacityColor;
  Color endOpacityColor;
  String image;
  String title;
  String descriprion;
  String textForElevatedButton;
  String textForOutlineButton;
  String theRoute;

  CustemScreen({
    super.key,
    required this.image,
    this.textForElevatedButton = "Next",
    this.textForOutlineButton = "Back",
    required this.title,
    this.descriprion = "",
    required this.startOpacityColor,
    required this.endOpacityColor,
    required this.theRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(image, fit: BoxFit.fill),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  startOpacityColor.withOpacity(0.1),
                  endOpacityColor.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: AppColors.blackColor,
                ),
                width: double.infinity,
                height: 260,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              title,

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              descriprion,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              routeName: theRoute,
                              text: textForElevatedButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
