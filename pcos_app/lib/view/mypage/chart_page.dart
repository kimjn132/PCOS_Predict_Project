import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

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
            '검사 결과',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // 전체적인 패딩 조정
          child: ListView(
            children: [
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'PCOS 예측결과 (%)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chart(
                data: [
                  Data(date: DateTime(2022, 2, 1), value: 20),
                  Data(date: DateTime(2022, 2, 2), value: 30),
                ],
              ),
              const SizedBox(height: 16), // 각 차트 사이에 간격 추가
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chart(
                data: [
                  Data(date: DateTime(2022, 2, 3), value: 40),
                  Data(date: DateTime(2022, 2, 4), value: 80),
                  Data(date: DateTime(2022, 2, 5), value: 60),
                  Data(date: DateTime(2022, 2, 6), value: 70),
                  Data(date: DateTime(2022, 2, 7), value: 53),
                  Data(date: DateTime(2022, 2, 8), value: 53),
                  Data(date: DateTime(2022, 2, 9), value: 53),
                  Data(date: DateTime(2022, 2, 10), value: 53),
                ],
              ),
              Container(
                color: const Color(0xFFD9D9D9),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '몸무게 (Kg)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Chart(
                data: [
                  Data(date: DateTime(2022, 2, 8), value: 53),
                  Data(date: DateTime(2022, 2, 9), value: 53),
                  Data(date: DateTime(2022, 2, 10), value: 53),
                  Data(date: DateTime(2022, 2, 14), value: 55),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
