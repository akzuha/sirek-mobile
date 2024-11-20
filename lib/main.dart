import 'package:flutter/material.dart';
import 'package:sirek/landing.dart';
import 'package:sirek/ui/login_page.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/admin/event_page.dart';
import 'package:sirek/admin/pendaftar_page.dart';
import 'package:sirek/admin/pengumuman_page.dart';
import 'package:sirek/mhs/beranda.dart';
import 'package:sirek/admin/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // supabase setup
  await Supabase.initialize(
    anonKey: 
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0ZnJobHJqbHZra2lldHd1emxuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIwMTY2MjQsImV4cCI6MjA0NzU5MjYyNH0.9TDflktuIjm8NdPpf9ctXCEYiiGAgtpum242rcXglNw",
    url:"https://vtfrhlrjlvkkietwuzln.supabase.co",
  );
  
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
