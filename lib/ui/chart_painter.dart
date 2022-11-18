import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

class ChartPainter extends CustomPainter {
  final List<DataPoint> dataPoints;
  final double margin;

  ChartPainter(this.dataPoints, this.margin);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width - 2 * margin;
    final height = size.height - 2 * margin;
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    Offset p1 = Offset(0, (1 - dataPoints[0].y) * height + margin);
    Offset p2 = Offset(dataPoints[0].x * width + margin,
        (1 - dataPoints[0].y) * height + margin);
    canvas.drawLine(p1, p2, paint);
    for (var i = 0; i < dataPoints.length - 1; i++) {
      p1 = Offset(dataPoints[i].x * width + margin,
          (1 - dataPoints[i].y) * height + margin);
      p2 = Offset(dataPoints[i + 1].x * width + margin,
          (1 - dataPoints[i + 1].y) * height + margin);
      canvas.drawLine(p1, p2, paint);
    }
    final i = dataPoints.length - 1;
    p1 = Offset(dataPoints[i].x * width + margin,
        (1 - dataPoints[i].y) * height + margin);
    p2 = Offset(1.0 * width + margin, (1 - dataPoints[i].y) * height + margin);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
