import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sirek/admin/profile_page.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getCollectionCount(String collectionName) async {
    QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.length;
  }

  Widget _buildDataCard(
    BuildContext context, {
    required String collectionName,
    required String title,
    required String description,
  }) {
    return FutureBuilder<int>(
      future: _getCollectionCount(collectionName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return _dataCard(
            context,
            value: "${snapshot.data}",
            title: title,
            description: description,
          );
        }
      },
    );
  }

  Widget _profileCard(
    BuildContext context, {
    required String name,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF072554), Color(0xFF0B3B91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : null, // Jangan tampilkan child jika ada gambar
            backgroundColor: Colors.grey[400], // Tidak ada gambar jika photoURL null
            child: user.photoURL == null
                ? const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white, // Warna ikon
                  )
                : null, // Warna latar untuk ikon default
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
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
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png",
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _profileCard(
                  context,
                  name: user.displayName ?? "Admin User",
                  email: user.email ?? "No Email Available",
                ),
                const SizedBox(height: 20),
                _buildDataCard(
                  context,
                  collectionName: "event",
                  title: "Jumlah Event",
                  description:
                      "Dari data yang ada, jumlah event yang telah dibuat.",
                ),
                _buildDataCard(
                  context,
                  collectionName: "pendaftar",
                  title: "Jumlah Pendaftar",
                  description:
                      "Dari data yang ada, jumlah pendaftar yang telah terdaftar.",
                ),
                _buildDataCard(
                  context,
                  collectionName: "pengumuman",
                  title: "Jumlah Pengumuman",
                  description:
                      "Dari data yang ada, jumlah pengumuman yang telah dibuat.",
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
    );
  }
}
