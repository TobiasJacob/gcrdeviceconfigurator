import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  String languageCode;
  String countryCode;

  final LocalStorage storage;

  AppSettings(this.languageCode, this.countryCode, this.storage);

  static AppSettings of(context) {
    return Provider.of<AppSettings>(context);
  }

  static Future<AppSettings> load() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

    final languageCode = await storage.getItem("languageCode") ?? "en";
    final countryCode = await storage.getItem("countryCode") ?? "US";
    return AppSettings(languageCode, countryCode, storage);
  }

  Future updateLanguage(String languageCode, String countryCode) async {
    this.languageCode = languageCode;
    this.countryCode = countryCode;

    await storage.setItem("languageCode", languageCode);
    await storage.setItem("countryCode", countryCode);

    notifyListeners();
  }
}
