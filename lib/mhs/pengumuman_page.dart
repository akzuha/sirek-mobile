import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka link file PDF

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
            // Container biru dengan judul
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
                  pdfUrl: "https://example.com/file_pengumuman_$index.pdf", // URL PDF untuk unduhan
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
    required String pdfUrl,
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
                    // Tampilkan pop-up unduh
                    _showDownloadDialog(context, pdfUrl);
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

  // Fungsi untuk menampilkan dialog unduhan
  void _showDownloadDialog(BuildContext context, String pdfUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Dialog dapat ditutup dengan klik di luar
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Download File Info",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF072554),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black54,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 50,
                color: Color(0xFF072554),
              ),
              const SizedBox(height: 8),
              const Text(
                "PDF - 754.73 KB",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF072554),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Buka link unduhan
                  if (await canLaunch(pdfUrl)) {
                    await launch(pdfUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gagal membuka link unduhan."),
                      ),
                    );
                  }
                  Navigator.of(context).pop(); // Tutup dialog setelah unduh
                },
                child: const Text(
                  "Download File",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
