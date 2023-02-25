import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/controller/map_favorite_provider.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:provider/provider.dart';

class MapLikeExample extends StatelessWidget {
  //final String name;

  const MapLikeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final hospitals = Provider.of<FavoriteProvider>(context).hospitalList;
    final String userId = UserInfoStatic.userId;

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
          foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            title: const Text(
              '좋아요 한 병원',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView.builder(
            key: const ValueKey('hospital_list'),
            itemCount: hospitals.length,
            itemBuilder: (BuildContext context, int index) {
              final record = hospitals[index];
              final isFavorite =
                  Provider.of<FavoriteProvider>(context).isFavorite(record);
              return ListTile(
                title: Text(record),
                trailing: IconButton(
                  icon: isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  onPressed: () {
                    if (isFavorite) {
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .removeFavorite(record, userId);
                    } else {
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .addFavorite(record);
                    }
                  },
                  color: const Color(0xFFF16A6E),
                ),
              );
            },
          )),
    );
  }
}
