import 'package:flutter/material.dart';
import 'package:sirek/controllers/event_controller.dart';
import 'package:sirek/controllers/pendaftar_controller.dart';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/models/pendaftar_model.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'detail_pendaftar_page.dart';

class PendaftarPage extends StatefulWidget {
  const PendaftarPage({super.key});

  @override
  State<PendaftarPage> createState() => _PendaftarPageState();
}

class _PendaftarPageState extends State<PendaftarPage> {
  final PendaftarController _pendaftarController = PendaftarController();
  final EventController _eventController = EventController();
  String? _selectedEvent;
  late Future<List<PendaftarModel>> _futurePendaftars;

  @override
  void initState() {
    super.initState();
    _futurePendaftars = _loadPendaftar();
  }

  Future<List<PendaftarModel>> _loadPendaftar() {
    return _pendaftarController.getAllPendaftars();
  }

  Future<List<EventModel>> _loadEvent() {
    return _eventController.getAllEvents();
  }

  List<PendaftarModel> _filterPendaftars(
      List<PendaftarModel> allPendaftars, String? selectedEvent) {
    if (selectedEvent == null || selectedEvent.isEmpty) {
      return allPendaftars;
    }
    return allPendaftars
        .where((pendaftar) => pendaftar.namaEvent == selectedEvent)
        .toList();
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
              "Pendaftar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<EventModel>>(
            future: _loadEvent(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No events available');
              } else {
                final events = snapshot.data!;
                return Container(
                  color: const Color(0xFF072554),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 40,
                    child: DropdownButtonFormField<String>(
                      value: _selectedEvent,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: events.map((event){
                        return DropdownMenuItem<String>(
                          value: event.namaEvent,
                          child: Text(
                            event.namaEvent,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEvent = value;
                        });
                      },
                      hint: const Text(
                        "Pilih Event",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }            
          ),
        ],
      ),
    );
  }

  Widget _pendaftarCard(BuildContext context,
      {required String pendaftarName, required String pendaftarId}) {
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
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                pendaftarName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF072554),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPendaftarPage(
                    pendaftarId: pendaftarId,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PendaftarModel>>(
          future: _futurePendaftars,
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
              final filteredPendaftars =
                  _filterPendaftars(snapshot.data!, _selectedEvent);

              return Column(
                children: [
                  _headerContainer(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredPendaftars.isEmpty
                        ? const Center(child: Text("No pendaftar found"))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredPendaftars.length,
                            itemBuilder: (context, index) {
                              final pendaftar = filteredPendaftars[index];
                              return _pendaftarCard(
                                context,
                                pendaftarName: pendaftar.namaPendaftar,
                                pendaftarId: pendaftar.id,
                              );
                            },
                          ),
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}
