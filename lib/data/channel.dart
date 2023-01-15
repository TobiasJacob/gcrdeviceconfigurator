import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class Channel extends ChangeNotifier {
  Usage usage;
  int minValue;
  int maxValue;

  bool edited = false;

  Channel(this.usage, this.minValue, this.maxValue);

  static Channel of(context) {
    return Provider.of<Channel>(context);
  }

  static Channel empty() {
    return Channel(Usage.none, 0, 4096);
  }

  static Channel fromJSON(Map<String, dynamic> data) {
    final usage = Usage.values[data["usage"] ?? 0];
    final minValue = data["minValue"] ?? 0;
    final maxValue = data["maxValue"] ?? 4096;

    return Channel(usage, minValue, maxValue);
  }

  Map<String, dynamic> toJSON() {
    return {"usage": usage.index, "minValue": minValue, "maxValue": maxValue};
  }

  bool thisOrDependencyEdited() {
    return edited;
  }

  void resetEdited() {
    edited = false;
  }

  // actions
  void setUsage(Usage usage) {
    this.usage = usage;
    edited = true;
    notifyListeners();
  }

  void setMinValue(int minValue) {
    this.minValue = minValue;
    edited = true;
    notifyListeners();
  }

  void setMaxValue(int maxValue) {
    this.maxValue = maxValue;
    edited = true;
    notifyListeners();
  }
}
