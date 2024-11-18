import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class EditPendaftarPage extends StatefulWidget {
  final String pendaftarName;

  const EditPendaftarPage({super.key, required this.pendaftarName});

  @override
  State<EditPendaftarPage> createState() => _EditPendaftarPageState();
}

class _EditPendaftarPageState extends State<EditPendaftarPage> {
  String? cvFileName;
  String? locFileName;
  DateTime? selectedDate;

  // Fungsi untuk memilih file
  Future<void> pickFile(bool isCv) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Hanya PDF yang diizinkan
    );

    if (result != null) {
      setState(() {
        if (isCv) {
          cvFileName = result.files.single.name;
        } else {
          locFileName = result.files.single.name;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCv
              ? "Hanya file PDF yang diizinkan untuk CV!"
              : "Hanya file PDF yang diizinkan untuk LoC!"),
        ),
      );
    }
  }

  // Fungsi untuk memilih tanggal lahir
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
          "Edit Pendaftar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Nama", initialValue: widget.pendaftarName),
            const SizedBox(height: 16),
            _buildTextField("Email", initialValue: "levi@gmail.com"),
            const SizedBox(height: 16),
            _buildTextField("Telepon", initialValue: "081234567890"),
            const SizedBox(height: 16),
            _buildTextField("Alamat", initialValue: "Kebumen"),
            const SizedBox(height: 16),

            // Tanggal Lahir dengan Date Picker
            const Text("Tanggal Lahir",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "10/10/2003",
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

            _buildDropdownField("Jenis Kelamin", ["Laki-Laki", "Perempuan"]),
            const SizedBox(height: 16),

            // NIM sebagai input field biasa
            _buildTextField("NIM", initialValue: "K1J02104"),
            const SizedBox(height: 16),

            _buildDropdownField("Jurusan", ["Kimia", "Fisika"]),
            const SizedBox(height: 16),
            _buildDropdownField(
                "Fakultas", ["FMIPA", "Fakultas Teknik", "Fakultas Ekonomi"]),
            const SizedBox(height: 16),
            _buildTextField("Angkatan", initialValue: "2021"),
            const SizedBox(height: 16),
            _buildDropdownField("Pilihan 1", ["Bendahara", "Sekretaris"]),
            const SizedBox(height: 16),
            _buildTextField("Alasan 1",
                initialValue: "Karena saya memiliki passion."),
            const SizedBox(height: 16),
            _buildDropdownField("Pilihan 2", ["Ketua", "Sekretaris"]),
            const SizedBox(height: 16),
            _buildTextField("Alasan 2",
                initialValue: "Ingin menambah pengalaman."),
            const SizedBox(height: 16),

            // File CV
            const Text("File CV",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickFile(true),
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text(
                    "Choose File",
                    style: TextStyle(color: Colors.white), // Warna putih
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(cvFileName ?? "No File Chosen"),
              ],
            ),
            const SizedBox(height: 16),

            // File LoC
            const Text("File LoC",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickFile(false),
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text(
                    "Choose File",
                    style: TextStyle(color: Colors.white), // Warna putih
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF072554),
                  ),
                ),
                const SizedBox(width: 10),
                Text(locFileName ?? "No File Chosen"),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Edit Pendaftar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data berhasil diperbarui!"),
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
                  "Edit Pendaftar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTextField(String label, {required String initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: initialValue),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
