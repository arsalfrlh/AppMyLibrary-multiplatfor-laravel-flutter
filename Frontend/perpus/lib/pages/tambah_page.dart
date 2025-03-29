import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/services/api_service.dart';

class TambahPage extends StatefulWidget {
  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  ApiService apiService = ApiService();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penulisController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final ImagePicker pilih = ImagePicker();
  XFile? gambar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'), backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey,
              child: Icon(Icons.broken_image),
            ),
            ElevatedButton(onPressed: () async{
              gambar = await pilih.pickImage(source: ImageSource.gallery);
              if(gambar != null){
                //gambar berhasil dipilih
              }
            }, child: Text('Pilih Gambar')),
            TextField(controller: judulController, decoration: InputDecoration(labelText: 'Judul')),
            TextField(controller: penulisController, decoration: InputDecoration(labelText: 'Penulis')),
            TextField(controller: stokController, decoration: InputDecoration(labelText: 'Stok')),
            ElevatedButton(onPressed: (){
              final newBuku = Buku(
                id: 0,
                judul: judulController.text,
                penulis: penulisController.text,
                stok: int.parse(stokController.text),
              );
              apiService.addBuku(newBuku, gambar);
              Navigator.pop(context);
            }, child: Text('Simpan'))
          ],
        ),
      ),
    );
  }
}
