import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  var _tickStream = Stream.periodic(Duration(seconds: 1));
  var _timeTick = ValueNotifier(DateTime.now());
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: ClockPainter(_timeTick),
      ),
    );
  }

  @override
  void initState() {
    _subscription = _tickStream.listen((event) {
      _timeTick.value = DateTime.now();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}

class ClockPainter extends CustomPainter {
  var pen = Paint();
  var radius = 120.0;
  ValueNotifier<DateTime> date;

  ClockPainter(ValueListenable repaint) : super(repaint: repaint) {
    this.date = repaint;
    _generateLablePoint(radius - 30, Offset.zero);
  }
  @override
  void paint(Canvas canvas, Size size) {
    pen.color = Colors.black;
    pen.isAntiAlias = true;
    canvas.drawColor(Colors.white, BlendMode.color);
    pen.color = Colors.amber;
    _drawBg(canvas, size);
    _drawNumberic(canvas, size);
    _drawHMS(canvas, size);
  }

  void _drawNumberic(Canvas canvas, Size size) {
    canvas.save();
    var center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    var index = 3;
    lablePoints.forEach((point) {
      var lable = index > 12 ? index - 12 : index;
      var paragBuilder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 12,
        fontStyle: FontStyle.normal,
        textDirection: ui.TextDirection.ltr,
      ))
        ..pushStyle(ui.TextStyle(color: Colors.black))
        ..addText("$lable")
        ..pop();
      var para = paragBuilder.build();
      para.layout(ParagraphConstraints(width: 14));
      var offset = Offset(point.dx - para.height / 2, point.dy - para.width / 2);
      canvas.drawParagraph(para, offset);
      index++;
    });
    canvas.restore();
  }

  List<Offset> lablePoints = List();
  void _generateLablePoint(double radius, Offset center) {
    var count = 12;
    var step = 2 * math.pi / count;
    for (int i = 0; i < count; i++) {
      var dx = center.dx + radius * math.cos(i * step);
      var dy = center.dx + radius * math.sin(i * step);
      var point = Offset(dx, dy);
      lablePoints.add(point);
    }
  }

  void _drawBg(Canvas canvas, Size size) {
    canvas.save();
    var center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.drawCircle(Offset.zero, radius, pen);
    pen.style = PaintingStyle.stroke;
    pen.strokeWidth = 4;
    pen.color = Colors.indigo;
    canvas.drawCircle(Offset.zero, radius, pen);
    var count2 = 60;
    var step2 = 2 * math.pi / 60;
    pen.strokeCap = StrokeCap.butt;
    // var LenghHour = 18;
    // var LenghMinute = 14;
    for (int i = 0; i < count2; i++) {
      if (i % 5 == 0) {
        pen.color = Colors.black;
        pen.strokeWidth = 4;
        canvas.drawLine(Offset(0, -100), Offset(0, -118), pen);
      } else {
        pen.color = Colors.black54;
        pen.strokeWidth = 2;
        canvas.drawLine(Offset(0, -104), Offset(0, -118), pen);
      }
      canvas.rotate(step2);
    }
    canvas.restore();
  }

  void _drawHMS(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    pen.style = PaintingStyle.fill;
    pen.color = Colors.black;
    var hour = date.value.hour;
    if (hour > 12) {
      hour -= 12;
    }
    var minute = date.value.minute;
    var second = date.value.second;
    print("Date $date");
// draw Houre pointer
    canvas.save();
    var radPerH = 2 * math.pi / 12;
    var radiansH = radPerH * hour; //*  (1 + minute / 60);
    radiansH += radPerH * minute / 60;
    canvas.rotate(radiansH);

    pen.strokeWidth = 6;
    canvas.drawLine(Offset.zero, Offset(0, -40), pen);
    var path1 = Path();
    path1.moveTo(-5, -35);
    path1.lineTo(0, -50);
    path1.lineTo(5, -35);
    path1.close();
    canvas.drawPath(path1, pen);
    canvas.restore();

// draw Minute pointer

    canvas.save();
    var radPerM = 2 * math.pi / 60;
    var radiansM = radPerM * minute; //*  (1 + minute / 60);
    canvas.rotate(radiansM);
    pen.strokeWidth = 4;
    canvas.drawLine(Offset.zero, Offset(0, -60), pen);
    var path2 = Path();
    path2.moveTo(-5, -55);
    path2.lineTo(0, -75);
    path2.lineTo(5, -55);
    path2.close();
    canvas.drawPath(path2, pen);
    canvas.restore();

// draw second pointer
    canvas.save();
    var radPerS = 2 * math.pi / 60;
    var radiansS = radPerS * second; //*  (1 + minute / 60);
    canvas.rotate(radiansS);
    pen.strokeWidth = 2;
    canvas.drawLine(Offset.zero, Offset(0, -80), pen);
    var path3 = Path();
    path3.moveTo(-5, -75);
    path3.lineTo(0, -95);
    path3.lineTo(5, -75);
    canvas.drawPath(path3, pen);
    canvas.restore();

    canvas.drawCircle(Offset.zero, 6, pen);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    if (oldDelegate is ClockWidget) {
      var dt = oldDelegate.date.value;
      return (dt.second != date.value.second || dt.minute != date.value.minute || dt.hour != date.value.hour);
    }
    return true;
  }
}
