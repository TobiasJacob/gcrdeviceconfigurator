import 'package:flutter/material.dart';

import 'i18n/languages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        },
        value: "en",
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
