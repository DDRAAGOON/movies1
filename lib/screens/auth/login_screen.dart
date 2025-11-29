import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:movies1/api/token_manager.dart';
import 'package:movies1/core/app_colors.dart';
import 'package:movies1/core/app_assets.dart';
import 'package:movies1/core/app_text_styles.dart';
import 'package:movies1/core/app_localizations.dart';
import 'package:movies1/providers/language_provider.dart';
import 'package:movies1/screens/auth/register_screen.dart';
import 'package:movies1/widget/toogle.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/custom_text_field.dart';
import 'forget_password_screen.dart';
import 'package:movies1/Utls/routes.dart' as routes;

final formkey = GlobalKey<FormState>();

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isGoogleLoading = false;

  Future<void> loginUser() async {
    if (!formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      
      // تسجيل الدخول باستخدام Firebase
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (userCredential.user != null) {
        // حفظ التوكن (ID Token من Firebase)
        final String? idToken = await userCredential.user?.getIdToken();
        if (idToken != null && idToken.isNotEmpty) {
          await TokenManager.save(idToken);
        }

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الدخول بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // انتقل للـ Home مباشرة بعد النجاح
        if (mounted) {
          Navigator.pushReplacementNamed(context, routes.AppRoutes.home);
        }
      }
    } on FirebaseAuthException catch (e) {
      final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
      final localizations = AppLocalizations.of(locale);
      String errorMsg = localizations.loginError;

      switch (e.code) {
        case 'user-not-found':
          errorMsg = localizations.userNotFound;
          break;
        case 'wrong-password':
          errorMsg = localizations.wrongPassword;
          break;
        case 'invalid-email':
          errorMsg = localizations.invalidEmail;
          break;
        case 'user-disabled':
          errorMsg = localizations.userDisabled;
          break;
        case 'too-many-requests':
          errorMsg = localizations.tooManyRequests;
          break;
        case 'operation-not-allowed':
          errorMsg = localizations.operationNotAllowed;
          break;
        case 'network-request-failed':
          errorMsg = localizations.networkError;
          break;
        default:
          errorMsg = e.message ?? localizations.unexpectedError;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
        final localizations = AppLocalizations.of(locale);
        String errorMsg = localizations.unexpectedError;
        if (e.toString().contains('API key')) {
          errorMsg = locale == 'ar' 
              ? 'مشكلة في إعدادات Firebase. يرجى التحقق من API key'
              : 'Firebase settings issue. Please check API key';
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

  Future<void> signInWithGoogle() async {
    setState(() => isGoogleLoading = true);

    try {
      // Configure Google Sign-In with scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // المستخدم ألغى العملية
        if (mounted) {
          setState(() => isGoogleLoading = false);
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      if (userCredential.user != null) {
        // حفظ التوكن (ID Token من Firebase)
        final String? idToken = await userCredential.user?.getIdToken();
        if (idToken != null && idToken.isNotEmpty) {
          await TokenManager.save(idToken);
        }

        // Show success message
        if (mounted) {
          final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
          final localizations = AppLocalizations.of(locale);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.loginSuccess),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // انتقل للـ Home مباشرة بعد النجاح
        if (mounted) {
          Navigator.pushReplacementNamed(context, routes.AppRoutes.home);
        }
      }
    } on FirebaseAuthException catch (e) {
      final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
      final localizations = AppLocalizations.of(locale);
      String errorMsg = localizations.googleLoginError;
      
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMsg = localizations.accountExistsWithDifferentCredential;
          break;
        case 'invalid-credential':
          errorMsg = localizations.invalidCredential;
          break;
        case 'operation-not-allowed':
          errorMsg = localizations.googleLoginNotEnabled;
          break;
        case 'network-request-failed':
          errorMsg = localizations.networkError;
          break;
        default:
          errorMsg = e.message ?? localizations.googleLoginError;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
        final localizations = AppLocalizations.of(locale);
        String errorMsg = localizations.googleLoginError;
        
        // Log the full error for debugging
        debugPrint('Google Sign-In Error: ${e.toString()}');
        debugPrint('Error Type: ${e.runtimeType}');
        
        // Handle specific Google Sign-In errors
        final errorString = e.toString().toLowerCase();
        
        if (errorString.contains('sign_in_failed') || errorString.contains('sign_in_canceled')) {
          // User cancelled, don't show error
          if (mounted) {
            setState(() => isGoogleLoading = false);
          }
          return;
        } else if (errorString.contains('network') || errorString.contains('socket')) {
          errorMsg = localizations.networkError;
        } else if (errorString.contains('developer_error') || errorString.contains('10:')) {
          errorMsg = locale == 'ar'
              ? 'خطأ في إعدادات التطبيق. يرجى التأكد من تفعيل Google Sign-In في Firebase Console'
              : 'App configuration error. Please make sure Google Sign-In is enabled in Firebase Console';
        } else if (errorString.contains('api_not_configured') || errorString.contains('12500')) {
          errorMsg = locale == 'ar'
              ? 'Google Sign-In غير مفعّل في Firebase Console. يرجى تفعيله من Authentication > Sign-in method'
              : 'Google Sign-In not enabled in Firebase Console. Please enable it from Authentication > Sign-in method';
        } else if (errorString.contains('sign_in_required')) {
          errorMsg = locale == 'ar'
              ? 'يرجى تسجيل الدخول مرة أخرى'
              : 'Please sign in again';
        } else if (errorString.contains('internal_error')) {
          errorMsg = locale == 'ar'
              ? 'خطأ داخلي. يرجى المحاولة مرة أخرى'
              : 'Internal error. Please try again';
        } else {
          // Show detailed error for debugging
          errorMsg = locale == 'ar'
              ? 'خطأ في تسجيل الدخول بجوجل: ${e.toString().split(':').last.trim()}'
              : 'Google login error: ${e.toString().split(':').last.trim()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final locale = Provider.of<LanguageProvider>(context).locale;
    final localizations = AppLocalizations.of(locale);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(AppAssets.group),
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
                      prefixicon: Image.asset(AppAssets.emailIcon),
                      hintText: localizations.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                    SizedBox(height: height * 0.02),

                    Customtextfield(
                      hintstyle: AppStyle.med16white,
                      borderSideColor: Colors.grey,
                      controller: passwordController,
                      obscuretext: !isPasswordVisible,
                      textInputType: TextInputType.visiblePassword,
                      suffixicon: Image.asset(
                        isPasswordVisible ? AppAssets.iconEyePass : AppAssets.hiddenIcon,
                      ),
                      onSuffixIconTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      prefixicon: Image.asset(AppAssets.passIcon),
                      hintText: localizations.password,
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
                          Text(localizations.forgetPassword, style: AppStyle.med14primary),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    Customelevatedbuttom(
                      onPressed: isLoading ? () {} : loginUser,
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
                          : Text(localizations.login, style: AppStyle.med20black),
                    ),

                    // باقي الـ UI زي ما هو (Google, Register, OR, Toggle...)
                    // مش هغيّره عشان ما يتكسرش عندك
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(localizations.dontHaveAccount, style: AppStyle.med14white),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(localizations.createOne, style: AppStyle.med14primary),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 2, indent: width * 0.04, endIndent: width * 0.04, color: AppColors.primary)),
                        Text(localizations.or, style: AppStyle.med14primary),
                        Expanded(child: Divider(thickness: 2, indent: width * 0.04, endIndent: width * 0.04, color: AppColors.primary)),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Customelevatedbuttom(
                      elevatedcolor: isGoogleLoading
                          ? AppColors.primary.withOpacity(0.5)
                          : AppColors.primary,
                      onPressed: isGoogleLoading ? () {} : signInWithGoogle,
                      elevatedchild: isGoogleLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 3,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppAssets.googleIcon),
                                SizedBox(width: width * 0.02),
                                Text(localizations.loginWithGoogle, style: AppStyle.med16black),
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