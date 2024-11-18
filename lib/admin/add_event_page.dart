import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sirek/widgets/admin_bottom_nav.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime? openDate;
  DateTime? closeDate;
  String? imageFileName;
  String? bookletFileName;

  // Fungsi untuk memilih file
  Future<void> pickFile(bool isImage) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isImage ? FileType.custom : FileType.custom,
      allowedExtensions: isImage ? ['png', 'jpg'] : ['pdf'], // Batasan format
    );

    if (result != null) {
      setState(() {
        if (isImage) {
          imageFileName = result.files.single.name;
        } else {
          bookletFileName = result.files.single.name;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isImage
                ? "Hanya file PNG atau JPG yang diizinkan!"
                : "Hanya file PDF yang diizinkan!",
            style: const TextStyle(color: Colors.red),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Event",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Gambar", style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text(imageFileName ?? "No File Chosen"),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Upload File Booklet",
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
                Text(bookletFileName ?? "No File Chosen"),
              ],
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
            const Text("Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text(
                        "Notification",
                        style: TextStyle(color: Colors.green),
                      ),
                      content: const Text(
                        "Event berhasil ditambahkan!",
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF38CC20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("Selesai"),
                          ),
                        ),
                      ],
                    ),
                  );
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
                  "Tambah Event",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const AdminBottomNavBar(currentIndex: 1), // Navbar bawah
    );
  }
}
