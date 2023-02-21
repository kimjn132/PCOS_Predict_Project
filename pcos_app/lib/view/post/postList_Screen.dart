import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_project_test/model/postStatic.dart';
import 'package:python_project_test/model/timeCompareWidget.dart';
import 'package:python_project_test/screen/postDetail_screen.dart';
import 'package:python_project_test/screen/postInsert_Screen.dart';

import '../model/posts.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
    return GestureDetector(
      onTap: () {
        FirebaseFirestore.instance
            .collection('posts')
            .where(doc.id);
        toPostDetail(doc, postList);
      },
      child: ListTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 0.1),
          // borderRadius: BorderRadius.circular(5),
        ),
        tileColor: Colors.white,
        title: Text(
          '제목 : ${postList.pTitle}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(children: [
          SizedBox(
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.eye_fill,
                  size: 15,
                ),
                Text(
                  postList.pViewCount.toString(),
                ),
              ],
            ),
          ),
          TimeCompare(date: postList.pPostDate),
        ]),
        trailing: const Text('data'),
      ),
      // child: Card(
      //   color: Colors.grey,
      //   child: Row(
      //     children: [
      //       // Padding(
      //       //   padding: const EdgeInsets.all(8.0),
      //       //   child: Image.network(
      //       //     // ignore: unnecessary_string_interpolations
      //       //     '${postList.pImage}',
      //       //     errorBuilder: (context, error, stackTrace) {
      //       //       return Image.asset(
      //       //         'images/fimage.png',
      //       //         width: 80,
      //       //         errorBuilder: (context, error, stackTrace) {
      //       //           return Image.asset('images/fimage.png');
      //       //         },
      //       //       );
      //       //     },
      //       //     width: 80,
      //       //   ),
      //       // ),
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(3.0),
      //               child: Text(
      //                 '제목 : ${postList.pTitle}',
      //                 style: const TextStyle(fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> toPostDetail(DocumentSnapshot doc, final postList) async {
    (postList.pNickname != postList.pNickname)
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
}
