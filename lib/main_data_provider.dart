import 'dart:async';

import 'package:gcrdeviceconfigurator/usb/usb_status.dart';

import 'data/database.dart';
import 'data/app_settings.dart';

enum MainDataProviderState { loading, finished }

class MainDataProvider {
  late Database database;
  late AppSettings languageSettings;
  late USBStatus usbStatus;

  late Future loadFuture;

  MainDataProvider() {
    loadFuture = loadData();
  }

  static resetToFactory() async {
    final database = Database();
    await database.save();
    final appSettings = await AppSettings.defaultSettings();
    await appSettings.save();
  }

  Future<void> loadData() async {
    database = Database();
    await database.load();
    languageSettings = await AppSettings.load();
    usbStatus = USBStatus();

    // throw Exception("Test error");
  }
}
