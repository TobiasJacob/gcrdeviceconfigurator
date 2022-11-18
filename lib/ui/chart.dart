import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'chart_drag_ball.dart';

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

class Chart extends StatelessWidget {
  final List<DataPoint> dataPoints;
  final Function(int index, DataPoint newDataPoint) updateDataPoint;

  const Chart(
      {super.key, required this.updateDataPoint, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.green,
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        child: Stack(
          children: [
            CustomPaint(painter: ChartPainter(dataPoints), child: Container()),
            ...dataPoints
                .asMap()
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                      dataPoint: dataPoint,
                      size: constraints.biggest,
                      updateDataPoint: (newPoint) {
                        updateDataPoint(i, newPoint);
                      },
                    )))
                .values
          ],
        ),
      );
    });
  }
}
