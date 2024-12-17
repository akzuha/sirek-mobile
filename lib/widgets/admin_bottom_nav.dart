import 'package:flutter/material.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/admin/event_page.dart';
import 'package:sirek/admin/pendaftar_page.dart';
import 'package:sirek/admin/pengumuman_page.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex; // Indeks halaman aktif

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return; // Jika halaman sudah aktif, tidak perlu navigasi ulang
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EventPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PendaftarPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PengumumanPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      selectedItemColor: const Color(0xFF072554),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "Event",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Pendaftar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Pengumuman",
        ),
      ],
    );
  }
}
