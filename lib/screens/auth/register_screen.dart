import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:movies1/api/token_manager.dart';
import 'package:movies1/core/app_assets.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/core/app_localizations.dart';
import 'package:movies1/providers/language_provider.dart';
import 'package:movies1/widget/toogle.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
import 'package:movies1/Utls/routes.dart' as routes;

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
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> registerUser() async {
    if (!formkey.currentState!.validate()) return;

    final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
    final localizations = AppLocalizations.of(locale);

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.passwordMismatch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (!mounted) return;

      if (userCredential.user != null) {
        final String? idToken = await userCredential.user?.getIdToken();
        if (idToken != null && idToken.isNotEmpty) {
          await TokenManager.save(idToken);
        }

        await userCredential.user?.updateDisplayName(
          nameController.text.trim(),
        );

        final locale = Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).locale;
        final localizations = AppLocalizations.of(locale);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, routes.AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      final locale = Provider.of<LanguageProvider>(
        context,
        listen: false,
      ).locale;
      final localizations = AppLocalizations.of(locale);
      String errorMsg = localizations.registerError;

      switch (e.code) {
        case 'weak-password':
          errorMsg = localizations.weakPassword;
          break;
        case 'email-already-in-use':
          errorMsg = localizations.emailAlreadyInUse;
          break;
        case 'invalid-email':
          errorMsg = localizations.invalidEmail;
          break;
        case 'operation-not-allowed':
          errorMsg = localizations.operationNotAllowed;
          break;
        case 'network-request-failed':
          errorMsg = localizations.networkError;
          break;
        default:
          errorMsg = e.message ?? localizations.registerError;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        final locale = Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).locale;
        final localizations = AppLocalizations.of(locale);
        String errorMsg = localizations.registerError;
        if (e.toString().contains('API key')) {
          errorMsg = locale == 'ar'
              ? 'مشكلة في إعدادات Firebase. يرجى التحقق من API key'
              : 'Firebase settings issue. Please check API key';
        } else if (e.toString().contains('network')) {
          errorMsg = localizations.networkError;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final locale = Provider.of<LanguageProvider>(context).locale;
    final localizations = AppLocalizations.of(locale);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.black,
        title: Text(localizations.register, style: AppStyle.med14primary),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppAssets.registerImage),
              SizedBox(height: height * 0.03),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Customtextfield(
                      hintstyle: AppStyle.med16white,
                      fillcolor: AppColors.gray,
                      controller: nameController,
                      textInputType: TextInputType.name,
                      prefixicon: Image.asset(AppAssets.nameIcon),
                      hintText: localizations.name,
                      borderSideColor: AppColors.gray,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations.pleaseEnterName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      fillcolor: AppColors.gray,
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixicon: Image.asset(AppAssets.emailIcon),
                      hintText: localizations.email,
                      hintstyle: AppStyle.med16white,
                      borderSideColor: AppColors.gray,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations.pleaseEnterEmail;
                        }
                        value = value.trim();
                        if (!value.contains('@')) {
                          return localizations.pleaseEnterValidEmail;
                        }
                        if (!value.contains('.')) {
                          return localizations.pleaseEnterValidEmailDot;
                        }
                        if (value.split('@').length != 2) {
                          return localizations.pleaseEnterValidEmailFormat;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      borderSideColor: AppColors.gray,
                      controller: passwordController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.text,
                      prefixicon: Image.asset(AppAssets.passIcon),
                      suffixicon: Image.asset(
                        isPasswordVisible
                            ? AppAssets.iconEyePass
                            : AppAssets.hiddenIcon,
                      ),
                      onSuffixIconTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      hintText: localizations.password,
                      obscuretext: !isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return localizations.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      borderSideColor: AppColors.gray,
                      controller: confirmPasswordController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.text,
                      prefixicon: Image.asset(AppAssets.passIcon),
                      suffixicon: Image.asset(
                        isConfirmPasswordVisible
                            ? AppAssets.iconEyePass
                            : AppAssets.hiddenIcon,
                      ),
                      onSuffixIconTap: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      hintText: localizations.confirmPassword,
                      obscuretext: !isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.pleaseConfirmPassword;
                        }
                        if (value != passwordController.text) {
                          return localizations.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Customtextfield(
                      borderSideColor: AppColors.gray,
                      controller: phoneController,
                      hintstyle: AppStyle.med16white,
                      textInputType: TextInputType.phone,
                      prefixicon: Image.asset(AppAssets.phoneIcon),
                      hintText: localizations.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations.pleaseEnterPhone;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    Customelevatedbuttom(
                      onPressed: isLoading ? () {} : registerUser,
                      elevatedcolor: isLoading
                          ? AppColors.primary.withOpacity(0.5)
                          : AppColors.primary,
                      elevatedchild: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              localizations.createAccount,
                              style: AppStyle.med20black,
                            ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.alreadyHaveAccount,
                          style: AppStyle.med14white,
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            localizations.login,
                            style: AppStyle.med14primary.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
