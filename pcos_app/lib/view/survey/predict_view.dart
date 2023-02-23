import 'package:flutter/material.dart';
import 'package:pcos_app/view/survey/pcos_result.dart';

class PredictView extends StatefulWidget {
  const PredictView({super.key});

  @override
  State<PredictView> createState() => _PredictViewState();
}

class _PredictViewState extends State<PredictView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예측결과'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox( 
                  width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.3,
            
            child: Text('당신이 PCOS에 걸렸을 확률은?', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),)),

          SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.3,
            
            child: Text(pcosResult.predict.toString()+'% 입니다.', textAlign: TextAlign.center,style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }
}