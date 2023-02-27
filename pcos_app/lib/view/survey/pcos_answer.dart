import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

    late int height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    height = pcosResult.height;
    heightController.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    heightController.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_zf6raviy.json')),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            textAlign: TextAlign.center,
            controller: heightController,
            decoration: const InputDecoration(hintText: '키를 입력해주세요.(cm)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {if (value.isEmpty) {
                heightController.text = '';
              } else {
                height = int.parse(value);
              }
              setState(() {
                pcosResult.height = height;
              });
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

  late int weight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weight = pcosResult.weight;
    weightController.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    weightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_t97bchh7.json')),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            textAlign: TextAlign.center,
            controller: weightController,
            decoration: const InputDecoration(hintText: '몸무게를 입력해주세요.(kg)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {if (value.isEmpty) {
                weightController.text = '';
              } else {
                weight = int.parse(value);
              }
              setState(() {
                pcosResult.weight = weight;
              });
            },
          ),
        ),
      ],
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

      late int waist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waist = pcosResult.waist;
    waistController.text = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    waistController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_b4bzucqa.json')),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            textAlign: TextAlign.center,
            controller: waistController,
            decoration: const InputDecoration(hintText: '허리사이즈를 입력해주세요.(inch)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {if (value.isEmpty) {
                waistController.text = '';
              } else {
                waist = int.parse(value);
              }
              setState(() {
                pcosResult.waist = waist;
              });
            },
          ),
        ),
      ],
    );
  }
} //CList





