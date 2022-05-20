import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lock_pattern/components/lock_pattern.dart';
import 'package:flutter/services.dart';

class PatternCheck extends StatefulWidget {
  final Set<int> authValue;
  PatternCheck({Key? key, required this.authValue}) : super(key: key);

  @override
  State<PatternCheck> createState() => _PatternCheckState();
}

class _PatternCheckState extends State<PatternCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double shake = 10;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 40), vsync: this);
    animation = Tween(begin: 0.0, end: shake).animate(controller);
    super.initState();
    Clipboard.setData(const ClipboardData());
    HapticFeedback.heavyImpact();
  }

  Color statusColor = Colors.grey;

  void update() => setState(() {});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '개남패턴확인',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -1),
        ),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              double x = 0;
              if (animation.value != shake) x = animation.value - (shake / 2);
              return Transform.translate(
                offset: Offset(x, 0),
                child: LockPattern(
                  width: 300,
                  height: 300,
                  rowCounts: 3,
                  colCounts: 3,
                  pointPadding: 15,
                  defaultColor: statusColor,
                  complete: (Set<LockPoint> tryAuthPoints) async {
                    var tryAuthValues =
                        tryAuthPoints.map((p) => p.index).toSet();
                    if (setEquals(widget.authValue, tryAuthValues)) {
                      Navigator.pop(context, true);
                    } else {
                      statusColor = Colors.red;
                      update();
                      controller.repeat();
                      await Future.delayed(const Duration(milliseconds: 200));
                      controller.stop();
                      statusColor = Colors.grey;
                    }
                    update();
                  },
                ),
              );
            }),
      ),
    );
  }
}
