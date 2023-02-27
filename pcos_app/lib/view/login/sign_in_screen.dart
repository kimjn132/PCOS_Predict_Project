// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:pcos_app/view/login/sign_up_google_screen.dart';

// import '../../model/login/userInfo.dart';
// import '../../tab_bar.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(30, 200, 30, 0),
//                   child: Image.asset(
//                     './images/logo.png',
//                     width: 200,
//                   ),
//                 ),
//                 const Text('PCOS',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 40,
//                       color: Color(0xFFFBA5A8),
//                     )),
//                 // signInwithGoogleButton(),
//                 GestureDetector(
//                   onTap: () {
//                     signInWithGoogle();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
//                     child: Image.asset(
//                         './images/btn_google_signin_light_normal_web@2x.png'),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }

//   signInwithGoogleButton() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(500, 50),
//           backgroundColor: const Color(0xFFFBA5A8),
//         ),
//         onPressed: () {
//           signInWithGoogle();
//         },
//         child: const Text(
//           '구글 로그인',
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   // Future<UserCredential> signInWithGoogle() async {
//   //   try {
//   //     // Trigger the authentication flow
//   //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   //     // Obtain the auth details from the request
//   //     final GoogleSignInAuthentication? googleAuth =
//   //         await googleUser?.authentication;

//   //     // Create a new credential
//   //     final credential = GoogleAuthProvider.credential(
//   //       accessToken: googleAuth?.accessToken,
//   //       idToken: googleAuth?.idToken,
//   //     );
//   //     signUpToFireStore();

//   //     // Once signed in, return the UserCredential
//   //     return await FirebaseAuth.instance.signInWithCredential(credential);
//   //   } on PlatformException catch (e) {
//   //     if (e.code == 'sign_in_canceled') {
//   //     } else {}
//   //     rethrow;
//   //   }
//   // }

//   signOutGoogle() async {
//     await GoogleSignIn().signOut();
//     await FirebaseAuth.instance.signOut();
//   }

//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       await signOutGoogle();
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       // Create a new credential
//       try {
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken,
//           idToken: googleAuth?.idToken,
//         );
//         signUpToFireStore();
//         return await FirebaseAuth.instance.signInWithCredential(credential);
//       } catch (e) {
//         if (e == 'accessToken != null || idToken != null') {
//         } else {}
//       }
//       return null;

//       // Once signed in, return the UserCredential
//     } on PlatformException catch (e) {
//       if (e.code == 'sign_in_canceled') {
//       } else if (e.code == 'accessToken != null || idToken != null') {
//       } else {}
//       rethrow;
//     }
//   }

//   signUpToFireStore() {
//     FirebaseAuth.instance.authStateChanges().listen(
//       (User? user) async {
//         if (user != null) {
//           String? userId = user.email;
//           QuerySnapshot snapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .where('userId', isEqualTo: userId)
//               .get();
//           if (snapshot.docs.isNotEmpty) {
//             DocumentSnapshot document = snapshot.docs[0];
//             Map<String, dynamic> userData =
//                 document.data()! as Map<String, dynamic>;
//             String? uid = userData['uid'];
//             String? userId = userData['userId'];
//             String? userNickname = userData['userNickname'];
//             UserInfoStatic.uid = uid!;
//             UserInfoStatic.userId = userId!;
//             UserInfoStatic.userNickname = userNickname!;
//             UserInfoStatic.userId = userId;
//             Get.to(() => const Tabbar());
//           } else {
//             await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(user.uid)
//                 .set({
//               'uid': user.uid,
//               'userId': user.email,
//             });
//             Get.to(() => SignUpGoogleScreen(
//                   uid: user.uid,
//                 ));
//           }
//         } else {}
//       },
//     );
//   }
// }
