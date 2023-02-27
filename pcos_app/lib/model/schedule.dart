class Schedule {
  final int? id;
  final String date;
  final String content;
  final String? dropdate;

  Schedule({
    this.id,
    required this.date,
    required this.content,
    this.dropdate,
  });

  Schedule.fromMap(Map<String, dynamic> res) // 생성자 만들기 똑같은 이름 줄 수 없음
      : id = res['id'],
        date = res['date'],
        content = res['content'],
        dropdate = res['dropdate'];

  Map<String, Object?> toMap() {
    // id가 널세이프티라 옵셔널 처리
    return {'id': id, 'date': date, 'content': content, 'dropdate': dropdate};
  }
}
