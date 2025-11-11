
import 'package:flutter/material.dart';
import 'package:movies1/Utls/images.dart';
import 'package:movies1/Utls/textStyle.dart';
import 'package:movies1/widget/toogle.dart';
import '../../Utls/colors.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
final formkey=GlobalKey<FormState>();
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var nameController = TextEditingController();
  var repassworddController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var _ = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.prirmaryColor),
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
                        hintstyle: AppStyle.med16white,
                        fillcolor: AppColors.greyColor,
                        controller: nameController,
                        textInputType: TextInputType.name,
                        prefixicon: Image.asset(AppImages.nameIcon),
                        hintText: 'Name',
                        borderSideColor: AppColors.greyColor,),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        fillcolor: AppColors.greyColor,
                        controller: nameController,
                        textInputType: TextInputType.name,
                        prefixicon: Image.asset(AppImages.emailIcon),
                        hintText: 'Email',
                        hintstyle: AppStyle.med16white,
                        borderSideColor: AppColors.greyColor,),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        borderSideColor: AppColors.greyColor,
                        controller: emailController,
                        hintstyle: AppStyle.med16white,
                        textInputType: TextInputType.emailAddress,
                        prefixicon: Image.asset(AppImages.passIcon),
                        suffixicon: Image.asset(AppImages.hiddenIcon),
                        hintText: 'Password',

                      ),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        borderSideColor: AppColors.greyColor,
                        controller: passwordController,
                        obscuretext: true,
                        textInputType: TextInputType.phone,
                        suffixicon: Image.asset(AppImages.hiddenIcon),
                        prefixicon: Image.asset(AppImages.passIcon),
                        hintText:'Confirm Password',
                        hintstyle: AppStyle.med16white,
                      ),
                      SizedBox(height: height * 0.02,),
                      Customtextfield(
                        borderSideColor: AppColors.greyColor,
                        controller: repassworddController,
                        obscuretext: true,
                        textInputType: TextInputType.phone,
                        prefixicon: Image.asset(AppImages.phoneIcon),
                        hintText:  'Phone',
                      hintstyle: AppStyle.med16white,
                      ),
                      SizedBox(height: height * 0.02,),
                      Customelevatedbuttom(onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/home');
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, child: Text('Login', style: AppStyle.med14primary
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
