import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';

class LanguageSettingTile extends StatelessWidget {
  const LanguageSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final langSettings = AppSettings.of(context);

    return DropdownButton<String>(
      onChanged: (value) {
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
    );
  }
}
