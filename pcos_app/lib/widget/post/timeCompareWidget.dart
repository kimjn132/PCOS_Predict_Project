import 'package:flutter/material.dart';

class TimeCompare extends StatelessWidget {
  const TimeCompare({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return dateTimeCompareResult(date);
  }
}

FutureBuilder<Duration> dateTimeCompareResult(postDate) {
  return FutureBuilder<Duration>(
      future: dateTimeCompare(postDate),
      builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.inSeconds < 60) {
            return Text(
              '${snapshot.data?.inSeconds}초 전',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            );
          } else if (snapshot.data!.inMinutes < 60) {
            return Text(
              '${snapshot.data?.inMinutes}분 전',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            );
          } else if (snapshot.data!.inHours < 24) {
            return Text(
              '${snapshot.data?.inHours}시간 전',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            );
          } else if (snapshot.data!.inDays < 31) {
            return Text(
              '${snapshot.data?.inDays}일 전',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            );
          } else {
            return Text(
              postDate.substring(0, 10),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      });
}

Future<Duration> dateTimeCompare(postDate) async {
  var now = DateTime.now();
  String date = postDate;
  var timediff = now.difference(DateTime.parse(date));
  return timediff;
}
