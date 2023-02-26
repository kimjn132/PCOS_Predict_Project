import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pcos_app/model/login/userInfo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<String> _favorites;


  FavoriteProvider() {
    _favorites = [];
  }


 Stream<List<String>> get hospitalListStream {
    return _firestore
        .collection('hospital')
        .where('userId', isEqualTo: UserInfoStatic.userNickname)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()['name'] as String).toList());
  }


  bool isFavorite(String name) {
    
    return _favorites.contains(name);
  }


  void addFavorite(String name) {
    _favorites.add(name);
    _firestore.collection('hospital').doc().set({'userId': UserInfoStatic.userNickname, 'name':name});
    notifyListeners();
  }


  void removeFavorite(String hospital) {
    _favorites.remove(hospital);
    _firestore.collection('hospital').where('userId', isEqualTo: UserInfoStatic.userNickname).where('name', isEqualTo: hospital).get().then((snapshot) {
      for (var doc in snapshot.docs) {
        _firestore.collection('hospital').doc(doc.id).delete().then((value) {
          notifyListeners();
        }).catchError((error) {
          // Handle the error
        });
      }
    });
  }


  List<String> get hospitalList => _favorites;
//Stream<List<String>> get hospitalListStream => _favoritesStream;


  // logout 하고 다시 다른 계정으로 로그인 했을 때 새롭게 해당 유저의 병원 리스트만 불러오기 위함 (안 그러면 이전 유저의 리스트를 불러옴) = 캐시 삭제 
  // 추후 로그아웃에 반영 예정
  void clearFavorites() {
    _favorites = [];
    notifyListeners();
  }

}