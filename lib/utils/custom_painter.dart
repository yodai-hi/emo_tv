import 'package:emo_tv/constants/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OvalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    paint.color = CC.MAIN;
    canvas.drawOval(Rect.fromPoints(
      Offset(0, -100),
      Offset(size.width, 100),
    ), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CirclePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    paint.color = CC.BASE;
    canvas.drawCircle(Offset(size.width/2, 0), 180.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
