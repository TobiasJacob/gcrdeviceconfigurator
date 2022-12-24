import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'axis.dart';

class Profile extends ChangeNotifier {
  String name;
  Map<Usage, ControllerAxis> axes;
  bool edited = false;

  Profile(this.name, this.axes);

  static Profile of(context) {
    return Provider.of<Profile>(context);
  }

  static Profile empty(String name) {
    return Profile(name, {
      for (var i = 0; i < Usage.values.length; i += 1)
        Usage.values[i]: ControllerAxis.empty()
    });
  }

  static Profile fromJSON(Map<String, dynamic> profileData) {
    String name = profileData["name"];
    Map<Usage, ControllerAxis> axes = {};
    if (profileData.isEmpty) {
      return Profile.empty("Default");
    }
    final jsonAxes = profileData["axes"] ?? {};
    for (final usage in Usage.values) {
      if (usage == Usage.none) {
        continue;
      }
      final key = usage.index.toString();
      if (jsonAxes.containsKey(key)) {
        axes[usage] = ControllerAxis.fromJSON(jsonAxes[key]!);
      } else {
        axes[usage] = ControllerAxis.empty();
      }
    }
    return Profile(name, axes);
  }

  Map<String, dynamic> toJSON() {
    final jsonAxes = {};

    for (final a in axes.entries) {
      jsonAxes[a.key.index.toString()] = a.value.toJSON();
    }

    return {"axes": jsonAxes, "name": name};
  }

  void updateName(String name) {
    this.name = name;
    edited = true;
    notifyListeners();
  }

  bool thisOrDependencyEdited() {
    if (edited) {
      return true;
    }
    for (final axis in axes.values) {
      if (axis.thisOrDependencyEdited()) {
        return true;
      }
    }
    return false;
  }

  void resetEdited() {
    for (final axis in axes.values) {
      axis.resetEdited();
    }
    edited = false;
  }
}
