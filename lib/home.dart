import 'package:flutter/material.dart';

import 'data/profile.dart';
import 'ui/profile_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String activeProfile = "First Profile";

  @override
  Widget build(BuildContext context) {
    var profileList = [
      Profile("First Profile", "First Profile"),
      Profile("Second Profile", "Second Profile"),
      Profile("Third Profile", "Third Profile")
    ];

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ProfileList(
            profileList: profileList,
            activeProfileId: activeProfile,
            onChanged: (activeProfile) {
              setState(() {
                this.activeProfile = activeProfile ?? "";
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(color: Colors.red),
        ),
        Expanded(
          flex: 3,
          child: Container(color: Colors.blue),
        ),
      ],
    );
  }
}
