import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_event_page.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class DetailEventPage extends StatelessWidget {
  const DetailEventPage({super.key, required this.eventId});

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _deleteEvent(BuildContext context) async {
    try {
      final eventDoc =
          FirebaseFirestore.instance.collection('event').doc(eventId);

      // Ambil data event untuk mendapatkan URL file gambar dan booklet
      final eventSnapshot = await eventDoc.get();
      if (eventSnapshot.exists) {
        final eventData = eventSnapshot.data();
        final imageUrl = eventData?['gambar'];
        final bookletUrl = eventData?['booklet'];

        // Hapus file gambar di Firebase Storage
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(imageUrl);
            await ref.delete();
          } catch (e) {
            debugPrint("Error deleting image: $e");
          }
        }

        // Hapus file booklet di Firebase Storage
        if (bookletUrl != null && bookletUrl.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(bookletUrl);
            await ref.delete();
          } catch (e) {
            debugPrint("Error deleting booklet: $e");
          }
        }

        // Hapus data event dari Firestore
        await eventDoc.delete();

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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil dihapus!"),
                  ),
                );
                _deleteEvent(context);
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
            final bookletUrl = eventData['bookletUrl'] ?? '';

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
                            await _launchURL(bookletUrl);
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
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(221, 95, 83, 205)),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Close Recruitment Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      eventData['closeRec'] != null
                          ? "Close Recruitment: ${DateFormat('dd MMM yyyy').format(
                              (eventData['closeRec'] as Timestamp).toDate(),
                            )}"
                          : "Close Recruitment: Tanggal tidak tersedia",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(221, 95, 83, 205)),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 20),

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
                                    eventId:
                                        eventId, // Kirim data jika diperlukan
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
            );
          }
        },
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
