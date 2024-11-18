import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'package:sirek/admin/pendaftar_page.dart';
import 'package:sirek/admin/edit_pendaftar_page.dart';

class DetailPendaftarPage extends StatelessWidget {
  final String pendaftarName;

  const DetailPendaftarPage({super.key, required this.pendaftarName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PendaftarPage(),
              ),
            );
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
                  pendaftarName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bagian konten dengan padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Nama", pendaftarName),
                  _buildDetailRow("Email", "levi@gmail.com"),
                  _buildDetailRow("Telepon", "081234567890"),
                  _buildDetailRow("Alamat", "Kebumen"),
                  _buildDetailRow("Tanggal Lahir", "10/10/2003"),
                  _buildDetailRow("Jenis Kelamin", "Laki-Laki"),
                  _buildDetailRow("NIM", "K1J02104"),
                  _buildDetailRow("Jurusan", "Kimia"),
                  _buildDetailRow("Fakultas",
                      "Fakultas Matematika dan Ilmu Pengetahuan Alam"),
                  _buildDetailRow("Angkatan", "2021"),
                  _buildDetailRow("Pilihan 1", "Bendahara"),
                  _buildDetailRow(
                      "Alasan 1", "Karena saya memiliki passion di situ"),
                  _buildDetailRow("Pilihan 2", "Sekretaris"),
                  _buildDetailRow("Alasan 2", "Ingin menambah pengalaman"),
                  const SizedBox(height: 16),

                  // Bagian upload file
                  const Text(
                    "File CV",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Logika upload file
                        },
                        icon: const Icon(Icons.upload, color: Colors.white),
                        label: const Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF072554),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text("CV-Ackerman.pdf"), // Nama file dummy
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "File LoC",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Logika upload file
                        },
                        icon: const Icon(Icons.upload, color: Colors.white),
                        label: const Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF072554),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text("LoC-Ackerman.pdf"), // Nama file dummy
                    ],
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPendaftarPage(
                                    pendaftarName: pendaftarName,
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
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
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

  // Fungsi untuk membuat baris detail
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Teks disusun ke bawah
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4), // Jarak antar teks
          Text(value),
        ],
      ),
    );
  }
}
