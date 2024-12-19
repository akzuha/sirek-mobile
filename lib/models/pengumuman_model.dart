import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PengumumanModel {
  PengumumanModel({
    required this.id,
    required this.namaEvent,
    required this.filePengumuman,
    required this.tanggalPengumuman,
    required this.keterangan,
  });

  factory PengumumanModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PengumumanModel(
      id: doc.id,
      namaEvent: data['namaEvent'] ?? '',
      filePengumuman: data['filePengumuman'] ?? '',
      tanggalPengumuman: (data['tanggalPengumuman'] as Timestamp).toDate(),
      keterangan: data['keterangan'] ?? '',
    );
  }

  String filePengumuman;
  String id;
  String keterangan;
  String namaEvent;
  DateTime tanggalPengumuman;

  // Convert EventModel to Map (useful for Firestore operations)
  Map<String, dynamic> toMap() {
    return {
      'namaEvent': namaEvent,
      'filePengumuman': filePengumuman,
      'tanggalPengumuman': tanggalPengumuman,
      'keterangan': keterangan,
    };
  }
}

class PengumumanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<PengumumanModel>> fetchAllPengumuman() async {
    QuerySnapshot snapshot = await _firestore.collection('pengumuman').get();
    return snapshot.docs
        .map((doc) => PengumumanModel.fromDocument(doc))
        .toList();
  }

  // Upload file to Firebase Storage
  Future<String> uploadFile(File file, String folder) async {
    try {
      String fileName = file.path.split('/').last;
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print("Progress upload: ${(progress * 100).toStringAsFixed(2)}%");
      });
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal unggah file: $e');
    }
  }

  Future<void> createPengumuman(
      PengumumanModel pengumuman) async {
    try {
      final createdPengumuman = PengumumanModel(
        id: pengumuman.id,
        namaEvent: pengumuman.namaEvent,
        filePengumuman: pengumuman.filePengumuman,
        keterangan: pengumuman.keterangan,
        tanggalPengumuman: pengumuman.tanggalPengumuman,
      );

      await _firestore.collection('pengumuman').add(createdPengumuman.toMap());
    } catch (e) {
      throw Exception('Gagal membuat pengumuman: $e');
    }
  }

  Future<void> updatePengumuman(
      String id, PengumumanModel pengumuman, File? pengumumanFile) async {
    try {
      String? newPengumumanUrl;

      if (pengumumanFile != null) {
        newPengumumanUrl = await uploadFile(pengumumanFile, 'pengumuman');
        if (pengumuman.filePengumuman.isNotEmpty) {
          await deleteFile(pengumuman.filePengumuman);
        }
      }

      final updatedPengumuman = PengumumanModel(
        id: pengumuman.id,
        namaEvent: pengumuman.namaEvent,
        filePengumuman: newPengumumanUrl ?? pengumuman.filePengumuman,
        tanggalPengumuman: pengumuman.tanggalPengumuman,
        keterangan: pengumuman.filePengumuman,
      );

      await _firestore.collection('event').doc(id).update(updatedPengumuman.toMap());
    } catch (e) {
      throw Exception('Gagal update event: $e');
    }
  }

  // Delete file from Firebase Storage
  Future<void> deleteFile(String url) async {
    try {
      // Extract the file path from URL
      final String path = Uri.parse(url).pathSegments.join('/');
      await _storage.ref(path).delete();
    } catch (e) {
      throw Exception('Gagal hapus file: $e');
    }
  }

  Future<void> deletePengumuman(String id) async {
    await _firestore.collection('pengumuman').doc(id).delete();
  }
}
