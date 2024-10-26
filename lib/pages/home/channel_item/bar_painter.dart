import 'package:flutter/material.dart';

class BarPainter extends CustomPainter {
  final double margin;
  final double? value;
  final String text;

  BarPainter({required this.margin, required this.value, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - 2 * margin;
    final height = size.height - 2 * margin;

    // Red background
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    Offset p1 = Offset(margin, margin);
    Offset p2 = Offset(width - margin, height - margin);
    canvas.drawRect(Rect.fromPoints(p1, p2), paint);

    if (value == null) {
      return;
    } else {
      // Green bar
      paint = Paint()
        ..color = Colors.green
        ..strokeWidth = 2;
      p1 = Offset(margin, margin);
      p2 = Offset(margin + (value ?? 0.0) * (width - 2.0 * margin), height - margin);
      canvas.drawRect(Rect.fromPoints(p1, p2), paint);

      // Text value as percentage
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        text: text,
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(margin + width / 2 - tp.width / 2, margin));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
