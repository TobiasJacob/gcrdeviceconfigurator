import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/settings/settings_tile.dart';

class LanguageSettingTile extends StatelessWidget {
  const LanguageSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final appSettings = AppSettings.of(context);

    return SettingsTile(
        title: "Language",
        child: DropdownButton<String>(
          onChanged: (value) {
            final String languageCode = value!;
            var countryCode = "US";
            if (value == "de") {
              countryCode = "DE";
            }
            appSettings.updateLanguage(languageCode, countryCode);
          },
          value: appSettings.languageCode,
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
        ));
  }
}
