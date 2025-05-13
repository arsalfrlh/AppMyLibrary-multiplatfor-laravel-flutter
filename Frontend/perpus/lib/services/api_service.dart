import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:perpustakaan/models/buku.dart';
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:perpustakaan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> register(String name, String email, String alamat, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perpus/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'alamat': alamat,
        'password': password
      }),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perpus/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return json.decode(response.body);
  }

  Future<User?> getUser() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.formJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.post(
      Uri.parse('$baseUrl/perpus/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    await key.remove('token');
  }

  Future<List<Buku>> getAllBuku() async { //function return yg mengembalikan data List<Buku>
    final response = await http.get(Uri.parse('$baseUrl/perpus/buku'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Buku.fromJson(item)).toList(); //ubah item dari json menjadi objek Buku
    } else {
      throw Exception('Data Gagal dimuat');
    }
  }

  Future<void> addBuku(Buku buku, XFile? gambar) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/perpus/buku/tambah'));
    request.fields['judul'] = buku.judul;
    request.fields['penulis'] = buku.penulis;
    request.fields['stok'] = buku.stok.toString();

    if(gambar != null){
      request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }

    await request.send();
  }

  Future<void> updateBuku(int id, Buku buku) async{
    await http.put(Uri.parse('$baseUrl/perpus/buku/update/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(buku.toJson())
    );
  }

  Future<void> deleteBuku(int id) async{
    await http.delete(Uri.parse('$baseUrl/perpus/buku/hapus/$id'));
  }

  Future<List<Peminjaman>> getAllPeminjaman(int id) async{
    final response = await http.get(Uri.parse('$baseUrl/perpus/peminjaman/$id'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Peminjaman.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<void> pinjamBuku(int id, Peminjaman peminjaman)async{
    await http.post(Uri.parse('$baseUrl/perpus/peminjaman/pinjam/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(peminjaman.toJson())
    );
  }

  Future<void> pengembalianBuku(int id, Peminjaman peminjaman)async{
    await http.put(Uri.parse('$baseUrl/perpus/peminjaman/kembali/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(peminjaman.toJson())
    );
  }

  Future<List<Peminjaman>> getAllLaporan() async{
    final response = await http.get(Uri.parse('$baseUrl/perpus/laporan'));
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Peminjaman.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<void>setujuiPeminjaman(int id) async{
    await http.put(Uri.parse('$baseUrl/perpus/laporan/disetujui/$id')
    );
  }

  Future<void>tolakPeminjaman(int id) async{
    await http.put(Uri.parse('$baseUrl/perpus/laporan/ditolak/$id')
    );
  }

  Future<void>deleteLaporan(int id)async{
    await http.delete(Uri.parse('$baseUrl/perpus/laporan/hapus/$id'));
  }
}
