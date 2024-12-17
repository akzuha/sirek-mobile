import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sirek/models/pendaftar_model.dart';
import 'package:sirek/controllers/pendaftar_controller.dart';

class DaftarEventPage extends StatefulWidget {
  const DaftarEventPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<DaftarEventPage> createState() => _DaftarEventPageState();
}

class _DaftarEventPageState extends State<DaftarEventPage> {
  String alamat = "";
  String alasan = "";
  int angkatan = 0;
  String email = "";
  String eventName = "";
  String fakultas = "";
  String fileCV = "";
  String fileLOC = "";
  String jenisKelamin = "";
  String jurusan = "";
  String nama = "";
  String nim = "";
  String pilihanDua = "";
  String pilihanSatu = "";
  int telepon = 0;
  DateTime? tglLahir;

  final _controller = PendaftarController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchEventName();
  }

  Future<void> _fetchEventName() async {
    DocumentSnapshot eventDoc = await FirebaseFirestore.instance
        .collection('event')
        .doc(widget.eventId)
        .get();
    setState(() {
      eventName = eventDoc['namaEvent'] ?? "Nama Event Tidak Ditemukan";
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      PendaftarModel pendaftar = PendaftarModel(
        id: "",
        namaEvent: eventName,
        namaPendaftar: nama,
        emailPendaftar: email,
        telepon: telepon,
        alamat: alamat,
        tglLahir: tglLahir ?? DateTime.now(),
        jenisKelamin: jenisKelamin,
        nim: nim,
        jurusan: jurusan,
        fakultas: fakultas,
        angkatan: angkatan,
        pilihanSatu: pilihanSatu,
        pilihanDua: pilihanDua,
        alasan: alasan,
        fileCV: fileCV,
        fileLOC: fileLOC,
      );

      await _controller.createPendaftar(pendaftar);

      // Notifikasi berhasil
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pendaftaran Berhasil"),
          content: const Text("Data pendaftaran berhasil disimpan."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<String?> _uploadFile(String filePath, String fileName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<void> _pickAndUploadFile(String fileType) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      final url = await _uploadFile(filePath, fileName);
      if (url != null) {
        setState(() {
          if (fileType == "CV") {
            fileCV = url;
          } else if (fileType == "LOC") {
            fileLOC = url;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$fileType berhasil diupload!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengupload $fileType.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Pendaftaran"),
        backgroundColor: const Color(0xFF072554),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF072554),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Daftar event: $eventName",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Event: $eventName",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Nama
              TextFormField(
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (value) => value == null || value.isEmpty
                    ? "Nama tidak boleh kosong"
                    : null,
                onSaved: (value) => nama = value!,
              ),
              const SizedBox(height: 20),

              // Email
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains("@")
                    ? "Email tidak valid"
                    : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 20),

              // Telepon
              TextFormField(
                decoration: const InputDecoration(labelText: "Telepon"),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? "Telepon tidak boleh kosong"
                    : null,
                onSaved: (value) => telepon = int.parse(value!),
              ),
              const SizedBox(height: 20),

              // Alamat
              TextFormField(
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (value) => value == null || value.isEmpty
                    ? "Alamat tidak boleh kosong"
                    : null,
                onSaved: (value) => alamat = value!,
              ),
              const SizedBox(height: 20),

              // Tanggal Lahir
              TextFormField(
                decoration: const InputDecoration(labelText: "Tanggal Lahir"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tglLahir = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: tglLahir != null
                      ? DateFormat('dd MMM yyyy').format(tglLahir!)
                      : "",
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown Jenis Kelamin
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                items: const [
                  DropdownMenuItem(
                      value: "Laki-Laki", child: Text("Laki-Laki")),
                  DropdownMenuItem(
                      value: "Perempuan", child: Text("Perempuan")),
                ],
                onChanged: (value) => jenisKelamin = value!,
              ),
              const SizedBox(height: 20),

              // NIM
              TextFormField(
                decoration: const InputDecoration(labelText: "NIM"),
                validator: (value) => value == null || value.isEmpty
                    ? "NIM tidak boleh kosong"
                    : null,
                onSaved: (value) => nim = value!,
              ),
              const SizedBox(height: 20),

              // Jurusan
              TextFormField(
                decoration: const InputDecoration(labelText: "Jurusan"),
                validator: (value) => value == null || value.isEmpty
                    ? "Jurusan tidak boleh kosong"
                    : null,
                onSaved: (value) => jurusan = value!,
              ),
              const SizedBox(height: 20),

              // Fakultas
              TextFormField(
                decoration: const InputDecoration(labelText: "Fakultas"),
                validator: (value) => value == null || value.isEmpty
                    ? "Fakultas tidak boleh kosong"
                    : null,
                onSaved: (value) => fakultas = value!,
              ),
              const SizedBox(height: 20),

              // Angkatan
              TextFormField(
                decoration: const InputDecoration(labelText: "Angkatan"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? "Angkatan harus berupa angka"
                        : null,
                onSaved: (value) => angkatan = int.parse(value!),
              ),
              const SizedBox(height: 20),

              // Dropdown Pilihan 1
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pilihan 1"),
                items: const [
                  DropdownMenuItem(value: "Acara", child: Text("Acara")),
                  DropdownMenuItem(value: "Humas", child: Text("Humas")),
                  DropdownMenuItem(value: "ATP", child: Text("ATP")),
                  DropdownMenuItem(value: "Konsumsi", child: Text("Konsumsi")),
                  DropdownMenuItem(
                      value: "Medis/P3K", child: Text("Medis/P3K")),
                  DropdownMenuItem(
                      value: "Sponsorship", child: Text("Sponsorship")),
                  DropdownMenuItem(
                      value: "Keamanan/Lapangan",
                      child: Text("Keamanan/Lapangan")),
                  DropdownMenuItem(value: "PDD", child: Text("PDD")),
                  DropdownMenuItem(
                      value: "Sekretaris", child: Text("Sekretaris")),
                  DropdownMenuItem(
                      value: "Bendahara", child: Text("Bendahara")),
                ],
                validator: (value) => value == null || value.isEmpty
                    ? "Pilihan 1 tidak boleh kosong"
                    : null,
                onChanged: (value) => pilihanSatu = value!,
              ),
              const SizedBox(height: 20),

              // Dropdown Pilihan 2
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pilihan 2"),
                items: const [
                  DropdownMenuItem(value: "Acara", child: Text("Acara")),
                  DropdownMenuItem(value: "Humas", child: Text("Humas")),
                  DropdownMenuItem(value: "ATP", child: Text("ATP")),
                  DropdownMenuItem(value: "Konsumsi", child: Text("Konsumsi")),
                  DropdownMenuItem(
                      value: "Medis/P3K", child: Text("Medis/P3K")),
                  DropdownMenuItem(
                      value: "Sponsorship", child: Text("Sponsorship")),
                  DropdownMenuItem(
                      value: "Keamanan/Lapangan",
                      child: Text("Keamanan/Lapangan")),
                  DropdownMenuItem(value: "PDD", child: Text("PDD")),
                  DropdownMenuItem(
                      value: "Sekretaris", child: Text("Sekretaris")),
                  DropdownMenuItem(
                      value: "Bendahara", child: Text("Bendahara")),
                ],
                validator: (value) => value == null || value.isEmpty
                    ? "Pilihan 2 tidak boleh kosong"
                    : null,
                onChanged: (value) => pilihanDua = value!,
              ),
              const SizedBox(height: 20),

              // Alasan
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Alasan Mendaftar"),
                validator: (value) => value == null || value.isEmpty
                    ? "Alasan tidak boleh kosong"
                    : null,
                onSaved: (value) => alasan = value!,
              ),
              const SizedBox(height: 20),

              // File CV Upload
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickAndUploadFile("CV"),
                    child: const Text("Upload File CV"),
                  ),
                  const SizedBox(width: 10),
                  Text(fileCV.isEmpty ? "Belum ada file" : "File CV diunggah"),
                ],
              ),
              const SizedBox(height: 20),

              // File LOC Upload
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickAndUploadFile("LOC"),
                    child: const Text("Upload File LOC"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                      fileLOC.isEmpty ? "Belum ada file" : "File LOC diunggah"),
                ],
              ),
              const SizedBox(height: 20),

              // (Submit button and other fields below...)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        label: const Text("Daftar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.save, color: Colors.white),
        backgroundColor: const Color(0xFF072554),
      ),
    );
  }
}
