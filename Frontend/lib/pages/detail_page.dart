import 'package:flutter/material.dart';
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:perpustakaan/services/api_service.dart';

class DetailPage extends StatefulWidget {
  final Peminjaman peminjaman;
  DetailPage({required this.peminjaman});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService apiService = ApiService();
  late TextEditingController nameController;
  late TextEditingController judulController;
  late TextEditingController tglpinjamController;
  late TextEditingController tglkembaliController;
  late TextEditingController jumlahController;
  late TextEditingController statusController;
  late String _status;
  DateTime? _pilihtanggal;

  Future<void> pilihtanggal(BuildContext context) async{
    final DateTime? pilih = await showDatePicker(
      context: context,
      initialDate: _pilihtanggal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if(pilih != null && pilih != _pilihtanggal){
      setState(() {
        _pilihtanggal = pilih;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.peminjaman.status == 'konfirmasi'){
      _status = 'Peminjaman sedang diproses mohon tunggu admin';
    }else if(widget.peminjaman.status == 'disetujui'){
      _status = 'Peminjaman anda telah disetujui';
    }else if(widget.peminjaman.status == 'ditolak'){
      _status = 'Peminjaman anda telah ditolak';
    }else{
      _status = 'Peminjaman telah anda kembalikan';
    }
    nameController = TextEditingController(text: widget.peminjaman.name);
    judulController = TextEditingController(text: widget.peminjaman.judul);
    tglpinjamController = TextEditingController(text: widget.peminjaman.tanggalPinjam);
    tglkembaliController = TextEditingController(text: widget.peminjaman.tanggalKembali);
    jumlahController = TextEditingController(text: widget.peminjaman.jumlah.toString());
    statusController = TextEditingController(text: _status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Peminjaman'), backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            widget.peminjaman.gambar != null
            ? Image.network('http://10.0.2.2:8000/images/${widget.peminjaman.gambar}',
            width: 80, 
            height: 80, 
            fit: BoxFit.cover, 
            errorBuilder: (context, error, StackTrace) => 
            Container(
              width: 80,
              height: 80,
              color: Colors.grey,
              child: Icon(Icons.broken_image),
            ))
            : Container(
              width: 80,
              height: 80,
              color: Colors.grey,
              child: Icon(Icons.broken_image),
            ),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nama Peminjam'), readOnly: true),
            TextField(controller: judulController, decoration: InputDecoration(labelText: 'Judul Buku'), readOnly: true),
            TextField(controller: tglpinjamController, decoration: InputDecoration(labelText: 'tanggal Pinjam'), readOnly: true),
            TextField(controller: widget.peminjaman.status == 'konfirmasi' || widget.peminjaman.status == 'ditolak' || widget.peminjaman.status == 'dikembalikan'
            ? tglkembaliController
            : TextEditingController(
              text: _pilihtanggal != null
              ? "${_pilihtanggal!.year}-${_pilihtanggal!.month}-${_pilihtanggal!.day}"
              : "Pilih tanggal kembali",
            ), onTap: () => pilihtanggal(context),
            decoration: InputDecoration(labelText: 'tanggal Kembali'),
            readOnly: widget.peminjaman.status == 'disetujui'
            ? false
            : true,),
            TextField(controller: jumlahController, decoration: InputDecoration(labelText: 'Jumlah Pinjam'), readOnly: true),
            TextField(controller: statusController, decoration: InputDecoration(labelText: 'Status Pinjam'), readOnly: true),
            widget.peminjaman.status == 'disetujui'
              ? ElevatedButton(onPressed: ()async{
                final pengembalianBuku = Peminjaman(
                  id: widget.peminjaman.id,
                  tanggalKembali: _pilihtanggal != null
                  ? "${_pilihtanggal!.year}-${_pilihtanggal!.month}-${_pilihtanggal!.day}"
                  : "",
                  jumlah: int.parse(jumlahController.text),
                );
                await apiService.pengembalianBuku(widget.peminjaman.id, pengembalianBuku);
                Navigator.pop(context);
              }, child: Text('Kembalikan buku'))
              : Text('')
          ],
        ),
      ),
    );
  }
}
