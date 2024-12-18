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
  final TextEditingController _searchController = TextEditingController();
  List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventController.getAllEvents();
      setState(() {
        _allEvents = events;
        _filteredEvents = events; // Awalnya tampilkan semua event
      });
    } catch (error) {
      // Tangani kesalahan jika ada
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredEvents = _allEvents
          .where((event) =>
              event.namaEvent.toLowerCase().contains(_searchController.text.toLowerCase()))
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Image.asset(
                'images/iconsirek.png',
                height: 40,
              ),
            ],
          ),
          const SizedBox(height: 10),
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
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Apa yang ingin kamu cari...",
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              constraints: const BoxConstraints(
                maxHeight: 40,
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
          ElevatedButton.icon(
            onPressed: () {
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
              color: Colors.white,
            ),
            label: const Text(
              "Detail",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADCB),
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
      body: Column(
        children: [
          _headerContainer(),
          _tambahDataEvent(),
          Expanded(
            child: _filteredEvents.isEmpty
                ? const Center(child: Text("Tidak menemukan data event"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
                      return _eventCard(
                        context,
                        eventName: event.namaEvent,
                        eventId: event.id,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
