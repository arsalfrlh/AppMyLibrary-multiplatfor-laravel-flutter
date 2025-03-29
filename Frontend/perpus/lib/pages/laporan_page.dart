import 'package:flutter/material.dart';
import 'package:perpustakaan/services/api_service.dart';
import 'package:perpustakaan/models/peminjaman.dart';

class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final ApiService apiService = ApiService();
  List<Peminjaman> laporanList = [];
  bool isLoading = false;
  late String _status;

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    setState(() {
      isLoading = true;
    });
    laporanList = await apiService.getAllLaporan();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Peminjaman'),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: fetchLaporan,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: laporanList.length,
                itemBuilder: (context, index) {
                  final laporan = laporanList[index];
                  if (laporan.status == 'konfirmasi') {
                    _status = 'Konfirmsi Peminjaman';
                  } else if (laporan.status == 'disetujui') {
                    _status = 'Peminjaman telah anda setujui';
                  } else if (laporan.status == 'ditolak') {
                    _status = 'Peminjaman telah anda tolak';
                  } else {
                    _status = 'Peminjan telah dikembalikan';
                  }
                  return ListTile(
                    leading: laporan.gambar != null
                        ? Image.network(
                            'http://10.0.2.2:8000/images/${laporan.gambar}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey,
                                    child: Icon(Icons.broken_image)))
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          ),
                    title: Text(
                        'judul: ${laporan.judul}, Nama Peminjam: ${laporan.name}'),
                    subtitle: Text('$_status'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        laporan.status == 'konfirmasi'
                        ? ElevatedButton(onPressed: () async{
                          await apiService.setujuiPeminjaman(laporan.id).then((_) => fetchLaporan());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Peminjaman telah anda setujui')));
                        }, child: Icon(Icons.add_task))
                        :Text(''),
                        laporan.status == 'konfirmasi'
                        ? ElevatedButton(onPressed: () async{
                          await apiService.tolakPeminjaman(laporan.id).then((_) => fetchLaporan());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Peminjaman telah anda tolak')));
                        }, child: Icon(Icons.cancel))
                        :Text(''),
                        ElevatedButton(onPressed: ()async{
                          await apiService.deleteLaporan(laporan.id).then((_) => fetchLaporan());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Peminjaman berhasil dihapus')));
                        }, child: Icon(Icons.delete))
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
