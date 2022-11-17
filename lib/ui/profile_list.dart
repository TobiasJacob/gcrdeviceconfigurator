import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:gcrdeviceconfigurator/ui/profile_tile.dart';

import '../data/profile.dart';

class ProfileList extends StatelessWidget {
  final List<Profile> profileList;
  final String activeProfileId;
  final Function(String?) onChanged;

  const ProfileList(
      {super.key,
      required this.profileList,
      required this.activeProfileId,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: profileList.length,
      itemBuilder: (BuildContext context, int index) {
        return ProfileTile(
          profile: profileList[index],
          activeProfileId: activeProfileId,
          onChanged: onChanged,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
