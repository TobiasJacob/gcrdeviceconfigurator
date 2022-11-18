import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'chart_button.dart';
import 'chart_drag_ball.dart';
import 'chart_painter.dart';

List<DataPoint> getMiddlePoints(List<DataPoint> dataPointList) {
  List<DataPoint> result = List.empty(growable: true);
  for (var i = 0; i < dataPointList.length - 1; i++) {
    result.add(DataPoint((dataPointList[i].x + dataPointList[i + 1].x) / 2,
        (dataPointList[i].y + dataPointList[i + 1].y) / 2));
  }
  return result;
}

class Chart extends StatelessWidget {
  final List<DataPoint> dataPoints;
  final Function(int index, DataPoint newDataPoint) updateDataPoint;
  final Function(int index) createDataPoint;

  const Chart(
      {super.key,
      required this.updateDataPoint,
      required this.dataPoints,
      required this.createDataPoint});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.green,
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        child: Stack(
          alignment: Alignment.center,
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
                        })))
                .values,
            ...getMiddlePoints(dataPoints)
                .asMap()
                .map((i, dp) => MapEntry(
                      i,
                      ChartButton(
                        dataPoint: dp,
                        size: constraints.biggest,
                        onPressed: () {
                          createDataPoint(i);
                        },
                      ),
                    ))
                .values
          ],
        ),
      );
    });
  }
}
