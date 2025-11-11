import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
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
        //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // fixedSize: Size(400, 60),
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
