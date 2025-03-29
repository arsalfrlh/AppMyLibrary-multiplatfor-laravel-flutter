import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/services/api_service.dart';
import 'package:template/models/buku.dart';

class TambahPage extends StatefulWidget {

  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  ApiService apiService = ApiService();
  final judulController = TextEditingController();
  final penulisController = TextEditingController();
  final stokController = TextEditingController();
  final ImagePicker pilih = ImagePicker();
  XFile? gambar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Buku'), backgroundColor: Colors.blue,),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                    child: Icon(Icons.image_not_supported),
                  ),
                  ElevatedButton(onPressed: () async{
                    gambar = await pilih.pickImage(source: ImageSource.gallery);
                  }, child: Text('Pilih Gambar')),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: judulController,
                          decoration: const InputDecoration(
                            hintText: 'Judul',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (phone) {
                            // Save it
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: penulisController,
                            decoration: const InputDecoration(
                              hintText: 'Penulis',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onSaved: (passaword) {
                              // Save it
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: stokController,
                            decoration: const InputDecoration(
                              hintText: 'Stok',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (passaword) {
                              // Save it
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async{
                            final newBuku = Buku(
                              id: 0,
                              judul: judulController.text,
                              penulis: penulisController.text,
                              stok: int.parse(stokController.text),
                            );
                            await apiService.addBuku(newBuku, gambar).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menambahkan data buku'), backgroundColor: Colors.green,));
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Simpan"),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}