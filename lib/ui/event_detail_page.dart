import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sirek/ui/daftar_event_page.dart';
import 'package:sirek/widgets/mhsbottom_nav.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  Future<Map<String, dynamic>> _fetchEventDetails(String id) async {
    final eventDoc =
        await FirebaseFirestore.instance.collection('event').doc(id).get();
    if (eventDoc.exists) {
      return eventDoc.data()!;
    } else {
      throw Exception("Event not found");
    }
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savePath = "${appDocDir.path}/$fileName.pdf";

      Dio dio = Dio();
      await dio.download(url, savePath);

      OpenFile.open(savePath);
    } catch (e) {
      throw Exception("Failed to download file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            "images/iconsirek.png",
            height: MediaQuery.of(context).size.height * 0.06,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: const Color(0xFF072554),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchEventDetails(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Event not found"));
          } else {
            final eventData = snapshot.data!;
            final bookletUrl = eventData['booklet'] ?? '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    color: const Color(0xFF072554),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      eventData['namaEvent'] ?? "Event Name",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        eventData['gambar'] ?? '',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Download Booklet Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (bookletUrl.isNotEmpty) {
                          try {
                            await _downloadFile(bookletUrl, "booklet_event");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Booklet berhasil diunduh")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Gagal mengunduh booklet: $e")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Booklet tidak tersedia")),
                          );
                        }
                      },
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text("Download Booklet"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      eventData['deskripsi'] ?? "No description available",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recruitment Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      eventData['openRec'] != null
                          ? "Open Recruitment: ${DateFormat('dd MMM yyyy').format(
                              (eventData['openRec'] as Timestamp).toDate(),
                            )}"
                          : "Open Recruitment: Tanggal tidak tersedia",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Close Recruitment Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      eventData['closeRec'] != null
                          ? "Close Recruitment: ${DateFormat('dd MMM yyyy').format(
                              (eventData['closeRec'] as Timestamp).toDate(),
                            )}"
                          : "Close Recruitment: Tanggal tidak tersedia",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarEventPage(
                              eventId: eventId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6A220),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 90, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
