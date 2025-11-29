import 'package:flutter/material.dart';
import 'package:movies1/core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../home/reset/reset_password.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedAvatar = AppAssets.icon;

  final List<String> avatars = [
    AppAssets.icon,
    AppAssets.icon2,
    AppAssets.icon3,
    AppAssets.icon4,
    AppAssets.icon5,
    AppAssets.icon6,
    AppAssets.icon7,
    AppAssets.icon8,
    AppAssets.icon9,
  ];

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final isSelected = avatar == selectedAvatar;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = avatar;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.amber : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(avatar, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset(selectedAvatar, height: 120)),
              const SizedBox(height: 40),

              TextField(
                style: const TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: AppColors.white),
                  hintText: "John Safwat",
                  hintStyle: const TextStyle(color: AppColors.white,
                  fontSize: 20),
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone, color: AppColors.white),
                  hintText: "01200000000",
                  hintStyle: const TextStyle(color: AppColors.white,
                  fontSize: 20),
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPassword(),
                      ),
                    );
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(color: AppColors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showAvatarPicker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Update Data",
                  style: TextStyle(color: AppColors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
