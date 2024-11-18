import 'package:flutter/material.dart';
import 'package:sirek/landing.dart';
import 'package:sirek/ui/login_page.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/admin/event_page.dart';
import 'package:sirek/admin/pendaftar_page.dart';
import 'package:sirek/admin/pengumuman_page.dart';
import 'package:sirek/mhs/beranda.dart';
import 'package:sirek/admin/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sirek BEM Unsoed",
      theme: ThemeData(
        primaryColor: const Color(0xFF072554),
        fontFamily: 'Poppins', // Atur font default menjadi Poppins
      ),
      initialRoute: '/', // Halaman awal aplikasi
      routes: {
        // Halaman umum
        '/': (context) => const Landing(title: 'Sirek Mobile'),
        '/login': (context) => const Loginpage(),

        // Halaman admin
        '/dashboard': (context) => const Dashboard(),
        '/event': (context) => const EventPage(),
        '/pendaftar': (context) => const PendaftarPage(),
        '/pengumuman': (context) => const PengumumanPage(),
        '/profile': (context) => const ProfilePage(),

        // Halaman mahasiswa
        '/beranda': (context) => const BerandaPage(),
      },
    );
  }
}
