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
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> createPengumumanWithFiles(
      PengumumanModel pengumuman, File? pengumumanFile) async {
    try {
      String? filePengumuman;

      if (pengumumanFile != null) {
        filePengumuman = await uploadFile(pengumumanFile, 'pengumuman');
      }

      final updatedEvent = PengumumanModel(
        id: pengumuman.id,
        namaEvent: pengumuman.namaEvent,
        filePengumuman: filePengumuman ?? '',
        keterangan: pengumuman.keterangan,
        tanggalPengumuman: pengumuman.tanggalPengumuman,
      );

      await _firestore.collection('pengumuman').add(updatedEvent.toMap());
    } catch (e) {
      throw Exception('Failed to create pengumuman: $e');
    }
  }

  Future<void> updatePengumuman(String id, PengumumanModel pengumuman) async {
    await _firestore
        .collection('pengumuman')
        .doc(id)
        .update(pengumuman.toMap());
  }

  Future<void> deletePengumuman(String id) async {
    await _firestore.collection('pengumuman').doc(id).delete();
  }
}
