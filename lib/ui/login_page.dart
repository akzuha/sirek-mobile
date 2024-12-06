import 'package:flutter/material.dart';
import 'package:sirek/auth/auth_service.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({ super.key });

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  //get auth service
  final authService = AuthService();

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    //attempt login
    try{
      await authService.signInWithEmailPassword(email, password);
    }

    //catch any errors
    catch (e){
      if(mounted){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  _showInput(TextEditingController namacontroller, String placeholder, bool isPassword) {
  return TextField(
    controller: namacontroller,
    obscureText: isPassword,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), 
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white), 
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0), 
      ),
      hintText: placeholder,
      hintStyle: const TextStyle(
        color: Colors.white70, 
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    ),
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
                onPressed: login,
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

              ),
            ),  
          ],
        ),
      ),
    );
  }
}