import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/model/login/userinfo.dart';

import 'package:pcos_app/view/post/post_detail_screen.dart';
import 'package:pcos_app/view/post/post_insert_screen.dart';

import '../../model/post/posts.dart';
import '../../widget/post/timeCompareWidget.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          title: const Text('공유하기'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('pPostDate', descending: true)
                  .snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshots.data!.docs;
                return ListView(
                  children: documents.map((e) => _buildItemWidget(e)).toList(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'postInsert',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const PostInsertScreen();
                },
              ),
            );
          },
          backgroundColor: Colors.orange,
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _buildItemWidget(DocumentSnapshot doc) {
    final postList = Posts(
      pNickname: doc['pNickname'],
      pTitle: doc['pTitle'],
      pContent: doc['pContent'],
      pImage: doc['pImage'],
      pLikeCount: doc['pLikeCount'],
      pViewCount: doc['pViewCount'],
      pPostDate: doc['pPostDate'],
      pUpdateDate: doc['pUpdateDate'],
      pDeleteDate: doc['pDeleteDate'],
    );
    return doc['pDeleteDate'] == '0'
        ? GestureDetector(
            onTap: () {
              FirebaseFirestore.instance.collection('posts').where(doc.id);
              toPostDetail(doc, postList);
            },
            child: ListTile(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 0.1),
                // borderRadius: BorderRadius.circular(5),
              ),
              tileColor: Colors.white,
              title: Text(
                postList.pTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(children: [
                Text(postList.pNickname),
                const SizedBox(width: 10),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.eye_fill,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      postList.pViewCount.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.hand_thumbsup,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      postList.pLikeCount.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                TimeCompare(date: postList.pPostDate),
              ]),
            ),
          )
        : const SizedBox();
  }

  Future<void> toPostDetail(DocumentSnapshot doc, final postList) async {
    (postList.pNickname != UserInfoStatic.userNickname)
        ? FirebaseFirestore.instance
            .collection('posts')
            .doc(doc.id)
            .update({"pViewCount": doc['pViewCount'] + 1})
        : false;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(pid: doc.id),
      ),
    );
  }

  Future<void> signOut() async {
    await Firebase.initializeApp();

    try {
      await FirebaseAuth.instance.signOut();
      print("Success");
    } catch (e) {
      print(e.toString());
    }
  }
}
