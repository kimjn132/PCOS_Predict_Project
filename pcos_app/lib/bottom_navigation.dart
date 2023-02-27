import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PageName {survey, map, calendar, post, mypage}

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();
  // 현재 페이지 기본 0번
  RxInt pageIndex = PageName.survey.index.obs;
  GlobalKey<NavigatorState> searchPageNaviationKey =
      GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0];

  // page 관리
  void changeBottomNav(int value, {bool hasGesture = true}) {
    var page = PageName.values[value];

    // bottom_nav에서 선택된 페이지로 이동
    switch (page) {
      case PageName.survey:
      case PageName.map:
      case PageName.calendar:
      case PageName.post:
      case PageName.mypage:
        _changePage(value, hasGesture: hasGesture);
        break;
    }
  }

  void _changePage(int value, {bool hasGesture = true}) {
    // bottom_nav에서 클릭한 페이지로 번호 지정
    pageIndex(value);

    if (!hasGesture) return;
    if (bottomHistory.last != value) {
      bottomHistory.add(value);
    }
  }
}
