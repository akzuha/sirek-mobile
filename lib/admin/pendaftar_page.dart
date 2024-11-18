import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class PendaftarPage extends StatelessWidget {
  const PendaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        title: const Text("Pendaftar"),
      ),
      body: Center(
        child: const Text(
          "Ini adalah halaman Pendaftar",
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}
