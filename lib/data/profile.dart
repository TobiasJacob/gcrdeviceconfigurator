import 'dart:ui';

import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'axis.dart';

class Profile {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name)
      : axes = {
          "dkixm": ControllerAxis(
              "Gas",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "qxlk": ControllerAxis(
              "Brake",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "xlkw": ControllerAxis(
              "Clutch",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "xkwo": ControllerAxis(
              "HandBrake",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
        };
}
