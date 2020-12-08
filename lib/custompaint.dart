import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomPaintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _PageSTF());
  }
}

class _PageSTF extends StatefulWidget {
  @override
  __PageSTFState createState() => __PageSTFState();
}

class __PageSTFState extends State<_PageSTF> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Page(img),
    );
  }

  @override
  void initState() {
    super.initState();
    initImg();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initImg() async {
    img = await loadImageFromAssets("assets/640.webp");
    setState(() {});
  }

  ui.Image img = null;

  Future<ui.Image> loadImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }
}

class ClockWidget extends CustomPainter {
  var pen = Paint();
  DateTime date;
  var radius = 120.0;
  ClockWidget(this.date) {
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
    var hour = date.hour;
    if (hour > 12) {
      hour -= 12;
    }
    var minute = date.minute;
    var second = date.second;
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Page extends CustomPainter {
  _Page(this.img);
  ui.Image img;
  var pen = Paint();
  @override
  void paint(Canvas canvas, Size size) {
    pen.color = Colors.black;
    pen.isAntiAlias = true;
    pen.blendMode = BlendMode.srcOver;
    canvas.drawColor(Colors.white, BlendMode.color);

    _drawAxis(canvas, size);
    _drawRect(canvas, size);
    _drawPath(canvas, size);
    _drawImg(canvas, size);
  }

  void _drawImg(Canvas canvas, Size size) async {
    if (img == null) {
      return;
    }
    pen.style = PaintingStyle.fill;
    canvas.drawImageRect(
        img, Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()), Rect.fromLTWH(0, 0, 200, 800), pen);
  }

  void _drawRect(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(300, 300);
    pen
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;
    //【1】.矩形中心构造
    Rect rectFromCenter = Rect.fromCenter(center: Offset(0, 0), width: 160, height: 160);
    canvas.drawRect(rectFromCenter, pen);
    //【2】.矩形左上右下构造
    Rect rectFromLTRB = Rect.fromLTRB(-120, -120, -80, -80);
    canvas.drawRect(rectFromLTRB, pen..color = Colors.red);
    //【3】. 矩形左上宽高构造
    Rect rectFromLTWH = Rect.fromLTWH(80, -120, 40, 40);
    canvas.drawRect(rectFromLTWH, pen..color = Colors.orange);
    //【4】. 矩形内切圆构造
    Rect rectFromCircle = Rect.fromCircle(center: Offset(100, 100), radius: 20);
    canvas.drawRect(rectFromCircle, pen..color = Colors.green);
    //【5】. 矩形两点构造
    Rect rectFromPoints = Rect.fromPoints(Offset(-120, 80), Offset(-80, 120));
    canvas.drawRect(rectFromPoints, pen..color = Colors.purple);

    canvas.restore();
  }

  void _drawPath(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(300, 100);
    Path path = Path();
    path.lineTo(60, 60);
    path.lineTo(-60, 60);
    path.lineTo(60, -60);
    path.lineTo(-60, -60);
    path.close();
    canvas.drawPath(path, pen);
    canvas.translate(140, 0);
    canvas.drawPath(
        path,
        pen
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    pen.style = PaintingStyle.stroke;
    Path path2 = Path();
    path2.lineTo(60, 60);
    path2.lineTo(-60, 60);
    path2.close();
    canvas.translate(150, 0);
    canvas.drawShadow(path2, Colors.deepPurpleAccent, 3, false);
    canvas.translate(250, 0);
    canvas.drawShadow(path2, Colors.deepPurpleAccent, 3, true);
    canvas.restore();
  }

  void _drawColor(Canvas canvas, Size size) {
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    pen.shader = ui.Gradient.linear(Offset(0, 0), Offset(size.width, 0), colors, pos, TileMode.clamp);
    pen.blendMode = BlendMode.lighten;
    canvas.drawPaint(pen);
  }

  void _drawAxis(Canvas canvas, Size size) {
    pen.strokeWidth = 2;
    pen.color = Colors.blue;
    var axisCenter = 300.0;
    var margin = 30.0;

    // Axis Y
    canvas.drawLine(Offset(axisCenter, margin), Offset(axisCenter, size.height - margin), pen);
    canvas.drawLine(Offset(axisCenter - 12, size.height - 48), Offset(axisCenter, size.height - margin), pen);
    canvas.drawLine(Offset(axisCenter + 12, size.height - 48), Offset(axisCenter, size.height - margin), pen);

    // Axis Y
    canvas.drawLine(Offset(margin, axisCenter), Offset(size.width - margin, axisCenter), pen);
    canvas.drawLine(
        Offset(
          size.width - 48,
          axisCenter - 12,
        ),
        Offset(
          size.width - margin,
          axisCenter,
        ),
        pen);
    canvas.drawLine(
        Offset(
          size.width - 48,
          axisCenter + 12,
        ),
        Offset(size.width - margin, axisCenter),
        pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
