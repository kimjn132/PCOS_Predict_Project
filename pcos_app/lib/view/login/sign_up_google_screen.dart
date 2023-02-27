import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pcos_app/view/login/signup_success_screen.dart';

import '../../model/login/userInfo.dart';

class SignUpGoogleScreen extends StatefulWidget {
  const SignUpGoogleScreen({super.key, required this.uid});
  final String uid;

  @override
  State<SignUpGoogleScreen> createState() => _SignUpGoogleScreenState();
}

class _SignUpGoogleScreenState extends State<SignUpGoogleScreen> {
  late TextEditingController nicknameTextController;

  late FocusNode nicknameFocusNode;

  late String nicknameText = "";

  bool nicknameColor = true;

  @override
  void initState() {
    super.initState();
    nicknameTextController = TextEditingController();

    nicknameFocusNode = FocusNode();

    focustListener();

    nicknameText = '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800], // 앱바 색상 변경
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBA5A8), // 앱바 색상 변경
          foregroundColor: Colors.white, // 앱바 텍스트 색상 변경
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('회원가입'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Image.asset(
                    './images/logo.png',
                    width: 100,
                  ),
                ),
                const Text('PCOS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFFBA5A8),
                    )),
                nicknameTextField(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        nicknameText,
                        style: TextStyle(
                          fontSize: 12,
                          color: nicknameColor ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      backgroundColor: const Color(0xFFFBA5A8),
                    ),
                    onPressed: () {
                      setState(() {
                        signUpToFireStore();
                      });
                    },
                    child: const Text(
                      '회원가입',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  nicknameTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
        controller: nicknameTextController,
        decoration: InputDecoration(
          label: Text(
            '닉네임',
            style: TextStyle(color: nicknameColor ? Colors.blue : Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: nicknameColor ? Colors.blue : Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: nicknameColor ? Colors.blue : Colors.red,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        focusNode: nicknameFocusNode,
      ),
    );
  }

  signUpToFireStore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .update({'userNickname': nicknameTextController.text});
    //
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.uid)
        .get();
    DocumentSnapshot document = snapshot.docs[0];
    Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
    String? uid = userData['uid'];
    String? userId = userData['userId'];
    String? userNickname = userData['userNickname'];
    UserInfoStatic.uid = uid!;
    UserInfoStatic.userId = userId!;
    UserInfoStatic.userNickname = userNickname!;
    UserInfoStatic.userId = userId;
    Get.to(() => const SignUpSuccessScreen());
  }

  toSignUpSuccessScreen() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SignUpSuccessScreen();
        },
      ),
    );
  }

  focustListener() {
    nicknameFocusNode.addListener(() {
      if (!nicknameFocusNode.hasFocus) {
        if (nicknameTextController.text.trim().isEmpty) {
          setState(() {
            nicknameColor = false;
            nicknameText = '닉네임을 입력하세요.';
          });
        } else {
          nicknameDuplicationCheck();
        }
      }
    });
  }

  Future<void> nicknameDuplicationCheck() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userNickname', isEqualTo: nicknameTextController.text)
        .get();
    if (querySnapshot.docs.isEmpty) {
      setState(() {
        nicknameColor = true;
        nicknameText = "사용가능한 닉네임 입니다.";
      });
    } else {
      setState(() {
        nicknameColor = false;
        nicknameText = "이미 존재하는 닉네임 입니다.";
      });
    }
  }
}
