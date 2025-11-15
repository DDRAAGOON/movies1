import 'package:flutter/material.dart';
import 'package:movies1/Utls/images.dart';
import 'package:movies1/Utls/textStyle.dart';
import 'package:movies1/widget/toogle.dart';
import '../../Utls/colors.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
import 'auth_service.dart';
import 'user_model.dart';

final formkey = GlobalKey<FormState>();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    if (!formkey.currentState!.validate()) return;

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password and confirm password do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      final UserModel res = await AuthService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        phone: phoneController.text.trim(),
        avaterId: 1,
      );

      final regCode = res.statusCode ?? 0;
      if (regCode == 200 || regCode == 201) {
        final UserModel loginRes = await AuthService.login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final loginCode = loginRes.statusCode ?? 0;
        if (loginCode == 200 || loginCode == 201) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          final msg = loginRes.message.isNotEmpty
              ? loginRes.message
              : 'Login failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      } else {
        final msg = res.message.isNotEmpty
            ? res.message
            : 'Registration failed';
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.prirmaryColor),
        backgroundColor: AppColors.blackColor,
        title: Text('Register', style: AppStyle.med14primary),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppImages.registerImage),
              SizedBox(height: height * 0.03),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Customtextfield(
                      hintstyle: AppStyle.med16white,
                      fillcolor: AppColors.greyColor,
                      controller: nameController,
                      textInputType: TextInputType.name,
                      prefixicon: Image.asset(AppImages.nameIcon),
                      hintText: 'Name',
                      borderSideColor: AppColors.greyColor,
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      fillcolor: AppColors.greyColor,
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixicon: Image.asset(AppImages.emailIcon),
                      hintText: 'Email',
                      hintstyle: AppStyle.med16white,
                      borderSideColor: AppColors.greyColor,
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      borderSideColor: AppColors.greyColor,
                      controller: passwordController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.text,
                      prefixicon: Image.asset(AppImages.passIcon),
                      suffixicon: Image.asset(AppImages.hiddenIcon),
                      hintText: 'Password',
                      obscuretext: true,
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      borderSideColor: AppColors.greyColor,
                      controller: confirmPasswordController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.text,
                      prefixicon: Image.asset(AppImages.passIcon),
                      suffixicon: Image.asset(AppImages.hiddenIcon),
                      hintText: 'Confirm Password',
                      obscuretext: true,
                    ),
                    SizedBox(height: height * 0.02),
                    Customtextfield(
                      borderSideColor: AppColors.greyColor,
                      controller: phoneController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.phone,
                      prefixicon: Image.asset(AppImages.phoneIcon),
                      hintText: 'Phone',
                    ),
                    SizedBox(height: height * 0.02),
                    Customelevatedbuttom(
                      onPressed: () {
                        if (!isLoading) {
                          registerUser();
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
                          : Text('Create Account', style: AppStyle.med20black),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already Have Account?', style: AppStyle.med14white),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Login',
                            style: AppStyle.med14primary.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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