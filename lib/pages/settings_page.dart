import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/dialogs/yes_no_dialog.dart';
import 'package:gcrdeviceconfigurator/pages/settings/language_settings_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../i18n/languages.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  late AppSettings uneditedSettings;

  @override
  void initState() {
    super.initState();
    uneditedSettings = ref.read(settingsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    return WillPopScope(
        onWillPop: () => willPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text(lang.settings),
          ),
          body: const Column(
            children: [
              LanguageSettingTile(),
            ],
          ),
        ));
  }

  Future<bool> willPop(BuildContext context) async {
    final lang = Languages.of(context);
    final appSettings = ref.read(settingsProvider);
    final notif = ref.read(settingsProvider.notifier);
    if (uneditedSettings == appSettings) {
      return true;
    }
    final confirmation = await showYesNoDialog(
        context, lang.saveSettings, lang.wantToSaveSettings);
    if (confirmation == true) {
      notif.save();
    } else {
      notif.load();
    }
    return true;
  }
}
