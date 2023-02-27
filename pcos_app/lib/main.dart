import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pcos_app/bottom_navigation.dart';
import 'package:pcos_app/controller/map_favorite_provider.dart';
import 'package:pcos_app/firebase_options.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:pcos_app/tab_bar.dart';
import 'package:pcos_app/view/login/signin_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "PCOS",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();

  Get.put(BottomNavController());

  FirebaseAuth.instance.authStateChanges().listen((user) async {
    if (user == null) {
    } else {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: user.email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs[0];
        Map<String, dynamic> userData =
            document.data()! as Map<String, dynamic>;
        String? uid = userData['uid'];
        String? userId = userData['userId'];
        String? userNickname = userData['userNickname'];
        UserInfoStatic.uid = uid!;
        UserInfoStatic.userId = userId!;
        UserInfoStatic.userNickname = userNickname!;
        UserInfoStatic.userId = userId;
      }
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return ChangeNotifierProvider(
            create: (_) => FavoriteProvider(),
            child: GetMaterialApp(
              debugShowMaterialGrid: false,
              title: 'PCOS',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                      selectedItemColor: Color(0xFFF16A6E))),
              debugShowCheckedModeBanner: false,
              home: const Tabbar(),
            ),
          );
        } else {
          return ChangeNotifierProvider(
            create: (_) => FavoriteProvider(),
            child: GetMaterialApp(
              debugShowMaterialGrid: false,
              title: 'PCOS',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                      selectedItemColor: Color(0xFFF16A6E))),
              debugShowCheckedModeBanner: false,
              home: const SignInScreen(),
            ),
          );
        }
      },
    );
  }
}
