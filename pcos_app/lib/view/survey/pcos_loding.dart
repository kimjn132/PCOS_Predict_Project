import 'package:flutter/material.dart';
import 'package:pcos_app/view/survey/predict_view.dart';

class Loding extends StatefulWidget {
  const Loding({Key? key}) : super(key: key);

  @override
  _LodingState createState() => _LodingState();
}

class _LodingState extends State<Loding> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PredictView()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('예측률 계산중...'),
        //로고 이미지 추가
      ),
    );
  }
}