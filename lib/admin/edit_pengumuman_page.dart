import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class EditPengumumanPage extends StatefulWidget {
  const EditPengumumanPage({super.key, required this.pengumumanId});

  final String pengumumanId;

  @override
  State<EditPengumumanPage> createState() => _EditPengumumanPageState();
}

class _EditPengumumanPageState extends State<EditPengumumanPage> {
  String? fileName;
  String? filePath;
  DateTime? selectedDate;

  final TextEditingController _keteranganController = TextEditingController();
  String? pengumumanName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPengumumanData();
  }

  // Fungsi untuk mengambil data pengumuman dari Firestore
  Future<void> fetchPengumumanData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('pengumuman')
          .doc(widget.pengumumanId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          pengumumanName = data['nama'] ?? "";
          _keteranganController.text = data['keterangan'] ?? "";
          fileName = data['fileName'] ?? "";
          selectedDate = data['tanggal'] != null
              ? DateTime.parse(data['tanggal'])
              : null;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengumuman tidak ditemukan.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data pengumuman: $e")),
      );
      Navigator.pop(context);
    }
  }

  // Fungsi untuk memilih file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hanya file PDF yang diizinkan!"),
        ),
      );
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Fungsi untuk mengunggah file ke Firebase Storage
  Future<String?> uploadFileToStorage(String filePath, String fileName) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('pengumuman/$fileName');

      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengunggah file: $e"),
        ),
      );
      return null;
    }
  }

  // Fungsi untuk memperbarui pengumuman ke Firestore
  Future<void> updatePengumuman() async {
    if (selectedDate == null || _keteranganController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi!"),
        ),
      );
      return;
    }

    String? fileUrl;

    if (filePath != null && fileName != null) {
      fileUrl = await uploadFileToStorage(filePath!, fileName!);
    }

    try {
      await FirebaseFirestore.instance
          .collection('pengumuman')
          .doc(widget.pengumumanId)
          .update({
        'keterangan': _keteranganController.text,
        'tanggal': selectedDate?.toIso8601String(),
        'filePengumuman': fileUrl ?? "",
        'fileName': fileName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pengumuman berhasil diperbarui!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui pengumuman: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
          "Edit Pengumuman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Event",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: pengumumanName),
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                fillColor: Colors.grey[300],
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text("File Pengumuman",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickFile,
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Expanded(
                    child: Text(
                      "Pilih File",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(fileName ?? "Belum ada file"),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Tanggal",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "",
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
            const Text("Keterangan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _keteranganController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: updatePengumuman,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A220),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Edit Pengumuman",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 3),
    );
  }
}
