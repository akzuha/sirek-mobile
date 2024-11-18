import 'package:flutter/material.dart';
import 'edit_event_page.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class DetailEventPage extends StatelessWidget {
  final String eventName;

  const DetailEventPage({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: null, // Kosongkan judul di AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul di tengah
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  eventName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gambar Event
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'images/event_image.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Download Booklet
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logika untuk download booklet
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  "Download Booklet",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF0F52BA), // Warna biru download
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi Event
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Acara tahunan yang diselenggarakan oleh BEM Unsoed dalam rangka penyambutan mahasiswa baru 2024...",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Recruitment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Open Recruitment: 10 Juni 2024",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005792),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Close Recruitment: 12 Juni 2024",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005792),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Edit dan Hapus
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman EditEventPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEventPage(
                              eventName:
                                  eventName, // Kirim data jika diperlukan
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFECC600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD83434),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Konfirmasi Hapus",
            style: TextStyle(
              color: Color(0xFF072554),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Apakah data ini yakin ingin dihapus?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman detail
              },
              child: const Text(
                "TIDAK",
                style: TextStyle(color: Color(0xFF072554)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Logika penghapusan data
                Navigator.pop(context); // Tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil dihapus!"),
                  ),
                );
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text(
                "YA",
                style: TextStyle(color: Color(0xFF072554)),
              ),
            ),
          ],
        );
      },
    );
  }
}
