
import 'package:flutter/material.dart';
import 'package:movies1/Utls/colors.dart';
import 'package:movies1/Utls/images.dart';
import 'package:movies1/Utls/textStyle.dart';
import 'package:movies1/widget/toogle.dart';

import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
final formkey=GlobalKey<FormState>();
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.blackColor),
        backgroundColor: AppColors.blackColor,
        title: Text('Register', style: AppStyle.med14primary,),
        centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppImages.registerImage),
              SizedBox(height: height * 0.03,),
              Form(
                  key: formkey,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Customtextfield(

                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter Name';
                          }
                          final bool namevalid = RegExp(
                              '!@#<>?":_``~;[]\|=-+)(*&^%1234567890').hasMatch(text);
                          if (!namevalid) {
                            return 'Please enter valid,email ';
                          }
                        },
                        hintstyle: AppStyle.med16white,
                        fillcolor: AppColors.greyColor,
                        controller: nameController,
                        textStyle: AppStyle.med16white,
                        textInputType: TextInputType.name,
                        prefixicon: Image.asset(AppImages.nameIcon),
                        hintText: 'Name',
                        borderSideColor: AppColors.greyColor,),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter Email';
                          }
                          final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(text);
                          if (!emailValid) {
                            return 'Please enter valid,email ';
                          }
                        },
                        textStyle: AppStyle.med16white,
                        fillcolor: AppColors.greyColor,
                        controller: emailController,
                        textInputType: TextInputType.name,
                        prefixicon: Image.asset(AppImages.emailIcon),
                        hintText:'Email',
                        hintstyle: AppStyle.med16white,
                        borderSideColor: AppColors.greyColor,),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        validator: (text) {
                          RegExp regex =
                          RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          if (text!.isEmpty) {
                            return 'Please enter password';
                          } else {
                            if (!regex.hasMatch(text)) {
                              return 'Enter valid password';
                            } else {
                              return null;
                            }
                          }
                        },
                        obscuretext: true,
                        textStyle: AppStyle.med16white,
                        borderSideColor: AppColors.greyColor,
                        controller: passwordController,
                        hintstyle: AppStyle.med16white,
                        textInputType: TextInputType.visiblePassword,
                        prefixicon: Image.asset(AppImages.passIcon),
                        suffixicon: Image.asset(AppImages.hiddenIcon),
                        hintText: 'Password',

                      ),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        validator: (text) {
                           if(text==passwordController.text){
                             return 'valid password';
                           }
                           return'invalid password';
                        },
                        textStyle: AppStyle.med16white,
                        borderSideColor: AppColors.greyColor,
                        controller: rePasswordController,
                        obscuretext: true,
                        textInputType: TextInputType.phone,
                        suffixicon: Image.asset(AppImages.hiddenIcon),
                        prefixicon: Image.asset(AppImages.passIcon),
                        hintText:'Confirm Password',
                        hintstyle: AppStyle.med16white,
                      ),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        validator: (text) {
                          Pattern pattern =
                              r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/';
                          RegExp regex = new RegExp(pattern.toString());
                          if (!regex.hasMatch(text!))
                            return 'Enter Valid Phone Number';
                          else
                            return null;
                        },
                        textStyle: AppStyle.med16white,
                        borderSideColor: AppColors.greyColor,
                        controller: phoneController,
                        obscuretext: true,
                        textInputType: TextInputType.phone,
                        prefixicon: Image.asset(AppImages.phoneIcon),
                        hintText:  'Phone',
                      hintstyle: AppStyle.med16white,
                      ),
                      SizedBox(height: height * 0.02,),
                      Customelevatedbuttom(onPressed: (){
                        if(formkey.currentState!.validate()==true){
                          Navigator.pop(context);
                        }
                      },
                        elevatedchild: Text('Create Account',
                          style: AppStyle.med20black,),
                        elevatedcolor: AppColors.prirmaryColor,),
                      SizedBox(height: height * 0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                             'Already Have Account?',
                            style: AppStyle.med14white),
                          TextButton(
                              onPressed: () {}, child: Text('Login', style: AppStyle.med14primary
                              .copyWith(
                            decoration: TextDecoration.underline,
                          ),))
                        ],),
                      SizedBox(height: height * 0.02,),
                      Toogle(),
                      // // Column(
                      // //   children: [
                      // //     FlagToggleExample(
                      // //       im1: AppAssets.EG, im2: AppAssets.US,),
                      // //   ],
                      // // ),
                      // SizedBox(height: height * 0.02,),


                    ],

                  )
              ),


            ],),
        ),
      ),
    );
  }

}
