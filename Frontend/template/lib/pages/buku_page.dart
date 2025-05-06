import 'package:flutter/material.dart';
import 'package:template/models/user.dart';
import 'package:template/pages/book_page.dart';
import 'package:template/pages/cari_page.dart';
import 'package:template/pages/home_page.dart';
import 'package:template/pages/peminjaman_page.dart';
import 'package:template/pages/pinjam_page.dart';
import 'package:template/pages/tambah_page.dart';
import 'package:template/pages/update_page.dart';
import 'package:template/services/api_service.dart';
import 'package:template/models/buku.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final ApiService apiService = ApiService();
  final cariController = TextEditingController();
  List<Buku> bukuList = [];
  bool isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    fetchBuku();
    fetchUser();
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

  void fetchUser()async{
    User? user = await apiService.getUser();
    setState(() {
      _user = user;
    });
  }

  void _deleteBuku(int id) async{
    await apiService.deleteBuku(id).then((_) { //saat berhasil menjalankan function deleteBuku di class api_service maka akan memanggil function fetchBuku dan menampilkan pesan
      fetchBuku();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menghapus buku'), backgroundColor: Colors.red,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        backgroundColor: Colors.blue,
        actions: [
          SizedBox( //membuat sebuah box yg akan di isi textfield
            width: 60,
            height: 40,
            child: TextField(controller: cariController, decoration: InputDecoration(hintText: 'Search'), onSubmitted: (value){ //saat di enter maka akan mengarahkan ke tampilan CariPage
                Navigator.push(context, MaterialPageRoute(builder: (context) => CariPage(cari: cariController.text))).then((_) => fetchBuku());
            },),
          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PeminjamanPage(id_user: _user!.id))); //saat di klik akan mengarahkan ke tampilan peminjaman user
          }, icon: Icon(Icons.backpack)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahPage()),
              ).then((_) => fetchBuku());
            },
            icon: Icon(Icons.add),
          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage()));
          }, icon: Icon(Icons.book))
        ],
      ),
      body: _user == null
      ? Center(child: CircularProgressIndicator())
      : RefreshIndicator(
        onRefresh: fetchBuku,
        child: isLoading
          ? Center(child: CircularProgressIndicator()) //jika tidak ada data api akan menampilkan refres
          : Padding( //jika ada akan menampilkan data yg dibungkus padding
              padding: const EdgeInsets.all(16), //posisi hp horizontal
              child: GridView.builder( //menggunakan GridView.builder cara kerjanya sama seperti ListView.builder
                itemCount: bukuList.length, //akan menampilkan jumlah data sebanyak yang ada di api
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => BukuCard( //isi itemBuilder akan memanggil class BukuCard beserta construktornya yg digunakan utk class tersebut| contohnya sama seperti UpdatePage yg pernah saya buat
                  buku: bukuList[index], //isi construktor buku ini menympan data buku yg sudah di panggil class Api_Service dan dimasukan kedalam itemCount dan GridView.builder| contohnya sama seperti final buku = bukuList[index] yg pernah dibuat sebelumnya
                  onDelete: () => _deleteBuku(bukuList[index].id), //isi construktor ini akan memanggil function _deletebuku dan parameter si id buku yg di simpan di variabel bukuList[index].id
                  onUpdate: () { //isi construktor ini akan mengarahkan ke halaman UpdatePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePage(buku: bukuList[index]), //di class UpdatePage ini membutuhkan data buku(bukuList[index]) yg akan dimasukkan ke dalam class buku jika sudah di tampilan UpdatePage
                      ),
                    ).then((_) => fetchBuku());
                  },
                  onPinjam: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PinjamPage(buku: bukuList[index],)));
                  },
                ),
              ),
            ),
      )
      
    );
  }
}

class BukuCard extends StatelessWidget {
  final Buku buku; //membuat variabel class Buku| isinya akan di ambil dari itemBuilder dari atas
  final VoidCallback onDelete; //membuat variabel untuk memanggil kembali si function| isinya akan di ambil dari itemBuilder dari atas
  final VoidCallback onUpdate;
  final VoidCallback onPinjam;

  const BukuCard({ //construktor untuk bisa mengakses class BukuCard membutuhkan parameter yg dibawah
    required this.buku,
    required this.onDelete,
    required this.onUpdate,
    required this.onPinjam,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPinjam, //jika kita mengklik salah satu buku akan memanggil aksi
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
              child: buku.gambar != null
                  ? Image.network(
                      'http://10.0.2.2:8000/images/${buku.gambar}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    )
                  : Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            buku.judul,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stok: ${buku.stok}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF7643),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onUpdate, //saat di klik tanda edit akan memanngil function CallBack dari itemBuilder di atas
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete), //saat di klik tanda edit akan memanngil function CallBack dari itemBuilder di atas
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
