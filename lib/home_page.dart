import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

import 'home.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
        body: Home());
  }
}
