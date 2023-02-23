import 'package:flutter/material.dart';
import 'package:test1/pcos_result.dart';

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
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextField(
            controller: heightController,
            decoration: const InputDecoration(hintText: '키를 입력해주세요.'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pcosResult.height = int.parse(heightController.text);
            },
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextField(
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
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          TextField(
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



