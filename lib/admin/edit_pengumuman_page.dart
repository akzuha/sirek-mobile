import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class EditPengumumanPage extends StatefulWidget {
  const EditPengumumanPage({super.key, required this.pengumumanName});

  final String pengumumanName;

  @override
  State<EditPengumumanPage> createState() => _EditPengumumanPageState();
}

class _EditPengumumanPageState extends State<EditPengumumanPage> {
  String? fileName;
  DateTime? selectedDate = DateTime.now();

  final TextEditingController _keteranganController = TextEditingController(
      text: "Silahkan unduh pengumuman melalui tombol dibawah ini.");

  // Fungsi untuk memilih file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Hanya file PDF yang diizinkan
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
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
              controller: TextEditingController(text: widget.pengumumanName),
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                fillColor: Colors.grey[300], // Warna background untuk readonly
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
                  label: const Text(
                    "Choose File",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(fileName ?? "No File Chosen"),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pengumuman berhasil diperbarui!"),
                    ),
                  );
                  Navigator.pop(context);
                },
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
