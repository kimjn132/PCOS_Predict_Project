import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
              foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
          ),
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: const Text('글 작성'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 2,
                      controller: titleTextController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '제목',
                      ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(500, 50),
                        backgroundColor: const Color(0xFFFBA5A8),
                      ),
                      onPressed: () {
                        postingAction();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '작성',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  postingAction() {
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
