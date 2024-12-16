import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'package:sirek/admin/edit_pendaftar_page.dart';

class DetailPendaftarPage extends StatelessWidget {
  const DetailPendaftarPage({super.key, required this.pendaftarId});

  final String pendaftarId;

  Future<Map<String, dynamic>> _fetchPendaftarDetails(String id) async {
    final pendaftarDoc =
        await FirebaseFirestore.instance.collection('pendaftar').doc(id).get();
    if (pendaftarDoc.exists) {
      return pendaftarDoc.data()!;
    } else {
      throw Exception("Pendaftar tidak ditemukan");
    }
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

  void _deletePendaftar(BuildContext context) async {
    try {
      final pendaftarDoc =
          FirebaseFirestore.instance.collection('pendaftar').doc(pendaftarId);

      // Ambil data event untuk mendapatkan URL file gambar dan booklet
      final pendaftarSnapshot = await pendaftarDoc.get();
      if (pendaftarSnapshot.exists) {
        final pendaftarData = pendaftarSnapshot.data();
        final CVfile = pendaftarData?['fileCV'];
        final LOCfile = pendaftarData?['fileLOC'];

        // Hapus file gambar di Firebase Storage
        if (CVfile != null && CVfile.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(CVfile);
            await ref.delete();
          } catch (e) {
            debugPrint("Error hapus file CV: $e");
          }
        }

        // Hapus file booklet di Firebase Storage
        if (LOCfile != null && LOCfile.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(LOCfile);
            await ref.delete();
          } catch (e) {
            debugPrint("Error hapus file LOC: $e");
          }
        }

        // Hapus data event dari Firestore
        await pendaftarDoc.delete();

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event berhasil dihapus!")),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event tidak ditemukan.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saat menghapus: $e")),
      );
    }
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
              child: const Text("TIDAK",
                  style: TextStyle(color: Color(0xFF072554))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data berhasil dihapus!")),
                );
                _deletePendaftar(context);
                Navigator.pop(context);
              },
              child:
                  const Text("YA", style: TextStyle(color: Color(0xFF072554))),
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
                        _buildDetailRow(
                            "Email", pendaftarData['emailPendaftar']),
                        _buildDetailRow(
                          "Telepon",
                          pendaftarData['telepon'] != null
                              ? pendaftarData['telepon'].toString()
                              : "-",
                        ),
                        _buildDetailRow("Alamat", pendaftarData['alamat']),
                        _buildDetailRow(
                          "Tanggal Lahir",
                          pendaftarData['tglLahir'] != null
                              ? DateFormat('dd MMM yyyy').format(
                                  (pendaftarData['tglLahir'] as Timestamp)
                                      .toDate(),
                                )
                              : "Tanggal tidak tersedia",
                        ),
                        _buildDetailRow(
                            "Jenis Kelamin", pendaftarData['jenisKelamin']),
                        _buildDetailRow("NIM", pendaftarData['nim']),
                        _buildDetailRow("Jurusan", pendaftarData['jurusan']),
                        _buildDetailRow("Fakultas", pendaftarData['fakultas']),
                        _buildDetailRow("Angkatan", pendaftarData['angkatan']),
                        _buildDetailRow(
                            "Pilihan 1", pendaftarData['pilihanSatu']),
                        _buildDetailRow(
                            "Pilihan 2", pendaftarData['pilihanDua']),
                        _buildDetailRow("Alasan", pendaftarData['alasan']),
                        const Divider(height: 32, thickness: 1),

                        // Bagian file upload
                        _buildDetailRow("File CV", FirebaseStorage.instance.refFromURL(pendaftarData['fileCV']).name),
                        const SizedBox(height: 16),
                        _buildDetailRow("File LoC",  FirebaseStorage.instance.refFromURL(pendaftarData['fileLOC']).name),
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
                                        pendaftarId: pendaftarId,
                                      ),
                                    ),
                                  );
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
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
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
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
}
