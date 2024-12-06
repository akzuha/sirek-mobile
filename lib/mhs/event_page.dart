import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sirek/controller/event_database.dart';
import 'package:sirek/mhs/event_detail_page.dart';
import 'package:sirek/widgets/mhsbottom_nav.dart';

class EventPage extends StatefulWidget {
  const EventPage({ super.key });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  //panggil db
  final eventDatabase = EventDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/iconsirek.png",
          height: MediaQuery.of(context).size.height * 0.06,
          fit: BoxFit.contain,
        ),
        backgroundColor: const Color(0xFF072554),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Atur posisi konten di kiri
        children: [
          // Widget di atas StreamBuilder
          Container(
            color: const Color(0xFF072554),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              child: Text(
                "Event Bahtera Karsa 2024",
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // StreamBuilder
          Expanded(
            child: StreamBuilder(
              // Listen to the stream
              stream: eventDatabase.stream,

              // Build UI
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Data sudah dimuat
                final event = snapshot.data!;

                return ListView.builder(
                  itemCount: event.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    // Data dari setiap event
                    final events = event[index];

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
                            offset: const Offset(0, 3), // Shadow ke bawah
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Event
                          Image.network(
                            events.gambar,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),

                          // Detail Event
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events.namaEvent,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF072554),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  events.deskripsi,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Tombol Selengkapnya
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailPage(
                                          title: events.namaEvent,
                                          description: events.deskripsi,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF6A220),
                                    minimumSize: const Size(80, 30),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Selengkapnya",
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
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}

/*

import 'package:flutter/material.dart';
import '../widgets/mhsbottom_nav.dart';
import 'event_detail_page.dart'; // Import halaman detail event

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Ikon di sebelah kanan
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container biru dengan judul BEM UNSOED 2024
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  "Event Bahtera Karsa 2024",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // List Event
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Agar tidak konflik dengan scroll utama
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 5, // Jumlah event
              itemBuilder: (context, index) {
                return _eventCard(
                  context,
                  title: "Soedirman Student Summit $index",
                  description: "Deskripsi event ke-$index: Acara tahunan BEM Unsoed dalam rangka penyambutan mahasiswa baru 2023.",
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1), // Navbar di bawah
    );
  }

  // Widget untuk kartu event
  Widget _eventCard(BuildContext context, {required String title, required String description}) {
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
            offset: const Offset(0, 3), // Shadow ke bawah
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Event
          Image.asset(
            "images/s3.png", // Pastikan file ini ada di folder assets/images
            height: 100, // Ukuran gambar diperbesar
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),

          // Detail Event
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
                    fontSize: 10, // Ukuran font deskripsi diperkecil
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Tombol Selengkapnya (Navigasi ke halaman detail event)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          title: title,
                          description: description,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220), // Warna tombol
                    minimumSize: const Size(80, 30), // Ukuran tombol diperkecil
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Ukuran font tombol diperkecil
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
}

 */
