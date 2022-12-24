import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/profile_tile.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../profile_page.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Languages.of(context);
    final database = Database.of(context);
    final profileKeys = database.profiles.keys.toList();

    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: profileKeys.length,
        itemBuilder: (BuildContext context, int index) {
          return ProfileTile(
            profileKey: profileKeys[index],
            profile: database.profiles[profileKeys[index]]!,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  final profile = database.createNewProfile(lang.newProfile);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                              value: profile, child: const ProfilePage())));
                },
              ),
            ),
          )),
    ]);
  }
}
