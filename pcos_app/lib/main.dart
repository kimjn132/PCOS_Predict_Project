import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pcos_app/bottom_navigation.dart';
import 'package:pcos_app/controller/map_favorite_provider.dart';
import 'package:pcos_app/firebase_options.dart';
import 'package:pcos_app/view/login/signin_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();

  Get.put(BottomNavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteProvider(),
      child: GetMaterialApp(
        debugShowMaterialGrid: false,
        title: 'PCOS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFFF16A6E)
          )
        ),
        debugShowCheckedModeBanner: false,
        home: const SignInScreen(),
      ),
    );
  }
}
