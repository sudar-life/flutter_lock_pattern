import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lock_pattern/components/lock_pattern.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Set<int> auth = {};
  bool isFinish = false;
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, auth);
          },
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text(
          '개남패턴등록',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -1),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              auth.isEmpty
                  ? '패턴설정'
                  : isFinish
                      ? '설정완료'
                      : '패턴확인',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -1),
            ),
            LockPattern(
                width: 300,
                height: 300,
                rowCounts: 3,
                colCounts: 3,
                pointPadding: 15,
                complete: (Set<LockPoint> tryAuthPoints) {
                  var tryAuthValues = tryAuthPoints.map((p) => p.index).toSet();
                  if (auth.isEmpty) {
                    auth = tryAuthValues;
                  } else {
                    if (setEquals(auth, tryAuthValues)) {
                      isFinish = true;
                    }
                  }
                  update();
                }),
            ElevatedButton(
              onPressed: () {
                auth = {};
                update();
              },
              child: const Text('재설정'),
            ),
          ],
        ),
      ),
    );
  }
}
