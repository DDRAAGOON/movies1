import 'package:flutter/material.dart';
import 'package:movies1/Utls/colors.dart';
import 'package:movies1/Utls/images.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Toogle extends StatelessWidget {
  const Toogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleSwitch(
        borderColor: [AppColors.prirmaryColor],
        borderWidth: 2,
        activeBorders: [Border.all(color: AppColors.prirmaryColor,width: 3)],
        animate: false,
        customWidgets: [
          Image.asset(AppImages.egIcon),
          Image.asset(AppImages.usIcon),
        ],
        minWidth: 50,
        cornerRadius: 50.0,
          activeBgColors: [[Colors.transparent], [Colors.transparent]],
        initialLabelIndex: 1,
        totalSwitches: 2,
        radiusStyle: true,
        onToggle: (index) {

        },
      ),
    );
  }
}
