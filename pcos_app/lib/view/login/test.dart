import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pcos_app/model/login/userinfo.dart';

class TestS extends StatefulWidget {
  const TestS({super.key});

  @override
  State<TestS> createState() => _TestSState();
}

class _TestSState extends State<TestS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(UserInfoStatic.uid),
          ],
        ),
      ),
    );
  }
}