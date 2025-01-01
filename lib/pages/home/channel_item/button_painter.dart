import 'package:flutter/material.dart';

class ButtonPainter extends CustomPainter {
  final double margin;
  final bool value;
  final String onText;
  final String offText;

  ButtonPainter({required this.margin, required this.value, required this.onText, required this.offText});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - 2 * margin;
    const height = 22.0;

    // Red background
    Paint paint = Paint()
      ..color = !value ? const Color.fromRGBO(238, 65, 35, 1) : const Color.fromRGBO(48, 48, 48, 1);
    Offset p1 = Offset(margin, -height / 2.0);
    Offset p2 = Offset(width / 2.0, height / 2.0);
    canvas.drawRect(Rect.fromPoints(p1, p2), paint);

    // Green bar
    paint = Paint()
      ..color = value ? Color.fromARGB(255, 58, 182, 0) : const Color.fromRGBO(48, 48, 48, 1);
    p1 = Offset(width / 2.0, -height / 2.0);
    p2 = Offset(width - margin, height / 2.0);
    canvas.drawRect(Rect.fromPoints(p1, p2), paint);

    // Text value as percentage
    TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.white, fontSize: 16),
      text: value ? onText : offText,
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset((width / 2.0 + margin) / 2.0 + (value ? (width / 2.0 - margin) : 0.0) - tp.width / 2, -height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
