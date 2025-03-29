class Peminjaman {
  final int id;
  final int? id_user;
  final int? id_buku;
  final String? tanggalPinjam;
  final String? tanggalKembali;
  final int? jumlah;
  final String? status;
  final String? name;
  final String? judul;
  final String? gambar;

  Peminjaman({required this.id, this.id_user, this.id_buku, this.tanggalPinjam, this.tanggalKembali, this.jumlah, this.status, this.name, this.judul, this.gambar});

  factory Peminjaman.fromJson(Map<String, dynamic> json){
    return Peminjaman(
      id: json['id'],
      id_user: json['id_user'],
      id_buku: json['id_buku'],
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
      'id_user': id_user,
      'id_buku': id_buku,
      'tgl_pinjam': tanggalPinjam,
      'tgl_kembali': tanggalKembali,
      'jumlah': jumlah,
    };
  }
}
