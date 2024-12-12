import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  String? bookletFileName;
  DateTime? closeDate;
  final TextEditingController deskripsiController = TextEditingController();
  String? imageFileName;
  final TextEditingController namaController = TextEditingController();
  DateTime? openDate;

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  // Fungsi untuk memilih file
  Future<void> pickFile(bool isImage) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.image : FileType.custom,
      allowedExtensions: isImage ? ['png', 'jpg'] : ['pdf'],
    );

    if (result != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      try {
        final downloadUrl = await _uploadFile(
          filePath,
          isImage ? 'event/images/$fileName' : 'event/booklets/$fileName',
        );

        setState(() {
          if (isImage) {
            imageFileName = downloadUrl;
          } else {
            bookletFileName = downloadUrl;
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isImage
                ? "Hanya file PNG atau JPG yang diizinkan!"
                : "Hanya file PDF yang diizinkan!",
          ),
        ),
      );
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> pickDate(BuildContext context, bool isOpenDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isOpenDate) {
          openDate = pickedDate;
        } else {
          closeDate = pickedDate;
        }
      });
    }
  }

  // Ambil data event dari Firestore
  Future<void> _fetchEventData() async {
    try {
      final eventDoc = await FirebaseFirestore.instance
          .collection('event')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists) {
        final data = eventDoc.data()!;
        setState(() {
          namaController.text = data['nama'] ?? '';
          deskripsiController.text = data['deskripsi'] ?? '';
          openDate = data['openDate'] != null
              ? DateTime.parse(data['openDate'])
              : null;
          closeDate = data['closeDate'] != null
              ? DateTime.parse(data['closeDate'])
              : null;
          imageFileName = data['imageFileName'] ?? '';
          bookletFileName = data['bookletFileName'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  // Fungsi untuk mengunggah file ke Firebase Storage
  Future<String> _uploadFile(String filePath, String storagePath) async {
    final file = File(filePath);
    final ref = FirebaseStorage.instance.ref().child(storagePath);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  // Fungsi untuk memperbarui data event
  Future<void> _updateEventData() async {
    try {
      await FirebaseFirestore.instance
          .collection('event')
          .doc(widget.eventId)
          .update({
        'nama': namaController.text,
        'deskripsi': deskripsiController.text,
        'openDate': openDate?.toIso8601String(),
        'closeDate': closeDate?.toIso8601String(),
        'imageFileName': imageFileName,
        'bookletFileName': bookletFileName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event berhasil diperbarui!")),
      );

      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating event: $e")),
      );
    }
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
          "Edit Event",
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
              controller: namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: deskripsiController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Open Recruitment",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: openDate != null
                    ? "${openDate!.day}/${openDate!.month}/${openDate!.year}"
                    : "",
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => pickDate(context, true),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Close Recruitment",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: closeDate != null
                    ? "${closeDate!.day}/${closeDate!.month}/${closeDate!.year}"
                    : "",
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => pickDate(context, false),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Upload Gambar",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => pickFile(true),
                  child: const Text("Pilih File"),
                ),
                const SizedBox(width: 10),
                Text(imageFileName ?? "No File Chosen"),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Upload File Booklet",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => pickFile(false),
                  child: const Text("Pilih File"),
                ),
                const SizedBox(width: 10),
                Text(bookletFileName ?? "No File Chosen"),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _updateEventData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A220),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Edit Event",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
