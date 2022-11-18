import 'package:gcrdeviceconfigurator/data/data_point.dart';

class ControllerAxis {
  final String name;
  final Map<String, DataPoint> dataPoints;

  ControllerAxis(this.name, this.dataPoints);
}
