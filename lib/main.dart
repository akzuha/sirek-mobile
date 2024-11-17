import 'package:flutter/material.dart';
import 'package:sirek/landing.dart';
import 'package:sirek/ui/login_page.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/mhs/beranda.dart';

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
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing(title: 'Sirek Mobile'),
        '/login': (context) => const Loginpage(),
        '/dashboard': (context) => const Dashboard(),
        '/beranda': (context) => const BerandaPage(),
      },
    );
  }
}
