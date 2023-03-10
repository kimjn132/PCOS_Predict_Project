import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pcos_app/model/login/userInfo.dart';
import 'package:pcos_app/view/login/sign_up_google_screen.dart';
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

  // ????????? ???????????????
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

  // ???????????? ???????????????
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

  // ????????? ??????
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
          '?????????',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ??????, ???????????? ?????? ??????
  findAndSignUpButtonGruop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            //
          },
          child: const Text(
            '????????? ??????',
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
            '???????????? ??????',
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
            '????????????',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ?????? ????????? ??????
  signInwithGoogleButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(500, 50),
          backgroundColor: const Color(0xFFFBA5A8),
        ),
        onPressed: () {
          signInWithGoogle();
        },
        child: const Text(
          '?????? ?????????',
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
        content: Text('???????????? ??????????????? ??????????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  emailEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('???????????? ???????????? ???????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  passwordEmptySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('??????????????? ???????????? ???????????????.'),
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
        content: Text('????????? ?????? ??????????????? ???????????? ????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void userDisabledErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('?????? ?????? ??????????????? ???????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void invalidEmailErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('????????? ????????? ???????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void unknownErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('??????????????? ????????? ????????? ????????????.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void toMainScreen() {
    BottomNavController bottomNavController = BottomNavController();
    Get.put(bottomNavController);
    Get.to(() => const Tabbar());
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
    }
  }

  signOutGoogle() async {
    showDialog(
      context: context,
      builder: (contexts) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await signOutGoogle();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        signUpToFireStore();
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        if (e == 'accessToken != null || idToken != null') {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      }
      return null;

      // Once signed in, return the UserCredential
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        Navigator.pop(context);
      } else if (e.code == 'accessToken != null || idToken != null') {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
      rethrow;
    }
  }

  signUpToFireStore() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          String? userId = user.email;
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('userId', isEqualTo: userId)
              .get();
          if (snapshot.docs.isNotEmpty) {
            DocumentSnapshot document = snapshot.docs[0];
            Map<String, dynamic> userData =
                document.data()! as Map<String, dynamic>;
            String? uid = userData['uid'];
            String? userId = userData['userId'];
            String? userNickname = userData['userNickname'];
            UserInfoStatic.uid = uid!;
            UserInfoStatic.userId = userId!;
            UserInfoStatic.userNickname = userNickname!;
            UserInfoStatic.userId = userId;
            Get.to(() => const Tabbar());
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'uid': user.uid,
              'userId': user.email,
            });
            Get.to(() => SignUpGoogleScreen(
                  uid: user.uid,
                ));
          }
        } else {}
      },
    );
  }
} // --- End
