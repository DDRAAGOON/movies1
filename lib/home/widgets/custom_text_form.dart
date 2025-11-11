import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomTextForm extends StatelessWidget {
  Color borderSideColor;
  String? hintText;
  TextStyle? hintStyle;
  Widget? prefixIcon;
  Widget? suffixIcon;
  CustomTextForm({super.key,
    this.borderSideColor = AppColors.greyColor,
    this.hintStyle , required this.hintText,
    this.prefixIcon , this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    var _ = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: width*0.03 ),
      child: TextFormField(
          cursorColor: AppColors.whiteColor,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyColor,
            enabledBorder: builtDecorationBorder(borderSideColor:borderSideColor ),
            focusedBorder: builtDecorationBorder(borderSideColor: borderSideColor),
            errorBorder: builtDecorationBorder(borderSideColor: AppColors.redColor),
            focusedErrorBorder: builtDecorationBorder(borderSideColor: AppColors.redColor),
            hintText: hintText,
            hintStyle: hintStyle ?? AppStyles.medium14White ,
            prefixIcon: prefixIcon,
            suffixIcon:suffixIcon ,
          )
      ),
    );
  }
}
OutlineInputBorder builtDecorationBorder({ required Color borderSideColor}){
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
          color: borderSideColor
      )
  );
}
