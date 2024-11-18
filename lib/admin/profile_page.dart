import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        title: const Text("Profile"),
      ),
      body: Center(
        child: const Text(
          "Ini adalah halaman Profile",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
