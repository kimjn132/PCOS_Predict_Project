import 'package:flutter/material.dart';
import 'package:pcos_app/view/survey/pcos_result.dart';

class PCOSAnswerList {
  List<Widget> pcosAnswerList = const [
    AList(), //키
    BList(), //몸무게
    CList(), //허리
  ];
}

class AList extends StatefulWidget {
  const AList({super.key});

  @override
  State<AList> createState() => _AListState();
}

class _AListState extends State<AList> {
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            textAlign: TextAlign.center,
            controller: heightController,
            decoration: const InputDecoration(hintText: '키를 입력해주세요.'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pcosResult.height = int.parse(heightController.text);
            },
          ),
        ),
      ],
    );
  }
} //AList

class BList extends StatefulWidget {
  const BList({super.key});

  @override
  State<BList> createState() => _BListState();
}

class _BListState extends State<BList> {
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            controller: weightController,
            decoration: const InputDecoration(hintText: '몸무게를 입력해주세요.'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pcosResult.weight = int.parse(weightController.text);
            },
          ),
        ],
      ),
    );
  }
} //BList

class CList extends StatefulWidget {
  const CList({super.key});

  @override
  State<CList> createState() => _CListState();
}

class _CListState extends State<CList> {
  TextEditingController waistController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextField(
            textAlign: TextAlign.center,
            controller: waistController,
            decoration: const InputDecoration(hintText: '허리사이즈를 입력해주세요.'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pcosResult.waist = int.parse(waistController.text);
            },
          ),
        ],
      ),
    );
  }
} //CList





