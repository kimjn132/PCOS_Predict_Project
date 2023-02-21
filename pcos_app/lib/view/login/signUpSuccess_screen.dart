import 'package:flutter/material.dart';
import 'package:python_project_test/view/signIn_screen.dart';

class SignUpSuccessScreen extends StatefulWidget {
  const SignUpSuccessScreen({super.key});

  @override
  State<SignUpSuccessScreen> createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const SignInScreen();
            },
          ),
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: const [
              SizedBox(
                height: 300,
              ),
              Text('회원가입이 완료 되었습니다.')
            ],
          ),
        ),
      ),
    );
  }
}
