import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

import '../data/profile.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;
  final String activeProfileId;
  final Function(String?) onChanged;

  const ProfileTile(
      {super.key,
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
            value: profile.id,
            groupValue: activeProfileId,
            onChanged: onChanged,
          ),
          Expanded(
              child: Container(
            child: Text(profile.name,
                style: const TextStyle(color: Colors.black, fontSize: 18)),
          ))
        ],
      ),
    );
  }
}
