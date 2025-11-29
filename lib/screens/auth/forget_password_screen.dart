import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies1/core/app_colors.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      
      // إرسال رابط إعادة تعيين كلمة المرور
      await auth.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );

      // Return to login screen after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'حدث خطأ، حاول مرة أخرى';

      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'البريد الإلكتروني غير موجود';
          break;
        case 'invalid-email':
          errorMsg = 'الإيميل غير صحيح';
          break;
        case 'too-many-requests':
          errorMsg = 'محاولات كثيرة، حاول مرة أخرى لاحقاً';
          break;
        default:
          errorMsg = e.message ?? 'حدث خطأ أثناء إرسال البريد';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = 'حدث خطأ غير متوقع';
        if (e.toString().contains('API key')) {
          errorMsg = 'مشكلة في إعدادات Firebase. يرجى التحقق من API key';
        } else if (e.toString().contains('network')) {
          errorMsg = 'مشكلة في الاتصال بالإنترنت';
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
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.yellow),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Forget Password',
          style: TextStyle(color: AppColors.yellow, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/forget/Forgot.png',
              height: 430,
              width: 430,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: AppColors.white),
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: AppColors.gray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : _sendResetEmail,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Verify Email',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
