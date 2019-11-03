import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faceRects);

  final Size absoluteImageSize;
  final List<Rect> faceRects;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (Rect faceRect in faceRects) {
      canvas.drawRect(
            Rect.fromLTRB(
              faceRect.left * scaleX,
              faceRect.top * scaleY,
              faceRect.right * scaleX,
              faceRect.bottom * scaleY,
            ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faceRects != faceRects;
  }
}
