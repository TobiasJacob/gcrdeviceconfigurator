import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

import 'i18n/languages.dart';

class SettingsPage extends StatelessWidget {
  final Database database;
  final Function updateLanguage;

  const SettingsPage(
      {super.key, required this.updateLanguage, required this.database});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
          child: DropdownButton(
        onChanged: (value) {
          print(value);
          database.settings.languageCode = value!;
          if (value == "de") {
            database.settings.countryCode = "DE";
          } else {
            database.settings.countryCode = "US";
          }
          database.save();
          updateLanguage();
        },
        value: database.settings.languageCode,
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
