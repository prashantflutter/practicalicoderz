import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icoderz_task_example/Pages/HomePage.dart';
import 'package:icoderz_task_example/Pages/SignInPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDRptDGYfcQXeFa9_gcMyitvsx5tnByQH8',
          appId: '1:704646194836:android:dcfd7217cfc13cdd847681',
          messagingSenderId: '704646194836',
          projectId: 'icoderz-solutions-practical')
  ):Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'iCoderz Solutions  Practical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser != null)?HomePage():SignInPage(),
    );
  }
}

