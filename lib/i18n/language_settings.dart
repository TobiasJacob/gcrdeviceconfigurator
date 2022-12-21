import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

class LanguageSettings extends ChangeNotifier {
  String languageCode;
  String countryCode;

  final LocalStorage storage;

  LanguageSettings(this.languageCode, this.countryCode, this.storage);

  static LanguageSettings of(context) {
    return Provider.of<LanguageSettings>(context);
  }

  static Future<LanguageSettings> load() async {
    final storage = LocalStorage('language.json');
    await storage.ready;

    final languageCode = await storage.getItem("languageCode") ?? "en";
    final countryCode = await storage.getItem("countryCode") ?? "US";
    return LanguageSettings(languageCode, countryCode, storage);
  }

  Future updateLanguage(String languageCode, String countryCode) async {
    this.languageCode = languageCode;
    this.countryCode = countryCode;

    await storage.setItem("languageCode", languageCode);
    await storage.setItem("countryCode", countryCode);

    notifyListeners();
  }
}
