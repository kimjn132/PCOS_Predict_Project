import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pcos_app/model/mypage/notice_model.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
            '공지사항',
          ),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notice')
                .orderBy('nDate', descending: true)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return const Center(
                  child: Text('데이터를 불러오는 중 오류가 발생하였습니다.'),
                );
              }
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final documents = snapshots.data!.docs;
              if (documents.isEmpty) {
                return const Center(
                  child: Text('작성된 글이 없습니다.'),
                );
              }

              List<DocumentSnapshot> latestDocuments = [];
              if (documents.length >= 3) {
                latestDocuments = documents.sublist(0, 3);
              } else {
                latestDocuments = documents;
              }

              return ListView(
                children: documents
                    .map((doc) => _buildItemWidget(doc, latestDocuments))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(
      DocumentSnapshot doc, List<DocumentSnapshot> latestDocuments) {
    final noticeList = NoticeModel(
      nContent: doc['nContent'],
      nDate: doc['nDate'],
      nTitle: doc['nTitle'],
    );

    DateTime nDate = DateTime.parse(noticeList.nDate);
    String formattedDate = DateFormat('yyyy년 MM월 dd일').format(nDate);

    // 최신글 3개의 문서 ID를 가져옵니다.
    List<String> latestDocumentIds =
        latestDocuments.map((doc) => doc.id).toList();

    // 현재 공지사항이 최신글 3개에 포함되어 있는지 확인합니다.
    bool isLatest = latestDocumentIds.contains(doc.id);

    return InkWell(
      onTap: () {
        // FirebaseFirestore.instance.collection('posts').where(doc.id);
        // toPostDetail(doc, noticeList);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLatest ? Colors.red : Colors.transparent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticeList.nTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
