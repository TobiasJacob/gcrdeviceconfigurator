import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/channel_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home/update_device_button.dart';
import 'settings_page.dart';

enum ProfileAction { addEmptyProfile, importProfile }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(lang.appName),
          actions: <Widget>[
            const UpdateDeviceWidget(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
        body: const ChannelList());
  }
}
