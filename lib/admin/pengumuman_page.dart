import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sirek/controllers/pengumuman_controller.dart';
import 'package:sirek/models/pengumuman_model.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'add_pengumuman_page.dart';
import 'edit_pengumuman_page.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final PengumumanController _pengumumanController = PengumumanController();
  final TextEditingController _searchController = TextEditingController();
  List<PengumumanModel> _allPengumumans = [];
  List<PengumumanModel> _filteredPengumumans = [];

  @override
  void initState() {
    super.initState();
    _loadPengumuman();
    _searchController.addListener(_filterPengumuman);
  }

  Future<void> _loadPengumuman() async {
    try {
      final pengumumans = await _pengumumanController.getAllPengumuman();
      setState(() {
        _allPengumumans = pengumumans;
        _filteredPengumumans = pengumumans;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data pengumuman: $e")),
      );
    }
  }

  void _filterPengumuman() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPengumumans = _allPengumumans
          .where((pengumuman) =>
              pengumuman.namaEvent.toLowerCase().contains(query))
          .toList();
    });
  }

  Widget _headerContainer() {
    return Container(
      color: const Color(0xFF072554),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo di kanan atas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Image.asset(
                'images/iconsirek.png', // Logo di kanan
                height: 40,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Judul Pengumuman
          const Center(
            child: Text(
              "Pengumuman",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Apa yang ingin kamu cari...",
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              constraints: const BoxConstraints(maxHeight: 40),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tambahDataButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddPengumumanPage()),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Tambah Pengumuman",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38CC20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pengumumanCard(BuildContext context,
      {required String pengumumanName, required String uploadDate, required String pengumumanId}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nama Pengumuman dan Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pengumumanName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF072554),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  uploadDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Tombol Edit
          SizedBox(
            width: 80,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPengumumanPage(
                      pengumumanName: pengumumanName,
                      pengumumanId: pengumumanId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white, size: 16),
              label: const Text(
                "Edit",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFECC600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Tombol Hapus
          SizedBox(
            width: 80,
            child: ElevatedButton.icon(
              onPressed: () {
                _showDeleteConfirmation(context, pengumumanId);
              },
              icon: const Icon(Icons.delete, color: Colors.white, size: 16),
              label: const Text(
                "Hapus",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD83434),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deletePengumuman(BuildContext context, String pengumumanId) async {
    try {
      final pengumumanDoc =
          FirebaseFirestore.instance.collection('pengumuman').doc(pengumumanId);

      // Ambil data event untuk mendapatkan URL file gambar dan booklet
      final pengumumanSnapshot = await pengumumanDoc.get();
      if (pengumumanSnapshot.exists) {
        final pengumumanData = pengumumanSnapshot.data();
        final pengumumanFile = pengumumanData?['filePengumuman'];

        // Hapus file gambar di Firebase Storage
        if (pengumumanFile != null && pengumumanFile.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(pengumumanFile);
            await ref.delete();
          } catch (e) {
            debugPrint("Error menghapus pengumuman: $e");
          }
        }

        await pengumumanDoc.delete();

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengumuman berhasil dihapus!")),
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

  void _showDeleteConfirmation(BuildContext context, String pengumumanId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Konfirmasi Hapus",
            style: TextStyle(
              color: Color(0xFF072554),
              fontWeight: FontWeight.bold,
            ),
          ),
          content:
              const Text("Apakah kamu yakin ingin menghapus pengumuman ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Tidak",
                style: TextStyle(color: Color(0xFF072554)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pengumuman berhasil dihapus!"),
                  ),
                );
                _deletePengumuman(context, pengumumanId);
              },
              child: const Text(
                "Ya",
                style: TextStyle(color: Color(0xFF072554)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _headerContainer(),
          _tambahDataButton(),
          Expanded(
            child: _filteredPengumumans.isEmpty
                ? const Center(
                    child: Text("Tidak ada pengumuman yang ditemukan."),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: _filteredPengumumans.length,
                    itemBuilder: (context, index) {
                      final pengumuman = _filteredPengumumans[index];
                      final tanggalPengumuman =
                          DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(pengumuman.tanggalPengumuman);

                      return _pengumumanCard(
                        context,
                        pengumumanName: pengumuman.namaEvent,
                        uploadDate: tanggalPengumuman,
                        pengumumanId: pengumuman.id,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 3),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
