import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

import 'home.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  final Database database;

  const HomePage({
    Key? key,
    required this.title,
    required this.database,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
        body: Home(database: database));
  }
}
