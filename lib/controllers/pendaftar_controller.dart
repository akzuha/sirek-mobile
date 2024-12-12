import 'package:sirek/models/pendaftar_model.dart';

class PendaftarController {
  final PendaftarRepository _eventRepository = PendaftarRepository();

  Future<List<PendaftarModel>> getAllPendaftars() async {
    return await _eventRepository.fetchAllPendaftars();
  }

  Future<void> createPendaftar(PendaftarModel pendaftar) async {
    await _eventRepository.createPendaftar(pendaftar);
  }

  Future<void> updatePendaftar(String id, PendaftarModel pendaftar) async {
    await _eventRepository.updatePendaftar(id, pendaftar);
  }

  Future<void> deletePendaftar(String id) async {
    await _eventRepository.deletePendaftar(id);
  }
}
