import 'package:gcrdeviceconfigurator/data/data_point.dart';

enum Smoothing {
  highSpeed,
  normal,
  highAccuracy,
}

class ControllerAxis {
  final String name;
  final List<DataPoint> dataPoints;
  Smoothing smoothing;

  ControllerAxis(this.name, this.dataPoints, this.smoothing);

  static ControllerAxis empty(name) {
    return ControllerAxis(
        name, [DataPoint(0, 0), DataPoint(1, 1)], Smoothing.normal);
  }

  static ControllerAxis fromJSON(Map<String, dynamic> axisData) {
    String name = axisData["name"];
    List<DataPoint> dataPoints = (axisData["dataPoints"] as List)
        .map((e) => DataPoint.fromJSON(e))
        .toList();
    Smoothing smoothing = Smoothing.values[axisData["smoothing"]];
    double currentValue = 0.5;

    return ControllerAxis(name, dataPoints, smoothing);
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
      "name": name,
      "dataPoints": jsonDataPoints,
      "smoothing": smoothing.index
    };
  }
}
