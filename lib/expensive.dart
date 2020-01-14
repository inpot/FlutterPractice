import 'dart:math';

import 'package:flutter/material.dart';

class ExpensivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expensive Paint"),
      ),
      body: ExpPaint(),
    );
  }
}

class ExpPaint extends StatefulWidget {
  @override
  _ExpPaintState createState() => _ExpPaintState();
}

class _ExpPaintState extends State<ExpPaint> {
  GlobalKey _paintKey = new GlobalKey();
  Offset _offset;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary( child:
         new CustomPaint(
            painter: new ExpensivePainter(),
            isComplex: true,
            willChange: false,
          ),
        ),
        new Listener(
          onPointerDown: _updateOffset,
          onPointerMove: _updateOffset,
          child: new CustomPaint(
            key: _paintKey,
            painter: new SingleCirclePaiter(_offset),
            child: new ConstrainedBox(
              constraints: new BoxConstraints.expand(),
            ),
          ),
        )
      ],
    );
  }

  _updateOffset(PointerEvent event) {
    RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    Offset offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _offset = offset;
    });
  }
}

class ExpensivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("Doing expensive paint job");
    Random rand = new Random(12345678);
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.white,
      Colors.brown,
      Colors.cyan,
      Colors.orange
    ];
    for (var i = 0; i < 5000; i++) {
      canvas.drawCircle(
          new Offset(
              rand.nextDouble() * size.width, rand.nextDouble() * size.height),
          10 + rand.nextDouble() * 20,
          new Paint()
            ..color = colors[rand.nextInt(colors.length)].withOpacity(0.2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false; 
}

class SingleCirclePaiter extends CustomPainter {
  final Offset _offset;

  SingleCirclePaiter(this._offset);
  @override
  void paint(Canvas canvas, Size size) {
    if (_offset == null) return;
    canvas.drawCircle(_offset, 10.0, new Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(SingleCirclePaiter other) => other._offset != _offset;
}
