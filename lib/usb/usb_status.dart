import 'dart:async';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

class USBStatus extends ChangeNotifier {
  List<double> currentValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  late Timer updateAxisValues;
  Random random = Random();

  USBStatus() {
    updateAxisValues =
        Timer.periodic(const Duration(milliseconds: 100), updateValues);
  }

  void updateValues(Timer timer) {
    for (var i = 0; i < currentValues.length; i++) {
      var newVal = currentValues[i] + (random.nextDouble() - 0.5) * 0.03;

      newVal += (0.5 - newVal) * 0.002;
      currentValues[i] = max(min(newVal, 1), 0);
    }
    notifyListeners();
  }

  static USBStatus of(BuildContext context) {
    return Provider.of<USBStatus>(context);
  }
}
