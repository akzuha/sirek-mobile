import 'dart:io';
import 'package:sirek/models/event_model.dart';
import 'package:sirek/models/pengumuman_model.dart';

class PengumumanController {
  final EventRepository _eventRepository = EventRepository();
  final PengumumanRepository _repository = PengumumanRepository();

  Future<List<PengumumanModel>> getAllPengumuman() async {
    return await _repository.fetchAllPengumuman();
  }

  // Upload File
  Future<String> uploadFile(File file, String folder) async {
    return await _repository.uploadFile(file, folder);
  }

  // Fetch all events
  Future<List<EventModel>> getEventList() async {
    return await _eventRepository.fetchAllEvents();
  }

  Future<void> createPengumuman(
      PengumumanModel pengumuman) async {
    await _repository.createPengumuman(pengumuman);
  }

  Future<void> updatePengumuman(String id, PengumumanModel pengumuman, File? pengumumanFile) async {
    await _repository.updatePengumuman(id, pengumuman, pengumumanFile);
  }

  Future<void> deletePengumuman(String id) async {
    await _repository.deletePengumuman(id);
  }
}
