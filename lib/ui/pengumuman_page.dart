import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/mhsbottom_nav.dart';
import '../controllers/pengumuman_controller.dart';
import '../models/pengumuman_model.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final PengumumanController _pengumumanController = PengumumanController();

  Future<List<PengumumanModel>> _loadPengumuman() async {
    try {
      return await _pengumumanController.getAllPengumuman();
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
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                width: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              );
            },
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
                    _showDownloadDialog(context, pdfUrl, title);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220),
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Unduh Pengumuman",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  void _showDownloadDialog(BuildContext context, String pdfUrl, String fileName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Unduh Pengumuman",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, color: Color(0xFF072554),
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
              Text(
                fileName,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkAndDownload(pdfUrl, fileName);
                },
                child: const Text(
                  "Unduh Pengumuman",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _checkAndDownload(String url, String fileName) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      _downloadFile(url, fileName);
    } else if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        _downloadFile(url, fileName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin penyimpanan ditolak")),
        );
      }
    }
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";

      Dio dio = Dio();
      await dio.download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File berhasil diunduh: $savePath")),
      );
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
            return Column(
              children: [
                _headerContainer(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Tidak Ada data Pengumuman"),
                ),
              ],
            );
          } else {
            final pengumumans = snapshot.data!;
            return Column(
              children: [
                _headerContainer(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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