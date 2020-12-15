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
