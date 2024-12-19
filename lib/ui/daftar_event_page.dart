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
  final _controller = PendaftarController();
  final _formKey = GlobalKey<FormState>();

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

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pendaftaran Berhasil"),
          content: const Text("Selamat kamu berhasil mendaftar! Silahkan menunggu hingga hasil pengumuman dirilis."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
          FirebaseStorage.instance.ref().child('pendaftar/$fileName');
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
      var filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      final url = await _uploadFile(filePath, fileName);
      if (url != null) {
        setState(() {
          if (fileType == "CV") {
            filePath = 'file CV';
            fileCV = url;
          } else if (fileType == "LOC") {
            filePath = 'file LOC';
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
    return Scaffold(appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF072554),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Form Pendaftaran Event",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar Event $eventName",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Text("Nama",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "Nama tidak boleh kosong"
                    : null,
                onSaved: (value) => nama = value!,
              ),
              const SizedBox(height: 16),

              const Text("Email",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains("@")
                    ? "Email tidak valid"
                    : null,
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),

              const Text("Telepon",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? "Telepon tidak boleh kosong"
                    : null,
                onSaved: (value) => telepon = int.parse(value!),
              ),
              const SizedBox(height: 16),

              const Text("Alamat",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "Alamat tidak boleh kosong"
                    : null,
                onSaved: (value) => alamat = value!,
              ),
              const SizedBox(height: 16),

              const Text("Tanggal Lahir",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
              const SizedBox(height: 16),

              const Text("Jenis Kelamin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "Laki-Laki", child: Text("Laki-Laki")),
                  DropdownMenuItem(
                      value: "Perempuan", child: Text("Perempuan")),
                ],
                onChanged: (value) => jenisKelamin = value!,
              ),
              const SizedBox(height: 16),

              const Text("NIM",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "NIM tidak boleh kosong"
                    : null,
                onSaved: (value) => nim = value!,
              ),
              const SizedBox(height: 16),

              const Text("Jurusan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "Jurusan tidak boleh kosong"
                    : null,
                onSaved: (value) => jurusan = value!,
              ),
              const SizedBox(height: 16),

              const Text("Fakultas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "Fakultas tidak boleh kosong"
                    : null,
                onSaved: (value) => fakultas = value!,
              ),
              const SizedBox(height: 16),

              const Text("Angkatan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? "Angkatan harus berupa angka"
                        : null,
                onSaved: (value) => angkatan = int.parse(value!),
              ),
              const SizedBox(height: 16),

              const Text("Pilihan 1",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 16),

              const Text("Pilihan 2",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 16),

              const Text("Alasan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? "Alasan tidak boleh kosong"
                    : null,
                onSaved: (value) => alasan = value!,
              ),
              const SizedBox(height: 16),

              const Text("File LOC",
                style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUploadFile("CV"),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Pilih File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(fileCV.isEmpty ? "Belum ada file" : "File CV diunggah")),
                ],
              ),
              const SizedBox(height: 16),

              const Text("File LOC",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUploadFile("LOC"),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Pilih File",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072554)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        fileLOC.isEmpty ? "Belum ada file" : "File LOC diunggah"),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
