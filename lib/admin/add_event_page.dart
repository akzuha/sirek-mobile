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
  File? _booklet;
  DateTime? _closeRec;
  String? _deskripsi;  
  File? _gambar;
  String? _namaEvent;
  DateTime? _openRec;

  // Fungsi untuk memilih file gambar atau booklet
  Future<void> _pickFile(bool isGambar) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: isGambar ? ['png', 'jpg'] : ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final selectedFile = File(result.files.single.path!);

        if (await selectedFile.exists()) {
          setState(() {
            if (isGambar) {
              _gambar = File(result.files.single.path!);
            } else {
              _booklet = File(result.files.single.path!);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File berhasil dipilih."),
              duration: Duration(seconds: 2),
            ),
          );
        } 
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_booklet == null ||
          _gambar == null ||
          _closeRec == null ||
          _openRec == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua bidang harus diisi.")),
        );
        return;
      }

      try {
        // Upload file gambar dan booklet
        String gambarUrl = await _eventController.uploadFile(_gambar!, 'event/logo');
        String bookletUrl = await _eventController.uploadFile(_booklet!, 'event/booklet');

        // Buat objek event baru
        final newEvent = EventModel(
          id: '',
          namaEvent: _namaEvent!,
          gambar: gambarUrl,
          booklet: bookletUrl,
          openRec: _openRec!,
          closeRec: _closeRec!,
          deskripsi: _deskripsi!,
        );

        // Tambahkan ke Firestore
        await _eventController.createEventWithFiles(newEvent);

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
              const Text("Nama Event",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text("Gambar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(true),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Pilih File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _gambar != null
                          ? _gambar!.path.split('/').last
                          : "Belum ada file",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Upload Booklet
              const Text("Upload File Booklet",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickFile(false),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Pilih File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _booklet != null
                          ? _booklet!.path.split('/').last
                          : "Belum ada file",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Input Open Recruitment
              const Text("Open Recruitment",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _openRec != null
                      ? DateFormat('dd/MM/yyyy').format(_openRec!)
                      : '',
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
              const Text("Close Recruitment",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _closeRec != null
                      ? DateFormat('dd/MM/yyyy').format(_closeRec!)
                      : '',
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
              const Text("Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Tambah Event",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
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
