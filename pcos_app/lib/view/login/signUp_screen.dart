import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcos_app/view/login/signup_success_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
  late TextEditingController passwordCheckTextController;
  late TextEditingController nicknameTextController;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode passwordCheckFocusNode;
  late FocusNode nicknameFocusNode;

  late String emailText = "";
  late String passwordText = "";
  late String passwordCheckText = "";
  late String nicknameText = "";

  late bool obscurePasswordBool;
  late bool obscurePasswordCheckBool;

  bool emailColor = true;
  bool passwordColor = true;
  bool passwordCheckColor = true;
  bool nicknameColor = true;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    passwordCheckTextController = TextEditingController();
    nicknameTextController = TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    passwordCheckFocusNode = FocusNode();
    nicknameFocusNode = FocusNode();

    focustListener();

    emailText = '';
    passwordText = '';
    passwordCheckText = '';
    nicknameText = '';

    obscurePasswordBool = true;
    obscurePasswordCheckBool = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                emailTextField(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        emailText,
                        style: TextStyle(
                            fontSize: 12,
                            color: emailColor ? Colors.blue : Colors.red),
                      ),
                    ),
                  ],
                ),
                passwordTextField(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        passwordText,
                        style: TextStyle(
                            fontSize: 12,
                            color: passwordColor ? Colors.blue : Colors.red),
                      ),
                    ),
                  ],
                ),
                passwordCheckTextField(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        passwordCheckText,
                        style: TextStyle(
                          fontSize: 12,
                          color: passwordCheckColor ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        signUpNullCheck();
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

  emailTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 30, 40, 10),
      child: SizedBox(
        width: 500,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailTextController,
          decoration: InputDecoration(
            label: Text(
              '이메일',
              style: TextStyle(color: emailColor ? Colors.blue : Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: emailColor ? Colors.blue : Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: emailColor ? Colors.blue : Colors.red,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          focusNode: emailFocusNode,
        ),
      ),
    );
  }

  passwordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
        focusNode: passwordFocusNode,
        obscureText: obscurePasswordBool,
        controller: passwordTextController,
        decoration: InputDecoration(
            label: Text(
              '비밀번호',
              style: TextStyle(color: passwordColor ? Colors.blue : Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: passwordColor ? Colors.blue : Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: passwordColor ? Colors.blue : Colors.red,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePasswordBool = !obscurePasswordBool;
                  });
                },
                icon: obscurePasswordBool
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off))),
      ),
    );
  }

  passwordCheckTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
        focusNode: passwordCheckFocusNode,
        controller: passwordCheckTextController,
        obscureText: obscurePasswordCheckBool,
        decoration: InputDecoration(
            label: Text(
              '비밀번호 재확인',
              style: TextStyle(
                  color: passwordCheckColor ? Colors.blue : Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: passwordCheckColor ? Colors.blue : Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: passwordCheckColor ? Colors.blue : Colors.red,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePasswordCheckBool = !obscurePasswordCheckBool;
                  });
                },
                icon: obscurePasswordCheckBool
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off))),
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

  signUpAction() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      signUpToFireStore();
      toSignUpSuccessScreen();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            emailColor = false;
            emailText = '이메일 형식이 틀렸습니다.';
          });
          break;
        case 'weak-password':
          setState(() {
            emailColor = false;
            emailText = '비밀번호를 6자 이상 입력해주세요.';
          });
          break;
        default:
          emailColor = false;
          emailText = '오류가 발생했습니다. 고객센터에 문의해 주시기 바랍니다.';
      }
    }
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
      setState(() {
        emailColor = false;
        nullCkeckErrorSnackBar('이메일을 입력하세요.');
      });
    } else if (passwordTextController.text.trim().isEmpty) {
      passwordColor = false;
      nullCkeckErrorSnackBar('비밀번호를 입력하세요.');
    } else if (passwordCheckTextController.text.trim().isEmpty) {
      passwordCheckColor = false;
      nullCkeckErrorSnackBar('비밀번호를 확인해주세요.');
    } else if (nicknameTextController.text.trim().isEmpty) {
      nullCkeckErrorSnackBar('닉네임을 입력하세요.');
    } else {
      signUpAction();
    }
  }

  signUpToFireStore() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'userId': emailTextController.text,
          'userNickname': nicknameTextController.text
        });
      }
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
        emailColor = true;
        emailText = "사용가능한 이메일 입니다.";
      });
    } else {
      // emailCheck = querySnapshot.docs.isEmpty;
      setState(() {
        emailColor = false;
        emailText = "이미 존재하는 이메일 입니다.";
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

  focustListener() {
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        if (emailTextController.text.trim().isEmpty) {
          setState(() {
            emailColor = false;
            emailText = '이메일을 입력하세요.';
          });
        }
        if (emailTextController.text.trim().isNotEmpty) {
          emailDuplicationCheck();
        }
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        if (passwordTextController.text.trim().isEmpty) {
          setState(() {
            passwordColor = false;
            passwordText = '비밀번호를 입력하세요';
          });
        } else if (passwordTextController.text.trim().length < 6) {
          setState(() {
            passwordColor = false;
            passwordText = '비밀번호는 6자 이상 입력해야 합니다.';
          });
        } else {
          setState(() {
            passwordColor = true;
            passwordText = '사용가능합니다.';
          });
        }
      }
    });
    passwordCheckFocusNode.addListener(() {
      if (!passwordCheckFocusNode.hasFocus) {
        if (passwordCheckTextController.text.trim().isEmpty) {
          setState(() {
            passwordCheckColor = false;
            passwordCheckText = '비밀번호를 입력하세요';
          });
        } else if (passwordCheckTextController.text.trim() !=
            passwordTextController.text.trim()) {
          setState(() {
            passwordCheckColor = false;
            passwordCheckText = '비밀번호가 일치하지 않습니다.';
          });
        } else {
          setState(() {
            passwordCheckColor = true;
            passwordCheckText = '비밀번호가 일치합니다.';
          });
        }
      }
    });
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
