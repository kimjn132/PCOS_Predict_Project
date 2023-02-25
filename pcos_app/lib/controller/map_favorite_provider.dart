import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> _favorites;
  String uId = FirebaseAuth.instance.currentUser!.uid;

  FavoriteProvider() {
    _favorites = [];
    _firestore.collection('hospital').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        _favorites.add(doc.id);
      }
      notifyListeners();
    });
  }

  bool isFavorite(String name) {
    return _favorites.contains(name);
  }

  void addFavorite(String name) {
    _favorites.add(name);
    _firestore.collection('hospital').doc(name).set({'uId': uId, 'hospital':name});
    notifyListeners();
  }

  void removeFavorite(String name) {
    _favorites.remove(name);
    _firestore.collection('hospital').doc(name).delete();
    notifyListeners();
  }
}