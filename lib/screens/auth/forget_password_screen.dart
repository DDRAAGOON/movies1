import 'package:flutter/material.dart';
import 'package:movies1/core/app_colors.dart';

class ForgetPasswordApp extends StatelessWidget {
  const ForgetPasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ForgetPasswordPage(),
    );
  }
}

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.yellow),
          onPressed: () {},
        ),
        title: const Text(
          "Forget Password",
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
              'lib/assets/forget/Forgot.png',
              height: 430,
              width: 430,
            ),
            const SizedBox(height: 40),

            TextField(
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: AppColors.white),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: AppColors.gray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Verify Email",
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