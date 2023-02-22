class Posts {
  final String pNickname;
  final String pTitle;
  final String pContent;
  final String pImage;
  final int pLikeCount;
  final int pViewCount;
  final String pPostDate;
  final String pUpdateDate;
  final String pDeleteDate;

  Posts(
      {required this.pNickname,
      required this.pTitle,
      required this.pContent,
      required this.pImage,
      required this.pLikeCount,
      required this.pViewCount,
      required this.pPostDate,
      required this.pUpdateDate,
      required this.pDeleteDate,});
}