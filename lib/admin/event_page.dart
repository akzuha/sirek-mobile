import 'package:flutter/material.dart';
import 'package:sirek/controllers/event_controller.dart';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'add_event_page.dart';
import 'detail_event_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventController _eventController = EventController();

  Future<List<EventModel>> _loadEvents() {
    return _eventController.getAllEvents();
  }

  // Widget untuk Container bagian atas
  Widget _headerContainer() {
    return Container(
      color: const Color(0xFF072554),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo di sebelah kanan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // Spacer untuk memindahkan logo ke kanan
              Image.asset(
                'images/iconsirek.png', // Logo di kanan
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
              hintStyle: const TextStyle(
                fontSize: 14, // Ukuran teks placeholder lebih kecil
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8, // Tinggi padding sangat kecil
                horizontal: 12,
              ),
              constraints: const BoxConstraints(
                maxHeight: 40, // Atur tinggi maksimum Search Bar
              ),
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

  Widget _tambahDataEvent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEventPage()),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Tambah Event",
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

  // Widget untuk Event Card
  Widget _eventCard(BuildContext context,
      {required String eventName, required String eventId}) {
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
                  builder: (context) => DetailEventPage(
                    eventId: eventId,
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<EventModel>>(
        future: _loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                _headerContainer(),
                _tambahDataEvent(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No events found"),
                ),
              ],
            );
          } else {
            final events = snapshot.data!;

            return Column(
              children: [
                _headerContainer(),
                _tambahDataEvent(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _eventCard(
                        context,
                        eventName: event.namaEvent,
                        eventId: event.id,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
