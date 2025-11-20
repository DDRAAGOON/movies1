import 'package:flutter/material.dart';
import 'package:movies1/core/app_colors.dart';
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

  String textForBackButton;
  Color? backButtonColor;
  bool showBackButton;

  double? cardHeight;

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
    this.textForBackButton = "Back",
    this.backButtonColor,
    this.showBackButton = false,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
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
                height: cardHeight ?? 260,
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

                      if (showBackButton) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: Color(0xffF6BD00),
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor: Color(0xff121312),
                                  shadowColor: Colors.black.withOpacity(0.5),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  textForBackButton,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xffF6BD00),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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