import 'package:flutter/material.dart';
import '../widgets/mhsbottom_nav.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Mahasiswa"),
        backgroundColor: const Color(0xFF072554),
      ),
      body: const Center(
        child: Text(
          "Daftar Event untuk Mahasiswa",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1), // Navbar di bawah
    );
  }
}
