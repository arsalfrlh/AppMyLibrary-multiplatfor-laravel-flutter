import 'package:flutter/material.dart';
import 'package:template/pages/buku_page.dart';
import 'package:template/pages/pengembalian_page.dart';
import 'package:template/services/api_service.dart';
import 'package:template/models/peminjaman.dart';

class PeminjamanPage extends StatefulWidget {
  final int id_user;
  PeminjamanPage({required this.id_user});

  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  ApiService apiService = ApiService();
  List<Peminjaman> peminjamanList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  Future<void> fetchPeminjaman() async {
    setState(() {
      isLoading = true;
    });
    peminjamanList = await apiService.getAllPeminjaman(widget.id_user);
    setState(() {
      isLoading = false;
    });
  }

  void onKembali(Peminjaman peminjaman) async { //menympan data list peminjan yg sudah di atur barisnya kedalam class Peminjaman
    peminjaman!.status == 'disetujui' //jika status peminjamannya disetujui akan mengarahkan ke halaman PengembalianPage
    ? Navigator.push(context, MaterialPageRoute(builder: (context) => PengembalianPage(peminjaman: peminjaman))).then((_) => fetchPeminjaman())
    : showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Detail Peminjaman'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: peminjaman.gambar != null
                    ? Image.network('http://10.0.2.2:8000/images/${peminjaman.gambar}', 
                    errorBuilder:(context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: Icon(Icons.broken_image),
                    ))
                    : Container(color: Colors.grey, child: Icon(Icons.image_not_supported),),
                  ),
                ),
                Text(
                      "Judul: ${peminjaman!.judul}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Peminjam: ${peminjaman!.name}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Jumlah: ${peminjaman!.jumlah}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text( 
                      peminjaman!.tanggalPinjam != null
                      ? "Tanggal Pinjam: ${peminjaman!.tanggalPinjam}"
                      : "Tanngal Pinjam: -",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      peminjaman!.tanggalKembali != null
                      ? "Tanggal Kembali: ${peminjaman!.tanggalKembali}"
                      : "Tanggal Kembali: -",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(peminjaman!.status == 'disetujui')
                    Text(
                      "Peminjaman disetujui",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(peminjaman!.status == 'ditolak')
                    Text(
                      "Peminjaman ditolak",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(peminjaman!.status == 'konfirmasi')
                    Text(
                      "Mohon tunggu kofirmasi",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(peminjaman!.status == 'dikembalikan')
                    Text(
                      "Peminjaman telah dikemabalikan",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ],
            )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Anda'),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: fetchPeminjaman,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                    itemCount: peminjamanList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) => PeminjamanCard(
                          peminjaman: peminjamanList[index],
                          onKembali: () => onKembali(peminjamanList[index]), //akan mengambil data List peminjaman yg sudah di atur barisnya oleh index| dan akan menampilkan alert dialog
                        )),
              ),
      ),
    );
  }
}

class PeminjamanCard extends StatelessWidget {
  final Peminjaman peminjaman;
  final VoidCallback onKembali;

  PeminjamanCard({required this.peminjaman, required this.onKembali});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onKembali,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.02,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF979797).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: peminjaman.gambar != null
                  ? Image.network(
                      'http://10.0.2.2:8000/images/${peminjaman.gambar}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    )
                  : Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${peminjaman!.judul}',
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jumlah: ${peminjaman!.jumlah}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF7643),
                ),
              ),
              Row(
                children: [
                  if (peminjaman!.status == 'konfirmasi')
                    Text(
                      'Status: ${peminjaman!.status}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Color(0xFFFF7643),
                      ),
                    ),
                  if (peminjaman!.status == 'disetujui')
                    Text(
                      'Status: ${peminjaman!.status}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: (Color(0xFFAEEA00)),
                      ),
                    ),
                  if (peminjaman!.status == 'ditolak')
                    Text(
                      'Status: ${peminjaman!.status}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: (Color(0xFFD84315)),
                      ),
                    ),
                  if (peminjaman!.status == 'dikembalikan')
                    Text(
                      'Status: ${peminjaman!.status}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: (Color(0xFF90A4AE)),
                      ),
                    ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
