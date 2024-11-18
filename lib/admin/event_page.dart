import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        title: const Text("Event"),
      ),
      body: Center(
        child: const Text(
          "Ini adalah halaman Event",
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
