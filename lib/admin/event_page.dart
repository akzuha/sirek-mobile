import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'add_event_page.dart'; // Import halaman Tambah Event
import 'detail_event_page.dart'; // Import halaman Detail Event

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header dengan logo, judul, dan background biru
          Container(
            color: const Color(0xFF072554),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Image.asset(
                      'images/iconsirek.png', // Logo di kiri
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Judul Event
                const Center(
                  child: Text(
                    "Event",
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
                  decoration: InputDecoration(
                    hintText: "Apa yang ingin kamu cari...",
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Tambah Event
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman Tambah Event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEventPage()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah Event",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38CC20), // Warna hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ListView Event
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4, // Jumlah event
              itemBuilder: (context, index) {
                return _eventCard(
                  context,
                  eventName: "Soedirman Student Summit (S3)",
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }

  // Widget untuk Event Card
  Widget _eventCard(BuildContext context, {required String eventName}) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama Event
          Expanded(
            child: Text(
              eventName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF072554),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Tombol Detail
          ElevatedButton.icon(
            onPressed: () {
              // Navigasi ke halaman Detail Event
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailEventPage(eventName: eventName),
                ),
              );
            },
            icon: const Icon(
              Icons.description,
              size: 16,
              color: Colors.white, // Ikon berwarna putih
            ),
            label: const Text(
              "Detail",
              style: TextStyle(
                color: Colors.white, // Teks berwarna putih
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADCB), // Warna biru
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
