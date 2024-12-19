import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel({
    required this.id,
    required this.namaEvent,
    required this.gambar,
    required this.booklet,
    required this.openRec,
    required this.closeRec,
    required this.deskripsi,
  });

  // Convert Firestore document to EventModel
  factory EventModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      namaEvent: data['namaEvent'] ?? '',
      gambar: data['gambar'] ?? '',
      booklet: data['booklet'] ?? '',
      openRec: (data['openRec'] as Timestamp?)?.toDate() ?? DateTime.now(),
      closeRec: (data['closeRec'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deskripsi: data['deskripsi'] ?? '',
    );
  }

  final String booklet;
  final DateTime closeRec;
  final String deskripsi;
  final String gambar;
  final String id;
  final String namaEvent;
  final DateTime openRec;

  // Convert EventModel to Map (useful for Firestore operations)
  Map<String, dynamic> toMap() {
    return {
      'namaEvent': namaEvent,
      'gambar': gambar,
      'booklet': booklet,
      'openRec': openRec,
      'closeRec': closeRec,
      'deskripsi': deskripsi,
    };
  }
}

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch all events
  Future<List<EventModel>> fetchAllEvents() async {
    QuerySnapshot snapshot = await _firestore.collection('event').get();
    return snapshot.docs.map((doc) => EventModel.fromDocument(doc)).toList();
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

  // Delete file from Firebase Storage
  Future<void> deleteFile(String url) async {
    try {
      // Extract the file path from URL
      final String path = Uri.parse(url).pathSegments.skip(1).join('/');
      await _storage.ref(path).delete();
    } catch (e) {
      throw Exception('Gagal hapus file: $e');
    }
  }

  // Create a new event
  Future<void> createEvent(EventModel event) async {
    try {
      // Update data event dengan URL file yang diunggah
      final updatedEvent = EventModel(
        id: event.id,
        namaEvent: event.namaEvent,
        gambar: event.gambar,
        booklet: event.booklet,
        openRec: event.openRec,
        closeRec: event.closeRec,
        deskripsi: event.deskripsi,
      );
      // Simpan ke Firestore
      await _firestore.collection('event').add(updatedEvent.toMap());
    } catch (e) {
      throw Exception('Gagal membuat event. Detail error: ${e.toString()}');
    }
  }

  // Update an event
  Future<void> updateEventWithFiles(
      String id, EventModel event, File? imageFile, File? bookletFile) async {
    try {
      String? newImageUrl;
      String? newBookletUrl;

      if (imageFile != null) {
        // Upload new image and delete the old one if exists
        newImageUrl = await uploadFile(imageFile, 'event/logo');
        if (event.gambar.isNotEmpty) {
          await deleteFile(event.gambar);
        }
      }

      if (bookletFile != null) {
        // Upload new booklet and delete the old one if exists
        newBookletUrl = await uploadFile(bookletFile, 'event/booklet');
        if (event.booklet.isNotEmpty) {
          await deleteFile(event.booklet);
        }
      }

      final updatedEvent = EventModel(
        id: event.id,
        namaEvent: event.namaEvent,
        gambar: newImageUrl ?? event.gambar,
        booklet: newBookletUrl ?? event.booklet,
        openRec: event.openRec,
        closeRec: event.closeRec,
        deskripsi: event.deskripsi,
      );

      await _firestore.collection('event').doc(id).update(updatedEvent.toMap());
    } catch (e) {
      throw Exception('Gagal update event: $e');
    }
  }

  // Delete an event
  Future<void> deleteEventWithFiles(String id) async {
    await _firestore.collection('event').doc(id).delete();
  }
}
