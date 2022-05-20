import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockPatternUtils {
  static bool isTouchPoint(
      Offset point, Offset currentPosition, int pointPadding) {
    return (point - currentPosition).distance < pointPadding;
  }
}

class LockPattern extends StatefulWidget {
  final double width;
  final double height;
  final int rowCounts;
  final int colCounts;
  final int pointPadding;
  final Color defaultColor;
  final Color activeColor;

  final void Function(Set<LockPoint>) complete;

  const LockPattern({
    Key? key,
    required this.width,
    required this.height,
    required this.rowCounts,
    required this.colCounts,
    required this.pointPadding,
    required this.complete,
    this.defaultColor = Colors.grey,
    this.activeColor = Colors.yellow,
  }) : super(key: key);

  @override
  State<LockPattern> createState() => _LockPatternState();
}

class LockPoint {
  final Offset point;
  final int index;
  bool _isSelected = false;
  LockPoint({required this.point, required this.index});
  updateSelectedPoint() {
    if (!_isSelected) {
      HapticFeedback.heavyImpact();
    }
    _isSelected = true;
  }

  bool get isSelected => _isSelected;
}

class _LockPatternState extends State<LockPattern> {
  Offset? updatePosition;
  List<LockPoint> lockPoints = [];
  Set<LockPoint> dropByPoints = {};
  bool isSelectedStartedPoints = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    var xDistance = widget.width / widget.rowCounts;
    var yDistance = widget.height / widget.colCounts;
    var index = 0;
    for (int i = 0; i < widget.rowCounts; i++) {
      for (int j = 0; j < widget.colCounts; j++) {
        index++;
        var point = LockPoint(
            point: Offset(xDistance * i + (xDistance / 2),
                yDistance * j + (yDistance / 2)),
            index: index);
        lockPoints.add(point);
      }
    }
    isSelectedStartedPoints = false;
    updatePosition = null;
    dropByPoints.clear();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: ((details) {
        if (lockPoints.isNotEmpty) {
          isSelectedStartedPoints = false;
          lockPoints.map((lp) {
            if (LockPatternUtils.isTouchPoint(
                lp.point, details.localPosition, widget.pointPadding)) {
              lp.updateSelectedPoint();
              dropByPoints.add(lp);
              isSelectedStartedPoints = true;
            }
          }).toList();
        }
        update();
      }),
      onPanUpdate: ((details) {
        if (isSelectedStartedPoints) {
          updatePosition = details.localPosition;
          lockPoints.map((lp) {
            if (LockPatternUtils.isTouchPoint(
                lp.point, details.localPosition, widget.pointPadding)) {
              lp.updateSelectedPoint();
              dropByPoints.add(lp);
            }
          }).toList();
        }
        update();
      }),
      onPanEnd: ((details) {
        widget.complete(dropByPoints);
        init();
        update();
      }),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: LockPatternPainter(
            lockPoints: lockPoints,
            updatePosition: updatePosition,
            dropByPoints: dropByPoints,
            pointPadding: widget.pointPadding,
            defaultColor: widget.defaultColor,
            activeColor: widget.activeColor,
          ),
        ),
      ),
    );
  }
}

class LockPatternPainter extends CustomPainter {
  Offset? updatePosition;
  List<LockPoint> lockPoints;
  Set<LockPoint> dropByPoints;

  Color defaultColor;
  Color activeColor;

  int pointPadding;
  Paint linePath;
  Paint selectedPaint;
  Paint defaultPaint;

  LockPatternPainter({
    required this.lockPoints,
    required this.updatePosition,
    required this.dropByPoints,
    required this.pointPadding,
    required this.defaultColor,
    required this.activeColor,
  })  : linePath = Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
        selectedPaint = Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2,
        defaultPaint = Paint()
          ..color = defaultColor
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < lockPoints.length; i++) {
      var cp = lockPoints[i].point;
      canvas.drawCircle(
          cp, 8, lockPoints[i].isSelected ? selectedPaint : defaultPaint);
    }
    var path = Path();
    if (dropByPoints.isNotEmpty) {
      path.moveTo(dropByPoints.first.point.dx, dropByPoints.first.point.dy);
      for (var point in dropByPoints) {
        path.lineTo(point.point.dx, point.point.dy);
      }
      if (updatePosition != null) {
        path.lineTo(updatePosition!.dx, updatePosition!.dy);
      }
      canvas.drawPath(path, linePath);
    } else {
      canvas.clipPath(path);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
