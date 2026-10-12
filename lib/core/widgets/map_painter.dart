import 'package:flutter/material.dart';

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2.0;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 16.0;

    // Draw some simple streets / grids
    canvas.drawLine(
        Offset(size.width * 0.2, 0), Offset(size.width * 0.2, size.height), paint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(
        Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.75), paint);

    // Large road
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
