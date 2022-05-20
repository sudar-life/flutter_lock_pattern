import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        '환영합니다.',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      )),
    );
  }
}
