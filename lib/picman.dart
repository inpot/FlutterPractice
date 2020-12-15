import 'package:flutter/material.dart';
import 'dart:math' as math;

class GesturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureT(),
    );
  }
}

class PicmanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Picman(),
        width: 300,
        height: 300,
        color: Colors.white,
      ),
    );
  }
}

class GestureT extends StatefulWidget {
  @override
  _GestureTState createState() => _GestureTState();
}

class _GestureTState extends State<GestureT> {
  var pointer = ValueNotifier(Offset(0, 0));
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: CustomPaint(painter: _GesterPainter(pointer)),
      ),
      onPanUpdate: (details) {
        pointer.value = details.localPosition;
      },
      onPanCancel: reset,
      onPanEnd: (details) => reset,
    );
  }

  void reset() {
    pointer.value = Offset.zero;
  }
}

class _GesterPainter extends CustomPainter {
  ValueNotifier<Offset> pointer;
  _GesterPainter(this.pointer) : super(repaint: pointer);
  var pen = Paint();
  var location = Offset(0, 0);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.srcOver);
    pen.color = Colors.blueAccent;
    var center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 300, pen);
    pen.color = Colors.lightGreen;

    var disX = center.dx - pointer.value.dx;
    var disY = center.dy - pointer.value.dy;
    var dis = math.sqrt(disX * disX + disY * disY);
    if (dis < 300) {
      location = pointer.value;
    } else {
      var rad = math.atan2(pointer.value.dy - center.dy, pointer.value.dx - center.dx);
      print("rad $rad");
      location = Offset(center.dx + 300 * math.cos(rad), center.dy + 300 * math.sin(rad));
      print(location);
    }
    canvas.drawCircle(location, 100, pen);
    pen.color = Colors.black;
    canvas.drawCircle(location, 10, pen);
  }

  @override
  bool shouldRepaint(covariant _GesterPainter oldDelegate) {
    return pointer.value.dx != oldDelegate.pointer.value.dx || pointer.value.dy != oldDelegate.pointer.value.dy;
  }
}

class Picman extends StatefulWidget {
  @override
  _PicmanState createState() => _PicmanState();
}

class _PicmanState extends State<Picman> with SingleTickerProviderStateMixin {
  var width = 300.0;
  var angleValue = ValueNotifier(1.0);
  AnimationController aniController;
  Animation animation;
  @override
  Widget build(BuildContext context) {
    print("build");
    return Container(
      width: width,
      height: width,
      child: CustomPaint(
        painter: _PicmanPainter(animation),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("init");
    aniController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    var curve = Curves.easeInOutCubic;
    var tween = CurveTween(curve: curve);
    animation = tween.animate(aniController);
    animation.addListener(() {
      angleValue.value = animation.value;
    });
    aniController.repeat(reverse: true);
  }

  @override
  void dispose() {
    aniController.dispose();
    super.dispose();
  }
}

class _PicmanPainter extends CustomPainter {
  Animation<double> angleVal;
  Paint _pen = new Paint();
  _PicmanPainter(this.angleVal) : super(repaint: angleVal) {
    this._pen.color = Colors.blue;
    this._pen.isAntiAlias = true;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var angle = angleVal.value * 2 * math.pi / 9;
    var end = 2 * math.pi - angle * 2;
    _pen.color = Colors.blue;
    canvas.drawArc(Rect.fromCenter(center: center, width: size.width, height: size.height), angle, end, true, _pen);
    _pen.color = Colors.white;
    canvas.drawCircle(Offset(center.dx + 20, center.dy / 2), 10, _pen);
  }

  @override
  bool shouldRepaint(covariant _PicmanPainter oldDelegate) {
    return (oldDelegate.angleVal.value != angleVal.value);
  }
}
