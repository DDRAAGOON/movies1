import 'package:flutter/material.dart';
import 'package:movies1/Utls/colors.dart';
import 'package:movies1/Utls/images.dart';
import 'package:movies1/Utls/textStyle.dart';
import 'package:movies1/screens/auth/register_screen.dart';
import 'package:movies1/widget/toogle.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
import 'auth_service.dart';
import 'user_model.dart';
import 'forget_password_screen.dart';

final formkey = GlobalKey<FormState>();

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final UserModel res = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final code = res.statusCode ?? 0;
      if (code == 200 || code == 201) {

        Navigator.of(context).pushReplacementNamed('/home');
      } else {

        final msg = res.message.isNotEmpty ? res.message : 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
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
                      hintText: 'Email',
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      hintstyle: AppStyle.med16white,
                      borderSideColor: Colors.grey,
                      controller: passwordController,
                      obscuretext: true,
                      textInputType: TextInputType.phone,
                      suffixicon: Image.asset(AppImages.hiddenIcon),
                      prefixicon: Image.asset(AppImages.passIcon),
                      hintText: 'Password',
                    ),
                    SizedBox(height: height * 0.02),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage(),
                          ),
                        );
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
                      onPressed: () {
                        if (!isLoading) {
                          loginUser();
                        }
                      },
                      elevatedcolor: isLoading
                          ? AppColors.prirmaryColor.withOpacity(0.5)
                          : AppColors.prirmaryColor,
                      elevatedchild: isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 3,
                              ),
                            )
                          : Text('Login', style: AppStyle.med20black),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have Account?", style: AppStyle.med14white),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
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
                        Text('OR', style: AppStyle.med14primary),
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text(
                                'Alert message',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text('Success login with Google'),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Ok',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      elevatedchild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.googleIcon),
                          SizedBox(width: width * 0.02),
                          Text('Login With Google', style: AppStyle.med16black),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    const Toogle(),
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
