import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcos_app/view/login/signUp_screen.dart';

import '../../model/login/userInfo.dart';
import '../../tab_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;

  get test => null;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            TextField(
              controller: emailTextController,
              decoration: const InputDecoration(
                label: Text(
                  'Email',
                ),
              ),
            ),
            TextField(
              controller: passwordTextController,
              decoration: const InputDecoration(
                label: Text(
                  'PassWord',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                emptyCheck();
              },
              child: const Text(
                'Sign in',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SignUpScreen();
                    },
                  ),
                );
              },
              child: const Text(
                'Sign up',
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  getUserInfo();
                });
              },
              child: const Text(
                'Test',
              ),
            ),
          ],
        ),
      ),
    );
  }

  emptyCheck() {
    if (emailTextController.text.trim().isEmpty &&
        passwordTextController.text.trim().isEmpty) {
      allEmptySnackBar();
    } else if (emailTextController.text.trim().isEmpty) {
      emailEmptySnackBar();
    } else if (passwordTextController.text.trim().isEmpty) {
      passwordEmptySnackBar();
    } else {
      signInAction();
    }
  }

  allEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('이메일과 비밀번호를 입력해주세요.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  emailEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('이메일이 입력되지 않았습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  passwordEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('비밀번호가 입력되지 않았습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void signInAction() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
      await getUserInfo();
      toMainScreen();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          Navigator.pop(context);
          invalidEmailErrorSnackBar();
          break;
        case 'user-disabled':
          Navigator.pop(context);
          userDisabledErrorSnackBar();
          break;
        case 'user-not-found':
          Navigator.pop(context);
          inputErrorSnackBar();
          break;
        case 'wrong-password':
          Navigator.pop(context);
          inputErrorSnackBar();
          break;
        default:
          Navigator.pop(context);
          invalidEmailErrorSnackBar();
      }
    }
  }

  void inputErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('이메일 혹은 비밀번호가 일치하지 않습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void userDisabledErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('탈퇴 혹은 비활성화된 계정입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void invalidEmailErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('이메일 형식이 틀렸습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void unknownErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('고객센터에 문의해 주시기 바랍니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void toMainScreen() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Tabbar();
        },
      ),
    );
  }

  Future<void> getUserInfo() async {
    String userId = emailTextController.text;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs[0];
      Map<String, dynamic> userData = document.data()! as Map<String, dynamic>;
      String? uid = userData['uid'];
      String? userNickname = userData['userNickname'];
      UserInfoStatic.uid = uid!;
      UserInfoStatic.userNickname = userNickname!;
    }
  }
} // --- End
