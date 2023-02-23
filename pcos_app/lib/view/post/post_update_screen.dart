import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostUpdateScreen extends StatefulWidget {
  const PostUpdateScreen({
    super.key,
    required this.pid,
    required this.pTitle,
    required this.pContent,
  });
  final String pid;
  final String pTitle;
  final String pContent;

  @override
  State<PostUpdateScreen> createState() => _PostUpdateScreenState();
}

class _PostUpdateScreenState extends State<PostUpdateScreen> {
  late TextEditingController titleTextController;
  late TextEditingController contentTextController;

  @override
  void initState() {
    super.initState();
    titleTextController = TextEditingController();
    contentTextController = TextEditingController();
    titleTextController.text = widget.pTitle;
    contentTextController.text = widget.pContent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
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
            title: const Text('수정하기'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 2,
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
                      setState(() {
                        Navigator.pop(context);
                        updatePost(widget.pid, titleTextController.text,
                            contentTextController.text);
                      });
                    },
                    child: const Text(
                      '완료',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

updatePost(String pid, String pTitle, String pContent) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .update({'pTitle': pTitle, 'pContent': pContent});
}
