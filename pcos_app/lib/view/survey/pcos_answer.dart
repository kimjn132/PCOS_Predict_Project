import 'package:flutter/material.dart';
import 'package:test1/pcos_result.dart';

class PCOSAnswerList {
  List<Widget> pcosAnswerList = const [
    AList(), //키
    BList(), //몸무게
    CList(), //허리
    // DList(), //hair_growth
    // EList(), //skin_darkening
    // FList(), //weight_gain
    // GList(), //fastfood
    // HList(), //pimmples
  ];
} //DementiaAnswerList Assemble

//Answer List Widget Starts

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
      padding: const EdgeInsets.all(20.0),
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
      padding: const EdgeInsets.all(20.0),
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
      padding: const EdgeInsets.all(20.0),
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

// class DList extends StatefulWidget {
//   const DList({super.key});

//   @override
//   State<DList> createState() => _DListState();
// }

// class _DListState extends State<DList> {
//   late Survey survey = Survey();

//   //late PageController pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         OutlinedButton.icon(
//             onPressed: () {
//               pcosResult.hair_growthYN = 1;
//             },
//             icon: Icon(Icons.done_outlined),
//             label: Text("몸에 털이 많이 난다.")),
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("그렇지 않다."))
//       ],
//     );
//   }
// } //DList

// class EList extends StatefulWidget {
//   const EList({super.key});

//   @override
//   State<EList> createState() => _EListState();
// }

// class _EListState extends State<EList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("흑색 극세포증이 보인다.")),
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("증상이 보이지 않는다."))
//       ],
//     );
//   }
// } //EList

// class FList extends StatefulWidget {
//   const FList({super.key});

//   @override
//   State<FList> createState() => _FListState();
// }

// class _FListState extends State<FList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("최근 몸무게가 증가했다.")),
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("변화가 없다."))
//       ],
//     );
//   }
// } //FList

// class GList extends StatefulWidget {
//   const GList({super.key});

//   @override
//   State<GList> createState() => _GListState();
// }

// class _GListState extends State<GList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("자주 먹는다.")),
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("거의 먹지 않는다."))
//       ],
//     );
//   }
// } //GList

// class HList extends StatefulWidget {
//   const HList({super.key});

//   @override
//   State<HList> createState() => _HListState();
// }

// class _HListState extends State<HList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("여드름이 있다.")),
//         OutlinedButton.icon(
//             onPressed: () {},
//             icon: Icon(Icons.done_outlined),
//             label: Text("없다."))
//       ],
//     );
//   }
// } //HList


