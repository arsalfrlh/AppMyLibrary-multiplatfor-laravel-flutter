import 'package:flutter/material.dart';
import 'package:perpustakaan/models/user.dart';
import 'package:perpustakaan/pages/buku_page.dart';
import 'package:perpustakaan/pages/laporan_page.dart';
import 'package:perpustakaan/pages/login_page.dart';
import 'package:perpustakaan/pages/peminjaman_page.dart';
import 'package:perpustakaan/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    User? user = await apiService.getUser();
    setState(() {
      _user = user;
    });
  }

  void _logout() async {
    await apiService.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.blue,
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${_user!.id}', style: TextStyle(fontSize: 20)),
                  Text('Email: ${_user!.email}',
                      style: TextStyle(fontSize: 20)),
                  Text('Nama: ${_user!.name}', style: TextStyle(fontSize: 20)),
                  Text('Alamat: ${_user!.alamat}',
                      style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BukuPage()));
                      },
                      child: Icon(Icons.book)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PeminjamanPage(
                                      id: _user!.id,
                                    )));
                      },
                      child: Icon(Icons.backpack)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LaporanPage()));
                      },
                      child: Icon(Icons.assignment_sharp))
                ],
              ),
            ),
    );
  }
}
