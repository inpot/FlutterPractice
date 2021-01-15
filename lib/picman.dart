import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as ui;

class GesturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureT(),
    );
  }
}

class RulerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: RulerWidget(),
        color: Colors.white,
      ),
    );
  }
}

class RulerWidget extends StatefulWidget {
  @override
  _RulerWidgetState createState() => _RulerWidgetState();
}

class _RulerWidgetState extends State<RulerWidget> {
  ValueNotifier point = ValueNotifier(Offset.zero);
  Offset downP = null;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: CustomPaint(
          painter: RulerPainter(point),
        ),
        onPanDown: (details) {
          if (downP == null) downP = details.localPosition;
        },
        onPanUpdate: (details) =>
            point.value = Offset(details.localPosition.dx - downP.dx, downP.dy + details.localPosition.dy));
  }
}

class RulerPainter extends CustomPainter {
  var padding = 16.0;
  var length = 60.0;
  var max = 100.0;
  var min = 0;
  var pen = Paint();
  ValueNotifier pointer;
  RulerPainter(this.pointer) : super(repaint: pointer);

  @override
  void paint(Canvas canvas, Size size) {
    print("offset ${pointer.value}");
    var dx = padding + pointer.value.dx;
    var maxDx = 520;
    pen.color = Colors.black;

    var dy = padding;
    for (int i = min; i <= max; i++) {
      if (dx > maxDx) {
        break;
      }
      if (i % 10 == 0) {
        pen.strokeWidth = 4;
        canvas.drawLine(Offset(dx, dy), Offset(dx, dy + length), pen);
        var paragBuilder = ParagraphBuilder(ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: 12,
          fontStyle: FontStyle.normal,
          textDirection: ui.TextDirection.ltr,
        ))
          ..pushStyle(ui.TextStyle(color: Colors.black))
          ..addText("${i}")
          ..pop();
        var parag = paragBuilder.build();
        parag.layout(ui.ParagraphConstraints(width: 30));
        canvas.drawParagraph(
          parag,
          Offset(dx - parag.width / 2, dy + length + 10),
        );
      } else {
        pen.strokeWidth = 2;
        canvas.drawLine(Offset(dx, dy), Offset(dx, dy + length - 10), pen);
      }
      dx += 10;
    }
  }

  @override
  bool shouldRepaint(covariant RulerPainter oldDelegate) {
    return pointer.value.dx != oldDelegate.pointer.value.dx || pointer.value.dy != oldDelegate.pointer.value.dy;
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
