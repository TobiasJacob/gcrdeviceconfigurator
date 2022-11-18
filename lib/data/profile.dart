import 'dart:ui';

import 'axis.dart';

class Profile {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name)
      : axes = {
          "Gas": ControllerAxis("Gas"),
          "Brake": ControllerAxis("Brake"),
          "Clutch": ControllerAxis("Clutch"),
          "Hand-Brake": ControllerAxis("Hand-Brake"),
        };
}
