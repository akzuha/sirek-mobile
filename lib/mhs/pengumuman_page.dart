import 'package:flutter/material.dart';
import '../widgets/mhsbottom_nav.dart';

class PengumumanPage extends StatelessWidget {
  const PengumumanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman Mahasiswa"),
        backgroundColor: const Color(0xFF072554),
      ),
      body: const Center(
        child: Text(
          "Pengumuman untuk Mahasiswa",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2), // Navbar di bawah
    );
  }
}
