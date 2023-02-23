import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NoticeDetail extends StatefulWidget {
  const NoticeDetail({
    super.key,
    required this.nid,
  });
  final String nid;

  @override
  State<NoticeDetail> createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  late Future<Map<String, dynamic>> _noticeDataFuture;
  late bool commentEditBool;

  @override
  void initState() {
    super.initState();
    commentEditBool = false;
    _noticeDataFuture = getPostData(widget.nid);
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
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '공지사항',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _noticeDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final noticeData = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        noticeData['nTitle'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(noticeData['nDate']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        noticeData['nContent'].replaceAll("\\n", "\n"),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
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
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getPostData(String nid) async {
  final DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('notice').doc(nid).get();
  final postData = documentSnapshot.data() as Map<String, dynamic>;

  DateTime nDate = DateTime.parse(postData['nDate']);
  String formattedDate = DateFormat('yyyy년 MM월 dd일').format(nDate);

  postData['nDate'] = formattedDate;

  return postData;
}
