
import 'package:flutter/material.dart';
import 'package:pcos_app/controller/map_provider.dart';
import 'package:provider/provider.dart';

class MapFavorite extends StatelessWidget {
  final String name;

  const MapFavorite({super.key, required this.name});



  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return IconButton(
      icon: Icon(
        favoriteProvider.isFavorite(name)
            ? Icons.favorite
            : Icons.favorite_border_outlined,
      ),
      onPressed: () {
        if (favoriteProvider.isFavorite(name)) {
          favoriteProvider.removeFavorite(name);
        } else {
          favoriteProvider.addFavorite(name);
        }
      },
      iconSize: 50,
      color: const Color(0xFFF16A6E),
    );
  }
}


