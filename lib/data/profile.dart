import 'axis.dart';

class Profile {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name)
      : axes = {
          "GasAxis": ControllerAxis("Gas"),
          "BrakeAxis": ControllerAxis("Brake"),
          "ClutchAxis": ControllerAxis("Clutch"),
          "HandBrakeAxis": ControllerAxis("HandBrake"),
        };
}
