import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uber_shop_app_web_admin/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: 'AIzaSyA1_RnI2n_4awa5wcLUrPQj43dC0Ig4zEI',
              appId: '1:1086554644168:web:b80152115eb670de170ffd',
              messagingSenderId: '1086554644168',
              projectId: 'uber-shop-app-b37fc',
              storageBucket: 'uber-shop-app-b37fc.appspot.com',
            )
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Web Pannel',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
