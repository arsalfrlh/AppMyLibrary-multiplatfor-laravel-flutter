class Buku {
  final int id; //variabel dalam class
  final String? gambar;
  final String judul;
  final String penulis;
  final int stok;

  Buku({required this.id, this.gambar, required this.judul, required this.penulis, required this.stok}); //jika ingin menggunakan variable dlm class ke construktor/function harus menggunakan this

  factory Buku.fromJson(Map<String, dynamic> json){
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
      'id': id,
      'judul':judul,
      'penulis': penulis,
      'stok': stok,
    };
  }
}
