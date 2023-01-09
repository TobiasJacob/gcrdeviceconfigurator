import 'dart:async';
import 'dart:math';

import 'package:dartusbhid/open_device.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class USBStatus extends ChangeNotifier {
  List<int> currentValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  Random random = Random();
  
  OpenUSBDevice? device;

  USBStatus(this.device);

  void updateValuesRandom(Timer timer) async {
    for (var i = 0; i < currentValues.length; i++) {
      var newVal = currentValues[i] + (random.nextDouble() - 0.5) * 100;

      newVal += (32768 / 2 - newVal) * 0.002;
      currentValues[i] = max(min(newVal.round(), 32768), -32768);
    }
    notifyListeners();
  }

  void updatePeriodic() async {
    while (true) {
      final report = await device!.readReport(null);
      for (var i = 0; i < currentValues.length; i++) {
        final val = report.buffer.asByteData().getInt16(i * 2 + 1, Endian.little);
        currentValues[i] = val;
      }
      notifyListeners();
    }
  }

  static USBStatus of(BuildContext context) {
    return Provider.of<USBStatus>(context);
  }
}
