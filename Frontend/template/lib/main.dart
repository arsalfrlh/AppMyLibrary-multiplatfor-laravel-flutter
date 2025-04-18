import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/pages/buku_page.dart';
import 'package:template/pages/home_page.dart';
import 'package:template/pages/laporan_page.dart';
import 'package:template/pages/login_page.dart';
import 'package:template/pages/template.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa binding Flutter sudah diinisialisasi sebelum memanggil SharedPreferences
  final key = await SharedPreferences.getInstance();
  final statusLogin = key.getBool('statusLogin') ?? false; //mengambil statusLogin bool di SharedPreferences| jika null maka bool akan bernilai false
  runApp(MyApp(statusLogin: statusLogin,));
}

class MyApp extends StatelessWidget {
  final bool statusLogin;
  MyApp({required this.statusLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template',
      home: statusLogin //variabel bool tadi
      ? HomePage() //jika true akan ke HomePage
      : LoginPage(), //jika false akan ke LoginPage
    );
  }
}
