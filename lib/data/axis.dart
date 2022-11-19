import 'package:gcrdeviceconfigurator/data/data_point.dart';

enum Smoothing {
  HighSpeed,
  Normal,
  HighAccuracy,
}

class ControllerAxis {
  final String name;
  final List<DataPoint> dataPoints;
  Smoothing smoothing;
  double currentValue;

  ControllerAxis(this.name, this.dataPoints, this.smoothing, this.currentValue);
}
