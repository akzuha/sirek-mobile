import 'package:flutter/material.dart';
import '../widgets/mhsbottom_nav.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Tanda panah warna putih
          onPressed: () {
            Navigator.pop(context); // Aksi kembali ke halaman sebelumnya
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "images/iconsirek.png", // Ikon di sebelah kanan
              height: 30, // Ukuran ikon diperkecil
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container biru dengan judul BEM UNSOED 2024
            Container(
              color: const Color(0xFF072554),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  "BEM UNSOED 2024",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Container putih untuk deskripsi dan logo
            // Container putih untuk deskripsi dan logo
Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Margin kanan-kiri 30
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white, // Warna putih dipindahkan ke dalam decoration
    borderRadius: BorderRadius.circular(10), // Radius 10
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3), // Shadow di bawah
      ),
    ],
  ),
  child: Column(
    children: [
      Image.asset(
        "images/logo_bem_unsoed.png", // Logo utama
        height: 80,
      ),
      const SizedBox(height: 10),
      const Text(
        "Kabinet Bahtera Karsa",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF072554),
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        "BEM Unsoed 2024 mengusung nama kabinet “Bahtera Karsa” dengan arti kapal/wadah yang besar di dalamnya terdapat orang-orang yang memiliki karsa/tekad yang sama. Bersama nama dan logo ini terdapat doa serta harapan yang mengiringi setiap perjalanan BEM Unsoed di tahun 2024. Dengan ini, perjalanan BEM Unsoed 2024 kita awali bersama. Sudah saatnya kita untuk saling berkolaborasi bersama untuk terus menciptakan ragam karya untuk Unsoed dan Negeri kita tercinta. Ciptakan bahtera, Satukan karsa, Melangkah bersama!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 20),
            // Filosofi Logo Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Filosofi Logo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF072554),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _logoDescription(
                  context,
                  "Api",
                  "Melambangkan kekuatan tekad juang yang senantiasa memberikan kehangatan serta cahaya dalam setiap langkah perjuangan, dan menjadi sumber inspirasi sekitarnya.",
                  "images/logo_api.png",
                ),
                _logoDescription(
                  context,
                  "Bahtera",
                  "Sebagai kapal besar yang akan melakukan perjalanan luas, diciptakan untuk mempereratkan dan mengokohkan rasa, memantapkan tujuan, serta melabuh untuk berlabuh bersama.",
                  "images/logo_bahtera.png",
                ),
                _logoDescription(
                  context,
                  "Tiga Percikan Air",
                  "Melambangkan tri dharma perguruan tinggi sebagai landasan.",
                  "images/logo_percikan_air.png",
                ),
                _logoDescription(
                  context,
                  "Tangan yang Mengadah",
                  "Melambangkan keterbukaan dan semangat yang mendorong bahtera karsa.",
                  "images/logo_tangan.png",
                ),
                _logoDescription(
                  context,
                  "Gelombang",
                  "Menggambarkan pergerakan yang dinamis serta keberanian yang tulus dalam menghadapi berbagai tantangan, terus melangkah bersama karsa guna mencapai tujuan bersama.",
                  "images/logo_gelombang.png",
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Booklet Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "BOOKLET",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF072554),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bookletCard(
                  context,
                  "Desa Cita",
                  "images/booklet_desa_cita.png",
                ),
                const SizedBox(width: 10),
                _bookletCard(
                  context,
                  "Panggil Sedulur",
                  "images/booklet_panggil_sedulur.png",
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0), // Navbar di bawah
    );
  }

  // Widget untuk Filosofi Logo
  Widget _logoDescription(
    BuildContext context,
    String title,
    String description,
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Image.asset(imagePath, width: 40),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  // Widget untuk Kartu Booklet
  Widget _bookletCard(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Klik pada booklet: $title")),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 100,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
