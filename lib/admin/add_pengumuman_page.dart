import 'dart:io';
import 'package:flutter/material.dart';
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
  final PengumumanController _pengumumanController = PengumumanController();
  final _formKey = GlobalKey<FormState>();

  List<EventModel> _eventList = [];
  File? _filePengumuman;
  String? _keterangan;
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
        String pengumumanUrl = await _pengumumanController.uploadFile(_filePengumuman!, 'pengumuman');

        final newPengumuman = PengumumanModel(
          id: '',
          namaEvent: _selectedEvent!,
          filePengumuman: pengumumanUrl,
          keterangan: _keterangan!,
          tanggalPengumuman: _tanggalPengumuman!,
        );

        await _pengumumanController.createPengumuman(newPengumuman);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengumuman berhasil ditambahkan!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
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
                    label: const Text("Pilih File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _filePengumuman != null
                          ? _filePengumuman!.path.split('/').last
                          : "Belum ada file",
                      overflow: TextOverflow.ellipsis,
                    ),
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
