import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcos_app/bottom_navigation.dart';
import 'package:pcos_app/tab_bar.dart';

void main() {
  // 탭바 연결 - anna
  Get.put(BottomNavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Tabbar(),
    );
  }
}
