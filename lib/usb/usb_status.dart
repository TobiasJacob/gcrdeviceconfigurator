import 'dart:async';
import 'dart:math';

import 'package:dartusbhid/open_device.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/usb/usb_hid_device.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class USBStatus extends ChangeNotifier {
  GcrUsbHidDevice device = GcrUsbHidDevice();
  Timer? updateAxisValues;

  List<int> currentValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  Random random = Random();
  
  bool get isConnected => !device.simulated;

  USBStatus() {
    // Timer.periodic(Duration(milliseconds: 100), updateValuesRandom);
    // updatePeriodic();
    updateLoop();
  }

  void updateLoop() async {
    while (true) {
      if (isConnected) {
        try {
          currentValues = await device.receiveRawADCValues();
          notifyListeners();
        } catch (e) {
          try {
            await device.close();
          } catch (e) {
            debugPrint("Error closing device: $e");
          }
        }
      } else {
        try {
          await device.open();
        // ignore: empty_catches
        } catch (e) {
          debugPrint("Error opening device: $e");
        }
      }
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void updateValuesRandom(Timer timer) async {
    for (var i = 0; i < currentValues.length; i++) {
      var newVal = currentValues[i] + (random.nextDouble() - 0.5) * 100;

      newVal += (4096 / 2 - newVal) * 0.002;
      currentValues[i] = max(min(newVal.round(), 4096), -4096);
    }
    notifyListeners();
  }

  static USBStatus of(BuildContext context) {
    return Provider.of<USBStatus>(context);
  }
}
