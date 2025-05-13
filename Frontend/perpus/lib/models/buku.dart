class Buku {
  final int id; //objek yg di kembalikan atw di buat akan di simpan di variabel ini
  final String? gambar;
  final String judul;
  final String penulis;
  final int stok;

  Buku({required this.id, this.gambar, required this.judul, required this.penulis, required this.stok}); //construktor utk membuat objek |digunakan seperti create, update

  factory Buku.fromJson(Map<String, dynamic> json){ //factory named construktor yg digunakan untuk mengembalikan objek yg sudah ada| digunakan utk mengembalikan objek dari api service
    return Buku(
      id: json['id'],
      gambar: json['gambar'],
      judul: json['judul'],
      penulis: json['penulis'],
      stok: json['stok'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'gambar': gambar,
      'judul': judul,
      'penulis': penulis,
      'stok': stok,
    };
  }
}
