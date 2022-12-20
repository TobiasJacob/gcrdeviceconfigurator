import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'axis.dart';

class Profile extends ChangeNotifier {
  String name;
  Map<String, ControllerAxis> axes;

  Profile(this.name, this.axes);

  static Profile of(context) {
    return Provider.of<Profile>(context);
  }

  static Profile empty(String name) {
    return Profile(name, {
      "GasAxis": ControllerAxis.empty("Gas"),
      "BrakeAxis": ControllerAxis.empty("Brake"),
      "ClutchAxis": ControllerAxis.empty("Clutch"),
      "HandBrakeAxis": ControllerAxis.empty("HandBrake"),
    });
  }

  static Profile fromJSON(Map<String, dynamic> profileData) {
    String name = profileData["name"];
    Map<String, ControllerAxis> axes = {};
    if (profileData.isEmpty) {
      return Profile.empty("Default");
    }
    for (final k in profileData["axes"].keys) {
      axes[k] = ControllerAxis.fromJSON(profileData["axes"][k]);
    }
    return Profile(name, axes);
  }

  Map<String, dynamic> toJSON() {
    final jsonAxes = {};

    for (final k in axes.keys) {
      jsonAxes[k] = axes[k]!.toJSON();
    }

    return {"axes": jsonAxes, "name": name};
  }

  void updateName(String name) {
    this.name = name;
    notifyListeners();
  }
}
