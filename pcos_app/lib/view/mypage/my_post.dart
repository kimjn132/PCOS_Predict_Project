import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:pcos_app/model/post/comments.dart';

import '../../model/post/posts.dart';
import '../post/post_detail_screen.dart';

class MyPostList extends StatefulWidget {
  const MyPostList({super.key});

  @override
  State<MyPostList> createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '내가 쓴 글',
          ),
          bottom: TabBar(
            indicatorColor: Colors.redAccent,
            indicatorWeight: 3,
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  '내가 쓴 글',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '내가 쓴 댓글',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('pNickname', isEqualTo: UserInfoStatic.userNickname)
                    .where('pDeleteDate', isEqualTo: '0')
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return const Center(
                        child: Text('데이터를 불러오는 중 오류가 발생하였습니다.'));
                  }
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshots.data!.docs;
                  if (documents.isEmpty) {
                    return const Center(
                      child: Text('작성한 글이 없습니다.'),
                    );
                  }

                  return ListView(
                    children:
                        documents.map((e) => _buildItemWidget(e)).toList(),
                  );
                },
              ),
            ),
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('comments')
                    .where('cNickname', isEqualTo: UserInfoStatic.userNickname)
                    .where('cDeleteDate', isEqualTo: '0')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('데이터를 불러오는 중 오류가 발생하였습니다.'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final documents = snapshot.data!.docs;
                  if (documents.isEmpty) {
                    return const Center(
                      child: Text('작성한 댓글이 없습니다.'),
                    );
                  }

                  return ListView(
                    children:
                        documents.map((e) => _buildItemWidget2(e)).toList(),
                  );
                },
              ),
            ),
          ],
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
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('posts').where(doc.id);
        toPostDetail(doc, postList);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제목 : ${postList.pTitle}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.eye_fill,
                  size: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  postList.pViewCount.toString(),
                ),
                const SizedBox(width: 8),
                Text(postList.pPostDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget2(QueryDocumentSnapshot doc) {
    final commentsList = Comments(
      cNickname: doc['cNickname'],
      cContent: doc['cContent'],
      cLikeCount: doc['cLikeCount'],
      cViewCount: doc['cViewCount'],
      cCommentDate: doc['cCommentDate'],
      cDeleteDate: doc['cDeleteDate'],
      cUpdateDate: doc['cUpdateDate'],
      pid: doc['pid'],
    );
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostDetailScreen(pid: commentsList.pid)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '내용 : ${commentsList.cContent}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.eye_fill,
                  size: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  commentsList.cViewCount.toString(),
                ),
                const SizedBox(width: 8),
                Text(commentsList.cCommentDate),
              ],
            ),
          ],
        ),
      ),
    );
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
}
