import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sirek/landing.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        automaticallyImplyLeading: true, // Tampilkan panah kembali
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna panah kiri diubah menjadi putih
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Warna teks diubah menjadi putih
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Nama (Disabled)
              const Text(
                "Nama",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                initialValue: user.displayName ?? "Admin User",
                enabled: false, // Disable input
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12, // Ukuran font lebih kecil
                ),
              ),
              const SizedBox(height: 15),

              // Email (Disabled)
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                initialValue: user.email ?? "admin@gmail.com",
                enabled: false, // Disable input
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12, // Ukuran font lebih kecil
                ),
              ),
              const SizedBox(height: 15),

              // Password
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12, // Ukuran font lebih kecil
                ),
              ),
              const SizedBox(height: 15),

              // Confirm New Password
              const Text(
                "Confirm New Password",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12, // Ukuran font lebih kecil
                ),
              ),
              const SizedBox(height: 25),

              // Update Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    user.updatePassword(_passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(
                      fontSize: 12, // Ukuran font tombol lebih kecil
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Landing(title: "Halaman Landing"),
                      ),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF6A220)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12), // Tinggi tombol lebih kecil
                  ),
                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFF6A220),
                    size: 16, // Ukuran ikon lebih kecil
                  ),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 12, // Ukuran font tombol lebih kecil
                      color: Color(0xFFF6A220),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
