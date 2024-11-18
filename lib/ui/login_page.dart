// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sirek/admin/dashboard.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({ super.key });

  @override
  // ignore: library_private_types_in_public_api
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var namauser;

  void _saveemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
  }

  _showInput(namacontroller, placeholder, isPassword){
    return TextField(
      controller: namacontroller,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        hintText: placeholder,
      )
    );
  }

  _showDialog(pesan, alamat){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pesan),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => alamat,
                  ),
                );
              },
            ),
          ],
        );
      }
    );
  }

@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Image.asset(height: MediaQuery.of(context).size.height * 0.06, fit: BoxFit.contain, "images/iconsirek.png"),
        ), 
        backgroundColor: const Color(0xFF072554),
      ),
      backgroundColor: const Color(0xFF072554),
      
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(height: MediaQuery.of(context).size.height * 0.2, fit: BoxFit.contain, "images/logo.png"),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Selamat Datang, \nAdmin/Pimpinan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20,),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text( style: TextStyle(color: Colors.white), "Email"),
            ),

            const SizedBox(height: 10,),

            _showInput(_emailController, 'isi email anda', false),

            const SizedBox(height: 20,),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text( style: TextStyle(color: Colors.white), "Password"),
            ),

            const SizedBox(height: 10,),

            _showInput(_passwordController, 'password', true),

            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6A220),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Center(
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                onPressed: () {
                  if (_emailController.text == 'admin' &&
                    _passwordController.text == 'admin'){
                      _saveemail();
                      _showDialog('Anda berhasil login', const Dashboard());
                  } else {
                      _showDialog('Email atau Password anda salah', const Loginpage());
                  }
                },
              ),
            ),  
          ],
        ),
      ),
    );
  }
}