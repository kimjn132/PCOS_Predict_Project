class Comments {
  final String cNickname;
  final String cContent;
  final int cLikeCount;
  final int cViewCount;
  final String cCommentDate;
  final String cDeleteDate;
  final String cUpdateDate;
  final String pid;

  Comments(
      {required this.cNickname,
      required this.cContent,
      required this.cLikeCount,
      required this.cViewCount,
      required this.cCommentDate,
      required this.cDeleteDate,
      required this.cUpdateDate,
      required this.pid});
}
