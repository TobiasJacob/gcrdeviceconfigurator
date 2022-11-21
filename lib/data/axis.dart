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
  double currentValue;

  ControllerAxis(this.name)
      : dataPoints = [DataPoint(0, 0), DataPoint(1, 1)],
        smoothing = Smoothing.normal,
        currentValue = 0.5;

  double getY() {
    final x = currentValue;
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
}
