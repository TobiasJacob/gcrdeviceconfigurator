import 'dart:async';

import 'package:gcrdeviceconfigurator/usb/usb_status.dart';

import 'data/database.dart';
import 'i18n/language_settings.dart';

enum MainDataProviderState { loading, finished }

class MainDataProvider {
  late Database database;
  late LanguageSettings languageSettings;
  late USBStatus usbStatus;

  late Future loadFuture;
  late Function updateUserInterface;

  MainDataProvider() {
    loadFuture = loadData();
  }

  Future<void> loadData() async {
    database = Database();
    await database.load();
    languageSettings = await LanguageSettings.load();
    usbStatus = USBStatus();

    updateUserInterface();
  }
}
