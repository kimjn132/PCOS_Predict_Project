import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:pcos_app/view/login/sign_in_google_screen.dart';
import 'package:pcos_app/view/login/signup_screen.dart';

import '../../bottom_navigation.dart';
import '../../tab_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late bool obscureTextBool;

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    obscureTextBool = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
                    child: Image.asset(
                      './images/logo.png',
                      width: 200,
                    ),
                  ),
                  const Text('PCOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color(0xFFFBA5A8),
                      )),
                  emailTextField(),
                  passwordTextField(),
                  signInButton(),
                  findAndSignUpButtonGruop(),
                  signInwithGoogleButton(),
                ],
              ),
            ),
          )),
    );
  }

  // 이메일 텍스트필드
  emailTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: 'Email',
        ),
      ),
    );
  }

  // 비밀번호 텍스트필드
  passwordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: TextField(
        obscureText: obscureTextBool,
        controller: passwordTextController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'Password',
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureTextBool = !obscureTextBool;
                  });
                },
                icon: obscureTextBool
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off))),
      ),
    );
  }

  // 로그인 버튼
  signInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(500, 50),
          backgroundColor: const Color(0xFFFBA5A8),
        ),
        onPressed: () {
          emptyCheck();
        },
        child: const Text(
          '로그인',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 찾기, 회원가입 버튼 그룹
  findAndSignUpButtonGruop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            //
          },
          child: const Text(
            '아이디 찾기',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const Text(
          '|',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        TextButton(
          onPressed: () {
            //
          },
          child: const Text(
            '비밀번호 찾기',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const Text(
          '|',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
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
            '회원가입',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // 구글 로그인 버튼
  signInwithGoogleButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(500, 50),
          backgroundColor: const Color(0xFFFBA5A8),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return GoogleSignInScreen();
            },
          ));
        },
        child: const Text(
          '구글 로그인',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
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
      builder: (contexts) {
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
      emailTextController.text = '';
      passwordTextController.text = '';
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
    BottomNavController bottomNavController = BottomNavController();
    Get.put(bottomNavController);
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
      String? userId = userData['userId'];
      String? userNickname = userData['userNickname'];
      UserInfoStatic.uid = uid!;
      UserInfoStatic.userId = userId!;
      UserInfoStatic.userNickname = userNickname!;
      UserInfoStatic.userId = userId;
    }
  }
} // --- End
