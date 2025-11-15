import 'package:flutter/material.dart';
import 'package:movies1/Utls/routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.updateProfile);
        },
        child: const Text('Update Profile'),
      ),
    );
  }
}
