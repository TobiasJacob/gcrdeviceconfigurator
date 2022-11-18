import 'dart:ui';

import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'axis.dart';

class Profile {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name)
      : axes = {
          "Gas": ControllerAxis("Gas",
              [DataPoint(0, 0), DataPoint(0.3, 0.5), DataPoint(1.0, 1.0)]),
          "Brake": ControllerAxis("Brake",
              [DataPoint(0, 0), DataPoint(0.3, 0.5), DataPoint(1.0, 1.0)]),
          "Clutch": ControllerAxis("Clutch",
              [DataPoint(0, 0), DataPoint(0.3, 0.5), DataPoint(1.0, 1.0)]),
          "Hand-Brake": ControllerAxis("Hand-Brake",
              [DataPoint(0, 0), DataPoint(0.3, 0.5), DataPoint(1.0, 1.0)]),
        };
}
