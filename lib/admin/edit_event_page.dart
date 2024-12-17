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
  late TextEditingController deskripsiController;
  String? imageFileName;
  late TextEditingController namaController;
  DateTime? openDate;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController();
    deskripsiController = TextEditingController();
    _fetchEventData();
  }

  @override
  void dispose() {
    // Membersihkan controller
    namaController.dispose();
    deskripsiController.dispose();
    super.dispose();
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

  Future<String> getBookletName(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      return ref.name;
    } catch (e) {
      debugPrint("Error getting booklet name: $e");
      return "Nama file tidak tersedia";
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
          namaController.text = data['namaEvent'] ?? '';
          deskripsiController.text = data['deskripsi'] ?? '';
          openDate = data['openDate'] != null
            ? (data['openDate'] as Timestamp).toDate()
            : null;

        closeDate = data['closeDate'] != null
            ? (data['closeDate'] as Timestamp).toDate()
            : null;
          imageFileName = data['gambar'] ?? '';
          bookletFileName = data['booklet'] ?? '';
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
        SnackBar(content: Text("Gagal update event: $e")),
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
            
            _buildTextField("Nama Event", namaController),
            const SizedBox(height: 16),
            _buildTextField("Deskripsi", deskripsiController, maxLines: 5),
            const SizedBox(height: 16),
            _buildDateField("Open Recruitment", openDate, true),
            const SizedBox(height: 16),
            _buildDateField("Close Recruitment", closeDate, false),
            const SizedBox(height: 16),
            _buildFilePicker("Upload Gambar", imageFileName, true),
            const SizedBox(height: 16),
            _buildFilePicker("Upload File Booklet", bookletFileName, false),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isOpenDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          controller: TextEditingController(
            text: date != null
                ? "${date.day}/${date.month}/${date.year}"
                : "",
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => pickDate(context, isOpenDate),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker(String label, String? fileName, bool isImage) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => pickFile(isImage),
          child: const Text("Pilih File"),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(fileName ?? "No File Chosen")),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF6A220),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _updateEventData,
        child: const Center(
          child: Text(
            "Edit Event",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}