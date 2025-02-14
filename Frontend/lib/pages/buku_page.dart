import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/pinjam_page.dart';
import 'package:perpustakaan/pages/tambah_page.dart';
import 'package:perpustakaan/pages/update_page.dart';
import 'package:perpustakaan/services/api_service.dart';
import 'package:perpustakaan/models/buku.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final ApiService apiService = ApiService();
  List<Buku> bukuList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBuku();
  }

  Future<void> fetchBuku() async {
    setState(() {
      isLoading = true;
    });
    bukuList = await apiService.getAllBuku();
    setState(() {
      isLoading = false;
    });
  }

  void _deleteBuku(id) {
    apiService.deleteBuku(id).then((_) {
      fetchBuku();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahPage()),
              ).then((_) => fetchBuku());
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchBuku,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bukuList.length,
                itemBuilder: (context, index) {
                  final buku = bukuList[index];
                  return ListTile(
                    leading: buku.gambar != null
                        ? Image.network(
                            'http://10.0.2.2:8000/images/${buku.gambar}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => //jika response APInya lambat dan error akan menampilkan image dibawah ini
                                Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: Icon(Icons.broken_image),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          ),
                    title: Text(buku.judul),
                    subtitle: Text('Penulis: ${buku.penulis}, stok: ${buku.stok}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push( //navigator yg dapat kembali kehalaman ini
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePage(buku: buku), //mengambil data buku dan menyinpan untuk digunakan halaman update
                                ),
                              ).then((_) => fetchBuku());
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => _deleteBuku(buku.id),
                            icon: Icon(Icons.delete)),
                        IconButton(
                          onPressed: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => PinjamPage(buku: buku)
                                  ),
                                );
                            }, icon: Icon(Icons.add_to_photos_sharp))
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
