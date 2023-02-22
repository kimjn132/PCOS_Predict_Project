import 'package:flutter/material.dart';
import 'package:pcos_app/view/post/postList_Screen.dart';

import '../../model/login/userInfo.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 400,
            ),
            const Text(
              'Main Screen',
            ),
            Text(UserInfoStatic.userNickname),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PostListScreen();
                      },
                    ),
                  );
                },
                child: const Text('Postings')),
          ],
        ),
      ),
    );
  }
}
