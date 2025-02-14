class Peminjaman {
  final int id;
  final int? idUser;
  final int? idBuku;
  final String? tanggalPinjam;
  final String? tanggalKembali;
  final int? jumlah;
  final String? status;
  final String? name;
  final String? judul;
  final String? gambar;

  Peminjaman({required this.id, this.idUser, this.idBuku, this.tanggalPinjam, this.tanggalKembali, this.jumlah, this.status, this.name, this.judul, this.gambar});

  factory Peminjaman.fromJson(Map<String, dynamic> json){
    return Peminjaman(
      id: json['id'],
      idUser: json['id_user'],
      idBuku: json['id_buku'],
      tanggalPinjam: json['tgl_pinjam'],
      tanggalKembali: json['tgl_kembali'],
      jumlah: json['jumlah'],
      status: json['statuspinjam'],
      name: json['user']['name'],
      judul: json['buku']['judul'],
      gambar: json['buku']['gambar'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'id_user': idUser,
      'id_buku': idBuku,
      'tgl_pinjam': tanggalPinjam,
      'tgl_kembali': tanggalKembali,
      'jumlah': jumlah,
    };
  }
}
