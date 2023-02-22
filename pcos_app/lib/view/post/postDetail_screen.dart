import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pcos_app/view/post/postUpdate_screen.dart';

import '../../model/login/userInfo.dart';
import '../../widget/post/timeCompareWidget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.pid,
  });
  final String pid;
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController contentTextController;
  late Future<Map<String, dynamic>> _postDataFuture;
  late ScrollController scrollController;

  late bool commentEditBool;

  late TextEditingController commentUpdateController;

  @override
  void initState() {
    super.initState();
    contentTextController = TextEditingController();
    _postDataFuture = getPostData(widget.pid);
    scrollController = ScrollController();

    commentEditBool = false;

    commentUpdateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _postDataFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final postData = snapshot.data!;
              return Text(postData['pTitle']);
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _postDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final postData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Text('data'),
                  tileColor: Colors.black12,
                  title: Text('작성자 : ${postData['pNickname']}'),
                  subtitle: TimeCompare(date: postData['pPostDate']),
                  trailing: DropdownButton(
                    icon: const Icon(CupertinoIcons.ellipsis),
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit),
                            Text('수정하기'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            Text('삭제하기'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostUpdateScreen(
                                pid: widget.pid,
                                pTitle: postData['pTitle'],
                                pContent: postData['pContent']),
                          ),
                        ).then((value) {
                          setState(() {
                            _postDataFuture = getPostData(widget.pid);
                          });
                        });
                      } else if (value == 'delete') {
                        deletePostCheckAlert(context, widget.pid);
                      }
                    },
                  ),
                ),
                Text(
                  postData['pTitle'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(postData['pContent']),
                SizedBox(
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.eye_fill,
                        size: 15,
                        color: Colors.black45,
                      ),
                      Text(
                        postData['pViewCount'].toString(),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black12,
                      width: 320,
                      child: TextField(
                        controller: contentTextController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          commentInsert(widget.pid, contentTextController.text);
                          contentTextController.text = '';
                          _postDataFuture = getPostData(widget.pid);
                        });
                      },
                      child: const Text('작성'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 510,
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!['comments'].length,
                    itemBuilder: (context, index) {
                      final commentData = snapshot.data!['comments'][index];
                      final cid = snapshot.data!['cid'][index];
                      return ListTile(
                          title: Row(
                            children: [
                              Text(
                                '작성자 : ${commentData['cNickname']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              TimeCompare(date: commentData['cCommentDate']),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Text(commentData['cContent']),
                              commentEditBool == false
                                  ? const SizedBox()
                                  : TextField(
                                      key: cid,
                                      controller: commentUpdateController,
                                    ),
                            ],
                          ),
                          trailing: UserInfoStatic.userNickname ==
                                      commentData['cNickname'] &&
                                  commentEditBool == false
                              ? SizedBox(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            commentEditBool = true;
                                          });
                                        },
                                        child: const Text(
                                          '수정',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext ctx) {
                                                return deleteCommentCheckAlert(
                                                    ctx,
                                                    context,
                                                    widget.pid,
                                                    cid);
                                              }).then((value) {
                                            setState(() {
                                              _postDataFuture =
                                                  getPostData(widget.pid);
                                            });
                                          });
                                        },
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : UserInfoStatic.userNickname ==
                                          commentData['cNickname'] &&
                                      commentEditBool == true
                                  ? SizedBox(
                                      width: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                commentEditBool = true;
                                              });
                                            },
                                            child: const Text(
                                              '취소',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //
                                            },
                                            child: const Text(
                                              '왼료',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox());
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> getPostData(String pid) async {
  final DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('posts').doc(pid).get();
  final postData = documentSnapshot.data() as Map<String, dynamic>;

  // Retrieve the comments for the post
  final commentsQuerySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .collection('comments')
      .orderBy('cCommentDate')
      .get();
  final commentsData =
      commentsQuerySnapshot.docs.map((doc) => doc.data()).toList();

  final snapshot = await FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .collection('comments')
      .orderBy('cCommentDate')
      .get();
  final docs = snapshot.docs;
  final commentIds = docs.map((doc) => doc.id).toList();
  postData['comments'] = commentsData;
  postData['cid'] = commentIds;
  return postData;
}

deletePostCheckAlert(context, String pid) {
  showDialog(
      context: context,
      barrierDismissible: false, // user must tap the button
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('삭제하기'),
          content: const Text('정말로 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pop(context);
                deletePost(pid);
                deleteCompleteSnackBar(context);
              },
              child: const Text(
                '네',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('아니요'),
            ),
          ],
        );
      });
}

deletePost(String pid) {
  FirebaseFirestore.instance.collection('posts').doc(pid).delete();
}

deleteCompleteSnackBar(context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('삭제되었습니다.'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
}

commentInsert(String pid, String content) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .collection('comments')
      .add(
    {
      'cNickname': UserInfoStatic.userNickname,
      'cContent': content,
      'cViewCount': 0,
      'cLikeCount': 0,
      'cCommentDate': DateTime.now().toString().substring(0, 19),
      'cUpdateDate': '',
      'cDeleteDate': '',
    },
  );
}

// Widget commentsBuild(
//     BuildContext context, pid, commentData, cid, commentUpdateController) {
//   return ListTile(
//       onTap: () {},
//       title: Row(
//         children: [
//           Text(
//             '작성자 : ${commentData['cNickname']}',
//             style: const TextStyle(
//               fontSize: 14,
//             ),
//           ),
//           TimeCompare(date: commentData['cCommentDate']),
//         ],
//       ),
//       subtitle: commentEditBool == true
//           ? Text(commentData['cContent'])
//           : TextField(
//               controller: commentUpdateController,
//             ),
//       trailing: UserInfoStatic.userNickname == commentData['cNickname']
//           ? SizedBox(
//               width: 60,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       commentEditBool = false;
//                     },
//                     child: const Icon(Icons.edit),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       print('tap');
//                     },
//                     child: const Icon(Icons.delete_forever),
//                   ),
//                 ],
//               ),
//             )
//           : const SizedBox());
// }

updateComment(String pid, String cid, String cContent) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .collection('comments')
      .doc(cid)
      .update({
    'cContent': cContent,
    'cUpdateDate': DateTime.now().toString().substring(0, 19)
  });
}

deleteCommentCheckAlert(ctx, context, pid, cid) {
  return AlertDialog(
    title: const Text('삭제하기'),
    content: const Text('정말로 삭제하시겠습니까?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(ctx).pop();
          deleteComment(pid, cid);
          deleteCompleteSnackBar(context);
        },
        child: const Text(
          '네',
          style: TextStyle(color: Colors.red),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.of(ctx).pop(),
        child: const Text('아니요'),
      ),
    ],
  );
}

deleteComment(String pid, String cid) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(pid)
      .collection('comments')
      .doc(cid)
      .delete();
}
