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
  final Function(int index) deleteDataPoint;

  const Chart(
      {super.key,
      required this.updateDataPoint,
      required this.dataPoints,
      required this.createDataPoint,
      required this.deleteDataPoint});

  @override
  Widget build(BuildContext context) {
    const margin = 16.0;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: constraints.biggest.width,
        height: constraints.biggest.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(margin), color: Colors.grey[300]),
            CustomPaint(
                painter: ChartPainter(dataPoints, margin), child: Container()),
            ...dataPoints
                .asMap()
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                      dataPoint: dataPoint,
                      size: constraints.biggest,
                      margin: margin,
                      updateDataPoint: (newPoint) {
                        updateDataPoint(i, newPoint);
                      },
                      onPressed: () {
                        if (dataPoints.length > 2) {
                          deleteDataPoint(i);
                        }
                      },
                    )))
                .values,
            ...getMiddlePoints(dataPoints)
                .asMap()
                .map((i, dp) => MapEntry(
                      i,
                      ChartButton(
                        dataPoint: dp,
                        size: constraints.biggest,
                        margin: margin,
                        text: "+",
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
