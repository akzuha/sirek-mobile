import 'package:flutter/material.dart';
import 'package:sirek/auth_page.dart';
import 'package:sirek/ui/beranda.dart';

class Landing extends StatelessWidget {
  final String title;
  const Landing({super.key, required this.title});

  void _showDialog(BuildContext context, String pesan, Widget alamat) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pesan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.blueAccent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red, // Ikon warning berwarna merah
                size: 40,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Tombol kembali berwarna putih
                side: const BorderSide(color: Colors.grey), // Border abu-abu
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Tombol lanjut berwarna oranye
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              ),
              child: const Text(
                'Lanjut',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
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
        title: Image.asset(
          "images/iconsirek.png",
          height: MediaQuery.of(context).size.height * 0.06,
          fit: BoxFit.contain,
        ),
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
                      height: MediaQuery.of(context).size.height * 0.5,
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
                      fontSize: 14,
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
                      fontSize: 12,
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BerandaPage(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 14,
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
                      fontSize: 12,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  child: const Text(
                    'Masuk',
                    style: TextStyle(color: Color(0xFFF6A220)),
                  ),
                  onTap: () {
                    _showDialog(
                      context,
                      'Login hanya untuk pimpinan dan admin',
                      const AuthPage(),
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
