import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icoderz_task_example/Pages/HomePage.dart';
import 'package:icoderz_task_example/Service/FirebaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstant/AppDialogs/AppDialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('SignInPage',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Image.asset('assets/img2.png'),
          Center(
            child: ElevatedButton(onPressed: ()async{
              FirebaseService service = new FirebaseService();
              SharedPreferences preferences = await SharedPreferences.getInstance();
              try {
                await service.signInithGoogle();
                preferences.setInt('TotalAmount', 50000);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));

              } catch(e){
                if(e is FirebaseAuthException){
                  showMessage(message:e.message!, context: context);
                }
              }
            }, child: Text('Login with Google')),
          ),
        ],
      ),
    );
  }
}
