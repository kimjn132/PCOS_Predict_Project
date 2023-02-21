import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/login/userInfo.dart';

class PostInsertScreen extends StatefulWidget {
  const PostInsertScreen({super.key});

  @override
  State<PostInsertScreen> createState() => _PostInsertScreenState();
}

class _PostInsertScreenState extends State<PostInsertScreen> {
  late TextEditingController titleTextController;
  late TextEditingController contentTextController;

  @override
  void initState() {
    super.initState();
    titleTextController = TextEditingController();
    contentTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleTextController,
          ),
          TextField(
            controller: contentTextController,
          ),
          ElevatedButton(
            onPressed: () {
              postingAction();
              Navigator.pop(context);
            },
            child: const Text(
              '완료',
            ),
          ),
          TextButton(
              onPressed: () {
                postingCompleteSnackBar(context);
              },
              child: const Text('test'))
        ],
      ),
    );
  }

  postingAction() {
    FirebaseFirestore.instance.collection('posts').add(
      {
        'pNickname': UserInfoStatic.userNickname,
        'pTitle': titleTextController.text,
        'pContent': contentTextController.text,
        'pImage': '',
        'pViewCount': 0,
        'pLikeCount': 0,
        'pPostDate': DateTime.now().toString().substring(0, 19),
        'pUpdateDate': '',
        'pDeleteDate': '',
      },
    );
    postingCompleteSnackBar(context);
  }
}

postingCompleteSnackBar(context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.blue,
      content: Text('글 작성이 완료되었습니다.'),
      duration: Duration(seconds: 2),
    ),
  );
}
