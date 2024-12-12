import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'package:sirek/admin/edit_pendaftar_page.dart';

class DetailPendaftarPage extends StatelessWidget {
  final String pendaftarId;

  const DetailPendaftarPage({super.key, required this.pendaftarId});

  Future<Map<String, dynamic>> _fetchPendaftarDetails(String id) async {
    final pendaftarDoc = await FirebaseFirestore.instance.collection('pendaftar').doc(id).get();
    if (pendaftarDoc.exists) {
      return pendaftarDoc.data()!;
    } else {
      throw Exception("Pendaftar tidak ditemukan");
    }
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Path untuk iconsirek.png
              height: 40, // Tinggi ikon
            ),
          ),
        ],
        title: null, // Kosongkan judul di AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchPendaftarDetails(pendaftarId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Pendaftar tidak ditemukan"));
          } else {
            final pendaftarData = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan nama pendaftar
                  Container(
                    color: const Color(0xFF072554),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        pendaftarData['namaPendaftar'] ?? "Pendaftar",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Konten detail
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Nama", pendaftarData['namaPendaftar']),
                        _buildDetailRow("Email", pendaftarData['emailPendaftar']),
                        _buildDetailRow(
                          "Telepon",
                          pendaftarData['telepon'] != null ? pendaftarData['telepon'].toString() : "-",
                        ),
                        _buildDetailRow("Alamat", pendaftarData['alamat']),
                        _buildDetailRow("Tanggal Lahir", pendaftarData['tglLahir'] != null
                          ? DateFormat('dd MMM yyyy').format(
                              (pendaftarData['tglLahir'] as Timestamp).toDate(),
                            )
                          : "Tanggal tidak tersedia",),
                        _buildDetailRow("Jenis Kelamin", pendaftarData['jenisKelamin']),
                        _buildDetailRow("NIM", pendaftarData['nim']),
                        _buildDetailRow("Jurusan", pendaftarData['jurusan']),
                        _buildDetailRow("Fakultas", pendaftarData['fakultas']),
                        _buildDetailRow("Angkatan", pendaftarData['angkatan']),
                        _buildDetailRow("Pilihan 1", pendaftarData['pilihanSatu']),
                        _buildDetailRow("Pilihan 2", pendaftarData['pilihanDua']),
                        _buildDetailRow("Alasan", pendaftarData['alasan']),
                        const Divider(height: 32, thickness: 1),

                        // Bagian file upload
                        _buildFileUploadSection("File CV", "CV-Ackerman.pdf"),
                        const SizedBox(height: 16),
                        _buildFileUploadSection("File LoC", "LoC-Ackerman.pdf"),
                        const Divider(height: 32, thickness: 1),

                        // Tombol Edit dan Hapus
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPendaftarPage(
                                        pendaftarId: pendaftarData['id'],
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }

  // Fungsi untuk membuat baris detail
  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value?.toString() ?? "-", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Fungsi untuk membuat bagian file upload
  Widget _buildFileUploadSection(String title, String fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text(fileName, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  // Fungsi konfirmasi hapus
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
                Navigator.pop(context);
              },
              child: const Text("TIDAK", style: TextStyle(color: Color(0xFF072554))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data berhasil dihapus!")),
                );
                Navigator.pop(context);
              },
              child: const Text("YA", style: TextStyle(color: Color(0xFF072554))),
            ),
          ],
        );
      },
    );
  }
}
