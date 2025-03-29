import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/home_page.dart';
import 'package:perpustakaan/pages/login_page.dart';
import 'package:perpustakaan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _register() async{
    final response = await apiService.register(nameController.text, emailController.text, alamatController.text, passwordController.text);
    if(response['sukses'] == true){
      final key = await SharedPreferences.getInstance();
      await key.setString('token', response['data']['token']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['pesan'])));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['pesan'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'), backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, icon: Icon(Icons.person))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nama Anda')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: alamatController, decoration: InputDecoration(labelText: 'Alamat')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true,),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _register, child: Text('register')),
          ],
        ),
      ),
    );
  }
}
