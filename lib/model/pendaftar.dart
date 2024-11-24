class Pendaftar{
  int? pendaftarId;
  String nama;
  String email;
  DateTime tglLahir;
  int? telpon;
  String alamat;
  String jenisKelamin;
  String nim;
  String jurusan;
  String fakultas;
  String angkatan;
  String pilihan1;
  String alasan1;
  String pilihan2;
  String alasan2;
  String filecv;
  String fileloc;
  int? eventId;

  Pendaftar({
    required this.pendaftarId,
    required this.nama,
    required this.email,
    required this.tglLahir,
    required this.telpon,
    required this.alamat,
    required this.jenisKelamin,
    required this.nim,
    required this.jurusan,
    required this.fakultas,
    required this.angkatan,
    required this.pilihan1,
    required this.alasan1,
    required this.pilihan2,
    required this.alasan2,
    required this.filecv,
    required this.fileloc,
    required this.eventId,
  });

  /*
   
  e.g. map <---> pendaftar

  {
    'id': 1,
    'nama_pendaftar': 'hello'
  }

  Pendaftar{
    id: 1,
    nama_pendaftar: 'hello'
  }

  */

  //map -> pendaftar
  factory Pendaftar.fromMap(Map<String, dynamic> map){
    return Pendaftar(
      pendaftarId: map['pendaftarId'] as int,
      nama: map['nama'] as String,
      email: map['email'] as String,
      tglLahir: map['tglLahir'] as DateTime,
      telpon: map['telpon'] as int,
      alamat: map['alamat'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      nim: map['nim'] as String,
      jurusan: map['jurusan'] as String,
      fakultas: map['fakultas'] as String,
      angkatan: map['angkatan'] as String,
      pilihan1: map['pilihan1'] as String,
      alasan1: map['alasan1'] as String,
      pilihan2: map['pilihan2'] as String,
      alasan2: map['alasan2'] as String,
      filecv: map['filecv'] as String,
      fileloc: map['fileloc'] as String,
      eventId: map['eventId'] as int,
    );
  }

  //pendaftar -> map
  Map<String, dynamic> toMap(){
    return{
      'nama': nama,
      'email' : email,
      'tglLahir' : tglLahir,
      'telpon' : telpon,
      'alamat' : alamat,
      'jenisKelamin' : jenisKelamin,
      'nim' : nim,
      'jurusan' : jurusan,
      'fakultas' : fakultas,
      'angkatan' : angkatan,
      'pilihan1' : pilihan1,
      'alasan1' : alasan1,
      'pilihan2' : pilihan2,
      'alasan2' : alasan2,
      'filecv' : filecv,
      'fileloc' : fileloc,
      'eventId' : eventId,
    };
  }

}
