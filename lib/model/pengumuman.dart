class Pengumuman{
  int? pengumumanId;
  String filePengumuman;
  DateTime tglPengumuman;
  String keterangan;
  int? eventId;

  Pengumuman({
    required this.pengumumanId,
    required this.filePengumuman,
    required this.tglPengumuman,
    required this.keterangan,
    required this.eventId,
  });

  /*
   
  e.g. map <---> event

  {
    'id': 1,
    'nama_event': 'hello'
  }

  Event{
    id: 1,
    nama_event: 'hello'
  }

  */

  //map -> event
  factory Pengumuman.fromMap(Map<String, dynamic> map){
    return Pengumuman(
      pengumumanId: map['eventId'] as int,
      filePengumuman: map['namaEvent'] as String,
      tglPengumuman: map['deskripsi'] as DateTime,
      keterangan: map['keterangan'] as String,
      eventId: map['eventId'] as int,
    );
  }

  //event -> map
  Map<String, dynamic> toMap(){
    return{
      'filePengumuman': filePengumuman,
      'tglPengumuman' : tglPengumuman,
      'keterangan' : keterangan,
      'eventId' : eventId,

    };
  }

}
