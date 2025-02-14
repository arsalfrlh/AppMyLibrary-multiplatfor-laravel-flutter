import 'package:flutter/material.dart';
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:perpustakaan/pages/detail_page.dart';
import 'package:perpustakaan/services/api_service.dart';

class PeminjamanPage extends StatefulWidget {
  final int id;
  PeminjamanPage({required this.id});

  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final ApiService apiService = ApiService();
  List<Peminjaman> peminjamanList = [];
  bool isLoading = false;
  late String _status;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  Future<void> fetchPeminjaman() async {
    setState(() {
      isLoading = true;
    });
    peminjamanList = await apiService.getAllPeminjaman(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Peminjaman'),
          backgroundColor: Colors.blue,
        ),
        body: RefreshIndicator(
          onRefresh: fetchPeminjaman,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: peminjamanList.length,
                  itemBuilder: (context, index) {
                    final peminjaman = peminjamanList[index];
                    if (peminjaman.status == 'konfirmasi') {
                      _status = 'Peminjaman anda sedang di proses mohon tunggu konfirmasi';
                    } else if (peminjaman.status == 'disetujui') {
                      _status = 'Peminjaman anda telah disetujui';
                    } else if (peminjaman.status == 'ditolak') {
                      _status = 'Peminjaman anda telah ditolak';
                    } else {
                      _status = 'Peminjaman anda telah dikembalikan';
                    }
                    return ListTile(
                      leading: peminjaman.gambar != null
                          ? Image.network(
                              'http://10.0.2.2:8000/images/${peminjaman.gambar}',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, StackTrace) =>
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey,
                                    child: Icon(Icons.broken_image),
                                  ))
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: Icon(Icons.image_not_supported),
                            ),
                      title: Text('judul: ${peminjaman.judul}'),
                      subtitle: Text('$_status'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(peminjaman: peminjaman))).then((_) => fetchPeminjaman());
                          }, icon: Icon(Icons.info))
                        ],
                      ),
                    );
                  }),
        ));
  }
}
