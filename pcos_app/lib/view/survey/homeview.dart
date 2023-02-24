import 'package:flutter/material.dart';
import 'package:pcos_app/view/survey/survey.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('홈 화면'),
            backgroundColor: Color(0xFFFBA5A8),
            automaticallyImplyLeading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backBtn(),
          ],
        ));
  }

//--- function ---

  Widget backBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBA5A8),
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 30),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Survey(),
                      ));
                },
                child: const Text('예측해보기')),
          ),
        ),
      ],
    );
  }
}// end