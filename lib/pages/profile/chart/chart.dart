import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';

import '../../../data/app_settings.dart';
import '../../../data/profile.dart';
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
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    final usbStatus = USBStatus.of(context);
    final profile = Profile.of(context);
    final axis = ControllerAxis.of(context);
    final appSettings = AppSettings.of(context);

    // Todo: Make this more efficient
    var usage = Usage.none;
    for (final element in profile.axes.entries) {
      if (element.value == axis) {
        usage = element.key;
        break;
      }
    }
    var channelIndex = -1;
    for (var i = 0; i < appSettings.channelSettings.length; i++) {
      if (appSettings.channelSettings[i].usage == usage) {
        channelIndex = i;
        break;
      }
    }
    var value = 0.0;
    if (channelIndex >= 0) {
      var channelSettings = appSettings.channelSettings[channelIndex];
      value = (usbStatus.currentValues[channelIndex] - channelSettings.minValue) / (channelSettings.maxValue - channelSettings.minValue);
    }

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
                painter: ChartPainter(
                    axis, margin, value),
                child: Container()),
            ...dataPoints
                .asMap()
                .map((i, dataPoint) => MapEntry(
                    i,
                    DragBall(
                      dataPoint: dataPoint,
                      size: constraints.biggest,
                      margin: margin,
                      updateDataPoint: (newDataPoint) {
                        axis.updateChartDataPoint(i, newDataPoint);
                      },
                      onPressed: () {
                        axis.deleteChartDataPointIfMoreThanTwo(i);
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
                          axis.addChartDataPointAfter(i);
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
