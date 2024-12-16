import 'package:flutter/material.dart';
import 'package:sirek/controllers/pengumuman_controller.dart';
import 'package:sirek/models/pengumuman_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../widgets/mhsbottom_nav.dart';

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka $url';
    }
  }

  Widget _headerContainer(){
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

  // Widget untuk kartu pengumuman
  Widget _pengumumanCard( BuildContext context, {
    required String title,
    required String description,
    required String pdfUrl,
    required String sizePdf,
    }) {
    return FutureBuilder<String>(
      future: getFileSize(pdfUrl),
      builder: (context, snapshot) {
        final fileSize = snapshot.data ?? "Mengambil ukuran...";
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
                    Text(
                      "Ukuran file: $fileSize",
                      style: const TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    // Tombol Unduh Pengumuman
                    ElevatedButton(
                      onPressed: () {
                        _showDownloadDialog(context, pdfUrl, fileSize, title);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6A220), // Warna tombol
                        minimumSize:
                            const Size(100, 30), // Ukuran tombol diperkecil
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      },
    );
  }

  Future<String> getFileSize(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    if (response.headers.containsKey('content-length')) {
      final bytes = int.parse(response.headers['content-length']!);
      if (bytes < 1024) {
        return "$bytes B";
      } else if (bytes < 1048576) {
        return "${(bytes / 1024).toStringAsFixed(2)} KB";
      } else {
        return "${(bytes / 1048576).toStringAsFixed(2)} MB";
      }
    } else {
      return "Ukuran tidak diketahui";
    }
  } catch (e) {
    return "Gagal mendapatkan ukuran file";
  }
}

  // Fungsi untuk menampilkan dialog unduhan
  void _showDownloadDialog(BuildContext context, String pdfUrl, String sizePdf, String title) {
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
              Text(
                title,
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
                onPressed: () async {
                  // Buka link unduhan
                  if (pdfUrl.isNotEmpty) {
                    try {
                      await _launchURL(pdfUrl);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Gagal membuka booklet: $e")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Booklet tidak tersedia")),
                    );
                  }
                  Navigator.of(context).pop();
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
                        sizePdf: pengumuman.filePengumuman,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 2),
    );
  }
}