import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

enum Usage { none, gas, brake, clutch, handbrake }

class AppSettings extends ChangeNotifier {
  String languageCode;
  String countryCode;
  List<Usage> channelSettings;

  final LocalStorage storage;

  AppSettings(
      this.languageCode, this.countryCode, this.channelSettings, this.storage);

  static AppSettings of(context) {
    return Provider.of<AppSettings>(context);
  }

  static Future<AppSettings> load() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

    final languageCode = storage.getItem("languageCode") ?? "en";
    final countryCode = storage.getItem("countryCode") ?? "US";
    final channelSettings =
        (await storage.getItem("channelSettings") as List<dynamic>?)
                ?.map((i) => Usage.values[i]) ??
            [for (var i = 0; i < 10; i++) Usage.none];
    return AppSettings(
        languageCode, countryCode, channelSettings.toList(), storage);
  }

  Future updateLanguage(String languageCode, String countryCode) async {
    this.languageCode = languageCode;
    this.countryCode = countryCode;

    await storage.setItem("languageCode", languageCode);
    await storage.setItem("countryCode", countryCode);

    notifyListeners();
  }

  Future updateChannelUsage(int index, Usage usage) async {
    channelSettings[index] = usage;

    await storage.setItem(
        "channelSettings", channelSettings.map((e) => e.index).toList());

    notifyListeners();
  }
}
