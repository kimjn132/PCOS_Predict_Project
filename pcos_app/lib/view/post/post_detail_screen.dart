import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/view/post/post_update_screen.dart';

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
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
          foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: SingleChildScrollView(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _postDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final postData = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('images/default_image.png'),
                          ),
                          title: Text(
                            postData['pNickname'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          subtitle: TimeCompare(date: postData['pPostDate']),
                          trailing: postData['pNickname'] ==
                                  UserInfoStatic.userNickname
                              ? DropdownButton(
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
                                          Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                          Text('삭제하기',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostUpdateScreen(
                                                  pid: widget.pid,
                                                  pTitle: postData['pTitle'],
                                                  pContent:
                                                      postData['pContent']),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          _postDataFuture =
                                              getPostData(widget.pid);
                                        });
                                      });
                                    } else if (value == 'delete') {
                                      deletePostCheckAlert(context, widget.pid);
                                    }
                                  },
                                )
                              : const SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            postData['pTitle'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            postData['pContent'],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.eye_fill,
                                  size: 15,
                                  color: Colors.black45,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  postData['pViewCount'].toString(),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                const Icon(
                                  CupertinoIcons.hand_thumbsup,
                                  size: 15,
                                  color: Colors.black45,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  postData['pLikeCount'].toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!['comments'].length,
                          itemBuilder: (context, index) {
                            final commentData =
                                snapshot.data!['comments'][index];
                            final cid = snapshot.data!['cid'][index];
                            return commentData['cDeleteDate'] == '0'
                                ? ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          commentData['cNickname'],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TimeCompare(
                                            date: commentData['cCommentDate']),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            commentData['cContent'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        commentEditBool == false
                                            ? const SizedBox()
                                            : TextField(
                                                controller:
                                                    commentUpdateController,
                                              ),
                                      ],
                                    ),
                                    trailing: UserInfoStatic.userNickname ==
                                                commentData['cNickname'] &&
                                            commentEditBool == false
                                        ? SizedBox(
                                            width: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      // commentEditBool = true;
                                                    });
                                                  },
                                                  child: const Text(
                                                    '수정',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder:
                                                            (BuildContext ctx) {
                                                          return deleteCommentCheckAlert(
                                                              ctx,
                                                              context,
                                                              widget.pid,
                                                              cid);
                                                        }).then((value) {
                                                      setState(() {
                                                        _postDataFuture =
                                                            getPostData(
                                                                widget.pid);
                                                      });
                                                    });
                                                  },
                                                  child: const Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                        color: Colors.red),
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
                                                          commentEditBool =
                                                              true;
                                                        });
                                                      },
                                                      child: const Text(
                                                        '취소',
                                                        style: TextStyle(
                                                            color: Colors.red),
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
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox())
                                : const SizedBox();
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 300,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          bottomSheet: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      minLines: 1,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      controller: contentTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: '댓글',
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          commentInsert(widget.pid, contentTextController.text);
                          contentTextController.text = '';
                          _postDataFuture = getPostData(widget.pid);
                        });
                      },
                      child: const Text('게시'),
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
    FirebaseFirestore.instance
        .collection('posts')
        .doc(pid)
        .update({'pDeleteDate': DateTime.now().toString().substring(0, 19)});
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
        'pid': pid,
        'cNickname': UserInfoStatic.userNickname,
        'cContent': content,
        'cViewCount': 0,
        'cLikeCount': 0,
        'cCommentDate': DateTime.now().toString().substring(0, 19),
        'cUpdateDate': '0',
        'cDeleteDate': '0',
      },
    );
  }

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
        .update({'cDeleteDate': DateTime.now().toString().substring(0, 19)});
  }

  sadf() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
