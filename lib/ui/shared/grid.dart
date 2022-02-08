import 'dart:ui';
import 'package:flutter/material.dart';

class GridPainter extends StatefulWidget {
  @override
  _GridPainterState createState() => _GridPainterState();
}

class _GridPainterState extends State<GridPainter>
    with TickerProviderStateMixin {
  var _sides = 3.0;

  late Animation<double> animation;
  late AnimationController controller;

  late Animation<double> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: ShapePainter(_sides, animation.value),
                    child: Container(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FOR PAINTING POLYGONS
class ShapePainter extends CustomPainter {
  final double sides;
  final double animationValue;

  final numVDivisions = 5;
  final numHDivisions = 8;
  final topPercentage = 0.2;

  ShapePainter(this.sides, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw horizontal lines
    var topLineLength = size.width * 0.8;

    var topLine = Paint()
      ..color = Colors.pink
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var topLinePath = Path();

    topLinePath.moveTo(-size.width / 2, 0);
    topLinePath.lineTo(size.width * 2, 0);

    canvas.drawShadow(topLinePath, Colors.pink, 8.0, false);
    canvas.drawPath(topLinePath, topLine);

    for (int i = 0; i <= numVDivisions; i++) {
      var path = Path();

      var percentage = i / numVDivisions + animationValue;
      if (percentage > 1.0) {
        percentage -= 1.0;
      }
      var yVal = size.height * percentage;

      path.moveTo(0, yVal);
      path.lineTo(size.width, yVal);

      var paint = Paint()
        ..color = Colors.pink.withOpacity(percentage)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);
    }

    // Draw vertical lines
    var topOffset = (size.width - topLineLength) / 2;

    for (int i = 0; i <= numHDivisions; i++) {
      var paint = Paint()
        ..color = Colors.pink
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var path = Path();
      var percentage = i / numHDivisions;
      var bottomX = ((size.width * 1.5) * percentage) - (size.width * 0.25);
      var topX = topOffset + (topLineLength * percentage);
      //print("Top $topLineLength Bottom $percentage");

      path.moveTo(bottomX, size.height);
      path.lineTo(topX, 0);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
