import 'package:flutter/material.dart';
import 'package:sirek/widgets/mhsbottom_nav.dart'; // Import mhsbottom_nav.dart
import 'event_page.dart'; // Import file EventPage

class DaftarEventPage extends StatelessWidget {
  final String title;

  const DaftarEventPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Ikon di sebelah kanan
              height: 40, // Ukuran ikon
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header biru dengan judul
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Text(
                "Daftar Event: $title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Nama
            const TextField(
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Email
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Telepon
            const TextField(
              decoration: InputDecoration(
                labelText: "Telepon",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Alamat
            const TextField(
              decoration: InputDecoration(
                labelText: "Alamat",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Input Field Tanggal
            const TextField(
              decoration: InputDecoration(
                labelText: "Tanggal",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown Jenis Kelamin
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Jenis Kelamin",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Laki-Laki",
                  child: Text("Laki-Laki"),
                ),
                DropdownMenuItem(
                  value: "Perempuan",
                  child: Text("Perempuan"),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Input Field NIM
            const TextField(
              decoration: InputDecoration(
                labelText: "NIM",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown Jurusan
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Jurusan",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Teknik Informatika",
                  child: Text("Teknik Informatika"),
                ),
                DropdownMenuItem(
                  value: "Sistem Informasi",
                  child: Text("Sistem Informasi"),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Dropdown Fakultas
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Fakultas",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "FT",
                  child: Text("Fakultas Teknik"),
                ),
                DropdownMenuItem(
                  value: "FMIPA",
                  child: Text("Fakultas MIPA"),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Input Field Alasan
            const TextField(
              decoration: InputDecoration(
                labelText: "Alasan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Daftar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Menampilkan dialog notifikasi berhasil mendaftar
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Tidak bisa ditutup dengan klik di luar dialog
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: const Text(
                          "Notification",
                          style: TextStyle(color: Colors.green),
                        ),
                        content: const Text(
                          "Selamat kamu berhasil mendaftar!\nSilahkan menunggu hingga hasil pengumuman dirilis.",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EventPage(),
                                  ),
                                  (route) => false, // Menghapus stack halaman sebelumnya
                                );
                              },
                              child: const Text("Selesai"),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A220),
                  padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1), // Tambahkan navbar di sini
    );
  }
}
