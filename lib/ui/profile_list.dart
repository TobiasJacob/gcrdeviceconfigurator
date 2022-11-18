import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/profile_tile.dart';

import '../data/profile.dart';

class ProfileList extends StatelessWidget {
  final Map<String, Profile> profiles;
  final String activeProfileId;
  final Function(String?) onChangeActiveProfile;
  final Function(String?) onChangeVisibleProfile;

  const ProfileList(
      {super.key,
      required this.profiles,
      required this.activeProfileId,
      required this.onChangeActiveProfile,
      required this.onChangeVisibleProfile});

  @override
  Widget build(BuildContext context) {
    var profileKeys = profiles.keys.toList();
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        return ProfileTile(
          profile: profiles[profileKeys[index]]!,
          activeProfileId: activeProfileId,
          onChangeActiveProfile: onChangeActiveProfile,
          onChangeVisibleProfile: onChangeVisibleProfile,
          profileId: profileKeys[index],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
