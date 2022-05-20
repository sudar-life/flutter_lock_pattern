import 'package:flutter/material.dart';
import 'package:flutter_lock_pattern/pages/home.dart';
import 'package:flutter_lock_pattern/pages/pattern_check.dart';
import 'package:flutter_lock_pattern/pages/setting.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Set<int> authValue = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '개남패턴인증서',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var auth = await Navigator.push<Set<int>>(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
                authValue = auth ?? {};
              },
              child: const Text('패턴설정'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (authValue.isEmpty) {
                  Fluttertoast.showToast(msg: '패턴을 설정해주세요');
                } else {
                  var authCheck = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatternCheck(authValue: authValue),
                    ),
                  );
                  if (authCheck != null && authCheck) {
                    Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                }
              },
              child: const Text('인증확인'),
            ),
          ],
        ),
      ),
    );
  }
}
