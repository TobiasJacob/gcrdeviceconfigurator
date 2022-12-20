import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

import '../ui/axis_detail.dart';
import '../ui/axis_list.dart';
import '../ui/profile_list.dart';
import '../ui/save_buttons.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Configurator"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Show Settings',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: database.edited
                  ? SaveOrResetButtons(
                      onSave: database.save,
                      onDiscard: database.load,
                    )
                  : const ProfileList(),
            ),
          ],
        ));
  }
}
