class Event{
  int? eventId;
  String namaEvent;
  String deskripsi;
  String gambar;

  Event({
    required this.eventId,
    required this.namaEvent,
    required this.deskripsi,
    required this.gambar,
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
  factory Event.fromMap(Map<String, dynamic> map){
    return Event(
      eventId: map['eventId'] as int,
      namaEvent: map['namaEvent'] as String,
      deskripsi: map['deskripsi'] as String,
      gambar: map['gambar'] as String,
    );
  }

  //event -> map
  Map<String, dynamic> toMap(){
    return{
      'namaEvent': namaEvent,
      'deskripsi' : deskripsi,
      'gambar' : gambar,
    };
  }

}
