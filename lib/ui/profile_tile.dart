import 'package:flutter/material.dart';

import '../data/profile.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final String profileId;
  final String activeProfileId;
  final Function(String?) onChanged;

  const ProfileTile(
      {super.key,
      required this.profileId,
      required this.profile,
      required this.activeProfileId,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Radio(
            value: profileId,
            groupValue: activeProfileId,
            onChanged: onChanged,
          ),
          Expanded(
              child: Text(profile.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            child: const Icon(
              Icons.arrow_right_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
