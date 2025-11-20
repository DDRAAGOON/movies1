import 'package:flutter/material.dart';

import 'package:movies1/core/app_assets.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import '../widgets/custom_text_form.dart';


class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        title: Text('Reset Password',style: AppStyles.bold16Orange,),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: AppColors.orangeColor,
            size: 30
        ),
      ),
      body: Column(
        children: [
          Image.asset(AppAssets.resetPassword,height: height*0.3,),
          CustomTextForm(hintText: 'Old Password',
            prefixIcon: Image.asset(AppAssets.iconPassword),
            suffixIcon: Image.asset(AppAssets.iconEyePass),
          ),
          SizedBox(height: height*0.02,),
          CustomTextForm(hintText: 'New Password',
            prefixIcon: Image.asset(AppAssets.iconPassword),
            suffixIcon: Image.asset(AppAssets.iconEyePass),
          ),
          SizedBox(height: height*0.02,),
          CustomTextForm(hintText: 'Confirm Password',
            prefixIcon: Image.asset(AppAssets.iconPassword),
            suffixIcon: Image.asset(AppAssets.iconEyePass),
          ),
          SizedBox(height: height*0.03,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: width*0.3,
                      vertical: height*0.02),
                  backgroundColor: AppColors.orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )
              ),
              onPressed: (){

              },
              child: Text('Reset Password',style: AppStyles.medium20Black,))

        ],
      ),
    );
  }
}
