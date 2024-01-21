class Lazy_load {
  String id;
  String username;
  String header;
  String deskripsi; 
  String tanggal;   
  int suka;         
  List<String> gambar;       
  int totalKomentar;          
  List<Map<String, dynamic>> komentar;  

  Lazy_load({
    required this.id,
    required this.username,
    required this.header,
    required this.deskripsi,
    required this.tanggal,
    required this.suka,
    required this.gambar,
    required this.totalKomentar,
    required this.komentar,
  });

  factory Lazy_load.fromJson(Map<String, dynamic> json) {
    return Lazy_load(
      id: json['id'],
      username: json['username'],
      header: json['header'],
      deskripsi: json['deskripsi'],
      tanggal: json['tanggal'],
      suka: json['suka'],
      gambar: List<String>.from(json['gambar']),
      totalKomentar: json['totalKomentar'],
      komentar: List<Map<String, dynamic>>.from(json['komentar']),
    );
  }
}
