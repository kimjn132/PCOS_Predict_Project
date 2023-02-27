import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:pcos_app/view/survey/pcos_answer.dart';
import 'package:pcos_app/view/survey/pcos_loding.dart';
import 'package:pcos_app/view/survey/pcos_result.dart';
import 'package:pcos_app/view/survey/pcos_survey.dart';
import 'package:pcos_app/view/survey/predict_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Survey extends StatefulWidget {
  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  late int selectedPage;
  late PageController pageController = PageController();
  PCOSsurvey surveyList = PCOSsurvey();
  PCOSAnswerList surveyAnswerList = PCOSAnswerList();
  late double result;
  //late int length = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPage = 0;
    //length = surveyAnswerList.pcosAnswerList.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('설문조사'),
          backgroundColor: Color(0xFFFBA5A8),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[pages()],
        ),
      ),
    );
  }

//------Function------

// 설문조사 페이지뷰
  Widget pages() {
    return Flexible(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (int value) {
          selectedPage = value;
        },
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: <Widget>[
                    //페이지 퍼센티지 보여주기(linear indicator)

                    if (index < 8)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                        child: LinearPercentIndicator(
                          barRadius: Radius.circular(15),
                          width: MediaQuery.of(context).size.width - 50,
                          lineHeight: 25.0,
                          animation: true,
                          animationDuration: 500,
                          percent: (index + 1) * 100 / (8).toDouble() * 0.01,
                          center: Text(
                            "${index + 1} / ${8}",
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          backgroundColor: Colors.grey,
                          progressColor: Color(0xFFFBA5A8),
                        ),
                      ),

                    //질문 리스트
                    if (index == 8)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: Text(
                          '모든 질문이 완료 되었습니다.',
                          style: const TextStyle(fontSize: 20),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: Text(
                          surveyList.questions.elementAt(index),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),

                    //답변 위젯 리스트
                    if (index <= 2) //0~2 페이지는 주관식 숫자를 받아야함.
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: surveyAnswerList.pcosAnswerList.elementAt(index),
                      )
                    else if (index < 8) // 나머지는 Y or N 답안으로 클릭시 다음 페이지로 넘어감.
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageselect(index),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () {
                                  if (index == 3)
                                    pcosResult.hair_growthYN = 1;
                                  else if (index == 4)
                                    pcosResult.skin_darkeningYN = 1;
                                  else if (index == 5)
                                    pcosResult.weight_gainYN = 1;
                                  else if (index == 6)
                                    pcosResult.fastfoodYN = 1;
                                  else if (index == 7)
                                    pcosResult.pimmplesYN = 1;

                                  pageController.jumpToPage(index + 1);
                                },
                                icon: Icon(Icons.done_outlined),
                                label: Text(
                                  "그렇다.",
                                  style: TextStyle(fontSize: 25),
                                )),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () {
                                  if (index == 3)
                                    pcosResult.hair_growthYN = 0;
                                  else if (index == 4)
                                    pcosResult.skin_darkeningYN = 0;
                                  else if (index == 5)
                                    pcosResult.weight_gainYN = 0;
                                  else if (index == 6)
                                    pcosResult.fastfoodYN = 0;
                                  else if (index == 7)
                                    pcosResult.pimmplesYN = 0;

                                  pageController.jumpToPage(index + 1);
                                },
                                icon: Icon(Icons.done_outlined),
                                label: Text("그렇지 않다.",
                                    style: TextStyle(fontSize: 25))),
                          )
                        ],
                      ),
                  ],
                ),
                //pageBtn(selectedPage)

                // button widget
                if (index <= 2)
                  pageBtn(index)
                else if (index == 8)
                  resultBtn(index)
                else
                  beforeBtn(index)
              ],
            ),
          );
        },
      ),
    );
  } // pages for survey

  Widget pageBtn(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBA5A8),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                pageController.jumpToPage(index - 1);
              },
              child: const Text('이전')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBA5A8),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (index == 0 && pcosResult.height == 0) {
                  heightEmptySnackBar();
                } else if (index == 1 && pcosResult.weight == 0) {
                  weightEmptySnackBar();
                } else if (index == 2 && pcosResult.waist == 0) {
                  waistEmptySnackBar();
                } else {
                  pageController.jumpToPage(index + 1);
                }
              },
              child: const Text('다음')),
        ),
      ],
    );
  } // pageBtn

  Widget beforeBtn(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBA5A8),
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                pageController.jumpToPage(index - 1);
              },
              child: const Text('이전')),
        ),
      ],
    );
  } // pageBtn

  Widget resultBtn(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFBA5A8),
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 40),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  //결과페이지롤 이동
                  getSJONData();
                },
                child: const Text('예측하기')),
          ),
        ),
      ],
    );
  } // pageBtn

//-------------function---------
  Widget imageselect(int index) {
    if (index == 3) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Lottie.network(
              'https://assets9.lottiefiles.com/private_files/lf30_nruc9E.json'));
    } else if (index == 4) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_jpxsQh.json'));
    } else if (index == 5) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Lottie.network(
              'https://assets1.lottiefiles.com/packages/lf20_gnhvwizz.json'));
    } else if (index == 6) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Lottie.network(
              'https://assets7.lottiefiles.com/packages/lf20_GUQObWT5Mw.json'));
    } else if (index == 7) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Lottie.network(
              'https://assets7.lottiefiles.com/packages/lf20_VfWq5Z.json'));
    } else {
      return Text('finish');
    }
  }

  getSJONData() async {
    print('예측함수시작');
    int height = pcosResult.height;
    int weight = pcosResult.weight;
    int waist = pcosResult.waist;
    int hair_growthYN = pcosResult.hair_growthYN;
    int skin_darkeningYN = pcosResult.skin_darkeningYN;
    int weight_gainYN = pcosResult.weight_gainYN;
    int fastfoodYN = pcosResult.fastfoodYN;
    int pimmplesYN = pcosResult.pimmplesYN;

    if (Platform.isAndroid) {
      var url = Uri.parse(
          'http://10.0.2.2:5000/pcospredict?height=$height&weight=$weight&waist=$waist&hair_growthYN=$hair_growthYN&skin_darkeningYN=$skin_darkeningYN&weight_gainYN=$weight_gainYN&fastfoodYN=$fastfoodYN&pimmplesYN=$pimmplesYN');
      var response = await http.get(url);
      setState(() {
        var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
        result = dataConvertedJSON['result'];
        pcosResult.predict = result;
        print('예측함수종료');
        addFirebase(height, weight, result);
        setState(() {
          pcosResult.height = 0;
          pcosResult.weight = 0;
          pcosResult.waist = 0;
        });

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Loding(),
            ));
        print('페이지 이동종료');
      });
    } else if (Platform.isIOS) {
      var url = Uri.parse(
          'http://192.168.10.47:5000/pcospredict?height=$height&weight=$weight&waist=$waist&hair_growthYN=$hair_growthYN&skin_darkeningYN=$skin_darkeningYN&weight_gainYN=$weight_gainYN&fastfoodYN=$fastfoodYN&pimmplesYN=$pimmplesYN');
      var response = await http.get(url);
      setState(() {
        var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
        result = dataConvertedJSON['result'];
        pcosResult.predict = result;
        print('예측함수종료');
        addFirebase(height, weight, result);

        setState(() {
          pcosResult.height = 0;
          pcosResult.weight = 0;
          pcosResult.waist = 0;
        });

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Loding(),
            ));
        print('페이지 이동종료');
      });
    }
  }

  //firebase에 키,몸무게, 예측값을 저장하는 함수
  addFirebase(int height, int weight, double predict) {
    print('파이어베이스 입력시작');
    print(UserInfoStatic.userNickname);
    FirebaseFirestore.instance.collection('survey_result').add({
      'height': height,
      'weight': weight,
      'predict': predict,
      'userNickname': UserInfoStatic.userNickname,
      'date': DateTime.now().toString().substring(0, 19)
    });
    print('파이어베이스 입력종료');
  }

  heightEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('키를 입력해주세요.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  weightEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('몸무게를 입력해주세요.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  waistEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('허리 사이즈를 입력해주세요.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} //END
