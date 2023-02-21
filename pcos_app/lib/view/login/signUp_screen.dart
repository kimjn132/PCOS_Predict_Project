import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcos_app/view/login/signUpSuccess_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late TextEditingController nicknameTextController;

  // // boolean for email duplication check
  // late bool emailCheck;

  // FocusNode for email duplication check
  late FocusNode emailFocusNode;

  // text for email duplication check
  String emailDuplicationText = "";

  // email duplication check text color
  Color testColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    nicknameTextController = TextEditingController();

    // // boolean for email duplication check
    // emailCheck = false;

    // email duplication
    emailFocusNode = FocusNode();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        if (emailTextController.text.isEmpty) {
          emailNullCheck();
        }
        if (emailTextController.text.isNotEmpty) {
          emailDuplicationCheck();
        }
      }
    });

    // text for email duplication check
    emailDuplicationText = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  focusNode: emailFocusNode,
                ),
              ),
              TextButton(
                onPressed: () {
                  emailDuplicationCheck();
                },
                child: const Text('data'),
              ),
            ],
          ),
          Text(
            emailDuplicationText,
          ),
          TextField(
            controller: passwordTextController,
            decoration: const InputDecoration(
              label: Text('PassWord'),
            ),
          ),
          TextField(
            controller: nicknameTextController,
            decoration: const InputDecoration(
              label: Text('Nickname'),
            ),
          ),
          TextButton(
            onPressed: () {
              signUpNullCheck();
            },
            child: const Text(
              'Sign Up',
            ),
          ),
          const Text('비밀번호는 6자(영문 기준) 이상이어야 합니다.'),
          TextButton(
            onPressed: () {
              emailDuplicationCheck();
            },
            child: const Text(
              'Test',
            ),
          ),
        ],
      ),
    );
  }

  signUpAction() {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          emailDuplicationText = '이메일 형식이 틀렸습니다.';
          break;
      }
    }
      signUpToFireStore();
      toSignUpSuccessScreen();
  }

  nullCkeckErrorSnackBar(String nullMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nullMessage,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  signUpNullCheck() {
    if (emailTextController.text.trim().isEmpty) {
      nullCkeckErrorSnackBar('이메일을 입력하세요.');
    } else if (passwordTextController.text.trim().isEmpty) {
      nullCkeckErrorSnackBar('비밀번호를 입력하세요.');
    } else if (nicknameTextController.text.isEmpty) {
      nullCkeckErrorSnackBar('닉네임을 입력하세요.');
    } else {
      signUpAction();
    }
  }

  signUpToFireStore() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'userId': emailTextController.text,
      'userNickname': nicknameTextController.text
    });
  }

  emailNullCheck() {
    setState(() {
      emailDuplicationText = '이메일을 입력하세요.';
    });
  }

  Future<void> emailDuplicationCheck() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: emailTextController.text)
        .get();
    if (querySnapshot.docs.isEmpty) {
      // emailCheck = querySnapshot.docs.isEmpty;
      setState(() {
        emailDuplicationText = "사용가능한 이메일 입니다.";
      });
    } else {
      // emailCheck = querySnapshot.docs.isEmpty;
      setState(() {
        emailDuplicationText = "이미 존재하는 이메일 입니다.";
      });
    }
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
}
