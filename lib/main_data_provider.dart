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
  late Function updateUserInterface;

  MainDataProvider() {
    loadFuture = loadData();
  }

  Future<void> loadData() async {
    database = Database();
    // Use await database.save(); here to reset to factory
    await database.load();
    languageSettings = await AppSettings.load();
    usbStatus = USBStatus();

    updateUserInterface();
  }
}
