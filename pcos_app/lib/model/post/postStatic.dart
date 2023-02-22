import 'package:flutter/src/widgets/framework.dart';

class PostStatic {
  static String pid = '';
  static String pTitle = '';
  static String pContent = '';
  static String pNickname = '';
  static int pViewCount = 0;
  static int pLikeCount = 0;
  static String pImage = '';
  static String pPostDate = '';
  static String pUpdateDate = '';
  static String pDeleteDate = '';
}

class PostStaticUpdate extends StatelessWidget {
  const PostStaticUpdate({
    super.key,
    required this.pid,
    required this.pTitle,
    required this.pContent,
    required this.pNickname,
    required this.pImage,
    required this.pViewCount,
    required this.pLikeCount,
    required this.pPostDate,
    required this.pUpdateDate,
    required this.pDeleteDate,
  });
  final String pid;
  final String pTitle;
  final String pContent;
  final String pNickname;
  final String pImage;
  final int pViewCount;
  final int pLikeCount;
  final String pPostDate;
  final String pUpdateDate;
  final String pDeleteDate;

  @override
  Widget build(BuildContext context) {
    return postStaticUpdate(pid, pTitle, pContent, pNickname, pImage,
        pViewCount, pLikeCount, pPostDate, pUpdateDate, pDeleteDate);
  }
}

postStaticUpdate(
    String pid,
    String pTitle,
    String pContent,
    String pNickname,
    String pImage,
    int pViewCount,
    int pLikeCount,
    String pPostDate,
    String pUpdateDate,
    String pDeleteDate) {
  PostStatic.pid = pid;
  PostStatic.pTitle = pTitle;
  PostStatic.pContent = pContent;
  PostStatic.pNickname = pNickname;
  PostStatic.pImage = pImage;
  PostStatic.pViewCount = pViewCount;
  PostStatic.pLikeCount = pLikeCount;
  PostStatic.pPostDate = pPostDate;
  PostStatic.pUpdateDate = pUpdateDate;
  PostStatic.pDeleteDate = pDeleteDate;
}
