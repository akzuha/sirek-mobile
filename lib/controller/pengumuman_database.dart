import 'package:sirek/model/pengumuman.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengumumanDatabase {
  //Database -> pengumuman
  final database = Supabase.instance.client.from('pengumuman');

  //Create
  Future createdPengumuman(Pengumuman newPengumuman) async {
    await database.insert(newPengumuman.toMap());
  }

  //Read
  final stream = Supabase.instance.client.from('pengumuman').stream(
    primaryKey: ['pengumumanId'],
  ).map((data) => data.map((pengumumanMap) => Pengumuman.fromMap(pengumumanMap)).toList());

  //Update
  Future updatePengumuman(Pengumuman oldPengumuman, String newContent) async {
    await database.update({'content': newContent}).eq('pengumumanId', oldPengumuman.pengumumanId!);
  }

  //Delete
  Future deletePengumuman(Pengumuman pengumuman) async{
    await database.delete().eq('pengumumanId', pengumuman.pengumumanId!);
  }
}