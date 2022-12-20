import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
import 'package:gcrdeviceconfigurator/i18n/language_settings.dart';

import 'i18n/languages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final langSettings = LanguageSettings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
          child: DropdownButton<String>(
        onChanged: (value) {
          print(value);
          final String languageCode = value!;
          var countryCode = "US";
          if (value == "de") {
            countryCode = "DE";
          }
          langSettings.updateLanguage(languageCode, countryCode);
        },
        value: langSettings.languageCode,
        items: [
          DropdownMenuItem(
            value: "en",
            child: Text(lang.english),
          ),
          const DropdownMenuItem(
            value: "de",
            child: Text("German"),
          ),
        ],
      )),
    );
  }
}
