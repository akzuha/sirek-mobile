import 'dart:io';
import 'package:sirek/models/pendaftar_model.dart';

class PendaftarController {
  final PendaftarRepository _pendaftarRepository = PendaftarRepository();

  Future<String> uploadFile(File file, String folder) async {
    return await _pendaftarRepository.uploadFile(file, folder);
  }

  Future<List<PendaftarModel>> getAllPendaftars() async {
    return await _pendaftarRepository.fetchAllPendaftars();
  }

  Future<void> createPendaftar(PendaftarModel pendaftar) async {
    await _pendaftarRepository.createPendaftar(pendaftar);
  }

  Future<void> updatePendaftar(String id, PendaftarModel pendaftar) async {
    await _pendaftarRepository.updatePendaftar(id, pendaftar);
  }

  Future<void> deletePendaftar(String id) async {
    await _pendaftarRepository.deletePendaftar(id);
  }
}
