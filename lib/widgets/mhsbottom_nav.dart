import 'package:flutter/material.dart';
import 'package:sirek/mhs/beranda.dart';
import 'package:sirek/mhs/event_page.dart';
import 'package:sirek/mhs/pengumuman_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Indeks halaman aktif

  const CustomBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BerandaPage()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const EventPage()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PengumumanPage()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Indeks halaman saat ini
      onTap: (index) => _onTap(context, index), // Navigasi ke halaman yang dipilih
      selectedItemColor: const Color(0xFF072554),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "Event",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement),
          label: "Pengumuman",
        ),
      ],
    );
  }
}
