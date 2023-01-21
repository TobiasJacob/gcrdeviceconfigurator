import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/profile_view_provider.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:gcrdeviceconfigurator/i18n/languages.dart';
import 'package:gcrdeviceconfigurator/pages/home/profile_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../profile_page.dart';

class ProfileList extends ConsumerWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = Languages.of(context);
    final profiles = ref.watch(settingsProvider.select((s) => s.profiles));

    final profileKeys = profiles.keys.toList();

    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: profileKeys.length,
        itemBuilder: (BuildContext context, int index) {
          return ProfileTile(
            profileKey: profileKeys[index],
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
                onPressed: () async {
                  final updateAndId = ref.read(settingsProvider).createNewProfile(lang.newProfile);
                  ref.read(settingsProvider.notifier).update(updateAndId.item1);
                  ref.read(visibleProfileProvider.notifier).setVisibleProfile(updateAndId.item2);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  await ref.read(settingsProvider.notifier).save();
                },
              ),
            ),
          )),
    ]);
  }
}
