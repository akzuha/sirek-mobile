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
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Delete file from Firebase Storage
  Future<void> deleteFile(String url) async {
    try {
      // Extract the file path from URL
      final String path = Uri.parse(url).pathSegments.skip(1).join('/');
      await _storage.ref(path).delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Create a new event
  Future<void> createEventWithFiles(
      EventModel event, File? imageFile, File? bookletFile) async {
    try {
      String? imageUrl;
      String? bookletUrl;

      if (imageFile != null) {
        imageUrl = await uploadFile(imageFile, 'event/logo');
      }

      if (bookletFile != null) {
        bookletUrl = await uploadFile(bookletFile, 'event/booklet');
      }

      final updatedEvent = EventModel(
        id: event.id,
        namaEvent: event.namaEvent,
        gambar: imageUrl ?? '',
        booklet: bookletUrl ?? '',
        openRec: event.openRec,
        closeRec: event.closeRec,
        deskripsi: event.deskripsi,
      );

      await _firestore.collection('event').add(updatedEvent.toMap());
    } catch (e) {
      throw Exception('Failed to create event: $e');
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
        newImageUrl = await uploadFile(imageFile, 'images');
        if (event.gambar.isNotEmpty) {
          await deleteFile(event.gambar);
        }
      }

      if (bookletFile != null) {
        // Upload new booklet and delete the old one if exists
        newBookletUrl = await uploadFile(bookletFile, 'booklets');
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
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete an event
  Future<void> deleteEventWithFiles(String id, EventModel event) async {
    try {
      // Delete associated files from Firebase Storage
      if (event.gambar.isNotEmpty) {
        await deleteFile(event.gambar);
      }

      if (event.booklet.isNotEmpty) {
        await deleteFile(event.booklet);
      }

      // Delete the event document from Firestore
      await _firestore.collection('event').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
