import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/models/buku.dart';
import 'package:template/models/peminjaman.dart';
import 'dart:convert';

import 'package:template/models/user.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async { //menyimpan data json yg sudah di decode (pesan,sukses,data) kedalam tpie data String| menyimpan data json yg sudah di decode (isi pesan, isi sukses, isi data) kelama tpie data dynamic 
    final response = await http.post(Uri.parse('$baseUrl/perpus/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String alamat, String password)async{
    final response = await http.post(Uri.parse('$baseUrl/perpus/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'email': email, 'alamat': alamat, 'password': password}));
    return json.decode(response.body);
  }

  Future<User?> getUser() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Buku>> getAllBuku()async{
    final response = await http.get(Uri.parse('$baseUrl/perpus/buku'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Buku.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<List<Buku>> cariBuku(dynamic cari)async{ //function cariBuku berisi parameter tipe data dynamic y di simpan di variabel cari
    final response = await http.post(Uri.parse('$baseUrl/perpus/buku/cari'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'cari': cari})); //mengirim data ke url tsb dengan arraykey 'cari' yg di isi dari parameter function
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Buku.fromJson(item)).toList(); //mengembalikan data ke class buku berupa list
  }

  Future<void> logout()async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/perpus/logout'),
    headers: {'Authorization': 'Bearer $token'});
    
    await key.remove('token');
  }
  
  Future<void> addBuku(Buku buku, XFile? gambar)async{
    final request = http.MultipartRequest('POST',Uri.parse('$baseUrl/perpus/buku/tambah'));
    request.fields['judul'] = buku.judul;
    request.fields['penulis'] = buku.penulis;
    request.fields['stok'] = buku.stok.toString();

    if(gambar != null){
      request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }

    await request.send();
  }

  Future<dynamic> updateBuku(Buku buku, int id_buku)async{ //menyimpan data json yg sudah di decode (message, data, sucess) kedalam tipe data dynamic
    final response = await http.put(Uri.parse('$baseUrl/perpus/buku/update/$id_buku'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(buku.toJson()));

    return json.decode(response.body); //mengembalikan data yg sudah di decode dari body api
  }

  Future<void> deleteBuku(int id_buku)async{
    await http.delete(Uri.parse('$baseUrl/perpus/buku/hapus/$id_buku'));
  }

  Future<List<Peminjaman>> getAllPeminjaman(int id_user)async{
    final response = await http.get(Uri.parse('$baseUrl/perpus/peminjaman/$id_user'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Peminjaman.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<dynamic> pinjam(Peminjaman peminjaman, int id_user)async{
    final response = await http.post(Uri.parse('$baseUrl/perpus/peminjaman/pinjam/$id_user'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(peminjaman.toJson()));

    return json.decode(response.body);
  }

  Future<dynamic> pengembalian(Peminjaman peminjaman, int id_pinjam)async{
    final response = await http.put(Uri.parse('$baseUrl/perpus/peminjaman/kembali/$id_pinjam'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(peminjaman.toJson()));

    return json.decode(response.body);
  }

  Future<List<Peminjaman>> getAllLaporan()async{
    final response = await http.get(Uri.parse('$baseUrl/perpus/laporan'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Peminjaman.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<void> disetujui(int id_pinjam)async{
    await http.put(Uri.parse('$baseUrl/perpus/laporan/disetujui/$id_pinjam'));
  }

  Future<void> ditolak(int id_pinjam)async{
    await http.put(Uri.parse('$baseUrl/perpus/laporan/ditolak/$id_pinjam'));
  }

  Future<void>deleteLaporan(int id_pinjam)async{
    await http.delete(Uri.parse('$baseUrl/perpus/laporan/hapus/$id_pinjam'));
  }
}
