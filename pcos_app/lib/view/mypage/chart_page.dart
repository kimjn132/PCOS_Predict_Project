import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/login/userInfo.dart';
import '../../model/mypage/chart_model.dart';
import 'chart.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
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
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                elevation: 1.0,
                color: Colors.grey[200],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'PCOS 확률 (%)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('survey_result')
                      .where('userNickname',
                          isEqualTo: UserInfoStatic.userNickname)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final chartModels = chartModelsFromSnapshot(snapshot.data!);
                    return Card(
                      child: Chart(
                        data: chartModels
                            .map((chartModel) => Data(
                                  date: chartModel.date,
                                  value: chartModel.predict,
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // 각 차트 사이에 간격 추가
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                elevation: 1.0,
                color: Colors.grey[200],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'BMI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('survey_result')
                      .where('userNickname',
                          isEqualTo: UserInfoStatic.userNickname)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final chartModels = chartModelsFromSnapshot(snapshot.data!);
                    return Card(
                      child: Chart(
                        data: chartModels
                            .map((chartModel) => Data(
                                  date: chartModel.date,
                                  value: double.parse((chartModel.weight /
                                          (chartModel.height /
                                              100 *
                                              chartModel.height /
                                              100))
                                      .toStringAsFixed(2)),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                elevation: 1.0,
                color: Colors.grey[200],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '몸무게 (Kg)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('survey_result')
                      .where('userNickname',
                          isEqualTo: UserInfoStatic.userNickname)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final chartModels = chartModelsFromSnapshot(snapshot.data!);
                    return Card(
                      child: Chart(
                        data: chartModels
                            .map((chartModel) => Data(
                                  date: chartModel.date,
                                  value: chartModel.weight,
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartModel> chartModelsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ChartModel(
        date: DateTime.parse(data['date']),
        height: (data['height'] as num).toDouble(),
        weight: (data['weight'] as num).toDouble(),
        predict: (data['predict'] as num).toDouble(),
      );
    }).toList();
  }
}
