import 'package:flutter/material.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_assets.dart';
import 'package:movies1/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Toogle extends StatelessWidget {
  const Toogle({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    // initialLabelIndex: 0 for Arabic (Egypt), 1 for English (USA)
    final initialIndex = languageProvider.locale == 'ar' ? 0 : 1;
    
    return Center(
      child: ToggleSwitch(
        borderColor: [AppColors.primary],
        borderWidth: 2,
        activeBorders: [Border.all(color: AppColors.primary,width: 3)],
        animate: false,
        customWidgets: [
          Image.asset(AppAssets.egIcon),
          Image.asset(AppAssets.usIcon),
        ],
        minWidth: 50,
        cornerRadius: 50.0,
        activeBgColors: [[Colors.transparent], [Colors.transparent]],
        initialLabelIndex: initialIndex,
        totalSwitches: 2,
        radiusStyle: true,
        onToggle: (index) {
          if (index != null) {
            languageProvider.toggleLanguage(index);
          }
        },
      ),
    );
  }
}
