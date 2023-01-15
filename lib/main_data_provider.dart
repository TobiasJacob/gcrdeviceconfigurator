import 'dart:async';

import 'package:dartusbhid/enumerate.dart';
import 'package:gcrdeviceconfigurator/usb/usb_hid_device.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';
import 'package:localstorage/localstorage.dart';

import 'data/database.dart';
import 'data/app_settings.dart';

enum MainDataProviderState { loading, finished }

class MainDataProvider {
  Database database = Database();
  AppSettings appSettings = AppSettings();
  USBStatus usbStatus = USBStatus();

  static resetToFactory() async {
    final database = Database();
    await database.save();
    final appSettings = AppSettings();
    await appSettings.save();
  }

  Future<void> loadData() async {
    await database.load();
    await appSettings.load();

    // throw Exception("Test error");
  }
}
