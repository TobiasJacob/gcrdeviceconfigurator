import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'axis.dart';

class Profile extends ChangeNotifier {
  String name;
  List<ControllerAxis> axes;
  bool edited = false;

  Profile(this.name, this.axes);

  static Profile of(context) {
    return Provider.of<Profile>(context);
  }

  static Profile empty(String name) {
    return Profile(
        name, [for (var i = 0; i < 10; i += 1) ControllerAxis.empty(i)]);
  }

  static Profile fromJSON(Map<String, dynamic> profileData) {
    String name = profileData["name"];
    List<ControllerAxis> axes = [];
    if (profileData.isEmpty) {
      return Profile.empty("Default");
    }
    for (final a in profileData["axes"]) {
      axes.add(ControllerAxis.fromJSON(a));
    }
    return Profile(name, axes);
  }

  Map<String, dynamic> toJSON() {
    final jsonAxes = [];

    for (final a in axes) {
      jsonAxes.add(a.toJSON());
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
    for (final axis in axes) {
      if (axis.thisOrDependencyEdited()) {
        return true;
      }
    }
    return false;
  }

  void resetEdited() {
    for (final axis in axes) {
      axis.resetEdited();
    }
    edited = false;
  }
}
