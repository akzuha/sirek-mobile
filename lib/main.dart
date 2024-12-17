import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sirek/landing.dart';
import 'package:sirek/ui/login_page.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/admin/event_page.dart';
import 'package:sirek/admin/pendaftar_page.dart';
import 'package:sirek/admin/pengumuman_page.dart';
import 'package:sirek/ui/beranda.dart';
import 'package:sirek/admin/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null);
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
        fontFamily: 'Poppins',
      ),
      initialRoute: '/', // Halaman awal aplikasi
      routes: {
        // Halaman umum
        '/': (context) => const Landing(title: 'Sirek Mobile'),
        '/login': (context) => const Loginpage(),

        // Halaman admin
        '/dashboard': (context) => Dashboard(),
        '/event': (context) => const EventPage(),
        '/pendaftar': (context) => const PendaftarPage(),
        '/pengumuman': (context) => const PengumumanPage(),
        '/profile': (context) => ProfilePage(),

        // Halaman mahasiswa
        '/beranda': (context) => const BerandaPage(),
      },
    );
  }
}
