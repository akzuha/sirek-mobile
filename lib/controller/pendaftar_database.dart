import 'package:sirek/model/pendaftar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PendaftarDatabase {
  //Database -> pendaftar
  final database = Supabase.instance.client.from('pendaftar');

  //Create
  Future createdPendaftar(Pendaftar newPendaftar) async {
    await database.insert(newPendaftar.toMap());
  }

  //Read
  final stream = Supabase.instance.client.from('pendaftar').stream(
    primaryKey: ['pendaftarId'],
  ).map((data) => data.map((pendaftarMap) => Pendaftar.fromMap(pendaftarMap)).toList());

  //Update
  Future updatePendaftar(Pendaftar oldPendaftar, String newContent) async {
    await database.update({'content': newContent}).eq('pendaftarId', oldPendaftar.pendaftarId!);
  }

  //Delete
  Future deletePendaftar(Pendaftar pendaftar) async{
    await database.delete().eq('pendaftarId', pendaftar.pendaftarId!);
  }
}