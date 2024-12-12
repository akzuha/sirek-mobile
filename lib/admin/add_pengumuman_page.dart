import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sirek/controllers/pengumuman_controller.dart';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/models/pengumuman_model.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class AddPengumumanPage extends StatefulWidget {
  const AddPengumumanPage({super.key});

  @override
  State<AddPengumumanPage> createState() => _AddPengumumanPageState();
}

class _AddPengumumanPageState extends State<AddPengumumanPage> {
  List<EventModel> _eventList = [];
  File? _filePengumuman;
  final _formKey = GlobalKey<FormState>();
  String? _keterangan;
  final PengumumanController _pengumumanController = PengumumanController();
  String? _selectedEvent;
  DateTime? _tanggalPengumuman;

  @override
  void initState() {
    super.initState();
    _getEventList();
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final selectedFile = File(result.files.single.path!);

        if (await selectedFile.exists()) {
          setState(() {
            _filePengumuman = selectedFile;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File berhasil dipilih."),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File tidak ditemukan. Coba pilih ulang."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak ada file yang dipilih."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat memilih file: $e"),
        ),
      );
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalPengumuman = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_filePengumuman == null ||
          _selectedEvent == null ||
          _tanggalPengumuman == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua bidang harus diisi.")),
        );
        return;
      }

      try {
        // Coba unggah file PDF
        String pengumumanUrl = await _uploadFileToStorage(_filePengumuman!);

        // Buat objek pengumuman baru
        final newPengumuman = PengumumanModel(
          id: '', // ID akan dibuat otomatis oleh Firestore
          namaEvent: _selectedEvent!,
          filePengumuman: pengumumanUrl,
          keterangan: _keterangan!,
          tanggalPengumuman: _tanggalPengumuman!,
        );

        // Tambahkan ke Firestore melalui controller
        await _pengumumanController.createPengumuman(
            newPengumuman, _filePengumuman);

        // Tampilkan notifikasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengumuman berhasil ditambahkan!')),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } catch (e) {
        // Tangani kesalahan proses upload atau Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  // Fungsi untuk mengunggah file ke Firebase Storage
  Future<String> _uploadFileToStorage(File file) async {
    try {
      // Mendapatkan nama file yang unik menggunakan timestamp
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";
      Reference storageRef =
          FirebaseStorage.instance.ref().child('pengumuman/$fileName');

      // Menjalankan proses pengunggahan file
      UploadTask uploadTask = storageRef.putFile(file);

      // Menampilkan progress upload ke console
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print("Progress upload: ${(progress * 100).toStringAsFixed(2)}%");
      });

      // Menunggu hingga unggahan selesai
      TaskSnapshot snapshot = await uploadTask;

      // Mendapatkan URL file yang diunggah
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Gagal mengunggah file ke Firebase Storage: $e");
    }
  }

  Future<void> _getEventList() async {
    try {
      final eventList = await _pengumumanController.getEventList();
      setState(() {
        _eventList = eventList;
      });
    } catch (e) {
      print('Error: $e');
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
          "Tambah Pengumuman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nama Event",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _eventList.map((event) {
                  return DropdownMenuItem<String>(
                    value: event.namaEvent,
                    child: Text(event.namaEvent),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedEvent = value;
                  });
                },
                hint: const Text("Pilih Event"),
                validator: (value) =>
                    value == null ? "Pilih salah satu event" : null,
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
                    label: const Text("Choose File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _filePengumuman != null
                        ? _filePengumuman!.path.split('/').last
                        : "No File Chosen",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Tanggal",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _tanggalPengumuman != null
                      ? "${_tanggalPengumuman!.day}/${_tanggalPengumuman!.month}/${_tanggalPengumuman!.year}"
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
              TextFormField(
                maxLines: 5,
                onChanged: (value) {
                  _keterangan = value;
                },
                validator: (value) =>
                    value!.isEmpty ? "Keterangan tidak boleh kosong" : null,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Tambah Pengumuman",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 3),
    );
  }
}
