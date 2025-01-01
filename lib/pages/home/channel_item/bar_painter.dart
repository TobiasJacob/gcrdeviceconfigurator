import 'package:flutter/material.dart';

class BarPainter extends CustomPainter {
  final double margin;
  final double? value;
  final String text;

  BarPainter({required this.margin, required this.value, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - 2 * margin;
    const height = 22.0;

    // Red background
    Paint paint = Paint()
      ..color = const Color.fromRGBO(48, 48, 48, 1);
    Offset p1 = Offset(margin, -height / 2.0);
    Offset p2 = Offset(width - margin, height / 2.0);
    canvas.drawRect(Rect.fromPoints(p1, p2), paint);

    if (value == null) {
      return;
    } else {
      // Green bar
      paint = Paint()
        ..color = const Color.fromRGBO(185, 101, 254, 1);
      p1 = Offset(margin, -height / 2.0);
      p2 = Offset(
          margin + (value ?? 0.0) * (width - 2.0 * margin), height / 2.0);
      canvas.drawRect(Rect.fromPoints(p1, p2), paint);

      // Text value as percentage
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 16),
        text: text,
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(width / 2 - tp.width / 2, -height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
