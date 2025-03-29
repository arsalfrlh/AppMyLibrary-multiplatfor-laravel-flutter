import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:perpustakaan/models/user.dart';
import 'package:perpustakaan/pages/peminjaman_page.dart';
import 'package:perpustakaan/services/api_service.dart';

class PinjamPage extends StatefulWidget {
  Buku buku;
  PinjamPage({required this.buku});

  @override
  _PinjamPageState createState() => _PinjamPageState();
}

class _PinjamPageState extends State<PinjamPage> {
  User? _user;
  final ApiService apiService = ApiService();

  late TextEditingController judulController;
  late TextEditingController penulisController;
  late TextEditingController jumlahController;
  DateTime? _pilihTanggal;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.buku.judul);
    penulisController = TextEditingController(text: widget.buku.penulis);
    jumlahController = TextEditingController(text: widget.buku.stok.toString());
    fetchUser();
  }

  void fetchUser() async {
    User? user = await apiService.getUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> pilihTanggal(BuildContext context) async{
    final DateTime? pilih = await showDatePicker(
      context: context, 
      initialDate: _pilihTanggal ?? DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101)
      );
      if(pilih != null && pilih != _pilihTanggal){
        setState(() {
          _pilihTanggal = pilih;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pinjam Buku'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            widget.buku.gambar != null
            ? Image.network('http://10.0.2.2:8000/images/${widget.buku.gambar}',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, StackTrace) => 
            Container(
              width: 80,
              height: 80,
              color: Colors.grey,
              child: Icon(Icons.broken_image),
            ),
            )
            : Container(
              height: 80,
              width: 80,
              color: Colors.grey,
              child: Icon(Icons.broken_image),
            ),
            TextField(
                controller: TextEditingController(text: _user!.name),
                readOnly: true,
                decoration: InputDecoration(labelText: 'Nama Peminjam')),
            TextField(
                controller: judulController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Judul Buku')),
            TextField(
                controller: penulisController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Penulis')),
                TextField(
                  controller: TextEditingController(
                    text: _pilihTanggal != null
                    ? "${_pilihTanggal!.year}-${_pilihTanggal!.month}-${_pilihTanggal!.day}"
                    : "Pilih tanggal pinjam",
                    ),
                    onTap: () => pilihTanggal(context),
                    decoration: InputDecoration(labelText: 'Tanggal Pinjam'),
                ),
            TextField(
                controller: jumlahController,
                decoration: InputDecoration(labelText: 'Jumlah Pinjam')),
                
            widget.buku.stok > 0
            ? ElevatedButton(
                 onPressed: () async{
                   final pinjamBuku = Peminjaman(
                     id: 0,
                     idBuku: widget.buku.id,
                     tanggalPinjam: _pilihTanggal != null
                     ? "${_pilihTanggal!.year}-${_pilihTanggal!.month}-${_pilihTanggal!.day}"
                     : "",
                     jumlah: int.parse(jumlahController.text),
                   );
                   await apiService.pinjamBuku(_user!.id, pinjamBuku);
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeminjamanPage(id: _user!.id,)));
                },
                child: Text('Pinjam'))
                : Text("Stok Habis")
          ],
        ),
      ),
    );
  }
}
