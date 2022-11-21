import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/ui/profile_tile.dart';

import '../data/profile.dart';

String generateRandomString() {
  const len = 16;
  var r = Random.secure();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

class ProfileList extends StatelessWidget {
  final Map<String, Profile> profiles;
  final String activeProfileId;
  final String visibleProfileId;
  final Function(String) onChangeActiveProfile;
  final Function(String) onChangeVisibleProfile;
  final Function(Map<String, Profile>) onUpdateProfiles;

  const ProfileList(
      {super.key,
      required this.profiles,
      required this.activeProfileId,
      required this.visibleProfileId,
      required this.onChangeActiveProfile,
      required this.onChangeVisibleProfile,
      required this.onUpdateProfiles});

  @override
  Widget build(BuildContext context) {
    var profileKeys = profiles.keys.toList();
    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (BuildContext context, int index) {
          return ProfileTile(
            profile: profiles[profileKeys[index]]!,
            activeProfileId: activeProfileId,
            visibleProfileId: visibleProfileId,
            onChangeActiveProfile: onChangeActiveProfile,
            onChangeVisibleProfile: onChangeVisibleProfile,
            profileId: profileKeys[index],
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
                for (var i = 0; i < 100; i++) {
                  final profileId = generateRandomString();
                  if (profiles.containsKey(profileId)) {
                    continue;
                  }
                  profiles[profileId] = Profile.empty("New profile");
                  onUpdateProfiles(profiles);
                  break;
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
