import 'package:flutter/material.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';
import 'package:sirek/admin/profile_page.dart'; // Import halaman Profile

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        automaticallyImplyLeading: false, // Hilangkan tanda panah hitam
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
          children: [
            // Header Dashboard
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  "DASHBOARD",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ListView dengan Profil dan Data
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Profil Section
                _profileCard(
                  context,
                  name: "John Doe",
                  email: "johndoe@bem-unsoed.ac.id",
                ),
                const SizedBox(height: 20),

                // Data Cards
                _dataCard(
                  context,
                  value: "10",
                  title: "Jumlah Event",
                  description:
                      "Dari data yang ada, jumlah event yang telah dibuat oleh Admin.",
                ),
                _dataCard(
                  context,
                  value: "50",
                  title: "Jumlah Pendaftar",
                  description:
                      "Dari data yang ada, jumlah pendaftar yang telah terdaftar.",
                ),
                _dataCard(
                  context,
                  value: "5",
                  title: "Jumlah Pengumuman",
                  description:
                      "Dari data yang ada, jumlah pengumuman yang telah dibuat.",
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0), // Navbar di bawah
    );
  }

  // Widget untuk kartu profil
  Widget _profileCard(
    BuildContext context, {
    required String name,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Jarak vertikal
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF072554), Color(0xFF0B3B91)], // Gradasi biru
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5), // Bayangan lebih tajam
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Profil
          const Icon(
            Icons.account_circle,
            size: 50,
            color: Colors.white, // Warna putih untuk ikon profil
          ),
          const SizedBox(width: 16),

          // Informasi Profil
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20, // Ukuran lebih besar
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Ikon Edit
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // Navigasi ke halaman ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk kartu data
  Widget _dataCard(
    BuildContext context, {
    required String value,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6A220),
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
          // Angka Besar
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF072554),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Informasi Data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF072554),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
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
