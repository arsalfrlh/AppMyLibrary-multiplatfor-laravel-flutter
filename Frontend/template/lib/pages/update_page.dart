import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/models/buku.dart';
import 'package:template/services/api_service.dart';

class UpdatePage extends StatefulWidget {
  Buku buku;
  UpdatePage({required this.buku});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  ApiService apiService = ApiService();
  late TextEditingController judulController;
  late TextEditingController penulisController;
  late TextEditingController stokController;
  final pilih = ImagePicker();
  XFile? gambar;

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
        title: Text('Update Buku'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  widget.buku.gambar != null
                  ? Image.network('http://10.0.2.2:8000/images/${widget.buku.gambar}', height: 100, width: 100, errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.broken_image),
                  ),)
                  : Container(
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
                          onPressed: () async {
                            if(judulController.text.isNotEmpty && penulisController.text.isNotEmpty && stokController.text.isNotEmpty){
                              final editBuku = Buku(
                                id: widget.buku.id,
                                judul: judulController.text,
                                penulis: penulisController.text,
                                stok: int.parse(stokController.text),
                              );
                              await apiService.editBuku(editBuku, gambar).then((_){
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update Buku berhasil'), backgroundColor: Colors.green,));
                              });
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Semua Field tidak boleh kosong'), backgroundColor: Colors.red,));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Update"),
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
    ;
  }
}
