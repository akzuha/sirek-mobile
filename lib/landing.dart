import 'package:flutter/material.dart';
import 'package:sirek/mhs/beranda.dart'; // Tambahkan import untuk halaman beranda
import 'package:sirek/ui/login_page.dart';

class Landing extends StatelessWidget {
  const Landing({super.key, required String title});

  void _showDialog(BuildContext context, String pesan, Widget alamat) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(pesan),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                // Close the dialog
                Navigator.pop(dialogContext);

                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => alamat,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(height: MediaQuery.of(context).size.height * 0.08, fit: BoxFit.contain, "images/iconsirek.png"),
        backgroundColor: const Color(0xFF072554),
      ),
      backgroundColor: const Color(0xFF072554),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "images/landingsirek.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Daftar Kepanitiaan Sesuai Minat Kamu!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Aplikasi resmi BEM Unsoed 2024 Kabinet Bahtera Karsa. Bahtera Karsa hadir sebagai ruang realisasi cita untuk transformasi Unsoed dan Indonesia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6A220),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // Navigasi ke halaman beranda
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BerandaPage(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Apakah kamu Admin/Pimpinan?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  child: const Text(
                    style: TextStyle(color: Color(0xFFF6A220),),'Masuk'),
                  onTap: () {
                    _showDialog(
                      context,
                      'Silahkan Login',
                      const Loginpage(),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
