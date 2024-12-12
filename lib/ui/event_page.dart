import 'package:flutter/material.dart';
import 'package:sirek/controllers/event_controller.dart';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/widgets/mhsbottom_nav.dart';
import 'event_detail_page.dart';

class EventPage extends StatelessWidget {
  EventPage({super.key});

  final EventController _eventController = EventController();

  Future<List<EventModel>> _loadEvents() {
    return _eventController.getAllEvents();
  }

  Widget _headerContainer(){
    return Container(
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
    );
  }

  Widget _eventCard(BuildContext context, {required String title, required String description, required String image, required String eventId}) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
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
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
            ),
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Tombol Selengkapnya (Navigasi ke halaman detail event)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          eventId: eventId,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No events found"),
                ),
              ],
            );
          } else {
            final events = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headerContainer(),      

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Agar tidak konflik dengan scroll utama
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _eventCard(
                      context,
                      title: event.namaEvent,
                      description: event.deskripsi,
                      image: event.gambar,
                      eventId: event.id,
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}

