import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'detail_pendaftar_page.dart';

class PendaftarPage extends StatelessWidget {
  const PendaftarPage({super.key});

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

                // Dropdown pilih event
                Container(
                  color: const Color(0xFF072554),
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Soedirman Student Summit",
                        child: Text("Soedirman Student Summit"),
                      ),
                      DropdownMenuItem(
                        value: "Desa Cita",
                        child: Text("Desa Cita"),
                      ),
                      DropdownMenuItem(
                        value: "Panggil Sedulur",
                        child: Text("Panggil Sedulur"),
                      ),
                    ],
                    onChanged: (value) {
                      // Logika saat memilih event
                    },
                    hint: const Text("Pilih Event"),
                  ),
                ),
              ],
            ),
          ),

          // ListView
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4, // Jumlah pendaftar
              itemBuilder: (context, index) {
                return _pendaftarCard(
                  context,
                  pendaftarName: "Levi Ackerman $index",
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }

  // Widget untuk Pendaftar Card
  Widget _pendaftarCard(BuildContext context, {required String pendaftarName}) {
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
          // Nama Pendaftar
          Expanded(
            child: Text(
              pendaftarName,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPendaftarPage(
                    pendaftarName:
                        pendaftarName, // Pastikan data yang dikirim sesuai
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
}
