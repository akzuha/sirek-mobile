import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/controllers/event_controller.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final EventController _eventController = EventController();
  final _formKey = GlobalKey<FormState>();

  String _namaEvent = '';
  String _deskripsi = '';
  DateTime? _openRec;
  DateTime? _closeRec;
  File? _gambar;
  File? _booklet;

  // Fungsi untuk memilih file gambar atau booklet
  Future<void> _pickFile(bool isGambar) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (isGambar) {
          _gambar = File(result.files.single.path!);
        } else {
          _booklet = File(result.files.single.path!);
        }
      });
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _pickDate(BuildContext context, bool isOpenRec) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isOpenRec) {
          _openRec = pickedDate;
        } else {
          _closeRec = pickedDate;
        }
      });
    }
  }

  // Fungsi untuk mengirim data ke Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Upload file gambar dan booklet
        String? gambarUrl;
        String? bookletUrl;

        // Buat objek event baru
        final newEvent = EventModel(
          id: '', // ID akan dibuat otomatis oleh Firestore
          namaEvent: _namaEvent,
          gambar: gambarUrl ?? '',
          booklet: bookletUrl ?? '',
          openRec: _openRec!,
          closeRec: _closeRec!,
          deskripsi: _deskripsi,
        );

        // Tambahkan ke Firestore
        await _eventController.createEventWithFiles(newEvent, gambarUrl as File?, bookletUrl as File?);

        // Tampilkan notifikasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event berhasil ditambahkan!')),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Tambah Event",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama Event
              const Text("Nama Event", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama event tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _namaEvent = value!,
              ),
              const SizedBox(height: 16),

              // Upload Gambar
              const Text("Gambar", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(true),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Choose File", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Text(_gambar != null ? "File dipilih" : "No File Chosen"),
                ],
              ),
              const SizedBox(height: 16),

              // Upload Booklet
              const Text("Upload File Booklet", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(false),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Choose File", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Text(_booklet != null ? "File dipilih" : "No File Chosen"),
                ],
              ),
              const SizedBox(height: 16),

              // Input Open Recruitment
              const Text("Open Recruitment", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _openRec != null ? DateFormat('dd/MM/yyyy').format(_openRec!) : '',
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context, true),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Close Recruitment
              const Text("Close Recruitment", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _closeRec != null ? DateFormat('dd/MM/yyyy').format(_closeRec!) : '',
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(context, false),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Deskripsi
              const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _deskripsi = value!,
              ),
              const SizedBox(height: 16),

              // Tombol Tambah Event
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6A220),
                    padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Tambah Event", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
    );
  }
}
