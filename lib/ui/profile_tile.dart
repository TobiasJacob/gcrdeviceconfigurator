import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../data/database.dart';
import '../data/profile.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;

  const ProfileTile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final database = Database.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Radio<Profile>(
            value: profile,
            groupValue: database.activeProfile,
            onChanged: (value) {
              database.setActiveProfile(value!);
            },
          ),
          Expanded(
              child: Text(profile.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18))),
          MaterialButton(
            onPressed: () {
              // TODO: Alert
              database.deleteProfileIfMoreThanOne(profile);
            },
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            child: const Icon(
              Icons.delete,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: profile, child: const ProfilePage())));
            },
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
