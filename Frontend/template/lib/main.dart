import 'package:flutter/material.dart';
import 'package:template/pages/buku_page.dart';
import 'package:template/pages/laporan_page.dart';
import 'package:template/pages/login_page.dart';
import 'package:template/pages/template.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template',
      home: LoginPage(),
    );
  }
}