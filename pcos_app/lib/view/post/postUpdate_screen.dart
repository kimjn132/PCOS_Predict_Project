import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Update'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleTextController,
            onChanged: (value) {},
          ),
          TextField(
            controller: contentTextController,
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
    );
  }
}

updatePost(String pid, String pTitle, String pContent) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .update({'pTitle': pTitle, 'pContent': pContent});
}
