import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

import 'channel.dart';

enum Usage { none, gas, brake, clutch, handbrake }

class AlreadyInUseException implements Exception {}

class AppSettings extends ChangeNotifier {
  String languageCode = "en";
  String countryCode = "US";
  List<Channel> channelSettings;

  final LocalStorage storage;

  bool edited = false;

  AppSettings(this.storage)
      : channelSettings = [for (var i = 0; i < 10; i++) Channel.empty()];

  static AppSettings of(context) {
    return Provider.of<AppSettings>(context);
  }

  static Future<AppSettings> defaultSettings() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

    return AppSettings(storage);
  }

  static Future<AppSettings> load() async {
    final appSettings = await defaultSettings();
    await appSettings.reload();
    return appSettings;
  }

  Future<void> reload() async {
    languageCode = storage.getItem("languageCode") ?? languageCode;
    countryCode = storage.getItem("countryCode") ?? countryCode;
    channelSettings =
        ((await storage.getItem("channelSettings") as List<dynamic>?)
                ?.map((el) => Channel.fromJSON(el)))?.toList() ??
            channelSettings;
    edited = false;
  }

  Future<void> save() async {
    await storage.setItem("languageCode", languageCode);
    await storage.setItem("countryCode", countryCode);
    await storage.setItem(
        "channelSettings", channelSettings.map((e) => e.toJSON()).toList());

    resetEdited();
  }

  bool thisOrDependencyEdited() {
    if (edited) {
      return true;
    }
    for (final chn in channelSettings) {
      if (chn.thisOrDependencyEdited()) {
        return true;
      }
    }
    return false;
  }

  void resetEdited() {
    for (final chn in channelSettings) {
      chn.resetEdited();
    }
    edited = false;
  }

  void updateLanguage(String languageCode, String countryCode) {
    this.languageCode = languageCode;
    this.countryCode = countryCode;

    edited = true;
    notifyListeners();
  }

  void updateUsage(int index, Usage usage) {
    if (usage != Usage.none) {
      for (var channel in channelSettings) {
        if (channel.usage == usage) {
          throw AlreadyInUseException();
        }
      }
    }
    channelSettings[index].setUsage(usage);
    notifyListeners();
  }
}
