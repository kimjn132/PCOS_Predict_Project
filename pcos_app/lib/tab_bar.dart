import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcos_app/bottom_navigation.dart';
import 'package:pcos_app/view/calendar/calendar.dart';
import 'package:pcos_app/view/map/map.dart';
import 'package:pcos_app/view/mypage/mypage.dart';
import 'package:pcos_app/view/post/post_list_screen.dart';
import 'package:pcos_app/view/survey/survey.dart';

class Tabbar extends GetView<BottomNavController> {
  const Tabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.pageIndex.value, // 현재 페이지 확인
          children: const [
            //여기에 페이지 추가
            SurveyPage(),
            MapPage(),
            CalendarPage(),
            PostListScreen(),
            MyPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.pageIndex.value, // items의 몇번째 페이지인지 지정
          elevation: 0,
          onTap: controller.changeBottomNav,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              activeIcon: Icon(Icons.content_paste),
              label: 'PCOS 테스트',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map_outlined),
              label: '주변병원',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              activeIcon: Icon(Icons.calendar_month),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people),
              label: '공유하기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              activeIcon: Icon(Icons.account_circle),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }
}
