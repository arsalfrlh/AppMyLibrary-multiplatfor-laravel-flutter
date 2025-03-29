import 'package:flutter/material.dart';
import 'package:template/services/api_service.dart';
import 'package:template/models/peminjaman.dart';

class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
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
    peminjamanList = await apiService.getAllLaporan();
    setState(() {
      isLoading = false;
    });
  }

  void showLaporan(Peminjaman peminjaman) async { //menyimpan data list yg sudah di atur barisnya kedalam class Peminjaman
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Detail Peminjaman'),
              content: Column( //Column untuk baris ke bawah| Row untuk baris kesamping| Container seperti kotak
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: peminjaman.gambar != null
                          ? Image.network(
                              'http://10.0.2.2:8000/images/${peminjaman.gambar}',
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey,
                                    child: Icon(Icons.broken_image),
                                  ))
                          : Container(
                              color: Colors.grey,
                              child: Icon(Icons.image_not_supported),
                            ),
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
                  if (peminjaman!.status == 'disetujui')
                    Text(
                      "Peminjaman telah disetujui",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (peminjaman!.status == 'ditolak')
                    Text(
                      "Peminjaman telah ditolak",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (peminjaman!.status == 'konfirmasi')
                    Text(
                      "Konfirmasi Peminjaman",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (peminjaman!.status == 'dikembalikan')
                    Text(
                      "Peminjaman telah dikemabalikan",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Row( //row untuk baris ke samping
                    children: [
                      if (peminjaman.status == 'konfirmasi')
                        IconButton(
                            onPressed: () async {
                              await apiService.disetujui(peminjaman.id).then((_) { 
                                fetchPeminjaman();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda telah menyetujui peminjaman'), backgroundColor: Colors.green,));
                                });
                            },
                            icon: Icon(Icons.add_task)),
                      if (peminjaman.status == 'konfirmasi')
                        IconButton(
                            onPressed: () async {
                              await apiService.ditolak(peminjaman.id).then((_) {
                                fetchPeminjaman();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda telah menolak peminjaman'), backgroundColor: Colors.red,));
                                });
                            },
                            icon: Icon(Icons.cancel)),
                      IconButton(
                          onPressed: () async {
                            await apiService.deleteLaporan(peminjaman.id).then((_) {
                              fetchPeminjaman();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan peminjaman telah anda hapus'), backgroundColor: Colors.red,));
                              });
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color(0xFF00BF6D),
          foregroundColor: Colors.white,
          title: const Text("Daftar Peminjaman"),
        ),
        body: RefreshIndicator(
          onRefresh: fetchPeminjaman,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: peminjamanList.length,
                  itemBuilder: (context, index) => ContactCard(
                    peminjaman: peminjamanList[index],
                    name: peminjamanList[index].name!,
                    judul: peminjamanList[index].judul!,
                    image: peminjamanList[index].gambar,
                    isActive: index.isEven, // for demo
                    press: () => showLaporan(peminjamanList[index]), //akan mengambil data List buku yg sudah di atur barisnya oleh index| dan akan menampilkan alert dialog
                  ),
                ),
        ));
  }
}

class ContactCard extends StatelessWidget {
  ContactCard(
      {super.key,
      required this.name,
      required this.judul,
      this.image,
      required this.isActive,
      required this.press,
      required this.peminjaman});

  Peminjaman peminjaman;
  final String name, judul;
  final String? image;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 / 2),
      onTap: press,
      leading: CircleAvatarWithActiveIndicator(
        image: image,
        isActive: isActive,
        radius: 28,
        peminjaman: peminjaman,
      ),
      title: Text('Judul: $judul'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 16.0 / 2),
        child: Text(
          'Peminjam: $name',
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
    this.isActive,
    required this.peminjaman
  });

  final Peminjaman peminjaman;
  final String? image;
  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage('http://10.0.2.2:8000/images/$image'),
        ),
        if (peminjaman.status == 'disetujui')
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          ),
        if (peminjaman.status == 'ditolak')
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          ),
        if (peminjaman.status == 'dikembalikan')
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          ),
        if (peminjaman.status == 'konfirmasi')
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          ),
      ],
    );
  }
}

final List<String> demoContactsImage = [
  'https://i.postimg.cc/g25VYN7X/user-1.png',
  'https://i.postimg.cc/cCsYDjvj/user-2.png',
  'https://i.postimg.cc/sXC5W1s3/user-3.png',
  'https://i.postimg.cc/4dvVQZxV/user-4.png',
  'https://i.postimg.cc/FzDSwZcK/user-5.png',
];
