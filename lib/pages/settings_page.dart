import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/settings/channel_tile.dart';
import 'package:gcrdeviceconfigurator/pages/settings/language_settings_tile.dart';
import 'package:provider/provider.dart';

import '../i18n/languages.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    return WillPopScope(
        onWillPop: () => willPop(context),
        child: Scaffold(
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
        ));
  }

  Future<bool> willPop(BuildContext context) async {
    final lang = Languages.of(context);
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final confirmation = await showYesNoDialog(
        context, lang.saveSettings, lang.wantToSaveSettings);
    if (confirmation == true) {
      appSettings.save();
    } else {
      appSettings.reload();
    }
    return true;
  }
}
