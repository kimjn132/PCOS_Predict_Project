import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pcos_app/model/login/userInfo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> _favorites;
  final String userId = UserInfoStatic.userId;

  FavoriteProvider() {
    _favorites = [];
    _firestore.collection('hospital').where('userId', isEqualTo: userId).get().then((snapshot) {
      for (var doc in snapshot.docs) {
        _favorites.add(doc.data()['hospital']);
      }
      notifyListeners();
    });
  }

  bool isFavorite(String name) {
    return _favorites.contains(name);
  }

  void addFavorite(String name) {
    _favorites.add(name);
    _firestore.collection('hospital').doc().set({'userId': userId, 'hospital':name});
    notifyListeners();
  }

  void removeFavorite(String name, String userId) {
    _favorites.remove(name);
    _firestore.collection('hospital').doc('$userId-$name').delete();
    notifyListeners();
  }

  List<String> get hospitalList => _favorites;


  // logout 하고 다시 다른 계정으로 로그인 했을 때 새롭게 해당 유저의 병원 리스트만 불러오기 위함 (안 그러면 이전 유저의 리스트를 불러옴) = 캐시 삭제 
  // 추후 로그아웃에 반영 예정
  void clearFavorites() {
    _favorites = [];
    notifyListeners();
  }


  

}