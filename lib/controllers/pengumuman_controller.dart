import 'dart:io';

import 'package:sirek/models/event_model.dart';
import 'package:sirek/models/pengumuman_model.dart';

class PengumumanController {
  final EventRepository _eventRepository = EventRepository();
  final PengumumanRepository _repository = PengumumanRepository();

  Future<List<PengumumanModel>> getAllPengumuman() async {
    return await _repository.fetchAllPengumuman();
  }

  // Fetch all events
  Future<List<EventModel>> getEventList() async {
    return await _eventRepository.fetchAllEvents();
  }

  Future<void> createPengumuman(
      PengumumanModel pengumuman, File? pengumumanFile) async {
    await _repository.createPengumumanWithFiles(pengumuman, pengumumanFile);
  }

  Future<void> updatePengumuman(String id, PengumumanModel pengumuman) async {
    await _repository.updatePengumuman(id, pengumuman);
  }

  Future<void> deletePengumuman(String id) async {
    await _repository.deletePengumuman(id);
  }
}
