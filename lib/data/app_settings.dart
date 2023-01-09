import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

import 'channel.dart';

enum Usage { none, gas, brake, clutch, handbrake }

class AlreadyInUseException implements Exception {}

class AppSettings extends ChangeNotifier {
  String languageCode = "en";
  String countryCode = "US";
  List<Channel> channelSettings = [for (var i = 0; i < 10; i++) Channel.empty()];

  bool edited = false;

  static AppSettings of(context) {
    return Provider.of<AppSettings>(context);
  }

  Future<void> load() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

    languageCode = storage.getItem("languageCode") ?? languageCode;
    countryCode = storage.getItem("countryCode") ?? countryCode;
    channelSettings =
        ((await storage.getItem("channelSettings") as List<dynamic>?)
                ?.map((el) => Channel.fromJSON(el)))?.toList() ??
            channelSettings;
    edited = false;
  }

  Future<void> save() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

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
