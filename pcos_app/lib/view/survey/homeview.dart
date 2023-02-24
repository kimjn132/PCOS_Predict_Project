import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
            title: const Text('내가 PCOS에 걸릴 확률은?'),
            backgroundColor: Color(0xFFFBA5A8),
            automaticallyImplyLeading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('나 혹시 PCOS에 걸리지 않았을까?', style: TextStyle(fontSize: 25),),
            Container(
                width: MediaQuery.of(context).size.height*0.5,
                height: MediaQuery.of(context).size.width*0.5,
                child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_gmspxrnd.json')),
            backBtn(),
          ],
        ));
  }

//--- function ---

  Widget backBtn() {
    return Center(
      child: 
        SizedBox(
          height: MediaQuery.of(context).size.height*0.15,
          width:  MediaQuery.of(context).size.width*0.48,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBA5A8),
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 26),
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
      
    );
  }
}// end