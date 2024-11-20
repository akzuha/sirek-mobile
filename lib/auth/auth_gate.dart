import 'package:flutter/material.dart';
import 'package:sirek/admin/dashboard.dart';
import 'package:sirek/ui/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({ super.key });

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      //listen to auth state change
      stream: Supabase.instance.client.auth.onAuthStateChange, 

      //build appropriate page based on auth state
      builder: (context, snapshot){
        //loading...
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //check if there is valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if(session!= null){
          return const Dashboard();
        } else{
          return const Loginpage();
        }
      },
    );
  }
}