import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RegistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("regist"),
      ),
      body: CustomPaint(painter: MyPaint(), size: Size(300, 300)),
    );
  }
}

class MyPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.orange[100];
    paint.strokeWidth = 4;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(60, 60), Offset(300, 250), paint);
    canvas.drawCircle(Offset(150, 150), 70, paint);
    paint.color = Colors.orange[200];
    canvas.drawCircle(Offset(150, 150), 60, paint);
    paint.color = Colors.orange[300];
    canvas.drawCircle(Offset(150, 150), 50, paint);
    paint.color = Colors.orange[400];
    canvas.drawCircle(Offset(150, 150), 40, paint);
    paint.color = Colors.orange[500];
    canvas.drawCircle(Offset(150, 150), 30, paint);
    paint.color = Colors.orange[600];
    canvas.drawCircle(Offset(150, 150), 20, paint);
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.green;
    paint.strokeWidth = 1;
    canvas.drawArc(
        Rect.fromCenter(center: Offset(150, 150), width: 150, height: 150),
        0,
        2,
        true,
        paint);
    paint.strokeWidth = 3;
    canvas.drawRRect( RRect.fromLTRBR(20, 20, 100, 100, Radius.circular(6)), paint);

    paint.style = PaintingStyle.fill;
    canvas.drawPoints(

        ///PointMode的枚举类型有三个，
        ///points（点）， lines（线，隔点连接）， polygon（线，相邻连接）
        PointMode.polygon,
        [
          Offset(20, 50),
          Offset(120, 50),
          Offset(80, 100),
          Offset(80, 150),
          Offset(60, 170),
          Offset(60, 100),
          Offset(20, 50),
        ],
        paint);
    var paragraph = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.left,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontSize: 15.0,
    ));
    ParagraphConstraints pc = ParagraphConstraints(width: 300);
    paragraph.addText("Regist");
    paint.color = Colors.black;
    paragraph.pushStyle(ui.TextStyle(color: Colors.black));
    canvas.drawParagraph(paragraph.build()..layout(pc), Offset(80, 100));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
