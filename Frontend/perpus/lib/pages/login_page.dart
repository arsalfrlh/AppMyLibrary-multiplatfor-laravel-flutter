import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/home_page.dart';
import 'package:perpustakaan/pages/register_page.dart';
import 'package:perpustakaan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _login() async{
    final response = await apiService.login(emailController.text, passwordController.text);
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
        title: Text('Login'), backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage())); //navigator yg menimpa halaman ini dan tidak bisa kembali ke halaman ini
          }, icon: Icon(Icons.person))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true,),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: _login, child: Text('login')),
          ],
        ),
      ),
    );
  }
}
