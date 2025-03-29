import 'package:flutter/material.dart';
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
                            final newBuku = Buku(
                              id: 0,
                              judul: judulController.text,
                              penulis: penulisController.text,
                              stok: int.parse(stokController.text),
                            );
                            final response = await apiService.updateBuku(newBuku, widget.buku.id);
                            if(response['sukses'] == true){
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['pesan']), backgroundColor: Colors.green,));
                            }else if(response['sukses'] == false){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['pesan']), backgroundColor: Colors.red,));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server sedang error'), backgroundColor: Colors.red,));
                            }
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
    ;
  }
}
