import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/settings/channel_tile.dart';
import 'package:gcrdeviceconfigurator/pages/settings/language_settings_tile.dart';

import '../i18n/languages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.settings),
      ),
      body: Column(
        children: const [
          LanguageSettingTile(),
          Divider(),
          ChannelTile(),
          Divider()
        ],
      ),
    );
  }
}
