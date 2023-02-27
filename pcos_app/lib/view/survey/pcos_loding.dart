import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      appBar: AppBar(
        title: const Text('설문조사'),
        backgroundColor: Color(0xFFFBA5A8),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network('https://assets1.lottiefiles.com/packages/lf20_nw19osms.json')
        ],
      )
    );
  }
}