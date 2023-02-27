import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcos_app/bottom_navigation.dart';
import 'package:pcos_app/view/login/signIn_screen.dart';
import 'package:pcos_app/view/map/map_favorite_example.dart';
import 'package:pcos_app/view/mypage/contact_page.dart';
import 'package:pcos_app/view/mypage/my_post.dart';
import 'package:pcos_app/view/mypage/version_manage_page.dart';
import '../../model/login/userInfo.dart';
import 'chart_page.dart';
import 'notice_page.dart';

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
            _buildProfileSection(context),
            const Divider(thickness: 1, height: 0),
            Expanded(
                child: ListView(
              children: [
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
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapLikeExample()),
                    );
                  },
                }),
                _buildListTile({
                  'title': '내가 쓴 글',
                  'icon': Icons.edit,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyPostList()),
                    );
                  },
                }),
                _buildListTile({
                  'title': '건의 및 문의',
                  'icon': Icons.question_answer,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactPage()),
                    );
                  },
                }),
                _buildListTile({
                  'title': '공지사항',
                  'icon': Icons.notifications,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoticePage()),
                    );
                  },
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
                  'onTap': () => _singOut(context),
                }),
              ],
            )),
          ],
        ),
      ),
    );
  }

  // 프로필
  Widget _buildProfileSection(BuildContext context) {
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('로그아웃'),
                    content: const Text('로그아웃을 하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('로그아웃'),
                        onPressed: () async {
                          UserInfoStatic.uid = "";
                          UserInfoStatic.userId = "";
                          UserInfoStatic.userNickname = "";
                          await FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          // Provider.of<FavoriteProvider>(context,
                          //         listen: false)
                          //     .clearFavorites();
                          // ignore: use_build_context_synchronously
                          Navigator.popUntil(context,
                              ModalRoute.withName(Navigator.defaultRouteName));
                          Get.reset();
                          Get.put(BottomNavController());
                        },
                      ),
                    ],
                  );
                },
              );
            },
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
      onTap: data['onTap'],
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

  // '회원 탈퇴' 버튼이 눌렸을 때 호출되는 함수
  void _singOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("회원 탈퇴"),
          content: const Text("정말로 탈퇴 하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("확인"),
              onPressed: () async {
                try {
                  UserInfoStatic.uid = "";
                  UserInfoStatic.userId = "";
                  UserInfoStatic.userNickname = "";
                  User user = FirebaseAuth.instance.currentUser!;
                  await user.delete();
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                  Get.reset();
                  Get.put(BottomNavController());
                } catch (e) {
                  print('회원 탈퇴 에러: $e');
                  _buildDialog(context, '회원 탈퇴 도중 오류가 발생했습니다.');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
