import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PendaftarModel {
  String id;
  String namaEvent;
  String namaPendaftar;
  String emailPendaftar;
  int telepon;
  String alamat;
  DateTime tglLahir;
  String jenisKelamin;
  String nim;
  String jurusan;
  String fakultas;
  int angkatan;
  String pilihanSatu;
  String pilihanDua;
  String alasan;
  String fileCV;
  String fileLOC;

  PendaftarModel({
    required this.id,
    required this.namaEvent,
    required this.namaPendaftar,
    required this.emailPendaftar,
    required this.telepon,
    required this.alamat,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.nim,
    required this.jurusan,
    required this.fakultas,
    required this.angkatan,
    required this.pilihanSatu,
    required this.pilihanDua,
    required this.alasan,
    required this.fileCV,
    required this.fileLOC,
  });

  factory PendaftarModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendaftarModel(
      id: doc.id,
      namaEvent: data['namaEvent'],
      namaPendaftar: data['namaPendaftar'],
      emailPendaftar: data['emailPendaftar'],
      telepon: data['telepon'],
      alamat: data['alamat'],
      tglLahir: (data['tglLahir'] as Timestamp).toDate(),
      jenisKelamin: data['jenisKelamin'],
      nim: data['nim'],
      jurusan: data['jurusan'],
      fakultas: data['fakultas'],
      angkatan: data['angkatan'],
      pilihanSatu: data['pilihanSatu'],
      pilihanDua: data['pilihanDua'],
      alasan: data['alasan'],
      fileCV: data['fileCV'],
      fileLOC: data['fileLOC'],
    );
  }
  
  // Convert EventModel to Map (useful for Firestore operations)
  Map<String, dynamic> toMap() {
    return {
      'namaEvent': namaEvent,
      'namaPendaftar': namaPendaftar,
      'emailPendaftar': emailPendaftar,
      'telepon': telepon,
      'alamat': alamat,
      'tglLahir': tglLahir,
      'jenisKelamin': jenisKelamin,
      'nim': nim,
      'jurusan': jurusan,
      'fakultas': fakultas,
      'angkatan': angkatan,
      'pilihanSatu': pilihanSatu,
      'pilihanDua': pilihanDua,
      'alasan': alasan,
      'fileCV': fileCV,
      'fileLOC': fileLOC,
    };
  }
}

// model/event_model.dart
class PendaftarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch all events
  Future<List<PendaftarModel>> fetchAllPendaftars() async {
    QuerySnapshot snapshot = await _firestore.collection('pendaftar').get();
    return snapshot.docs.map((doc) => PendaftarModel.fromDocument(doc)).toList();
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

  // Create a new event
  Future<void> createPendaftar(PendaftarModel pendaftar) async {
    await _firestore.collection('pendaftar').add(pendaftar.toMap());
  }

  // Update an event
  Future<void> updatePendaftar(String id, PendaftarModel pendaftar) async {
    await _firestore.collection('pendaftar').doc(id).update(pendaftar.toMap());
  }

  // Delete an event
  Future<void> deletePendaftar(String id) async {
    await _firestore.collection('pendaftar').doc(id).delete();
  }
}
