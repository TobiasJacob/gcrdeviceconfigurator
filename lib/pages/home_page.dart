import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';

import 'home/profile_list.dart';
import 'home/update_device_button.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const ProfileList());
  }
}
