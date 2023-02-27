import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/login/userinfo.dart';

class PostInsertBottomSheet extends StatefulWidget {
  const PostInsertBottomSheet({Key? key}) : super(key: key);

  @override
  State<PostInsertBottomSheet> createState() => _PostInsertBottomSheetState();
}

class _PostInsertBottomSheetState extends State<PostInsertBottomSheet> {
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
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
