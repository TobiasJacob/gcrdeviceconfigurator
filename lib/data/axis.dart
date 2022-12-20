import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:provider/provider.dart';

enum Smoothing {
  highSpeed,
  normal,
  highAccuracy,
}

class ControllerAxis extends ChangeNotifier {
  final int index;
  final List<DataPoint> dataPoints;
  Smoothing smoothing;

  bool edited = false;

  ControllerAxis(this.index, this.dataPoints, this.smoothing);

  static ControllerAxis of(context) {
    return Provider.of<ControllerAxis>(context);
  }

  static ControllerAxis empty(name) {
    return ControllerAxis(
        name, [DataPoint(0, 0), DataPoint(1, 1)], Smoothing.normal);
  }

  static ControllerAxis fromJSON(Map<String, dynamic> axisData) {
    int index = axisData["index"];
    List<DataPoint> dataPoints = (axisData["dataPoints"] as List)
        .map((e) => DataPoint.fromJSON(e))
        .toList();
    Smoothing smoothing = Smoothing.values[axisData["smoothing"]];

    return ControllerAxis(index, dataPoints, smoothing);
  }

  double getY(double x) {
    if (x < dataPoints[0].x) {
      return dataPoints[0].y;
    }

    for (var i = 1; i < dataPoints.length; i++) {
      if (x < dataPoints[i].x) {
        // Linear interpolation
        return dataPoints[i - 1].y +
            (dataPoints[i].y - dataPoints[i - 1].y) *
                (x - dataPoints[i - 1].x) /
                (dataPoints[i].x - dataPoints[i - 1].x);
      }
    }

    return dataPoints[dataPoints.length - 1].y;
  }

  Map<String, dynamic> toJSON() {
    final jsonDataPoints = dataPoints.map((dp) => dp.toJSON()).toList();
    return {
      "index": index,
      "dataPoints": jsonDataPoints,
      "smoothing": smoothing.index
    };
  }

  // UI Actions

  void updateChartDataPoint(int i, DataPoint point) {
    var x = point.x;
    var y = point.y;
    if (i > 0) {
      x = max(x, dataPoints[i - 1].x);
    } else {
      x = max(x, 0);
    }
    if (i < dataPoints.length - 1) {
      x = min(x, dataPoints[i + 1].x);
    } else {
      x = min(x, 1);
    }
    y = max(y, 0);
    y = min(y, 1);
    dataPoints[i] = DataPoint(x, y);
    edited = true;
    notifyListeners();
  }

  void deleteChartDataPointIfMoreThanTwo(int i) {
    if (dataPoints.length > 2) {
      dataPoints.removeAt(i);
    }
    edited = true;
    notifyListeners();
  }

  void addChartDataPointAfter(int i) {
    dataPoints.insert(
        i + 1,
        DataPoint(
          (dataPoints[i].x + dataPoints[i + 1].x) / 2,
          (dataPoints[i].y + dataPoints[i + 1].y) / 2,
        ));
    notifyListeners();
  }

  void setAxisSmoothing(Smoothing? smoothing) {
    smoothing = smoothing ?? Smoothing.normal;
    notifyListeners();
  }

  bool thisOrDependencyEdited() {
    return edited;
  }

  void resetEdited() {
    edited = false;
  }
}
