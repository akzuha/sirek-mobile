import 'package:flutter/material.dart';
import '../widgets/mhsbottom_nav.dart';

class PengumumanPage extends StatelessWidget {
  const PengumumanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Ikon di sebelah kanan
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container biru dengan judul BEM UNSOED 2024
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  "Pengumuman Event",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // List Pengumuman
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Agar tidak konflik dengan scroll utama
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 5, // Jumlah pengumuman
              itemBuilder: (context, index) {
                return _pengumumanCard(
                  context,
                  title: "Soedirman Student Summit (S3)",
                  description:
                      "Silahkan unduh file pengumuman melalui tombol di bawah ini.",
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2), // Navbar di bawah
    );
  }

  // Widget untuk kartu pengumuman
  Widget _pengumumanCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow ke bawah
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Pengumuman
          Image.asset(
            "images/s3.png", // Pastikan file ini ada di folder assets/images
            height: 100, // Ukuran gambar
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),

          // Detail Pengumuman dan Tombol Unduh
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF072554),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Tombol Unduh Pengumuman
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Unduh Pengumuman ditekan")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220), // Warna tombol
                    minimumSize: const Size(100, 30), // Ukuran tombol diperkecil
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Unduh Pengumuman",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Ukuran font tombol diperkecil
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
