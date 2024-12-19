import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:sirek/widgets/mhsbottom_nav.dart';

class PengumumanModel {
  final String id; 
  final String namaEvent;
  final String keterangan;
  final String filePengumuman;

  PengumumanModel({
    required this.id,
    required this.namaEvent,
    required this.keterangan,
    required this.filePengumuman,
  });
}

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  Future<List<PengumumanModel>> _loadPengumuman() async {
    try {
      final response = await FirebaseFirestore.instance.collection('pengumuman').get();
      return response.docs.map((doc) {
        final data = doc.data();
        return PengumumanModel(
          id: doc.id,
          namaEvent: data['namaEvent'],
          keterangan: data['keterangan'],
          filePengumuman: data['filePengumuman'],
        );
      }).toList();
    } catch (e) {
      throw Exception("Gagal memuat data pengumuman: $e");
    }
  }

  Widget _headerContainer() {
    return Container(
      color: const Color(0xFF072554),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Text(
          "Pengumuman",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _pengumumanCard(BuildContext context,
      {required String title, required String description, required String pdfUrl}) {
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "images/logo_bem_unsoed.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
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
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _showDownloadDialog(context, pdfUrl, title);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220),
                    minimumSize: const Size(100, 30),
                  ),
                  child: const Text(
                    "Unduh Pengumuman",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadDialog(BuildContext context, String pdfUrl, String fileName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Unduh Pengumuman"),
          content: const Icon(Icons.picture_as_pdf, size: 50),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _downloadFile(pdfUrl, fileName);
              },
              child: const Text("Unduh"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(url);
      final String downloadUrl = await storageRef.getDownloadURL();

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savePath = "${appDocDir.path}/$fileName.pdf";

      Dio dio = Dio();
      await dio.download(downloadUrl, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File berhasil diunduh di: $savePath")),
      );

      OpenFile.open(savePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/iconsirek.png",
          height: appBarHeight,
          fit: BoxFit.contain,
        ),
        backgroundColor: const Color(0xFF072554),
      ),
      body: FutureBuilder<List<PengumumanModel>>(
        future: _loadPengumuman(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada pengumuman"));
          } else {
            final pengumumans = snapshot.data!;
            return Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headerContainer(),
                const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: pengumumans.length,
                itemBuilder: (context, index) {
                  final pengumuman = pengumumans[index];
                  return _pengumumanCard(
                    context,
                    title: pengumuman.namaEvent,
                    description: pengumuman.keterangan,
                    pdfUrl: pengumuman.filePengumuman,
                  );
                },
              ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
