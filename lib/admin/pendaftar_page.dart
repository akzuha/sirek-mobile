import 'package:flutter/material.dart';
import 'package:sirek/controllers/pendaftar_controller.dart';
import 'package:sirek/models/pendaftar_model.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'detail_pendaftar_page.dart';

class PendaftarPage extends StatelessWidget {
  PendaftarPage({super.key});

  final PendaftarController _pendaftarController = PendaftarController();

  Future<List<PendaftarModel>> _loadPendaftar() {
    return _pendaftarController.getAllPendaftars();
  }

  Widget _headerContainer() {
    return Container(   
      color: const Color(0xFF072554),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo di kanan atas
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
          // Judul
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

          // Dropdown pilih event diperkecil
          Container(
            color: const Color(0xFF072554),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 40, // Tinggi dropdown lebih kecil
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8), // Padding diperkecil
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Soedirman Student Summit",
                    child: Text(
                      "Soedirman Student Summit",
                      style:
                          TextStyle(fontSize: 12), // Ukuran font lebih kecil
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Desa Cita",
                    child: Text(
                      "Desa Cita",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Panggil Sedulur",
                    child: Text(
                      "Panggil Sedulur",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                onChanged: (value) {
                  // Logika saat memilih event
                },
                hint: const Text(
                  "Pilih Event",
                  style: TextStyle(
                    fontSize: 14, // Ukuran font lebih kecil
                    color: Colors.grey, // Warna font abu-abu
                  ),
                ),
              ),
            ),
          ),
        ],
      ),               
    );
  }

  // Widget untuk Pendaftar Card
  Widget _pendaftarCard(BuildContext context, {required String pendaftarName, required String pendaftarId}) {
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
              padding: const EdgeInsets.only(right:16),
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

          // Tombol Detail
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
              color: Colors.white, // White icon color
            ),
            label: const Text(
              "Detail",
              style: TextStyle(
                color: Colors.white, // White text color
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ADCB), // Blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8), // Button padding
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
        future: _loadPendaftar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                // Header
                _headerContainer(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No events found"),
                ),
              ],
            );
          } else {
            final pendaftars = snapshot.data!;

            return Column(
              children: [
                // Header dengan logo di kanan, judul, dan background biru
                _headerContainer(),           

                // Tambahkan jarak antara container dropdown dan ListView
                const SizedBox(height: 16),

                // ListView
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pendaftars.length,
                    itemBuilder: (context, index) {
                      final pendaftar = pendaftars[index];
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
        }
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}
