import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
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
  final ControllerAxis axis;
  final Function(ControllerAxis axis) updateAxis;

  const Chart({super.key, required this.axis, required this.updateAxis});

  @override
  Widget build(BuildContext context) {
    final dataPoints = axis.dataPoints;
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
                painter: ChartPainter(axis, margin), child: Container()),
            ...dataPoints
                .asMap()
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                      dataPoint: dataPoint,
                      size: constraints.biggest,
                      margin: margin,
                      updateDataPoint: (newDataPoint) {
                        var x = newDataPoint.x;
                        var y = newDataPoint.y;
                        if (i > 0) {
                          x = max(x, axis.dataPoints[i - 1].x);
                        } else {
                          x = max(x, 0);
                        }
                        if (i < axis.dataPoints.length - 1) {
                          x = min(x, axis.dataPoints[i + 1].x);
                        } else {
                          x = min(x, 1);
                        }
                        y = max(y, 0);
                        y = min(y, 1);
                        axis.dataPoints[i] = DataPoint(x, y);
                        updateAxis(axis);
                      },
                      onPressed: () {
                        if (dataPoints.length > 2) {
                          axis.dataPoints.removeAt(i);
                          updateAxis(axis);
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
                          axis.dataPoints.insert(
                              i + 1,
                              DataPoint(
                                (axis.dataPoints[i].x +
                                        axis.dataPoints[i + 1].x) /
                                    2,
                                (axis.dataPoints[i].y +
                                        axis.dataPoints[i + 1].y) /
                                    2,
                              ));
                          updateAxis(axis);
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
