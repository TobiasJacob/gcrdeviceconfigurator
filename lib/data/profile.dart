import 'dart:ui';

import 'package:gcrdeviceconfigurator/data/data_point.dart';

import 'axis.dart';

class Profile {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name)
      : axes = {
          "Gas": ControllerAxis(
              "Gas",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "Brake": ControllerAxis(
              "Brake",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "Clutch": ControllerAxis(
              "Clutch",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
          "HandBrake": ControllerAxis(
              "HandBrake",
              {
                "kdn": DataPoint(0, 0),
                "akn": DataPoint(0.3, 0.5),
                "2xk": DataPoint(1.0, 1.0),
              }.values.toList()),
        };
}
