import 'package:flutter/material.dart';
import 'package:pcos_app/view/mypage/version_manage_page.dart';

import '../../model/login/userInfo.dart';
import 'chart_page.dart';

class MyPage extends StatelessWidget {
  MyPage({Key? key}) : super(key: key);

  final String userId = UserInfoStatic.userId;
  final String userNick = UserInfoStatic.userNickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileSection(),
            const Divider(thickness: 1, height: 0),
            Expanded(
                child: ListView(
              children: [
                // _buildListTile({
                //   'title': '내 정보',
                //   'icon': Icons.person,
                //   'onTap': '내 정보',
                // }),
                _buildListTile({
                  'title': '검사 결과',
                  'icon': Icons.bar_chart,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChartPage()),
                    );
                  },
                }),
                _buildListTile({
                  'title': '내가 좋아요한 병원',
                  'icon': Icons.favorite,
                  'onTap': () => _buildDialog(context, '아직 준비중인 서비스입니다.'),
                }),
                _buildListTile({
                  'title': '내가 쓴 글',
                  'icon': Icons.edit,
                  'onTap': '내가 쓴 글',
                }),
                _buildListTile({
                  'title': '건의 및 문의',
                  'icon': Icons.question_answer,
                  'onTap': '건의 및 문의',
                }),
                _buildListTile({
                  'title': '공지사항',
                  'icon': Icons.notifications,
                  'onTap': '공지사항',
                }),
                _buildListTile({
                  'title': '버전 관리',
                  'icon': Icons.system_update_alt,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VersionManagementPage()),
                    );
                  },
                }),
                _buildListTile({
                  'title': '회원 탈퇴',
                  'icon': Icons.exit_to_app,
                  'onTap': '회원 탈퇴',
                }),
              ],
            )),
          ],
        ),
      ),
    );
  }

  // 프로필
  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('images/default_image.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userNick,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  userId,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => print('로그아웃 아이콘 클릭됨'),
          ),
        ],
      ),
    );
  }

  // ListView
  Widget _buildListTile(Map<String, dynamic> data) {
    return ListTile(
      leading: Icon(data['icon']),
      title: Text(data['title']),
      trailing: const Icon(Icons.chevron_right),
      onTap:
          data['onTap'] is String ? () => print(data['onTap']) : data['onTap'],
    );
  }

  // Dialog message(내용)
  void _buildDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // // 유저 정보를 가져오는 함수
  // Future<void> _getUserInfo() async {
  //   // 현재 로그인된 사용자 정보 가져오기
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Cloud Firestore의 "users" collection에서 현재 사용자 정보 가져오기
  //     final userData = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //     if (userData.exists) {
  //       // 유저 정보를 UserInfoStatic에 저장
  //       UserInfoStatic.uid = userData['uid'];
  //       UserInfoStatic.userNickname = userData['userNickname'];
  //       UserInfoStatic.userId = userData['userId'];
  //     }
  //   }
  // }
}
