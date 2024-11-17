import 'package:flutter/material.dart';
import 'daftar_event_page.dart'; // Pastikan file ini ada dan diimport

class EventDetailPage extends StatelessWidget {
  final String title;
  final String description;

  // Konstruktor untuk menerima parameter
  const EventDetailPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Tanda panah warna putih
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Ikon di sebelah kanan
              height: 40, // Ukuran ikon diperkecil
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header biru dengan judul
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),

            // Gambar utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "images/event_image.png", // Pastikan file gambar ini ada
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol download booklet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Download Booklet ditekan")),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text("Download Booklet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF072554),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi event
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),

            // Informasi tanggal open dan close recruitment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Open Recruitment : 10 Juni 2024",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Close Recruitment : 12 Juni 2024",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol daftar
Center(
  child: ElevatedButton(
    onPressed: () {
      // Navigasi ke halaman daftar_event dengan parameter title
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DaftarEventPage(title: title), // Melewatkan parameter title
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF6A220),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    child: const Text(
      "Daftar Sekarang",
      style: TextStyle(color: Colors.white),
    ),
  ),
),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
