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

    final profileKeys = ref.watch(settingsProvider.select((s) => s.profiles.keys.toList()));

    return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: profileKeys.length,
        itemBuilder: (BuildContext context, int index) {
          return ProfileTile(
            profileKey: profileKeys[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      );
  }
}
