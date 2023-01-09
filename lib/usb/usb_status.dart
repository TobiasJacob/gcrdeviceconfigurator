import 'dart:async';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class USBStatus extends ChangeNotifier {
  List<int> currentValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  Random random = Random();

  void updateValues(Timer timer) {
    for (var i = 0; i < currentValues.length; i++) {
      var newVal = currentValues[i] + (random.nextDouble() - 0.5) * 100;

      newVal += (8000 - newVal) * 0.002;
      currentValues[i] = max(min(newVal.round(), 16384), 0);
    }
    notifyListeners();
  }

  static USBStatus of(BuildContext context) {
    return Provider.of<USBStatus>(context);
  }
}
