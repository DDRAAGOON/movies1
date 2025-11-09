
import 'package:flutter/material.dart';
import 'package:movies1/Utls/colors.dart';
import 'package:movies1/Utls/images.dart';
import 'package:movies1/Utls/textStyle.dart';
import 'package:movies1/widget/toogle.dart';

import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';



final formkey = GlobalKey<FormState>();

class Loginscreen extends StatefulWidget {
  Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Image.asset(AppImages.group),
              SizedBox(height: height * 0.03),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Customtextfield(
                        hintstyle: AppStyle.med16white,
                      borderSideColor: Colors.grey,
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,


                       prefixicon: Image.asset(AppImages.emailIcon),
                      hintText: 'Email'
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      hintstyle: AppStyle.med16white,
                      borderSideColor: Colors.grey,

                      controller: passwordController,
                      obscuretext: true,
                      textInputType: TextInputType.phone,
                       suffixicon: Image.asset(AppImages.hiddenIcon),
                       prefixicon: Image.asset(AppImages.passIcon,),
                       hintText: 'password',
                    ),
                    SizedBox(height: height * 0.02),
                    TextButton(
                      onPressed: () {
                        //todo navigate to forget password screen
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forget Password?",
                            style: AppStyle.med14primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Customelevatedbuttom(

                      onPressed:  (){},
elevatedcolor: AppColors.prirmaryColor,
                       elevatedchild: Text(
                  'Login',
                         style: AppStyle.med20black,
              ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                    "Don't Have Account?",
                          style: AppStyle.med14white,
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.of(
                            //   context,
                            // ).pushNamed(Approuts.registerScreen);
                          },
                          child: Text(
                            'Create One',
                            style: AppStyle.med14primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            indent: width * 0.04,
                            endIndent: width * 0.04,
                            color: AppColors.prirmaryColor,
                          ),
                        ),
                        Text(
                          'OR',
                          style: AppStyle.med14primary,

                        ),

                        Expanded(
                          child: Divider(
                            thickness: 2,
                            indent: width * 0.04,
                            endIndent: width * 0.04,
                            color: AppColors.prirmaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Customelevatedbuttom(
                      elevatedcolor: AppColors.prirmaryColor,
                      onPressed:  (){},

                      elevatedchild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Image.asset(AppImages.googleIcon),
                             SizedBox(width: width*0.02,),
                             Text('Login With Google',style:AppStyle.med16black ,)
                           ],
                      ),
                    ),
                     SizedBox(height: height*0.02,),
                     Toogle()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}
