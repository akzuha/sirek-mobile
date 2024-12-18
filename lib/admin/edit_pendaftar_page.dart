import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class EditPendaftarPage extends StatefulWidget {
  const EditPendaftarPage({super.key, required this.pendaftarId});

  final String pendaftarId;

  @override
  State<EditPendaftarPage> createState() => _EditPendaftarPageState();
}

class _EditPendaftarPageState extends State<EditPendaftarPage> {
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController angkatanController = TextEditingController();
  String? cvFileName;
  final TextEditingController emailController = TextEditingController();
  TextEditingController fakultasController = TextEditingController();
  String? jenisKelamin;
  TextEditingController jurusanController = TextEditingController();
  String? locFileName;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  String? pilihan1;
  String? pilihan2;
  DateTime? selectedDate;
  final TextEditingController teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPendaftarDetails();
  }

  // Fungsi untuk memilih file
  Future<void> pickFile(bool isCv) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isCv) {
          cvFileName = result.files.single.name;
        } else {
          locFileName = result.files.single.name;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCv
              ? "Hanya file PDF yang diizinkan untuk CV!"
              : "Hanya file PDF yang diizinkan untuk LoC!"),
        ),
      );
    }
  }

  // Fungsi untuk memilih tanggal lahir
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _fetchPendaftarDetails() async {
    final pendaftarDoc = await FirebaseFirestore.instance
        .collection('pendaftar')
        .doc(widget.pendaftarId)
        .get();
    if (pendaftarDoc.exists) {
      final data = pendaftarDoc.data()!;
      setState(() {
        namaController.text = data['namaPendaftar'] ?? '';
        emailController.text = data['emailPendaftar'] ?? '';
        teleponController.text = (data['telepon'] != null) ? data['telepon'].toString() : '';
        alamatController.text = data['alamat'] ?? '';
        nimController.text = data['nim'] ?? '';
        angkatanController.text = data['angkatan'] ?? '';
        alasanController.text = data['alasan'] ?? '';
        jenisKelamin = data['jenisKelamin'] ?? '';
        jurusanController = data['jurusan'] ?? '';
        fakultasController = data['fakultas'] ?? '';
        pilihan1 = data['pilihanSatu'] ?? '';
        pilihan2 = data['pilihanDua'] ?? '';
        selectedDate =
            data['tglLahir'] != null ? DateTime.parse(data['tglLahir']) : null;
      });
    }
  }

  Future<void> _updatePendaftar() async {
    try {
      // Konversi tipe data sesuai kebutuhan
      final int? telepon = int.tryParse(teleponController.text);
      final int? angkatan = int.tryParse(angkatanController.text);
      final Timestamp? tglLahir = 
          selectedDate != null ? Timestamp.fromDate(selectedDate!) : null;

      // Validasi nilai penting
      if (telepon == null || angkatan == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Telepon dan Angkatan harus berupa angka!")),
        );
        return;
      }

      // Update data di Firestore
      await FirebaseFirestore.instance
          .collection('pendaftar')
          .doc(widget.pendaftarId)
          .update({
        'namaPendaftar': namaController.text,
        'emailPendaftar': emailController.text,
        'telepon': telepon,
        'alamat': alamatController.text,
        'nim': nimController.text,
        'angkatan': angkatan,
        'alasan': alasanController.text,
        'jenisKelamin': jenisKelamin,
        'jurusan': jurusanController.text,
        'fakultas': fakultasController.text,
        'pilihanSatu': pilihan1,
        'pilihanDua': pilihan2,
        'tglLahir': tglLahir,
      });

      // Notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil diperbarui!")),
      );
      Navigator.pop(context);
    } catch (e) {
      // Notifikasi jika terjadi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  Widget _buildTextField(String label,
      {required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Pendaftar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nama", controller: namaController),
            const SizedBox(height: 16),
            _buildTextField("Email", controller: emailController),
            const SizedBox(height: 16),
            _buildTextField("Telepon", controller: teleponController),
            const SizedBox(height: 16),
            _buildTextField("Alamat", controller: alamatController),
            const SizedBox(height: 16),

            // Tanggal Lahir dengan Date Picker
            const Text("Tanggal Lahir",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "10/10/2003",
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => pickDate(context),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            _buildDropdownField("Jenis Kelamin", ["Laki-Laki", "Perempuan"]),
            const SizedBox(height: 16),

            // NIM sebagai input field biasa
            _buildTextField("NIM", controller: nimController  ),
            const SizedBox(height: 16),

            _buildTextField("Jurusan", controller: jurusanController),
            const SizedBox(height: 16),
            _buildTextField("Fakultas", controller: fakultasController),
            const SizedBox(height: 16),
            _buildTextField("Angkatan", controller: angkatanController),
            const SizedBox(height: 16),
            _buildDropdownField("Pilihan 1", ["Bendahara", "Sekretaris"]),
            const SizedBox(height: 16),
            _buildDropdownField("Pilihan 2", ["Ketua", "Sekretaris"]),
            const SizedBox(height: 16),
            _buildTextField("Alasan", controller: alasanController),
            const SizedBox(height: 16),

            // File CV
            const Text("File CV",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickFile(true),
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text(
                    "Pilih File",
                    style: TextStyle(color: Colors.white), // Warna putih
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(cvFileName ?? "Belum ada file"),
              ],
            ),
            const SizedBox(height: 16),

            // File LoC
            const Text("File LoC",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickFile(false),
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text(
                    "Pilih File",
                    style: TextStyle(color: Colors.white), // Warna putih
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(locFileName ?? "Belum ada file"),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _updatePendaftar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A220),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Edit Pendaftar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }
}
