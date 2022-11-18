import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

class ChartPainter extends CustomPainter {
  final List<DataPoint> dataPoints;

  ChartPainter(this.dataPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < dataPoints.length - 1; i++) {
      Offset p1 = Offset(
          dataPoints[i].x * size.width, (1 - dataPoints[i].y) * size.height);
      Offset p2 = Offset(dataPoints[i + 1].x * size.width,
          (1 - dataPoints[i + 1].y) * size.height);
      Paint paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
