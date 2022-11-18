import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'chart_drag_ball.dart';
import 'chart_painter.dart';

class Chart extends StatelessWidget {
  final Map<String, DataPoint> dataPoints;
  final Function(String index, DataPoint newDataPoint) updateDataPoint;

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
            CustomPaint(
                painter: ChartPainter(dataPoints.values.toList()),
                child: Container()),
            ...dataPoints
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                        dataPoint: dataPoint,
                        size: constraints.biggest,
                        updateDataPoint: (newPoint) {
                          updateDataPoint(i, newPoint);
                        })))
                .values
          ],
        ),
      );
    });
  }
}
