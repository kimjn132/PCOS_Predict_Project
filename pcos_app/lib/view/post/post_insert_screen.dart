import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/login/userInfo.dart';

class PostInsertScreen extends StatefulWidget {
  const PostInsertScreen({Key? key}) : super(key: key);

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
        title: const Text('글 작성'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleTextController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: '제목'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: contentTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '내용',
              ),
              minLines: 10,
              maxLines: 15,
            ),
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
        ],
      ),
    );
  }

  postingAction() {
    print(UserInfoStatic.userNickname);
    FirebaseFirestore.instance.collection('posts').add(
      {
        'pNickname': UserInfoStatic.userNickname,
        'pTitle': titleTextController.text,
        'pContent': contentTextController.text,
        'pImage': '0',
        'pViewCount': 0,
        'pLikeCount': 0,
        'pPostDate': DateTime.now().toString().substring(0, 19),
        'pUpdateDate': '0',
        'pDeleteDate': '0',
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