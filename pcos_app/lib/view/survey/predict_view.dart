import 'package:flutter/material.dart';
import 'package:pcos_app/tab_bar.dart';
import 'package:pcos_app/view/survey/pcos_result.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PredictView extends StatefulWidget {
  const PredictView({super.key});

  @override
  State<PredictView> createState() => _PredictViewState();
}

class _PredictViewState extends State<PredictView> {
  late double predict = pcosResult.predict;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예측 결과'),
        backgroundColor: Color(0xFFFBA5A8),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Text(
                '당신이 PCOS에 걸렸을 확률은?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              )),
          SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 39.27, color: Colors.green),
              GaugeRange(
                  startValue: 39.27, endValue: 50.4, color: Colors.orange),
                  
              GaugeRange(startValue: 50.4, endValue: 100, color: Colors.red)
            ], pointers: <GaugePointer>[
              NeedlePointer(value: predict,
              enableAnimation: true,
              needleColor: Color(0xFFFBA5A8),
              knobStyle: KnobStyle(color: Colors.white, borderColor: Color(0xFFFBA5A8),
                       knobRadius: 0.06,
                       borderWidth: 0.04),
              )
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(predict.toString() + '%',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Text(predict <= 30
                            ? '안전합니다.'
                            : predict <= 50
                                ? '조심할 필요가 있습니다.'
                                : '위험합니다. 병원에 방문하세요', style: TextStyle(
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ]),


        backBtn()
        
        
        ],
      ),
    );
  }


  //---finction---

  Widget backBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFBA5A8),
              foregroundColor: Colors.black,
              textStyle: TextStyle(fontSize: 20),
        
              
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
              onPressed: () {
              Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Tabbar(),
                    ));
              },
              child: const Text('처음으로')),
        ),
      ],
    );
  } 


}//end
