import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'profile.dart';

final visibleProfileProvider =
    StateNotifierProvider<ProfileProvider, String>((ref) {
  return ProfileProvider(ref);
});

class ProfileProvider extends StateNotifier<String> {
  final Ref ref;

  ProfileProvider(this.ref)
      : super(ref.read(settingsProvider).profiles.keys.first);

  void setVisibleProfile(String profileId) {
    assert(ref.read(settingsProvider).profiles.containsKey(profileId));
    state = profileId;
  }

  Profile get profile {
    return ref
        .watch(settingsProvider.select((value) => value.profiles[state]!));
  }

  void update(Profile profile) {
    final notif = ref.read(settingsProvider.notifier);
    notif.update(notif.state.copyWith(profiles: {
      ...notif.state.profiles,
      state: profile,
    }));
  }
}
