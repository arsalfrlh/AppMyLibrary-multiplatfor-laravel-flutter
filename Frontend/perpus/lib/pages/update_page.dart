import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/services/api_service.dart';

class UpdatePage extends StatefulWidget {
  final Buku buku;
  UpdatePage({required this.buku}); //untuk masuk ke halaman ini membutuhkan data buku pada halaman buku

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  ApiService apiService = ApiService();
  late TextEditingController judulController;
  late TextEditingController penulisController;
  late TextEditingController stokController;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.buku.judul);
    penulisController = TextEditingController(text: widget.buku.penulis);
    stokController = TextEditingController(text: widget.buku.stok.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Buku'), backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            widget.buku.gambar != null
            ? Image.network('http://10.0.2.2:8000/images/${widget.buku.gambar}',
              width: 80,
              height: 80,
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
                width: 80,
                height: 80,
                color: Colors.grey,
                child: Icon(Icons.broken_image),
            ),
            TextField(controller: judulController, decoration: InputDecoration(labelText: 'Judul')),
            TextField(controller: penulisController, decoration: InputDecoration(labelText: 'Penulis')),
            TextField(controller: stokController, decoration: InputDecoration(labelText: 'Stok')),
            ElevatedButton(onPressed: () async{
              final updateBuku = Buku(
                id: widget.buku.id,
                judul: judulController.text,
                penulis: penulisController.text,
                stok: int.parse(stokController.text),
              );
              await apiService.updateBuku(widget.buku.id, updateBuku);
              Navigator.pop(context); //kembali ke navigator sebelumnya
            }, child: Text('Update'))
          ],
        ),
      ),
    );
  }
}
