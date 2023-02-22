import 'package:flutter/material.dart';

import 'chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '검사 결과',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Container(
              color: const Color(0xFFD9D9D9),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'PCOS 예측결과 (%)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Chart(
              data: [
                Data(date: DateTime(2022, 2, 1), value: 20),
                Data(date: DateTime(2022, 2, 2), value: 30),
                // Data(date: DateTime(2022, 2, 3), value: 40),
                // Data(date: DateTime(2022, 2, 4), value: 80),
                // Data(date: DateTime(2022, 2, 5), value: 60),
                // Data(date: DateTime(2022, 2, 6), value: 70),
                // Data(date: DateTime(2022, 2, 7), value: 53),
                // Data(date: DateTime(2022, 2, 8), value: 53),
                // Data(date: DateTime(2022, 2, 9), value: 53),
                // Data(date: DateTime(2022, 2, 10), value: 53),
                // Data(date: DateTime(2022, 2, 11), value: 53),
                // Data(date: DateTime(2022, 2, 12), value: 53),
                // Data(date: DateTime(2022, 2, 13), value: 53),
                // Data(date: DateTime(2022, 2, 14), value: 55),
                // Data(date: DateTime(2022, 2, 15), value: 70),
              ],
            ),
            Container(
              color: const Color(0xFFD9D9D9),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                // Data(date: DateTime(2022, 2, 11), value: 53),
                // Data(date: DateTime(2022, 2, 12), value: 53),
                // Data(date: DateTime(2022, 2, 13), value: 53),
                Data(date: DateTime(2022, 2, 14), value: 55),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
