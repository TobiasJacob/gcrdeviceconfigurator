import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'profile.dart';

final profileIdProvier =
    StateProvider<String>((ref) {
  return ref.watch(settingsProvider.select((value) => value.profiles.keys)).first;
});

final profileProvider = Provider<Profile>((ref) {
  final id = ref.watch(profileIdProvier);
  final settings = ref.watch(settingsProvider);
  return settings.profiles[id]!;
});