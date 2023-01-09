import 'dart:async';

import 'package:dartusbhid/enumerate.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';
import 'package:localstorage/localstorage.dart';

import 'data/database.dart';
import 'data/app_settings.dart';

enum MainDataProviderState { loading, finished }

class MainDataProvider {
  Database database = Database();
  AppSettings appSettings = AppSettings();
  USBStatus usbStatus = USBStatus(null);
  
  Timer? updateAxisValues;

  static resetToFactory() async {
    final database = Database();
    await database.save();
    final appSettings = AppSettings();
    await appSettings.save();
  }

  Future<void> loadData() async {
    await database.load();
    await appSettings.load();
    final devices = await enumerateDevices(22352, 1155);
    if (devices.isEmpty) {
      usbStatus = USBStatus(null);
      updateAxisValues =
          Timer.periodic(const Duration(milliseconds: 10), usbStatus.updateValuesRandom);
    } else {
      print(devices.first);
      final device = await devices.first.open();
      print(device);
      usbStatus = USBStatus(device);
      usbStatus.updatePeriodic();
    }
    

    // throw Exception("Test error");
  }
}
